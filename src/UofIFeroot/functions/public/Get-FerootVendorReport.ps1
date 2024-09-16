<#
.Synopsis
    Returns the overall vendor statistics and a list of vendors' products detected in Feroot Projects within a specified time range.
.DESCRIPTION
    Returns the overall vendor statistics and a list of vendors' products detected in Feroot Projects within a specified time range.
.PARAMETER ProjectUUIDs
    An array of Project UUIDs
    Use Get-FerootProjects to get Project UUIDs
.PARAMETER StartDate
    Timestamp of the start of the date range
.PARAMETER EndDate
    Timestamp of the end of the date range
.EXAMPLE
    Get-FerootVendorReport -StartDate (Get-Date).AddDays(-30) -EndDate (Get-Date)
.EXAMPLE
    Get-FerootVendorReport -ProjectUUIDs @('00000000-0000-0000-0000-000000000000', '11111111-0000-0000-0000-1111111111111') -StartDate (Get-Date).AddDays(-30) -EndDate (Get-Date)
#>
function Get-FerootVendorReport{
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
        $StartDate = ([DateTimeOffset]$StartDate).ToUnixTimeSeconds()*1000
        $EndDate = ([DateTimeOffset]$EndDate).ToUnixTimeSeconds()*1000

        $ProjectUUIDParam = $ProjectUUIDs | ForEach-Object { "projectUuids[]=$_" }
        $ProjectUUIDParam = $ProjectUUIDParam -join "&"

        # Complete URI with query parameters
        $RelativeUri = "platform/vendors?startDate=$($ThirtyDaysAgo)&endDate=$($Today)&$($ProjectUUIDParam)"

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-FerootRestCall @RestSplat
        $Response
    }
}
