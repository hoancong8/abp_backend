# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Cài đặt Node.js và ABP CLI để cài thư viện frontend (wwwroot/libs)
RUN apt-get update && apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    dotnet tool install -g Volo.Abp.Studio.Cli

ENV PATH="${PATH}:/root/.dotnet/tools"

# Copy toàn bộ source code vào container
COPY . .

# Chạy abp install-libs cho HttpApi.Host
WORKDIR /src/src/AbpSolution1.HttpApi.Host
RUN abp install-libs

# Restore & Publish dự án API Host
WORKDIR /src
RUN dotnet restore "src/AbpSolution1.HttpApi.Host/AbpSolution1.HttpApi.Host.csproj"
RUN dotnet publish "src/AbpSolution1.HttpApi.Host/AbpSolution1.HttpApi.Host.csproj" -c Release -o /app/publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80

ENTRYPOINT ["dotnet", "AbpSolution1.HttpApi.Host.dll"]
