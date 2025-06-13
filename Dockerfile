# Use .NET 7.0 for better security and performance
FROM mcr.microsoft.com/dotnet/aspnet:7.0-alpine AS base
WORKDIR /app
# Add non-root user for security
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

FROM mcr.microsoft.com/dotnet/sdk:7.0-alpine AS build
WORKDIR /src
COPY ./src ./src
RUN dotnet restore src/VulnerableApi/VulnerableApi.csproj
RUN dotnet publish src/VulnerableApi/VulnerableApi.csproj -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 80
ENTRYPOINT ["dotnet", "VulnerableApi.dll"]
