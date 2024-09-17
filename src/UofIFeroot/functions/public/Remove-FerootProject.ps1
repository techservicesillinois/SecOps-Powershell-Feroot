<#
.Synopsis
    Deletes a Feroot project
.DESCRIPTION
    Deletes a Feroot project
.PARAMETER ProjectUUID
    Project UUID to delete
    Use Get-FerootProject to get Project UUIDs
.EXAMPLE
    Remove-FerootProject -ProjectUUID '00000000-0000-0000-0000-000000000000'
#>
function Remove-FerootProject{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProjectUUID
    )

    process{

        # Complete URI with query parameters
        $RelativeUri = "platform/$($ProjectUUID)"

        $RestSplat = @{
            Method = 'DELETE'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-FerootRestCall @RestSplat
        $Response
    }
}
