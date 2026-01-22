param(
    [Parameter(Mandatory=$true)]
    [string]$Environment,
    
    [Parameter(Mandatory=$true)]
    [string]$Version
)

# Locate the JSON file in the NuGet cache
# NuGet packages are stored in ~/.nuget/packages/packageid/version/
$PackagePath = Join-Path $env:HOME ".nuget/packages/myorg.config.$Environment/$Version/content"
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

# Parse the JSON
$Config = Get-Content $JsonPath | ConvertFrom-Json

# --- POC VALIDATION ---
Write-Host "----------------------------------------"
Write-Host " POC SUCCESS: Configuration Loaded"
Write-Host "----------------------------------------"
Write-Host " Target Environment: $($Config.Environment)"
Write-Host " Database Connection: $($Config.Database)"
Write-Host " Region: $($Config.Region)"
Write-Host "----------------------------------------"

# Example: Setting a pipeline variable for subsequent steps
"DB_CONNECTION_STRING=$($Config.Database)" | Out-File -FilePath $env:GITHUB_ENV -Append
