<#
.Synopsis
    Returns the specified Feroot Project's configuration.
.DESCRIPTION
    Returns the specified Feroot Project's configuration.
.PARAMETER ProjectUUID
    Project UUID to return the configuration of
    Use Get-FerootProject to get Project UUIDs
.EXAMPLE
    Get-FerootProjectConfiguration -ProjectUUID '00000000-0000-0000-0000-000000000000'
#>
function Get-FerootProjectConfiguration{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProjectUUID
    )

    process{

        # Complete URI with query parameters
        $RelativeUri = "platform/$($ProjectUUID)"

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-FerootRestCall @RestSplat
        $Response
    }
}
