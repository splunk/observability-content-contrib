#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["MultiStageDocker/MultiStageDocker.csproj", "MultiStageDocker/"]
RUN dotnet restore "MultiStageDocker/MultiStageDocker.csproj"
COPY . .
WORKDIR "/src/MultiStageDocker"
RUN dotnet build "MultiStageDocker.csproj" -c Release -o /app/build

# Add dependencies for splunk-otel-dotnet-install.sh
RUN apt-get update && \
	apt-get install -y unzip

# Download Splunk OTel .NET installer
RUN curl -sSfL https://github.com/signalfx/splunk-otel-dotnet/releases/latest/download/splunk-otel-dotnet-install.sh -O

# Install the distribution
RUN sh ./splunk-otel-dotnet-install.sh

FROM build AS publish
RUN dotnet publish "MultiStageDocker.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final

# Copy instrumentation file tree
WORKDIR "/root/.splunk-otel-dotnet"
COPY --from=build /root/.splunk-otel-dotnet/ .

WORKDIR /app
COPY --from=publish /app/publish .
COPY --from=build /src/MultiStageDocker/entrypoint.sh .

# debug that traces are running and add other OTel configurations here
ENV OTEL_DOTNET_AUTO_TRACES_CONSOLE_EXPORTER_ENABLED=true

ENTRYPOINT ["sh", "entrypoint.sh"]
CMD ["dotnet", "MultiStageDocker.dll"]