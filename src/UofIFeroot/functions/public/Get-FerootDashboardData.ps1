<#
.Synopsis
    Returns a summary of the events in your Feroot Project(s) within a specified time range.
.DESCRIPTION
    Returns a summary of the events in your Feroot Project(s) within a specified time range.
.PARAMETER StartDate
    Timestamp of the start of the date range
.PARAMETER EndDate
    Timestamp of the end of the date range
.EXAMPLE
    Get-FerootDashboardData -StartDate (Get-Date).AddDays(-30) -EndDate (Get-Date)
#>
function Get-FerootDashboardData{
    [CmdletBinding()]
    param (
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
        $RelativeUri = "platform/dashboard?startDate=$($Start)&endDate=$($End)"

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-FerootRestCall @RestSplat
        $Response
    }
}
