<#
.Synopsis
    Returns a summary of the form input assets detected in your Feroot Project(s) within a specified time range.
.DESCRIPTION
    Returns a summary of the form input assets detected in your Feroot Project(s) within a specified time range.
.PARAMETER ProjectUUIDs
    An array of Project UUIDs
    Use Get-FerootProjects to get Project UUIDs
.PARAMETER StartDate
    Timestamp of the start of the date range
.PARAMETER EndDate
    Timestamp of the end of the date range
.EXAMPLE
    Get-FerootDataAssets -StartDate (Get-Date).AddDays(-30) -EndDate (Get-Date)
.EXAMPLE
    Get-FerootDataAssets -ProjectUUIDs @('00000000-0000-0000-0000-000000000000', '11111111-0000-0000-0000-1111111111111') -StartDate (Get-Date).AddDays(-30) -EndDate (Get-Date)
#>
function Get-FerootDataAssets{
    [CmdletBinding()]
    param (
        [string[]]$ProjectUUIDs,
        [Parameter(Mandatory=$true)]
        [datetime]$StartDate,
        [Parameter(Mandatory=$true)]
        [datetime]$EndDate
    )

    process{

        #Convert to UNIX Time
        $Start = ([DateTimeOffset]$StartDate).ToUnixTimeSeconds()*1000
        $End = ([DateTimeOffset]$EndDate).ToUnixTimeSeconds()*1000

        # Complete URI with query parameters
        $RelativeUri = "platform/data-assets?startDate=$($Start)&endDate=$($End)"

        if($ProjectUUIDs){
            $ProjectUUIDParam = $ProjectUUIDs | ForEach-Object { "projectUuids[]=$_" }
            $ProjectUUIDParam = $ProjectUUIDParam -join "&"
            $RelativeUri += "&$($ProjectUUIDParam)"
        }

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-FerootRestCall @RestSplat
        $Response
    }
}
