param(
    [Parameter(Mandatory=$true)]
    [string]$Environment,
    
    [Parameter(Mandatory=$true)]
    [string]$Region,
    
    [Parameter(Mandatory=$true)]
    [string]$Version
)

# Locate the JSON file in the NuGet cache
$PackagePath = Join-Path $env:HOME ".nuget/packages/myorg.config.multi/$Version/content"
$JsonPath = Join-Path $PackagePath "config.json"

if (-not (Test-Path $JsonPath)) { 
    Write-Host "Expected path: $JsonPath"
    Write-Host "Searching for config.json..."
    $JsonPath = Get-ChildItem -Path (Join-Path $env:HOME ".nuget/packages") -Filter "config.json" -Recurse | Select-Object -First 1 -ExpandProperty FullName
}

if (-not $JsonPath) { 
    throw "Config file not found!" 
}

Write-Host "Found config file at: $JsonPath"
Write-Host ""

# Parse the JSON
$ConfigData = Get-Content $JsonPath | ConvertFrom-Json

# Find the specific environment-region configuration
$TargetConfig = $ConfigData.Configurations | Where-Object { 
    $_.Environment -eq $Environment -and $_.Region -eq $Region 
} | Select-Object -First 1

if (-not $TargetConfig) {
    throw "Configuration for environment '$Environment' and region '$Region' not found!"
}

# --- POC VALIDATION ---
Write-Host "========================================="
Write-Host " POC SUCCESS: Configuration Loaded"
Write-Host "========================================="
Write-Host " Target: $Environment-$Region"
Write-Host " Environment: $($TargetConfig.Environment)"
Write-Host " Region: $($TargetConfig.Region)"
Write-Host " Database: $($TargetConfig.Database)"
Write-Host " Connection String: $($TargetConfig.ConnectionString)"
Write-Host " API Endpoint: $($TargetConfig.ApiEndpoint)"
Write-Host " Generated At: $($TargetConfig.GeneratedAt)"
Write-Host "========================================="

# Set environment variables for subsequent steps
"DB_CONNECTION_STRING=$($TargetConfig.ConnectionString)" | Out-File -FilePath $env:GITHUB_ENV -Append
"API_ENDPOINT=$($TargetConfig.ApiEndpoint)" | Out-File -FilePath $env:GITHUB_ENV -Append
"TARGET_ENVIRONMENT=$($TargetConfig.Environment)" | Out-File -FilePath $env:GITHUB_ENV -Append
"TARGET_REGION=$($TargetConfig.Region)" | Out-File -FilePath $env:GITHUB_ENV -Append
