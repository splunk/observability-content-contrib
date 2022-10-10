# AWS Lambda Instrumetation Example with VPC-Connected OpenTelemetry Collector Gateway
This project is intended as an example implementation of an Otel-instrumented Python Lambda using the [AWS Serverless Application Model (SAM)](https://aws.amazon.com/serverless/sam/).
The additional AWS Resources included in this template support the Splunk-recommended best practice of sending Lambda telemetry to an OpenTelemetry Collector Gateway.

For additional information about the AWS SAM framework please refer to the [original README file](./ORIGINAL_README.md) generated with this sample's inital call to `sam init`. This is provided for historical purposes and contains some helpful information about AWS SAM.

# Pre-Requisites
1. Python 3.9 set as the active Python interpreter on your local machine. [Pyenv](https://github.com/pyenv/pyenv) is a great tool for managing different Python versions globally, locally for a given directory or a virtual environment.  Installation can be done with [Homebrew](https://github.com/pyenv/pyenv#homebrew-in-macos) on a Mac or with the [installer tool](https://github.com/pyenv/pyenv-installer).  Using whatever Python version management tool you like, ensure that Python 3.9.x is installed.  For example, to use Python 3.9.13 globally on your local machine, execute the following:
 ```bash
pyenv install 3.9.13
pyev global 3.9.13
```
Verify the version of your Python interpreter by executing
```bash
python3 --version
```
If you prefer some other means to manage the active Python interpreter for your shell session, feel free to use what you like :smiley:

2. Installation and configuration of the [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html)
3. IAM Permissions to deploy Cloudformation templates into an AWS Account. This is accomplished most easily by associating the `AdministratorAccess` AWS managed policy to a role associated to the User account under which Cloudformation will run.
4. An EC2 Access Key Pair available in `us-east-1`.  This will be needed during the initial guided deploy wizard. You will need only the "Name" of the Key Pair.
5. A valid ingest Access Token from Splunk Observability Cloud org.  The realm (`us0`|`eu0`, etc...) are required to execute this build. 

# Build and Deploy:
1. Install [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html)
2. Make sure Python 3.9.x is active in this dir.  If you installed Pyenv, you can execute `pyenv global 3.9.13`
3. Run `sam build`.  You see output similar to:
```bash
Your template contains a resource with logical ID "ServerlessRestApi", which is a reserved logical ID in AWS SAM. It could result in unexpected behaviors and is not recommended.
Building codeuri: <local path>/hello_world runtime: python3.9 metadata: {} architecture: x86_64 functions: HelloWorldFunction
Running PythonPipBuilder:ResolveDependencies
Running PythonPipBuilder:CopySource

Build Succeeded

Built Artifacts  : .aws-sam/build
Built Template   : .aws-sam/build/template.yaml

Commands you can use next
=========================
[*] Validate SAM template: sam validate
[*] Invoke Function: sam local invoke
[*] Test Function in the Cloud: sam sync --stack-name {stack-name} --watch
[*] Deploy: sam deploy --guided
```
4. Run `sam deploy --guided` and accept all the defaults if they are acceptable for you use case. Note, there are no defaults for `SplunkRealm`, `SplunkAccessToken` and `EC2KeyPairName`.  These parameters require explicit user-defined values.  When you run the deploy command with the `--guided` switch, you'll be prompted to enter values for the parameters in the SAM template.  Please supply your own appropriate for your environment.  When you get to the question "HelloWorldFunction may not have authorization defined, Is this okay?" Just enter "Y".  We're not concerned with permissions for the purposes of this sample.

You should see output similar to:
```bash
❯ sam deploy --guided

Configuring SAM deploy
======================

        Looking for config file [samconfig.toml] :  Found
        Reading default arguments  :  Success

        Setting default arguments for 'sam deploy'
        =========================================
        Stack Name [hello-requests]: 
        AWS Region [us-east-1]: 
        Parameter EC2Ami [ami-026b57f3c383c2eec]: 
        Parameter EC2InstanceType [t2.micro]: 
        Parameter EC2AvailabilityZone [us-east-1b]: 
        Parameter EC2KeyPairName []: 
        Parameter SplunkAccessToken []: 
        Parameter SplunkRealm []: 
        Parameter EnvironmentName [lambda-devlab]: 
        #Shows you resources changes to be deployed and require a 'Y' to initiate deploy
        Confirm changes before deploy [y/N]: 
        #SAM needs permission to be able to create roles to connect to the resources in your template
        Allow SAM CLI IAM role creation [Y/n]: 
        #Preserves the state of previously provisioned resources when an operation fails
        Disable rollback [y/N]: 
        HelloWorldFunction may not have authorization defined, Is this okay? [y/N]: y
        Save arguments to configuration file [Y/n]: 
```
5. This will spin up the VPC, the OTel Gateway and properly connect the Lambda to the VPC.
6. In the AWS Console, "Test" the Lambda.  Spans should begin to populate in Splunk Observability in just a few minutes

# Tear it Down
To delete this stack and all the associated resources simply requires the command `sam delete`.  Clouformation will take over and delete all of the resources in the `template.yaml` file.  




