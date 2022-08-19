# o11y-quickstart-demo

## OpenTelemetry Quick Start Demo

OpenTelemetry Quick Start is a guide to how to quickly get started evaluating the features of Splunk Observability Cloud. This exercise is using the Splunk branch of the [Online Boutique microservices demo application](https://github.com/signalfx/microservices-demo-rum "microservices-demo-rum github repository") instrumented with Application Peformance Monitoring and Real User Monitoring. The [Splunk OpenTelemetry Collector for Kubernetes](https://github.com/signalfx/splunk-otel-collector-chart "Splunk OpenTelemetry Collector for Kubernetes Repository") is also installed along side the microservices demo relaying signals to Splunk Observability Cloud as well as providing Infrastructure Metrics.

1. Sign-up for the free trial at [Try Splunk Observability Cloud Free for 14 days](https://www.splunk.com/en_us/download/o11y-cloud-free-trial.html?utm_campaign=solutionsinnovationspecial "14-Day Trial Link")

## Preparation and Prerequisites Prior to Installation

Docker, Minikube, Helm and GSED should be installed prior to starting this exercise. After the prerequistes are met then we will Start Minikube with the enough memory to run the example applications and services.

1. [Docker](https://docs.docker.com/engine/install/ "Install Docker") - Install Docker if needed.
2. [Minikube](https://minikube.sigs.k8s.io/docs/start/ "Minikube Quick Start") - Install and configure Minikube.
3. [Helm](https://helm.sh/docs/intro/install/ "Install Helm v3+") - Install Helm version 3.0+ or Latest.
4. [GSED](https://formulae.brew.sh/formula/gnu-sed "brew install gnu-sed") - gsed is used in the configuration script for the kubernetes manifests.

## Pre-Installation

Launch Minikube with at least 4 CPUs, 4 GiB Memory and 32GB of disk space.

    minikube start --cpus=6 --memory 4096 --disk-size 32g --container-runtime=docker --vm=true

Check minikube's docker-daemon environment variables using the command:

    minikube docker-env

### Example output from the command `minikube docker-env`

    % minikube docker-env
    export DOCKER_TLS_VERIFY="1"
    export DOCKER_HOST="tcp://192.168.64.4:2376"
    export DOCKER_CERT_PATH="/Users/auser/.minikube/certs"
    export MINIKUBE_ACTIVE_DOCKERD="minikube"

Point your shell to minikube's docker daemon by running:

    eval $(minikube -p minikube docker-env)

## Installation

### Sending data to Splunk Observability Cloud through an OpenTelemetry Collector

Download the Splunk opentelemetry helm chart and assocaiate the Helm repository.

### Get the installer for splunk-otel-collector-chart

    git clone https://github.com/signalfx/splunk-otel-collector-chart

### Add Helm repo `splunk-otel-collector-chart` to the minikube environment

    helm repo add splunk-otel-collector-chart https://signalfx.github.io/splunk-otel-collector-chart

### Install `splunk-otel-collector-chart`

To use the helm install command setting a collector name such as `my-local-splunk-o11y-otel-collector` to identify your collector.

For Splunk Observability Cloud the following parameters are required: Variables for realm, access token, and a name for your otel collector need to be set when installing the helm chart.

splunk-otel-collector-chart/splunk-otel-collector parameters:

1. `splunkObservability.realm=<us0|us1|eu1|jp0|future_realm>`
2. `splunkObservability.accessToken=<Splunk Observability Cloud Ingest Token>`
3. `clusterName=<my-local-otel-collector-cluster|an-actual-useful-name>`

Example of the Helm command to install for Splunk Observability Cloud `splunk-otel-collector-chart/splunk-otel-collector`:

    helm install my-local-splunk-o11y-otel-collector --set="splunkObservability.realm=us1,splunkObservability.accessToken=***-******************,clusterName=my-local-otel-collector-cluster" splunk-otel-collector-chart/splunk-otel-collector

## Build and install the microservices demo (Hipstershop) to run locally

    git clone https://github.com/signalfx/microservices-demo-rum

Change directories to the cloned repository microservices-demo-rum:

    cd ./microservices-demo-rum

## Export Real User Monitoring Token

    export RUM_REALM=<YOUR_RUM_SPLUNK_REALM> RUM_AUTH=<YOUR_RUM_AUTH_TOKEN>

Optional RUM parameters: RUM_APP_NAME, RUM_ENVIRONMENT and RUM_DEBUG can be used as well.

    export RUM_REALM=<YOUR_RUM_SPLUNK_REALM> RUM_AUTH=<YOUR_RUM_AUTH_TOKEN> RUM_APP_NAME=<YOUR_APP_NAME> RUM_ENVIRONMENT=<YOUR_ENVIRONMENT_NAME>

## Build the Microservices Demo Application

Create kubernetes manifest files, making sure to export the RUM_REALM and TOKEN prior to running the script:

    ./hack/make-release-artifacts.sh

## Deploying the application

    kubectl apply -f ./release/kubernetes-manifests.yaml

Run the command `kubectl get pods` and verify that the services are running and the external IP is exposed. This may take a few moments to get all the services started.

    kubectl get pods

## Wait for services to start and expose external ports

After all services are running, use the following commands:

This command forwards a port to the frontend service.

    kubectl port-forward deployment/frontend 8080:8080 &

This command outputs the nodeport and address for the loadgenerator service. Use this address to access the load generator service.

    minikube service loadgenerator --url

After port mapping one can run  `kubectl get pods` and verify that the services are running and the external IP are exposed expected ports.

Example output from the command `kubectl get pods`

    NAME                                     READY   STATUS    RESTARTS   AGE
    my-splunk-otel-collector-qph4v           1/1     Running   0          4m21s
    adservice-76bdd69666-ckc5j               1/1     Running   0          2m58s
    cartservice-66d497c6b7-dp5jr             1/1     Running   0          2m59s
    checkoutservice-666c784bd6-4jd22         1/1     Running   0          3m1s
    currencyservice-5d5d496984-4jmd7         1/1     Running   0          2m59s
    emailservice-667457d9d6-75jcq            1/1     Running   0          3m2s
    frontend-6b8d69b9fb-wjqdg                1/1     Running   0          3m1s
    loadgenerator-665b5cd444-gwqdq           1/1     Running   0          3m
    paymentservice-68596d6dd6-bf6bv          1/1     Running   0          3m
    productcatalogservice-557d474574-888kr   1/1     Running   0          3m
    recommendationservice-69c56b74d4-7z8r5   1/1     Running   0          3m1s
    redis-cart-5f59546cdd-5jnqf              1/1     Running   0          2m58s
    shippingservice-6ccc89f8fd-v686r         1/1     Running   0          2m58s

## Navigate to Microservices-Demo Hipstershop and create some traffic manually

1. Explore the front end instrumented with Real User Monitoring (RUM) at <http://localhost:8080>.

## Create load automatically with the load generator service

1. Navigate to the NodePort address output from the `minikube service loadgenerator --url` command run earlier.
2. Setup the desired tests and run them against the local services.

## Navigate to the Splunk Observability Cloud Trial Organization

Start by navigating to the Splunk Observability Cloud Realm which was configured and then log into the appropriate organization. You should be able to see some of your trace data within a few minutes or less.

Example URL:
    <https://app.your_realm.signalfx.com/#/apm?startTime=-15m&endTime=Now>

1. Login or Navigate to your Splunk Observability Cloud Trial Organization.
2. Navigate to the Splunk Infrastructure Manager to see the infrastructure setup in this exercise clicking `Infrastructure -> Kubernetes`.
3. Navigate to Application Performance Monitoring see the Application Performance and Distributed Traces.
4. Navigate to Real User Monitoring and see how Real Users are interacting with the web application.
5. (Optional) Review the [Welcome to Splunk Observability Cloud](https://docs.splunk.com/Observability/get-started/welcome.html#welcome "Welcome to Splunk Observability Cloud Link") page gives an overview of the capabilities and use-cases of Splunk Observability Cloud.

### Useful Refererences

#### Delete a Helm chart

    helm delete my-local-splunk-o11y-otel-collector 

#### Use a YAML file rather than environment variables

    helm install my-splunk-otel-collector --values my_values.yaml splunk-otel-collector-chart/splunk-otel-collector

Example splunk-otel-collector YAML file for a local container:

    apiVersion: v1
    kind: Pod
    metadata:
    name: splunk-otel-collector-name
    namespace: default
    spec:
    containers:
    - name: splunk-otel-collector-name
    image: splunk-otel-collector-name:latest

## Contributing

We welcome feedback and contributions from the community! Please see our [(contribution guidelines)](https://github.com/signalfx/splunk-otel-collector-chart/blob/main/CONTRIBUTING.md "contribution guidelines") for more information on how to get involved.

## License

Apache Software License version 2.0.
