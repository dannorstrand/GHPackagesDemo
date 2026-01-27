param(
    [Parameter(Mandatory=$false)]
    [string]$EnvironmentsFile = "config/environments.txt",
    
    [Parameter(Mandatory=$false)]
    [string]$RegionsFile = "config/regions.txt"
)

# Read environments and regions from config files
$Environments = Get-Content $EnvironmentsFile | Where-Object { $_ -and $_.Trim() }
$Regions = Get-Content $RegionsFile | Where-Object { $_ -and $_.Trim() }

Write-Host "========================================="
Write-Host "  Generating Multi-Environment Config"
Write-Host "========================================="
Write-Host "Environments: $($Environments -join ', ')"
Write-Host "Regions: $($Regions -join ', ')"
Write-Host ""

# Generate configurations for all combinations
$Configurations = @()
$GeneratedAt = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

foreach ($Environment in $Environments) {
    foreach ($Region in $Regions) {
        $Config = @{
            Environment          = $Environment
            Region              = $Region
            GeneratedAt         = $GeneratedAt
            Database            = "sql-$Environment-$Region.local"
            ConnectionString    = "Server=sql-$Environment-$Region.local;Database=AppDB;Integrated Security=true;"
            ApiEndpoint         = "https://api-$Environment-$Region.contoso.com"
            FeatureFlag         = $true
        }
        
        $Configurations += $Config
        Write-Host "Generated config for: $Environment-$Region"
    }
}

# Create the final JSON structure
$FinalConfig = @{
    Version        = "1.0"
    GeneratedAt    = $GeneratedAt
    Configurations = $Configurations
}

# Save to config.json
$FinalConfig | ConvertTo-Json -Depth 10 | Set-Content -Path "config.json"

Write-Host ""
Write-Host "Generated config.json with $($Configurations.Count) configurations"
Write-Host "========================================="
