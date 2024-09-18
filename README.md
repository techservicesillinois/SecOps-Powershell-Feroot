![Pester Tests](https://github.com/techservicesillinois/SecOps-Powershell-Feroot/workflows/Pester%20Tests/badge.svg)
![ScriptAnalyzer](https://github.com/techservicesillinois/SecOps-Powershell-Feroot/workflows/ScriptAnalyzer/badge.svg)

# What is This?

This Powershell module acts as a wrapper for the Feroot REST API, allowing you to create scripts that run operations tasks in Feroot.
This module is not a feature-complete match of the Feroot API. Please consider contributing functions to this module or requesting functionality that may be valuable.

# How do I install it?

The latest stable release is always available via the [PSGallery](https://www.powershellgallery.com/packages/UofIFeroot).
```powershell
# This will install on the local machine
Install-Module -Name 'UofIFeroot'
```

# How does it work?

Get-Help is available for all functions in this module.
You must run New-FerootSession before other functions can be used.

# How do I help?

Submit a PR on GitHub

# End-of-Life and End-of-Support Dates

As of the last update to this README, the expected End-of-Life and End-of-Support dates of this product are November 2026.

End-of-Life was decided upon based on these dependencies and their End-of-Life dates:

- Powershell 7.4 (November 2026)

# To Do

- New-FerootPolicy
- Edit-FerootPolicy
- New-FerootProject
- Edit-FerootProject
- New-FerootCrawl
- Edit-FerootCrawl
- New-FerootScriptTag
- Edit-FerootScriptTag
- All Cookies endpoint functions
- New-FerootComplianceReport
- Get-FerootDataTransfers
- Get-FerootDataTransferDetails
