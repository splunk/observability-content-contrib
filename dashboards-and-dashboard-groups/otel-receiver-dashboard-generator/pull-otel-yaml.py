import os
import requests
import yaml

# GitHub repository information
repo_owner = "open-telemetry"
repo_name = "opentelemetry-collector-contrib"
repo_path = "receiver"
github_token = os.environ.get('GITHUB_PAT_TOKEN')
headers = {}
api_url = f"https://api.github.com/repos/{repo_owner}/{repo_name}/contents/{repo_path}"

# Check for our PAT and make auth headers so we don't get rate limited
if github_token is not None:
    headers["Authorization"] = "Bearer " + github_token
else:
    print("no $GITHUB_PAT_TOKEN environment variable found. Expect rate limiting.")

# Make a request to GitHub API
response = requests.get(api_url, headers=headers)
contents = response.json()
if response.status_code != 200:
    print("Received " + str(response.status_code) + " STATUS CODE. \n" + response.text)
    exit()

# Iterate through contents and find subdirectories
directories = [content["name"] for content in contents if content["type"] == "dir"]

# Iterate through subdirectories and extract metadata.yaml with 'metrics' section
for sub in directories:
    subdir_api_url = f"{api_url}/{sub}"
    subdir_response = requests.get(subdir_api_url, headers=headers)
    if subdir_response.status_code != 200:
        print("Received " + str(subdir_response.status_code) + " STATUS CODE. \n" + response.text)
        exit()
    subdir_contents = subdir_response.json()

    # Check if metadata.yaml exists in the subdirectory
    metadata_content = None
    for content in subdir_contents:
        if content["name"] == "metadata.yaml":
            metadata_url = content["download_url"]
            metadata_response = requests.get(metadata_url, headers=headers)
            if metadata_response.status_code != 200:
                print("Received " + str(metadata_response.status_code) + " STATUS CODE. \n" + response.text)
                exit()
            metadata_content = metadata_response.text
            break

    if metadata_content:
        # Parse YAML content
        metadata_data = yaml.safe_load(metadata_content)

        # Check if 'metrics' section exists in metadata.yaml then save
        if "metrics" in metadata_data:
            filename = f"./otel-receiver-yaml/{sub}_metadata.yaml"
            with open(filename, "w") as file:
                file.write(metadata_content)
            print(f"Metadata.yaml with 'metrics' section extracted from {sub}")
