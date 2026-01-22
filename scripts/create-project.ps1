param(
    [Parameter(Mandatory=$true)]
    [string]$Environment,
    
    [Parameter(Mandatory=$true)]
    [string]$Version
)

# Generate a minimal .csproj file for packaging
$CsprojContent = @"
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>netstandard2.0</TargetFramework>
    <PackageId>MyOrg.Config.$Environment</PackageId>
    <Version>$Version</Version>
    <Authors>DevOpsTeam</Authors>
    <Description>Configuration settings for $Environment environment.</Description>
    <GeneratePackageOnBuild>false</GeneratePackageOnBuild>
    <IncludeBuildOutput>false</IncludeBuildOutput>
  </PropertyGroup>
  <ItemGroup>
    <Content Include="config.json" PackagePath="content" />
  </ItemGroup>
</Project>
"@

Set-Content -Path "config.csproj" -Value $CsprojContent
Write-Host "Created config.csproj for environment: $Environment, version: $Version"
