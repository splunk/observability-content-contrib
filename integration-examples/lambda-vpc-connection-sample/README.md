# AWS Lambda Instrumetation Example with VPC-Connected OpenTelemetry Collector Gateway
This project is intended as an example implementation of an Otel-instrumented Python Lambda using the [AWS Serverless Application Model (SAM)](https://aws.amazon.com/serverless/sam/).
The additional AWS Resources included in this template support the Splunk-recommended best practice of sending Lambda telemetry to an OpenTelemetry Collector Gateway.

For additional information about the AWS SAM framework please refer to the [original README file](./ORIGINAL_README.md) generated with this sample's inital call to `sam init`. 

# Pre-Requisites
1. Python 3.9 set as the active Python interpreter on your local machine
1. Installation and configuration of the [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html)
1. IAM Permissions to deploy Cloudformation templates into an AWS Account
1. An EC2 Access Key Pair available in `us-east-1`
1. A valid ingest Access Token from Splunk Observability Cloud org.  The realm (`us0`|`eu0`, etc...) are required to execute this build. 

# Build and Deploy:
1. Install SAM CLI
1. Ensure you have admin access to an AWS environment (out of scope to cover at this point)
1. Python 3.9 active in this dir `pyenv` is nice for this, I just hit the easy button and `pyenv global 3.9.13`
1. Define an SSH key to allow access to the Otel Collector host EC2 instance, add that name in line 69 of `template.yaml`
1. Run `sam build`
1. Run `sam deploy --guided` and accept all the defaults if they are acceptable for you use case. Note, there are no defaults for `SplunkRealm`, `SplunkAccessToken` and `EC2KeyPairName`.  These parameters require explicit user-defined values.
1. This will spin up the VPC, the OTel Gateway and properly connect the Lambda to the VPC.
1. In the AWS Console, "Test" the Lambda.  Spans should begin to populate in Splunk Observability in just a few minutes




