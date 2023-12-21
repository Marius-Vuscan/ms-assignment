#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base

USER root
RUN apt-get update && apt-get install -y iputils-ping
USER app

WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["Assignment.ServiceB/Assignment.ServiceB.csproj", "Assignment.ServiceB/"]
RUN dotnet restore "./Assignment.ServiceB/./Assignment.ServiceB.csproj"
COPY . .
WORKDIR "/src/Assignment.ServiceB"
RUN dotnet build "./Assignment.ServiceB.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./Assignment.ServiceB.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Assignment.ServiceB.dll"]