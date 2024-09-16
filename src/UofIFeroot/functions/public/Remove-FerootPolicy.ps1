<#
.Synopsis
    Deletes the specified policy.
.DESCRIPTION
    Deletes the specified policy.
.PARAMETER PolicyUuid
    UUID of the policy to delete
    Use Get-FerootPolicies to get Policy UUIDs
.EXAMPLE
    Remove-FerootPolicy -PolicyUuid '00000000-0000-0000-0000-000000000000'
#>
function Remove-FerootPolicy{
    param (
        [Parameter(Mandatory=$true)]
        [string]$PolicyUuid
    )

    process{

        $RelativeUri = "platform/policies/$($PolicyUuid)"

        $RestSplat = @{
            Method = 'DELETE'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-FerootRestCall @RestSplat
        $Response
    }
}
