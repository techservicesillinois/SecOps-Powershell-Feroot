<#
.Synopsis
    Returns the details of an issue identified in a Feroot Project.
.DESCRIPTION
    Returns the details of an issue identified in a Feroot Project.
.PARAMETER IssueUuid
    UUID of the issue to return details for
    Use Get-FerootProjectIssues to get Issue UUIDs
.EXAMPLE
    Get-FerootIssueDetails -IssueUuid '00000000-0000-0000-0000-000000000000'
#>
function Get-FerootIssueDetails{
    param (
        [Parameter(Mandatory=$true)]
        [string]$IssueUuid
    )

    process{

        $RelativeUri = "platform/issues/$($IssueUuid)"

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-FerootRestCall @RestSplat
        $Response
    }
}
