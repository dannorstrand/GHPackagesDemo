# GitHub Packages Configuration Management POC

A proof-of-concept demonstrating how to use GitHub Packages as a centralized configuration management solution using NuGet packages and GitHub Actions workflows.

## Overview

This project showcases a pattern for:
- **Packaging** environment-specific configurations as NuGet packages
- **Publishing** configuration packages to GitHub Packages
- **Consuming** configuration packages in deployment workflows
- **Distributing** configuration across multiple environments without duplicating workflow code

## Use Cases

- Centralized configuration management across multiple repositories
- Environment-specific configuration distribution (dev, staging, prod)
- Versioned configuration deployment
- Secure configuration sharing using GitHub Packages authentication
- Decoupling configuration from application code

## Workflows

### Producer Workflow (`producer.yml`)

Generates environment-specific configuration and publishes it as a NuGet package to GitHub Packages.

**Inputs:**
- `environment`: Target environment (e.g., dev, prod)
- `version`: Package version (e.g., 1.0.0)

**What it does:**
1. Generates a configuration JSON file based on the environment
2. Creates a .NET project file (.csproj) to package the configuration
3. Packs the configuration as a NuGet package
4. Publishes to GitHub Packages

**To run:**
1. Go to Actions → "POC - Config Producer (Package)"
2. Click "Run workflow"
3. Enter environment name (e.g., `dev`)
4. Enter version (e.g., `1.0.0`)
5. Run workflow

### Consumer Workflow (`consumer.yml`)

Retrieves a configuration package from GitHub Packages and uses it in a deployment workflow.

**Inputs:**
- `environment`: Environment to fetch (e.g., dev, prod)
- `version`: Version to deploy (e.g., 1.0.0)

**What it does:**
1. Authenticates to GitHub Packages
2. Downloads the specified configuration package
3. Extracts and parses the configuration JSON
4. Makes configuration available for deployment steps

**To run:**
1. Go to Actions → "POC - Config Consumer (Deploy)"
2. Click "Run workflow"
3. Enter environment name (e.g., `dev`)
4. Enter version (e.g., `1.0.0`)
5. Run workflow

## Configuration Format

The generated configuration includes:

```json
{
  "Environment": "dev",
  "GeneratedAt": "2026-01-21 10:30:00",
  "Database": "sql-dev.local",
  "Region": "eastus2",
  "FeatureFlag": true
}
```

You can customize the configuration structure in the "Generate Configuration JSON" step of the producer workflow.

## Architecture

```
┌─────────────────────┐
│  Producer Workflow  │
│   (Build Config)    │
└──────────┬──────────┘
           │ Publishes
           ▼
┌─────────────────────┐
│  GitHub Packages    │
│   (NuGet Registry)  │
└──────────┬──────────┘
           │ Downloads
           ▼
┌─────────────────────┐
│  Consumer Workflow  │
│   (Use Config)      │
└─────────────────────┘
```

## Prerequisites

- GitHub repository with Actions enabled
- GitHub Packages enabled for the repository
- Workflow permissions set to allow package write/read:
  - Repository Settings → Actions → General → Workflow permissions
  - Enable "Read and write permissions"

## Package Naming Convention

Packages follow the format: `MyOrg.Config.{environment}`

Examples:
- `MyOrg.Config.dev` - Development configuration
- `MyOrg.Config.staging` - Staging configuration
- `MyOrg.Config.prod` - Production configuration

## Security Considerations

- Configuration packages are private by default (requires authentication)
- Uses `GITHUB_TOKEN` for secure authentication
- Packages are scoped to the repository owner
- Access controlled via GitHub Packages permissions

## Extending This POC

To adapt this for production use:

1. **Add more configuration fields**: Modify the `$ConfigData` object in producer workflow
2. **Support multiple files**: Add more files to the `.csproj` `<ItemGroup>`
3. **Add validation**: Include configuration schema validation
4. **Environment protection**: Use GitHub Environment protection rules
5. **Secrets integration**: Combine with GitHub Secrets for sensitive values
6. **Multi-repo consumption**: Use the consumer pattern in other repositories

## Troubleshooting

### Package not found
- Ensure the producer workflow completed successfully
- Verify the package exists in Packages tab
- Check that environment and version match exactly

### Authentication failed
- Verify `GITHUB_TOKEN` has packages:read permission
- Check workflow permissions in repository settings

### Config file not found
- The package is stored in `~/.nuget/packages/myorg.config.{env}/{version}/content/`
- Check the workflow logs for the actual download location

## License

This is a proof-of-concept project for demonstration purposes.