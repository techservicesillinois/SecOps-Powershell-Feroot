<#
.Synopsis
    Returns the details for a vendor's product's activity within a specified time range.
.DESCRIPTION
    Returns the details for a vendor's product's activity within a specified time range.
.PARAMETER VendorID
    The ID of a vendor's product
.PARAMETER ProjectUUIDs
    An array of Project UUIDs
    Use Get-FerootProjects to get Project UUIDs
.PARAMETER StartDate
    Timestamp of the start of the date range
.PARAMETER EndDate
    Timestamp of the end of the date range
.EXAMPLE
    Get-FerootVendorDetails -StartDate (Get-Date).AddDays(-30) -EndDate (Get-Date) -VendorID "twitter"
.EXAMPLE
    Get-FerootVendorDetails -VendorID "yahoo" -ProjectUUIDs @('00000000-0000-0000-0000-000000000000') -StartDate (Get-Date).AddDays(-30) -EndDate (Get-Date)
#>
function Get-FerootVendorDetails{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$VendorID,
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
        $RelativeUri = "platform/vendors/details?vendorId=$($VendorID)&startDate=$($Start)&endDate=$($End)"

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
