<#
.Synopsis
    Returns the information about different scripts having access to inputs on various pages.
.DESCRIPTION
    Returns the information about different scripts having access to inputs on various pages.
.PARAMETER PageID
    The ID of a page
.PARAMETER ProjectUUIDs
    An array of Project UUIDs
    Use Get-FerootProject to get Project UUIDs
.PARAMETER StartDate
    Timestamp of the start of the date range
.PARAMETER EndDate
    Timestamp of the end of the date range
.EXAMPLE
    Get-FerootAccessInsights -StartDate (Get-Date).AddDays(-30) -EndDate (Get-Date) -PageID 'd970adbbdaae64d521b9ad0a7dfc208415f8eef8'
.EXAMPLE
    Get-FerootAccessInsights -PageID 'd970adbbdaae64d521b9ad0a7dfc208415f8eef8' -ProjectUUIDs @('00000000-0000-0000-0000-000000000000') -StartDate (Get-Date).AddDays(-30) -EndDate (Get-Date)
#>
function Get-FerootAccessInsights{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '',
            Justification = 'This is consistent with the vendors verbiage')]
    param (
        [Parameter(Mandatory=$true)]
        [string]$PageID,
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
        $RelativeUri = "platform/access-insights/$($PageID)?startDate=$($Start)&endDate=$($End)"

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
