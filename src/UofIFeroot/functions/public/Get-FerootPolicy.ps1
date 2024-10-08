﻿<#
.Synopsis
    Returns a list of all policies from the Policy Engine.
.DESCRIPTION
    Returns a list of all policies from the Policy Engine.
.EXAMPLE
    Get-FerootPolicy
#>
function Get-FerootPolicy{

    process{

        $RelativeUri = "platform/policies"

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-FerootRestCall @RestSplat
        $Response
    }
}
