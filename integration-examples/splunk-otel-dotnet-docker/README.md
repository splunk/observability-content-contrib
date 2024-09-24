# Splunk OTel Dotnet & Docker

This example demonstrates the execution of a .NET application within a Docker container, utilizing the Splunk Distribution of OpenTelemetry for .NET.
The Docker image is constructed using a multi-stage Docker image approach, wherein the build image is more substantial, and the runtime image is a barebone image.

The installation of instrumentation needs to be divided between different stages.
During the build step, the instrumentation is installed, and subsequently, the outcome is transferred to the final image, eliminating the necessity for additional dependencies specified in a separate build step.

The `entrypoint.sh` is essential for sourcing environment variables from the `instrument.sh` script, which is included with the instrumentation. This ensures the correct setup of environment variables for each platform.

## Instructions

To build, run from the `splunk-otel-dotnet-docker` directory:
```
docker build -f MultiStageDocker/Dockerfile -t multistagedocker:latest .
```

To execute:

```bash
docker run -d \
  -e OTEL_DOTNET_AUTO_TRACES_CONSOLE_EXPORTER_ENABLED=true \
  -p 8181:8080 \
  multistagedocker:latest
```

Alternatively run points 1-3 manually:

1. Set `ENV OTEL_DOTNET_AUTO_TRACES_CONSOLE_EXPORTER_ENABLED=true` in the Dockerfile for verification purposes.
1. Build the Docker image.
1. Map a random host port (e.g.: 8181) to the container port (8080).
1. Open your browser and navigate to `http://localhost:8181`.
1. Verify the execution of instrumentation by examining the container logs, which should now include Activity information. (Refer to the sample output below.)

```txt
2023-12-01 15:34:28 info: Microsoft.Hosting.Lifetime[14]
2023-12-01 15:34:28       Now listening on: http://[::]:8080
2023-12-01 15:34:28 info: Microsoft.Hosting.Lifetime[0]
2023-12-01 15:34:28       Application started. Press Ctrl+C to shut down.
2023-12-01 15:34:28 info: Microsoft.Hosting.Lifetime[0]
2023-12-01 15:34:28       Hosting environment: Production
2023-12-01 15:34:28 info: Microsoft.Hosting.Lifetime[0]
2023-12-01 15:34:28       Content root path: /app
2023-12-01 15:34:32 Activity.TraceId:            7f34db4b569f6b6dd6c77c1a5d5164e2
2023-12-01 15:34:32 Activity.SpanId:             87c76863b1d6b603
2023-12-01 15:34:32 Activity.TraceFlags:         Recorded
2023-12-01 15:34:32 Activity.ActivitySourceName: OpenTelemetry.Instrumentation.AspNetCore
2023-12-01 15:34:32 Activity.DisplayName:        GET /
2023-12-01 15:34:32 Activity.Kind:               Server
2023-12-01 15:34:32 Activity.StartTime:          2023-12-01T13:34:32.4239711Z
2023-12-01 15:34:32 Activity.Duration:           00:00:00.0958729
2023-12-01 15:34:32 Activity.Tags:
2023-12-01 15:34:32     net.host.name: localhost
2023-12-01 15:34:32     net.host.port: 8181
2023-12-01 15:34:32     http.method: GET
2023-12-01 15:34:32     http.scheme: http
2023-12-01 15:34:32     http.target: /
2023-12-01 15:34:32     http.url: http://localhost:8181/
2023-12-01 15:34:32     http.flavor: 1.1
2023-12-01 15:34:32     http.user_agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0
2023-12-01 15:34:32     http.route: /
2023-12-01 15:34:32     http.status_code: 200
2023-12-01 15:34:32 Resource associated with Activity:
2023-12-01 15:34:32     service.name: MultiStageDocker
2023-12-01 15:34:32     splunk.distro.version: 1.2.0
2023-12-01 15:34:32     telemetry.distro.name: splunk-otel-dotnet
2023-12-01 15:34:32     telemetry.distro.version: 1.2.0
2023-12-01 15:34:32     container.id: 9cc3abcf5e01dd5276768fe5e008ffc0a83cb57073d8dd98dc2e2c79f5620100
2023-12-01 15:34:32     telemetry.sdk.name: opentelemetry
2023-12-01 15:34:32     telemetry.sdk.language: dotnet
2023-12-01 15:34:32     telemetry.sdk.version: 1.6.0
2023-12-01 15:34:32
```

To send the traces to an OTLP receiver just define the endpoint via ENV.
```
docker run -d \
  -e OTEL_DOTNET_AUTO_TRACES_CONSOLE_EXPORTER_ENABLED=true \
  -e OTEL_SERVICE_NAME=service_name \
  -e OTEL_EXPORTER_OTLP_ENDPOINT=http://otelcol.lan:4318
  -e OTEL_RESOURCE_ATTRIBUTES=deployment.environment=dev,service.version=1
  -p 8181:8080 \
  multistagedocker:latest
```

## Alternative Option:  NuGet Package

You can also deploy the Splunk Distribution of the OpenTelemetry .NET instrumentation automatically using the official NuGet packages.

Refer to [NuGet package installation considerations](https://docs.splunk.com/observability/en/gdi/get-data-in/application/otel-dotnet/instrumentation/instrument-dotnet-application.html#nuget-package-installation-considerations)
to determine if the NuGet option is preferable for your specific scenario.

Generally, it's best to add the NuGet package as part of the application development process. 
This is done by adding the NuGet packages with the following command, replacing \<project\> 
with the .csproj file name:
````
dotnet add <project> package Splunk.OpenTelemetry.AutoInstrumentation --prerelease
````

Installing this NuGet package results in multiple dependencies added to the project, along with 
version changes for existing dependencies, which should all be tested locally before dockerizing 
and deploying to a higher environment. 

If this isn't possible, then you might consider adding this step to the Dockerfile instead:

```bash
RUN dotnet add "./MultiStageDocker.csproj" package Splunk.OpenTelemetry.AutoInstrumentation --prerelease
```


To build the example Docker image with this option, run from the `splunk-otel-dotnet-docker` directory:
```
docker build -f MultiStageDockerNuGetOption/Dockerfile -t multistagedockernuget:latest .
```

To execute:

```bash
docker run -d \
  -e OTEL_DOTNET_AUTO_TRACES_CONSOLE_EXPORTER_ENABLED=true \
  -p 8181:8080 \
  multistagedockernuget:latest
```

This option requires a Runtime Identifier (RID) to be passed into the `dotnet build` 
and `dotnet publish` commands in the Dockerfile: 

```bash
RUN dotnet build "./MultiStageDocker.csproj" -r linux-x64 -c $BUILD_CONFIGURATION -o /app/build
...
RUN dotnet publish "./MultiStageDocker.csproj" -r linux-x64 -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false
```

You might need to update the runtime identifier value for your target environment. Refer 
to [Find the runtime identifier for your .NET applications](https://docs.splunk.com/observability/en/gdi/get-data-in/application/otel-dotnet/troubleshooting/common-dotnet-troubleshooting.html#find-the-runtime-identifier-for-your-net-applications)
for further details.

## Common known issues

### Visual Studio is not starting the instrumentation

Utilize Visual Studio for constructing the Docker image by right-clicking on the Dockerfile and selecting "Build Docker image." Use Docker Desktop to run the image. It is noteworthy that initiating a container directly from Visual Studio is known to not start the instrumentation.

### instrument.sh is not found

Linux distributions that do not recognize CRLF (Carriage Return Line Feed) file endings may encounter issues when executing the `entrypoint.sh` script. It is necessary to ensure that on such systems, `entrypoint.sh` uses LF (Line Feed) file endings, especially when the file has been modified in a Windows environment.

See more info [here](https://en.wikipedia.org/wiki/Newline#Issues_with_different_newline_formats).

### The docker exec process may not display all environment variables

The environment variables derived from the `instrument.sh` are not visible when the `env` command is executed through `docker exec`. This occurs because `docker exec` initiates a new session, and the environment variables set in the entry point only apply to the `dotnet MultiStageDocker.dll` session.

### Activity log does not appear

Either the instrumentation wasn't configured properly, or there is no action triggering the activity. In this example, opening the browser at `http://localhost:8181` generates HTTP activity.
