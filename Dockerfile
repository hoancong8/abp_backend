# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy toàn bộ source code vào container
COPY . .

# Restore & Publish dự án API Host
RUN dotnet restore "src/AbpSolution1.HttpApi.Host/AbpSolution1.HttpApi.Host.csproj"
RUN dotnet publish "src/AbpSolution1.HttpApi.Host/AbpSolution1.HttpApi.Host.csproj" -c Release -o /app/publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# Chạy abp install-libs nếu cần thiết tĩnh
ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80

ENTRYPOINT ["dotnet", "AbpSolution1.HttpApi.Host.dll"]
