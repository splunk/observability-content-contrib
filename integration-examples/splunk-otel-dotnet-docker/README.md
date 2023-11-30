# Splunk OTel Dotnet & Docker

This example demonstrates the execution of a .NET application within a Docker container, utilizing the Splunk Distribution of OpenTelemetry for .NET.
The Docker image is constructed using a multi-stage Docker image approach, wherein the build image is more substantial, and the runtime image is a barebone image.

The installation of instrumentation needs to be divided between different stages.
During the build step, the instrumentation is installed, and subsequently, the outcome is transferred to the final image, eliminating the necessity for additional dependencies specified in a separate build step.

The `entrypoint.sh` is essential for sourcing environment variables from the `instrument.sh` script, which is included with the instrumentation. This ensures the correct setup of environment variables for each platform.

## Instructions

1. Set `ENV OTEL_DOTNET_AUTO_TRACES_CONSOLE_EXPORTER_ENABLED=true` in the Dockerfile for verification purposes.
1. Build the Docker image.
1. Map a random host port (e.g.: 8181) to the container port (80).
1. Open your browser and navigate to `http://localhost:8181`.
1. Verify the execution of instrumentation by examining the container logs, which should now include Activity information. (Refer to the sample output below.)

Sample log output:

```txt
2023-11-30 13:16:56 info: Microsoft.Hosting.Lifetime[14]
2023-11-30 13:16:56       Now listening on: http://[::]:80
2023-11-30 13:16:56 info: Microsoft.Hosting.Lifetime[0]
2023-11-30 13:16:56       Application started. Press Ctrl+C to shut down.
2023-11-30 13:16:56 info: Microsoft.Hosting.Lifetime[0]
2023-11-30 13:16:56       Hosting environment: Production
2023-11-30 13:16:56 info: Microsoft.Hosting.Lifetime[0]
2023-11-30 13:16:56       Content root path: /app/
2023-11-30 13:17:02 Activity.TraceId:            31f535f9515f017c72f030c17823651d
2023-11-30 13:17:02 Activity.SpanId:             fb15fa8d223d9f6c
2023-11-30 13:17:02 Activity.TraceFlags:         Recorded
2023-11-30 13:17:02 Activity.ActivitySourceName: OpenTelemetry.Instrumentation.AspNetCore
2023-11-30 13:17:02 Activity.DisplayName:        GET /
2023-11-30 13:17:02 Activity.Kind:               Server
2023-11-30 13:17:02 Activity.StartTime:          2023-11-30T11:17:02.1819362Z
2023-11-30 13:17:02 Activity.Duration:           00:00:00.0766474
2023-11-30 13:17:02 Activity.Tags:
2023-11-30 13:17:02     net.host.name: localhost
2023-11-30 13:17:02     net.host.port: 8181
2023-11-30 13:17:02     http.method: GET
2023-11-30 13:17:02     http.scheme: http
2023-11-30 13:17:02     http.target: /
2023-11-30 13:17:02     http.url: http://localhost:8181/
2023-11-30 13:17:02     http.flavor: 1.1
2023-11-30 13:17:02     http.user_agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0
2023-11-30 13:17:02     http.route: /
2023-11-30 13:17:02     http.status_code: 200
2023-11-30 13:17:02 Resource associated with Activity:
2023-11-30 13:17:02     service.name: MultiStageDocker
2023-11-30 13:17:02     splunk.distro.version: 1.2.0
2023-11-30 13:17:02     telemetry.distro.name: splunk-otel-dotnet
2023-11-30 13:17:02     telemetry.distro.version: 1.2.0
2023-11-30 13:17:02     container.id: 78f56ae03c320713dd0af833f1ab3a844ac5b5f6440ccd4d1716cfe9d73180e4
2023-11-30 13:17:02     telemetry.sdk.name: opentelemetry
2023-11-30 13:17:02     telemetry.sdk.language: dotnet
2023-11-30 13:17:02     telemetry.sdk.version: 1.6.0
2023-11-30 13:17:02
```

## Common known issues

### Visual Studio is not starting the instrumentation

Utilize Visual Studio for constructing the Docker image by right-clicking on the Dockerfile and selecting "Build Docker image." Use Docker Desktop to run the image. It is noteworthy that initiating a container directly from Visual Studio is known to not start the instrumentation.

### instrument.sh is not found

Linux distributions that do not recognize CRLF (Carriage Return Line Feed) file endings may encounter issues when executing the `entrypoint.sh` script. It is necessary to ensure that on such systems, `entrypoint.sh` uses LF (Line Feed) file endings, especially when the file has been modified in a Windows environment.

### The docker exec process may not display all environment variables

The environment variables derived from the `instrument.sh` are not visible when the `env` command is executed through `docker exec`. This occurs because `docker exec` initiates a new session, and the environment variables set in the entry point only apply to the `dotnet MultiStageDocker.dll` session.

### Activity log does not appear

Either the instrumentation wasn't configured properly, or there is no action triggering the activity. In this example, opening the browser at `http://localhost:8181` generates HTTP activity.
