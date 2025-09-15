module main

go 1.24.0

toolchain go1.24.3

require (
	github.com/hashicorp/go-version v1.7.0
	github.com/hashicorp/hcl/v2 v2.24.0
	github.com/hashicorp/terraform-exec v0.22.0
	github.com/signalfx/signalfx-go v1.52.0
	github.com/zclconf/go-cty v1.16.3
)

require (
	github.com/agext/levenshtein v1.2.1 // indirect
	github.com/apparentlymart/go-textseg/v15 v15.0.0 // indirect
	github.com/google/go-cmp v0.6.0 // indirect
	github.com/hashicorp/terraform-json v0.22.1 // indirect
	github.com/mitchellh/go-wordwrap v1.0.1 // indirect
	golang.org/x/mod v0.17.0 // indirect
	golang.org/x/net v0.33.0 // indirect
	golang.org/x/oauth2 v0.27.0 // indirect
	golang.org/x/sync v0.14.0 // indirect
	golang.org/x/text v0.25.0 // indirect
	golang.org/x/tools v0.21.1-0.20240508182429-e35e4ccd0d2d // indirect
)

// https://github.com/hashicorp/terraform-exec/pull/446 can be removed after the PR is merged
replace github.com/hashicorp/terraform-exec v0.22.0 => github.com/hrmsk66/terraform-exec v0.21.0
