<#
.Synopsis
    Creates a copy of an existing Feroot policy, which you have to specify via its UUID.
.DESCRIPTION
    Creates a copy of an existing Feroot policy, which you have to specify via its UUID.
    The newly created copy will have another UUID.
    You will be able to identify the new copy in the list of policies because its name will be the original policy's name with (copy) added at the end.
.PARAMETER PolicyUuid
    UUID of the policy to duplicate
    Use Get-FerootPolicies to get Policy UUIDs
.EXAMPLE
    Copy-FerootPolicy -PolicyUuid '00000000-0000-0000-0000-000000000000'
#>
function Copy-FerootPolicy{
    param (
        [Parameter(Mandatory=$true)]
        [string]$PolicyUuid
    )

    process{

        $RelativeUri = "platform/policies/$($PolicyUuid)/duplicate"

        $RestSplat = @{
            Method = 'POST'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-FerootRestCall @RestSplat
        $Response
    }
}
