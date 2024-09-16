﻿<#
.Synopsis
    Returns a list of project groups/folders.
.DESCRIPTION
    Returns a list of project groups/folders.
.EXAMPLE
    Get-FerootProjectGroups
#>
function Get-FerootProjectGroups{

    process{

        $RelativeUri = "platform/project-groups"

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-FerootRestCall @RestSplat
        $Response
    }
}
