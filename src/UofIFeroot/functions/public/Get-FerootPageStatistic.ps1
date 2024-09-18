<#
.Synopsis
    Returns a summary of the pages detected in your Feroot Project(s) within a specified time range.
.DESCRIPTION
    Returns a summary of the pages detected in your Feroot Project(s) within a specified time range.
.PARAMETER ProjectUUIDs
    An array of Project UUIDs
    Use Get-FerootProject to get Project UUIDs
.PARAMETER StartDate
    Timestamp of the start of the date range
.PARAMETER EndDate
    Timestamp of the end of the date range
.EXAMPLE
    Get-FerootPageStatistic -StartDate (Get-Date).AddDays(-30) -EndDate (Get-Date)
.EXAMPLE
    Get-FerootPageStatistic -ProjectUUIDs @('00000000-0000-0000-0000-000000000000', '11111111-0000-0000-0000-1111111111111') -StartDate (Get-Date).AddDays(-30) -EndDate (Get-Date)
#>
function Get-FerootPageStatistic{
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
        $RelativeUri = "platform/pages/stats?startDate=$($Start)&endDate=$($End)"

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
