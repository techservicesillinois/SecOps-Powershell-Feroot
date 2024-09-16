<#
.Synopsis
    Returns the specified policy's configuration.
.DESCRIPTION
    Returns the specified policy's configuration.
.PARAMETER PolicyUuid
    UUID of the policy to return configuration details for
    Use Get-FerootPolicies to get Policy UUIDs
.EXAMPLE
    Get-FerootIssueDetails -IssueUuid '00000000-0000-0000-0000-000000000000'
#>
function Get-FerootPolicyConfiguration{
    param (
        [Parameter(Mandatory=$true)]
        [string]$PolicyUuid
    )

    process{

        $RelativeUri = "platform/policies/$($PolicyUuid)"

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-FerootRestCall @RestSplat
        $Response
    }
}
