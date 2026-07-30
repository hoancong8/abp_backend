# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy common props and csproj files first for layer caching
COPY common.props ./
COPY src/AbpSolution1.Domain.Shared/*.csproj ./src/AbpSolution1.Domain.Shared/
COPY src/AbpSolution1.Domain/*.csproj ./src/AbpSolution1.Domain/
COPY src/AbpSolution1.Application.Contracts/*.csproj ./src/AbpSolution1.Application.Contracts/
COPY src/AbpSolution1.Application/*.csproj ./src/AbpSolution1.Application/
COPY src/AbpSolution1.EntityFrameworkCore/*.csproj ./src/AbpSolution1.EntityFrameworkCore/
COPY src/AbpSolution1.HttpApi/*.csproj ./src/AbpSolution1.HttpApi/
COPY src/AbpSolution1.HttpApi.Client/*.csproj ./src/AbpSolution1.HttpApi.Client/
COPY src/AbpSolution1.DbMigrator/*.csproj ./src/AbpSolution1.DbMigrator/
COPY src/AbpSolution1.HttpApi.Host/*.csproj ./src/AbpSolution1.HttpApi.Host/

# Restore NuGet packages
RUN dotnet restore "src/AbpSolution1.HttpApi.Host/AbpSolution1.HttpApi.Host.csproj"

# Copy source code
COPY src/ ./src/

# Publish application with no-restore flag
RUN dotnet publish "src/AbpSolution1.HttpApi.Host/AbpSolution1.HttpApi.Host.csproj" \
    -c Release \
    --no-restore \
    -o /app/publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80

ENTRYPOINT ["dotnet", "AbpSolution1.HttpApi.Host.dll"]
