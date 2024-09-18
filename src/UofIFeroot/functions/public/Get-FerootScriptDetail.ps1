<#
.Synopsis
    Returns the details of a script's activity within a specified time interval.
.DESCRIPTION
    Returns the details of a script's activity within a specified time interval.
.PARAMETER ScriptID
    The ID of a vendor's product
.PARAMETER ProjectUUIDs
    An array of Project UUIDs
    Use Get-FerootProject to get Project UUIDs
.PARAMETER StartDate
    Timestamp of the start of the date range
.PARAMETER EndDate
    Timestamp of the end of the date range
.EXAMPLE
    Get-FerootScriptDetail -StartDate (Get-Date).AddDays(-30) -EndDate (Get-Date) -ScriptID 'd696075d6d1219c32e55df901f90491c4899548b'
.EXAMPLE
    Get-FerootScriptDetail -ScriptID "d696075d6d1219c32e55df901f90491c4899548b" -ProjectUUIDs @('00000000-0000-0000-0000-000000000000') -StartDate (Get-Date).AddDays(-30) -EndDate (Get-Date)
#>
function Get-FerootScriptDetail{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$ScriptID,
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
        $RelativeUri = "platform/scripts/$($ScriptID)?startDate=$($Start)&endDate=$($End)"

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
