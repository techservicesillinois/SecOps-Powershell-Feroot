<#
.Synopsis
    Returns the detailed information about a particular compliance report.
.DESCRIPTION
    Returns the detailed information about a particular compliance report.
.PARAMETER ReportID
    The ID of a particular compliance report
.EXAMPLE
    Get-FerootIssueDetail -ReportID $ReportID
#>
function Get-FerootComplianceReportDetail{
    param (
        [Parameter(Mandatory=$true)]
        [string]$ReportID
    )

    process{

        $RelativeUri = "platform/compliance/reports/$($ReportID)"

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-FerootRestCall @RestSplat
        $Response
    }
}
