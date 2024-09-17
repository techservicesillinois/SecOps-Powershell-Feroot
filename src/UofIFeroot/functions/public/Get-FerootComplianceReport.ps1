<#
.Synopsis
    Returns a list of compliance reports created in your Feroot Project(s).
.DESCRIPTION
    Returns a list of compliance reports created in your Feroot Project(s).
.PARAMETER ProjectUUIDs
    Project UUID to return the configuration of
    Use Get-FerootProject to get Project UUIDs
.EXAMPLE
    Get-FerootComplianceReport -ProjectUUIDs '00000000-0000-0000-0000-000000000000'
#>
function Get-FerootComplianceReport{
    [CmdletBinding()]
    param (
        [string[]]$ProjectUUIDs
    )

    process{

        # Complete URI with query parameters
        $RelativeUri = "platform/compliance/reports"

        if($ProjectUUIDs){
            $ProjectUUIDParam = $ProjectUUIDs | ForEach-Object { "projectUuids[]=$_" }
            $ProjectUUIDParam = $ProjectUUIDParam -join "&"
            $RelativeUri += "?$($ProjectUUIDParam)"
        }

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-FerootRestCall @RestSplat
        $Response
    }
}
