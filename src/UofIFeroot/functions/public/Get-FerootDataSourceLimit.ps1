<#
.Synopsis
    Returns the information about your organization's plan and subscription with Feroot.
.DESCRIPTION
    Returns the information about your organization's plan and subscription with Feroot.
    This includes the data source limits that apply to every Feroot Project associated with your organization's account.
    To adjust these limits, contact us at support@feroot.com
.EXAMPLE
    Get-FerootDataSourceLimit
#>
function Get-FerootDataSourceLimit{

    process{

        $RelativeUri = "subscription/info"

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-FerootRestCall @RestSplat
        $Response
    }
}
