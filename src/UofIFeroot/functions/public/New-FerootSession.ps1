<#
.Synopsis
    This function creates a Feroot user session to be used with the other functions in this module.
.DESCRIPTION
    This function creates a Feroot user session to be used with the other functions in this module.
.PARAMETER Credential
    Credential object with your Feroot API Key stored as the PASSWORD. Username can be anything.
.EXAMPLE
    $Credential = Get-Credential
    PowerShell credential request
    Enter your credentials.
    User: none
    Password for user none: <Feroot API Key>
    New-FerootSession -Credential $Credential
.EXAMPLE
    You can also export/import credentials to an XML file to use these functions without entering your API key each session (less secure):
    $Credential = Get-Credential (only needs to be done once)
    $Credential | Export-Clixml -Path '.\FerootAPIKey.xml' (only needs to be done once)
    $Credential = Import-Clixml -Path '.\FerootAPIKey.xml'
    New-FerootSession -Credential $Credential
#>
function New-FerootSession{
    param (
        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]$Credential
    )

    process{

        # Extract the API key (password) from the PSCredential object
        $Script:Session = $Credential.GetNetworkCredential().Password
    }
}
