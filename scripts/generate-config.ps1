param(
    [Parameter(Mandatory=$true)]
    [string]$Environment,
    
    [Parameter(Mandatory=$true)]
    [string]$Region
)

# Create a configuration object based on environment and region
$ConfigData = @{
    Environment = $Environment
    Region      = $Region
    GeneratedAt = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Database    = "sql-$Environment-$Region.local"
    FeatureFlag = $true
}

# Save to config.json
$ConfigData | ConvertTo-Json | Set-Content -Path "config.json"

Write-Host "Generated config.json for ${Environment}-${Region}:"
Get-Content config.json
