package main

import (
	"context"
	"errors"
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strings"

	"github.com/hashicorp/go-version"
	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclsyntax"
	"github.com/hashicorp/hcl/v2/hclwrite"
	"github.com/hashicorp/terraform-exec/tfexec"
	"github.com/signalfx/signalfx-go"
	"github.com/zclconf/go-cty/cty"
)

type Args struct {
	APIToken               string
	APIURL                 string
	Directory              string
	Groups                 []string
	TFPath                 string
	AddVarFile             bool
	AddVersionsFile        bool
	AllowChartNameConflict bool
}

var (
	minVersion           = "1.5.0"
	sfxDashboardRes      = "signalfx_dashboard"
	sfxDashboardGroupRes = "signalfx_dashboard_group"
	sfxDetectorRes       = "signalfx_detector"
)

var chartTypeMap = map[string]string{
	"Heatmap":         "signalfx_heatmap_chart",
	"List":            "signalfx_list_chart",
	"SingleValue":     "signalfx_single_value_chart",
	"Text":            "signalfx_text_chart",
	"TimeSeriesChart": "signalfx_time_chart",
	"TableChart":      "signalfx_table_chart",
	"Line":            "signalfx_line_chart",
	"Event":           "signalfx_event_feed_chart",
}

var (
	tfClient  *tfexec.Terraform
	sfxClient *signalfx.Client
)

var (
	chartTypeRe = regexp.MustCompile(`^signalfx_(heatmap|list|single_value|time|table|line|event)_chart$`)

	// regex for detector_id in the program_text ex alerts(detector_id='FthOzfwAkAA')
	detectorIDRe = regexp.MustCompile(`detector_id\s*=\s*'([^']+)'`)

	// allowed characters in TF resource label, additionally removing hyphens
	tfRe = regexp.MustCompile(`[^a-zA-Z0-9_]`)
)

func getValidResourceName(name string) string {
	// name = strings.ReplaceAll(name, "-", "")
	resName := tfRe.ReplaceAllString(name, "_")
	if len(resName) > 0 && resName[0] >= '0' && resName[0] <= '9' {
		resName = "_" + resName
	}
	return resName
}

func parseArgs() Args {
	var args Args
	var groups string

	flag.StringVar(&args.APIToken, "api-token", "", "API token for authentication")
	flag.StringVar(&args.APIURL, "api-url", "https://app.us0.signalfx.com", "The API URL for Splunk Observability")
	flag.StringVar(&args.Directory, "dir", "", "Working directory where TF files will be written.")
	flag.StringVar(&groups, "groups", "", "Comma-separated list  dashboard group IDs in Splunk Observability to import. Required.")
	flag.StringVar(&args.TFPath, "tf-path", "terraform", "The path to the Terraform binary")
	flag.BoolVar(&args.AddVarFile, "add-var-file", false, "Add variables.tf file to the directory. This file only defines variabled the generated terraform code uses.")
	flag.BoolVar(&args.AddVersionsFile, "add-versions-file", false, "Add versions.tf file to the directory. This file will have terraform block with version requirements.")
	flag.BoolVar(&args.AllowChartNameConflict, "allow-chart-name-conflict", false, "Allow charts with the same name in a dashboard. This will add an index at the end of the chart's name attribute and resource name to resolve conflict in naming. It is recommended to rename charts when you export the dashboards to TF for the first time.")
	flag.Usage = func() {
		fmt.Fprintf(flag.CommandLine.Output(), "Usage: %s [options]\n", os.Args[0])
		flag.PrintDefaults()
	}
	flag.Parse()

	if args.APIToken == "" || args.Directory == "" || groups == "" {
		fmt.Println("APIKey, Dir and Groups are required")
		flag.Usage()
		os.Exit(1)
	}

	args.Groups = strings.Split(strings.ReplaceAll(groups, " ", ""), ",")

	return args
}

func main() {
	args := parseArgs()

	// create tmp director under args.Directory to run terraform
	pid := fmt.Sprintf("%d", os.Getpid())
	tmpdir := filepath.Join(args.Directory, "_tmp_generation_"+pid)
	err := os.MkdirAll(tmpdir, 0755)
	// clean up tmp directory
	defer func() {
		if err := os.RemoveAll(tmpdir); err != nil {
			fmt.Printf("failed to remove tmp directory %s: %v\n", tmpdir, err)
		}
	}()

	if err != nil {
		fmt.Printf("failed to create tmp directory: %v\n", err)
		os.Exit(1)
	}

	if _, err = writeProviderTF(tmpdir, args.APIToken, args.APIURL); err != nil {
		fmt.Printf("failed to add provider: %v\n", err)
		os.Exit(1)
	}

	tfClient, err = setupTF(tmpdir, args.TFPath)
	if err != nil {
		fmt.Printf("failed to setup Terraform: %v\n", err)
		os.Exit(1)
	}

	sfxClient, err = signalfx.NewClient(args.APIToken, signalfx.APIUrl(args.APIURL))
	if err != nil {
		fmt.Printf("failed to create SignalFx client: %v\n", err)
		os.Exit(1)
	}

	var outputFiles []string
	for _, group := range args.Groups {
		files, err := writeDashboardGroupTF(tmpdir, args.Directory, group, args.AllowChartNameConflict)
		if err != nil {
			fmt.Printf("failed to write TF config for group %s: %v\n", group, err)
			os.Exit(1)
		}
		outputFiles = append(outputFiles, files...)
	}

	if args.AddVarFile {
		if outputFile, err := writeVarTF(args.Directory); err != nil {
			fmt.Printf("failed to write variables.tf: %v\n", err)
		} else {
			outputFiles = append(outputFiles, outputFile)
		}
	}

	if args.AddVersionsFile {
		if outputFile, err := writeProviderTF(args.Directory, "", ""); err != nil {
			fmt.Printf("failed to write versions.tf to %s: %v\n", args.Directory, err)
		} else {
			outputFiles = append(outputFiles, outputFile)
		}
	}
	fmt.Printf("\n============ Please verify below generated TF files ============\n%s\n", strings.Join(outputFiles, "\n"))
}

func writeProviderTF(dir, apiToken, apiURL string) (string, error) {
	f := hclwrite.NewEmptyFile()

	rootBody := f.Body()

	terraformBlock := rootBody.AppendNewBlock("terraform", nil)
	terraformBody := terraformBlock.Body()
	requiredProviders := terraformBody.AppendNewBlock("required_providers", nil)
	requiredProvidersBody := requiredProviders.Body()
	requiredProvidersBody.SetAttributeValue("signalfx", cty.ObjectVal(map[string]cty.Value{
		"source":  cty.StringVal("splunk-terraform/signalfx"),
		"version": cty.StringVal("~> 9.20.0"),
	}))
	terraformBody.SetAttributeValue("required_version", cty.StringVal("~> 1.6"))
	rootBody.AppendNewline()

	if apiToken != "" && apiURL != "" {
		providerBlock := rootBody.AppendNewBlock("provider", []string{"signalfx"})
		providerBody := providerBlock.Body()
		providerBody.SetAttributeValue("auth_token", cty.StringVal(apiToken))
		providerBody.SetAttributeValue("api_url", cty.StringVal(apiURL))
		rootBody.AppendNewline()
	}

	path := filepath.Join(dir, "versions.tf")
	err := os.WriteFile(path, f.Bytes(), 0644)
	if err != nil {
		return "", fmt.Errorf("failed to write versions.tf: %w", err)
	}
	return path, nil
}

func createImportBlock(resourceAddr, id string) *hclwrite.Block {
	importBlock := hclwrite.NewBlock("import", nil)
	importBody := importBlock.Body()
	importBody.SetAttributeRaw("to", hclwrite.Tokens{
		{Type: hclsyntax.TokenIdent, Bytes: []byte(resourceAddr)},
	})
	importBody.SetAttributeValue("id", cty.StringVal(id))
	return importBlock
}

func writeDashboardGroupTF(tmpdir, wdir, id string, allowChartConflict bool) ([]string, error) {
	group, err := sfxClient.GetDashboardGroup(context.Background(), id)
	if err != nil {
		return nil, fmt.Errorf("failed to fetch dashboard group: %w", err)
	}
	groupName := getValidResourceName(group.Name)

	// track generated file names
	tfFiles := []string{}

	// generate an outputs file for the dashboard group
	outFile := hclwrite.NewEmptyFile()
	outRootBody := outFile.Body()
	outputFile := filepath.Join(wdir, fmt.Sprintf("outputs_%s.tf", groupName))

	// generate for each dashboard in dashboard group
	for _, dashID := range group.Dashboards {
		dashFile, dashName, err := writeDashboardTF(tmpdir, wdir, dashID, groupName, allowChartConflict)
		if err != nil {
			return nil, fmt.Errorf("failed to write group's dashboard: %w", err)
		}

		outputBlock := outRootBody.AppendNewBlock("output", []string{"dashboard_url_" + dashName})
		outputBlock.Body().SetAttributeRaw("value", hclwrite.Tokens{
			{Type: hclsyntax.TokenIdent, Bytes: []byte(fmt.Sprintf("%s.%s.url", sfxDashboardRes, dashName))},
		})
		outputBlock.Body().SetAttributeValue("description", cty.StringVal(fmt.Sprintf("URL for dashboard %s", dashName)))
		outRootBody.AppendNewline()

		tfFiles = append(tfFiles, dashFile)
	}

	f := hclwrite.NewEmptyFile()
	rootBody := f.Body()
	importBlock := createImportBlock(fmt.Sprintf("%s.%s", sfxDashboardGroupRes, groupName), id)
	rootBody.AppendBlock(importBlock)

	importFile := filepath.Join(tmpdir, fmt.Sprintf("import_%s.tf", sfxDashboardGroupRes))
	defer os.Remove(importFile)

	err = os.WriteFile(importFile, f.Bytes(), 0644)
	if err != nil {
		return tfFiles, fmt.Errorf("failed to write %s: %w", importFile, err)
	}

	tmpFile := filepath.Join(tmpdir, fmt.Sprintf("%s_%s.tf", sfxDashboardGroupRes, groupName))

	err = planTF(tmpFile)
	if err != nil {
		return nil, err
	}

	// copy to wdir - this is to workaround terraform not allowing overwriting files
	generatedFile := filepath.Join(wdir, fmt.Sprintf("%s_%s.tf", sfxDashboardGroupRes, groupName))
	err = os.Rename(tmpFile, generatedFile)
	if err != nil {
		return tfFiles, fmt.Errorf("failed to move generated file from %s to %s: %w", tmpFile, generatedFile, err)
	}

	tfFiles = append(tfFiles, generatedFile)

	// sort resources alphabetically to reduce diff in git commits on reruns
	err = sortResourcesAlphabetically(generatedFile)
	if err != nil {
		return tfFiles, fmt.Errorf("failed to sort resources alphabetically: %w", err)
	}

	// cleanup generated TF files
	err = commonProcessing(generatedFile)
	if err != nil {
		return tfFiles, err
	}

	// replace principal_id with var.org_id and update permissions to READ only
	err = sanitizeTF(generatedFile, func(f *hclwrite.File) {
		for _, block := range f.Body().Blocks() {
			if block.Type() != "resource" {
				continue
			}
			if block.Labels()[0] != sfxDashboardGroupRes {
				continue
			}
			for _, resBlock := range block.Body().Blocks() {
				if resBlock.Type() == "permissions" {
					resBlock.Body().SetAttributeTraversal("principal_id", hcl.Traversal{
						hcl.TraverseRoot{Name: "var"},
						hcl.TraverseAttr{Name: "org_id"},
					})
					resBlock.Body().SetAttributeValue("principal_type", cty.StringVal("ORG"))
					resBlock.Body().SetAttributeValue("actions", cty.ListVal([]cty.Value{cty.StringVal("READ")}))
				}
			}
		}
	})

	if err != nil {
		return tfFiles, fmt.Errorf("failed to cleanup generated TF: %w", err)
	}

	// write output for dashboard group id
	outputBlock := outRootBody.AppendNewBlock("output", []string{"dashboard_group_id_" + groupName})
	outputBlock.Body().SetAttributeRaw("value", hclwrite.Tokens{
		{Type: hclsyntax.TokenIdent, Bytes: []byte(fmt.Sprintf("%s.%s.id", sfxDashboardGroupRes, groupName))},
	})
	outputBlock.Body().SetAttributeValue("description", cty.StringVal(fmt.Sprintf("ID for dashboard group %s", groupName)))
	outRootBody.AppendNewline()

	// write outputs file
	err = os.WriteFile(outputFile, outFile.Bytes(), 0644)
	if err != nil {
		return tfFiles, fmt.Errorf("failed to write %s: %w", outputFile, err)
	}

	tfFiles = append(tfFiles, outputFile)

	// strip comments from generated files
	for _, file := range tfFiles {
		err = stripComments(file)
		if err != nil {
			fmt.Printf("failed to strip comments from %s: %v\n", file, err)
		}
	}

	return tfFiles, nil

}

func writeDashboardTF(tmpdir, wdir, id, groupResName string, allowChartConflict bool) (string, string, error) {
	dashboard, err := sfxClient.GetDashboard(context.Background(), id)
	if err != nil {
		return "", "", fmt.Errorf("failed to fetch dashboard: %w", err)
	}

	dashName := fmt.Sprintf("%s_%s", groupResName, getValidResourceName(dashboard.Name))

	f := hclwrite.NewEmptyFile()
	rootBody := f.Body()

	var importBlock *hclwrite.Block

	// tracks chart names to avoid conflicts - we will error if dashboard has
	// charts with the same name.
	// User should update the dashboard to have unique chart names in the same dashboard.
	chartNameMap := make(map[string]string)
	chartResMap := make(map[string]string)

	for _, chart := range dashboard.Charts {
		chartObj, err := sfxClient.GetChart(context.Background(), chart.ChartId)
		if err != nil {
			return "", "", fmt.Errorf("failed to fetch chart %s: %w", chart.ChartId, err)
		}
		chartType := chartObj.Options.Type
		chartAttrName := chartObj.Name
		tfResource, ok := chartTypeMap[chartType]
		if !ok {
			return "", "", fmt.Errorf("unsupported chart type: %s", chartType)
		}
		chartResName := getValidResourceName(chartObj.Name)

		// try to get the chart name from description if name is empty for Text chart
		if chartType == "Text" && strings.TrimSpace(chartObj.Name) == "" && strings.TrimSpace(chartObj.Description) != "" {
			chartResName = getValidResourceName(chartObj.Description)
			// fmt.Printf("warning: chart name is empty for Text chart. Using description as chart name. Chart resource name suffix %s\n\n", chartResName)
		}

		chartRes := fmt.Sprintf("%s.%s_%s", tfResource, dashName, chartResName)

		if _, ok := chartNameMap[chartRes]; ok {
			if !allowChartConflict {
				return "", "", fmt.Errorf("chart name \"%s\" already exists in dashboard %s. Please rename charts to avoid conflicting resource name generation", chartObj.Name, dashName)
			}
			fmt.Printf("warning: chart name \"%s\" already exists in dashboard %s. Adding an index to the chart and resource name. It is recommended to rename charts.\n\n", chartObj.Name, dashName)
			// add index to chart name
			for i := 1; ; i++ {
				chartRes = fmt.Sprintf("%s_%d", chartRes, i)
				if _, ok := chartNameMap[chartRes]; !ok {
					chartAttrName = fmt.Sprintf("%s %d", chartObj.Name, i)
					break
				}
			}
		}

		chartNameMap[chartRes] = chartAttrName
		chartResMap[chart.ChartId] = chartRes

		importBlock = createImportBlock(chartRes, chart.ChartId)
		rootBody.AppendBlock(importBlock)
		rootBody.AppendNewline()
	}

	importBlock = createImportBlock(fmt.Sprintf("%s.%s", sfxDashboardRes, dashName), id)
	rootBody.AppendBlock(importBlock)
	rootBody.AppendNewline()

	importFile := filepath.Join(tmpdir, fmt.Sprintf("import_%s_%s.tf", sfxDashboardRes, dashName))
	defer os.Remove(importFile)

	err = os.WriteFile(importFile, f.Bytes(), 0644)
	if err != nil {
		return "", "", fmt.Errorf("failed to write %s: %w", importFile, err)
	}

	tmpFile := filepath.Join(tmpdir, fmt.Sprintf("%s_%s.tf", sfxDashboardRes, dashName))

	err = planTF(tmpFile)
	if err != nil {
		return "", "", err
	}

	// copy to wdir - this is to workaround terraform not allowing overwriting files
	generatedFile := filepath.Join(wdir, fmt.Sprintf("%s_%s.tf", sfxDashboardRes, dashName))
	err = os.Rename(tmpFile, generatedFile)
	if err != nil {
		return "", "", fmt.Errorf("failed to move generated file from %s to %s: %w", tmpFile, generatedFile, err)
	}

	// sort resources alphabetically to reduce diff in git commits on reruns
	err = sortResourcesAlphabetically(generatedFile)
	if err != nil {
		return "", "", fmt.Errorf("failed to sort resources alphabetically: %w", err)
	}

	// cleanup generated TF files
	err = commonProcessing(generatedFile)
	if err != nil {
		return "", "", err
	}

	// Clean dashboard resource
	// 1. add tags to refer to var.tags
	// 2. replace permissions.parent and dashboard_group with dashboard_group_id
	// 3. replace chart_id with chart resource id
	err = sanitizeTF(generatedFile, func(f *hclwrite.File) {
		groupIdRef := fmt.Sprintf("%s.%s.id", sfxDashboardGroupRes, groupResName)
		for _, block := range f.Body().Blocks() {
			if block.Type() != "resource" {
				continue
			}
			if block.Labels()[0] != sfxDashboardRes {
				continue
			}
			block.Body().SetAttributeTraversal("tags", hcl.Traversal{
				hcl.TraverseRoot{Name: "var"},
				hcl.TraverseAttr{Name: "tags"},
			})
			block.Body().SetAttributeRaw("dashboard_group", hclwrite.Tokens{
				{Type: hclsyntax.TokenIdent, Bytes: []byte(groupIdRef)},
			})
			for _, resBlock := range block.Body().Blocks() {
				if resBlock.Type() == "permissions" {
					resBlock.Body().SetAttributeRaw("parent", hclwrite.Tokens{
						{Type: hclsyntax.TokenIdent, Bytes: []byte(groupIdRef)},
					})
				}
				if resBlock.Type() != "chart" {
					continue
				}
				chartResId := strings.TrimSpace(string(resBlock.Body().GetAttribute("chart_id").Expr().BuildTokens(nil).Bytes()))
				chartResId = strings.Trim(chartResId, "\"")
				resBlock.Body().SetAttributeRaw("chart_id", hclwrite.Tokens{
					{Type: hclsyntax.TokenIdent, Bytes: []byte(fmt.Sprintf("%s.id",
						chartResMap[chartResId]))},
				})
			}
		}
	})

	if err != nil {
		return "", "", fmt.Errorf("failed to cleanup generated TF: %w", err)
	}

	// Clean chart resources
	// 1. optionally append index to chart.name if conflicting with another chart name
	// 2. replace detector_id in program_text with detector resource id
	err = sanitizeTF(generatedFile, func(f *hclwrite.File) {
		for _, block := range f.Body().Blocks() {
			if block.Type() != "resource" {
				continue
			}
			if !chartTypeRe.MatchString(block.Labels()[0]) {
				continue
			}

			resName := fmt.Sprintf("%s.%s", block.Labels()[0], block.Labels()[1])
			block.Body().SetAttributeValue("name", cty.StringVal(chartNameMap[resName]))

			progText := string(block.Body().GetAttribute("program_text").Expr().BuildTokens(nil).Bytes())
			matches := detectorIDRe.FindAllStringSubmatch(progText, -1)
			for _, match := range matches {
				detector, err := sfxClient.GetDetector(context.Background(), match[1])
				if err != nil {
					fmt.Printf("failed to get detector with id %s: %v\n", match[1], err)
					continue
				}
				detectorResName := getValidResourceName(detector.Name)
				detectorResName = fmt.Sprintf("${%s.%s.id}", sfxDetectorRes, detectorResName)
				progText = strings.ReplaceAll(progText, match[1], detectorResName)
			}
			if matches != nil {
				block.Body().SetAttributeRaw("program_text", hclwrite.Tokens{
					{Type: hclsyntax.TokenIdent, Bytes: []byte(progText)},
				})
			}
		}
	})

	if err != nil {
		return "", "", fmt.Errorf("failed to cleanup generated TF: %w", err)
	}

	return generatedFile, dashName, nil
}

func writeVarTF(dir string) (string, error) {
	f := hclwrite.NewEmptyFile()

	rootBody := f.Body()

	varsBlock := rootBody.AppendNewBlock("variable", []string{"tags"})
	varsBlock.Body().SetAttributeValue("description", cty.StringVal("Tags to apply to all dashboards."))
	varsBlock.Body().SetAttributeRaw("type", hclwrite.Tokens{
		{Type: hclsyntax.TokenIdent, Bytes: []byte("list(string)")},
	})
	varsBlock.Body().SetAttributeValue("default", cty.ListVal([]cty.Value{cty.StringVal("tf-managed")}))

	varsBlock = rootBody.AppendNewBlock("variable", []string{"teams"})
	varsBlock.Body().SetAttributeValue("description", cty.StringVal("Team IDs to add to dashboard groups. Override this in per realm config."))
	varsBlock.Body().SetAttributeRaw("type", hclwrite.Tokens{
		{Type: hclsyntax.TokenIdent, Bytes: []byte("list(string)")},
	})
	varsBlock.Body().SetAttributeValue("default", cty.ListValEmpty(cty.String))

	varsBlock = rootBody.AppendNewBlock("variable", []string{"org_id"})
	varsBlock.Body().SetAttributeValue("description", cty.StringVal("Organization ID. Override this in per realm config."))
	varsBlock.Body().SetAttributeRaw("type", hclwrite.Tokens{
		{Type: hclsyntax.TokenIdent, Bytes: []byte("string")},
	})
	varsBlock.Body().SetAttributeValue("default", cty.StringVal(""))

	path := filepath.Join(dir, "variables.tf")
	err := os.WriteFile(path, f.Bytes(), 0644)
	if err != nil {
		return "", fmt.Errorf("failed to write variables.tf: %w", err)
	}
	return path, nil
}

func setupTF(dir, execPath string) (*tfexec.Terraform, error) {
	tf, err := tfexec.NewTerraform(dir, execPath)
	if err != nil {
		return nil, fmt.Errorf("error running NewTerraform: %s", err)
	}

	v, _, err := tf.Version(context.Background(), true)
	if err != nil {
		return nil, fmt.Errorf("failed to get Terraform version: %v", err)
	}

	minVer, err := version.NewVersion(minVersion)
	if err != nil {
		return nil, fmt.Errorf("failed to parse minimum version: %v", err)
	}

	if !v.GreaterThanOrEqual(minVer) {
		return nil, fmt.Errorf("terraform version is %s, please upgrade terraform. This script includes functionality introduced in version %s", v, minVer)
	}

	initOptions := []tfexec.InitOption{
		tfexec.Upgrade(true),
	}

	err = tf.Init(context.Background(), initOptions...)
	if err != nil {
		return nil, fmt.Errorf("error running Init: %w", err)
	}

	return tf, nil
}

func planTF(generatedFile string) error {
	_, err := tfClient.Plan(context.Background(), tfexec.GenerateConfigOut(generatedFile))
	if err != nil {
		return fmt.Errorf("failed to plan Terraform: %v", err)
	}
	return nil
}

type sanitizeFn func(*hclwrite.File)

func sanitizeTF(fpath string, fn sanitizeFn) error {

	src, err := os.ReadFile(fpath)
	if err != nil {
		return err
	}

	file, diags := hclwrite.ParseConfig(src, fpath, hcl.Pos{Line: 1, Column: 1})
	if diags.HasErrors() {
		return errors.New(diags.Error())
	}

	origBytes := file.Bytes()

	fn(file)

	if string(origBytes) != string(file.Bytes()) {
		stat, err := os.Stat(fpath)
		if err != nil {
			return err
		}

		if err := os.WriteFile(fpath, file.Bytes(), stat.Mode()); err != nil {
			return err
		}
	}

	return nil
}

func commonProcessing(fpath string) error {
	// remove id attribute and replace teams with var.teams from resources
	err := sanitizeTF(fpath, func(f *hclwrite.File) {
		for _, block := range f.Body().Blocks() {
			if block.Type() != "resource" {
				continue
			}
			block.Body().RemoveAttribute("id")
			if attr := block.Body().GetAttribute("teams"); attr != nil {
				block.Body().SetAttributeTraversal("teams", hcl.Traversal{
					hcl.TraverseRoot{Name: "var"},
					hcl.TraverseAttr{Name: "teams"},
				})
			}
		}
	})
	if err != nil {
		return fmt.Errorf("failed to cleanup generated TF: %w", err)
	}
	return nil
}

func stripComments(filePath string) error {
	input, err := os.ReadFile(filePath)
	if err != nil {
		return fmt.Errorf("failed to read file: %w", err)
	}

	lines := strings.Split(string(input), "\n")
	var output []string

	for _, line := range lines {
		if !strings.HasPrefix(strings.TrimSpace(line), "#") {
			output = append(output, line)
		}
	}

	err = os.WriteFile(filePath, []byte(strings.Join(output, "\n")), 0644)
	if err != nil {
		return fmt.Errorf("failed to write file: %w", err)
	}

	return nil
}

func sortResourcesAlphabetically(file string) error {
	data, err := os.ReadFile(file)
	if err != nil {
		return fmt.Errorf("failed to read file: %w", err)
	}
	f, diags := hclwrite.ParseConfig(data, file, hcl.InitialPos)
	if diags.HasErrors() {
		return fmt.Errorf("failed to parse HCL file: %s", diags.Error())
	}

	var resourceBlocks []*hclwrite.Block
	for _, block := range f.Body().Blocks() {
		if block.Type() == "resource" {
			resourceBlocks = append(resourceBlocks, block)
		}
	}

	// Sort resource blocks alphabetically by type and name
	sort.Slice(resourceBlocks, func(i, j int) bool {
		typeI, nameI := resourceBlocks[i].Labels()[0], resourceBlocks[i].Labels()[1]
		typeJ, nameJ := resourceBlocks[j].Labels()[0], resourceBlocks[j].Labels()[1]
		if typeI == typeJ {
			return nameI < nameJ
		}
		return typeI < typeJ
	})

	newFile := hclwrite.NewEmptyFile()
	newBody := newFile.Body()
	for _, block := range resourceBlocks {
		newBody.AppendBlock(block)
	}

	// Write the sorted file back
	err = os.WriteFile(file, newFile.Bytes(), 0644)
	if err != nil {
		return fmt.Errorf("failed to write sorted file: %w", err)
	}

	return nil
}
