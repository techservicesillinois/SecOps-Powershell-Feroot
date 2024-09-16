![Pester Tests](https://github.com/techservicesillinois/SecOps-Powershell-Feroot/workflows/Pester%20Tests/badge.svg)
![ScriptAnalyzer](https://github.com/techservicesillinois/SecOps-Powershell-Feroot/workflows/ScriptAnalyzer/badge.svg)

# What is This?

This Powershell module acts as a wrapper for the Feroot REST API, allowing you to create scripts that run operations tasks in Feroot

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

# To Do

- Support for targeting by IPs with Scan functions
- Prod/Dev BaseURI switching
- Example Scripts
