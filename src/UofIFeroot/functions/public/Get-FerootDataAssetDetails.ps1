<#
.Synopsis
    Returns detailed information associated with a particular data asset.
.DESCRIPTION
    Returns detailed information associated with a particular data asset.
.PARAMETER AssetName
    One of the possible input asset names.
    Choices are: "email", "password", "username", "name", "first_name", "last_name",
        "company_name", "address", "city", "state", "zip", "phone", "country", "sin", "card_number",
        "cc_number", "cc_code", "cc_other", "date_of_birth", "allergies", "medications", "med_conditions", "other"
.PARAMETER ProjectUUIDs
    An array of Project UUIDs
    Use Get-FerootProjects to get Project UUIDs
.PARAMETER StartDate
    Timestamp of the start of the date range
.PARAMETER EndDate
    Timestamp of the end of the date range
.EXAMPLE
    Get-FerootDataAssetDetails -StartDate (Get-Date).AddDays(-30) -EndDate (Get-Date) -AssetName "email"
.EXAMPLE
    Get-FerootDataAssetDetails -AssetName "password" -ProjectUUIDs @('00000000-0000-0000-0000-000000000000') -StartDate (Get-Date).AddDays(-30) -EndDate (Get-Date)
#>
function Get-FerootDataAssetDetails{
    [CmdletBinding()]
    param (
        [ValidateSet("email", "password", "username", "name", "first_name", "last_name",
        "company_name", "address", "city", "state", "zip", "phone", "country", "sin", "card_number",
        "cc_number", "cc_code", "cc_other", "date_of_birth", "allergies", "medications", "med_conditions", "other")]
        [Parameter(Mandatory=$true)]
        [string]$AssetName,
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
        $RelativeUri = "platform/data-assets/details?assetName=$($AssetName)&startDate=$($Start)&endDate=$($End)"

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
