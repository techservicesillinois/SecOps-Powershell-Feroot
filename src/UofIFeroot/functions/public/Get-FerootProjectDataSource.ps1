<#
.Synopsis
    Returns a project's data sources from Feroot
.DESCRIPTION
    Returns a project's data sources from Feroot
.PARAMETER ProjectUUID
    Project UUID to return the data sources from
    Use Get-FerootProject to get Project UUIDs
.EXAMPLE
    Get-FerootProjectDataSource -ProjectUUID '00000000-0000-0000-0000-000000000000'
#>
function Get-FerootProjectDataSource{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProjectUUID
    )

    process{

        # Complete URI with query parameters
        $RelativeUri = "platform/$($ProjectUUID)/data-source"

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-FerootRestCall @RestSplat
        $Response
    }
}
