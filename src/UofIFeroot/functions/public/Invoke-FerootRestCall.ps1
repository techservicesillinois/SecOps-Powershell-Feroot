<#
.Synopsis
    Makes a REST method call on the given relative URI for Feroot. Utilizes credentials created with New-FerootSession.
.DESCRIPTION
    Makes a REST method call on the given relative URI for Feroot. Utilizes credentials created with New-FerootSession.
.PARAMETER RelativeURI
    The relativeURI you wish to make a call to. Ex: platform/issues/
.PARAMETER Method
    Method of the REST call Ex: POST
.PARAMETER Body
    Body of the REST call as a hashtable (most Feroot API calls do not require a body)
.EXAMPLE
    Invoke-FerootRestCall -RelativeURI "platform/issues/" -Method 'GET'
#>
function Invoke-FerootRestCall {
    [CmdletBinding(DefaultParameterSetName='Body')]
    param (
        [Parameter(Mandatory=$true)]
        [String]$RelativeURI,
        [Parameter(Mandatory=$true)]
        [String]$Method,
        [hashtable]$Body
    )

    begin {
        if($null -eq $Script:Session){
            Write-Verbose -Message 'No Feroot session established. Please provide credentials. Username can be anything. API Key is the password.'
            New-FerootSession
        }
    }

    process {

        if ($RelativeURI.StartsWith('/')){
            $RelativeURI.Substring(1)
        }

        $IVRSplat = @{
            Headers = @{
                'Content-Type' = 'application/json'
                'X-API-KEY' = $Script:Session
            }
            Method = $Method
            URI = "$($Script:Settings.BaseURI)$RelativeURI"
        }

        if($Body){
            $IVRSplat.Add('Body', ($Body | ConvertTo-Json))
        }
        #Retry parameters only available in Powershell 7.1+, so we use a try/catch to retry calls once to compensate for short periods where the Feroot API is unreachable
        try{

            Invoke-RestMethod @IVRSplat
            $Script:APICallCount++
        }
        catch{
            Start-Sleep -Seconds 4
            Invoke-RestMethod @IVRSplat
            $Script:APICallCount++
        }
    }

    end {
    }
}
