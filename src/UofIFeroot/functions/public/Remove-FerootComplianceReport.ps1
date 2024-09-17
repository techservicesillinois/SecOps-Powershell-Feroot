<#
.Synopsis
    Returns the detailed information about a particular compliance report.
.DESCRIPTION
    Returns the detailed information about a particular compliance report.
.PARAMETER ReportID
    The ID of a particular compliance report
.EXAMPLE
    Remove-FerootComplianceReport -ReportID $ReportID
#>
function Remove-FerootComplianceReport{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$true)]
        [string]$ReportID
    )

    process{

        if ($PSCmdlet.ShouldProcess("$($ReportID)", "Delete Compliance Report")) {
            $RelativeUri = "platform/compliance/reports/$($ReportID)"

            $RestSplat = @{
                Method = 'DELETE'
                RelativeURI = $RelativeUri
            }

            $Response = Invoke-FerootRestCall @RestSplat
            $Response
        }
    }
}
