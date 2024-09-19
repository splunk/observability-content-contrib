#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["MultiStageDocker/MultiStageDocker.csproj", "MultiStageDocker/"]
RUN dotnet restore "./MultiStageDocker/./MultiStageDocker.csproj"
WORKDIR "/src/MultiStageDocker"
COPY . .

RUN dotnet add "./MultiStageDocker.csproj" package Splunk.OpenTelemetry.AutoInstrumentation --prerelease

RUN dotnet build "./MultiStageDocker.csproj" -r linux-x64 -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./MultiStageDocker.csproj" -r linux-x64 -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final

WORKDIR /app
COPY --from=publish /app/publish .

ENTRYPOINT ["./splunk-launch.sh", "dotnet", "MultiStageDocker.dll"]