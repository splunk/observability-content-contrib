# ci-webhook-serverless-example

This example uses the Node.js `serverless` toolset to create an AWS Lambda
function implemented in Python to handle websocket requests from a continuous
build system. Requests to the lambda function are logged to a DynamoDB database
so that the elapsed time of each step of the build process can be captured. The
lambda function reports `build started` and `build complete` events to Splunk
Infrastucture Monitoring along with metrics for the build and each step (
`build_system.build_time_ms` and `build_system.step_time_ms`, respectively)

The provided `generate-test-events.py` script will simulate data coming from a
build process. Extending this example to an actual build system would involve
add curl scripts to your build process to forward event information to the lambda
handler. The handler translates these asyncronous events into metrics for tracking
the progress of builds.

A sample dashboard is provided illustrating usage of these metrics and
annotation via events.

## Deploying the example to AWS

1. Install `serverless` from [https://www.serverless.com/](https://www.serverless.com/). This
toolset is used to push lambda functions and supporting components as described
via the `serverless.yml` configuration.

    ```
    npm install -g serverless
    cd ci-webhook-handler
    npm init --yes
    npm install --save serverless-python-requirements
    ```

1. Review the info in `serverless.yml`. You can change the names of the
resources in `serverless.yml`, but you'll need to make corresponding changes
to the lambda function.

1. Create an AWS Credential for serverless to deploy

    There are several options for connecting. See : https://www.serverless.com/framework/docs/providers/aws/guide/credentials/

1. Package the necessary python libraries with the runtime. `serverless` uses
Docker to build a custom runtime by pulling the AWS runtime as a docker image
and including dependencies declared in `requirements.txt` into that image to
form a custom runtime. NOTE: THIS MAY TAKE A VERY LONG TIME THE FIRST RUN (if
it has to pull base images from AWS Docker repo and run `docker build`)

    ```
    serverless deploy
    ```

    When that is complete you should see the lambda URL denoted under `endpoints:`
    as the sole `POST` endpoint

1. The configuration in `serverless.yml` sets up a secret using AWS Secrets Manager to
store your Splunk Infrastructure Monitoring credentials. This secret is by default
named `SignalFx/Ingest`. You will need to edit that secret and set the secret
values for two keys `SignalFxRealm` and `SignalFxToken`.

1. At this point you should have a running lambda function which you can test
at the command line via (using the lambda URL which was returned from
the `serverless deploy` command):

    ```
    curl -X POST -H "Content-Type: application/json" -d '{ "environment": "env01", "buildId": "abc321", "eventType": "start_build", "buildStep": "start", "status": "success" }' <lambda_url>
    ```
    (wait a few seconds)
    ```
    curl -X POST -H "Content-Type: application/json" -d '{ "environment": "env01", "buildId": "abc321", "eventType": "build_step", "buildStep": "step1", "status": "success" }' <lambda_url>
    ```
    (wait a few seconds)
    ```
    curl -X POST -H "Content-Type: application/json" -d '{ "environment": "env01", "buildId": "abc321", "eventType": "build_complete", "buildStep": "finito", "status": "success" }' <lambda_url>
    ```

1. You should now be able to log into Splunk Infrastructure Monitoring and
create a new chart showing metrics `build_system.build_time_ms` and
`build_system.step_time_ms`.

1. You can generate some fake data with:

    ```
    python3 generate-test-events.py <lambda_url> <environment>
    ```

1. You can import the custom dashboard `dashboard_Build System Demo.json`. You
should see metrics and events depicted in that dashboard.
