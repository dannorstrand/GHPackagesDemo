param(
    [Parameter(Mandatory=$true)]
    [string]$Environment
)

# Create a configuration object based on environment
$ConfigData = @{
    Environment = $Environment
    GeneratedAt = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Database    = "sql-$Environment.local"
    Region      = "eastus2"
    FeatureFlag = $true
}

# Save to config.json
$ConfigData | ConvertTo-Json | Set-Content -Path "config.json"

Write-Host "Generated config.json for ${Environment}:"
Get-Content config.json
