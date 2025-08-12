# ShadowFlowerCouncil Runbook

## Overview
ShadowFlowerCouncil is a PowerShell-based project that requires proper execution environment and security considerations.

## Prerequisites
- PowerShell 7.0+ (recommended) or PowerShell 5.1+
- Windows 10/11 or Windows Server 2016+
- Execution Policy configured appropriately

## Local Development

### Setup
1. Clone the repository:
   ```powershell
   git clone https://github.com/EsKaye/ShadowFlowerCouncil.git
   cd ShadowFlowerCouncil
   ```

2. Configure execution policy (if needed):
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. Install PSScriptAnalyzer for development:
   ```powershell
   Install-Module PSScriptAnalyzer -Force -Scope CurrentUser
   ```

### Development Commands
- **Lint scripts**: `Invoke-ScriptAnalyzer -Path . -Recurse`
- **Validate syntax**: Check individual scripts with `pwsh -NoProfile -File script.ps1`
- **Run tests**: Execute scripts in test environment

## Environment Variables
- `PSExecutionPolicy`: PowerShell execution policy setting
- `PSModulePath`: Module search paths

## Troubleshooting

### Common Issues
1. **Execution Policy Errors**: Use `Set-ExecutionPolicy` to allow script execution
2. **Module Not Found**: Ensure PSScriptAnalyzer is installed
3. **Permission Denied**: Run as Administrator if needed

### Debug Mode
Enable verbose output:
```powershell
$VerbosePreference = "Continue"
```

## Security Considerations
- Review all scripts before execution
- Use signed scripts when possible
- Keep execution policy appropriately configured
- Regularly update PowerShell and modules

## CI/CD Integration
- Automated linting with PSScriptAnalyzer
- Syntax validation on all PowerShell scripts
- Security scanning for vulnerabilities