<#
.Synopsis
    Enables or disables a Web Crawl data source in a Feroot Project.
.DESCRIPTION
    Enables or disables a Web Crawl data source in a Feroot Project.
.PARAMETER ProjectUUID
    Project UUID of the crawl to change the status of
    Use Get-FerootProject to get Project UUIDs
.PARAMETER CrawlUUID
    UUID of a crawl associated with the project
    Use Get-FerootProjectDataSource to get Crawl UUIDs
.EXAMPLE
    Set-FerootCrawlStatus -Status 'Enabled' -ProjectUUID '00000000-0000-0000-0000-000000000000' -CrawlUUID '00000000-0000-0000-0000-000000000000'
.EXAMPLE
    Set-FerootCrawlStatus -Status 'Disabled' -ProjectUUID '00000000-0000-0000-0000-000000000000' -CrawlUUID '00000000-0000-0000-0000-000000000000'
#>
function Set-FerootCrawlStatus{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [ValidateSet("Enabled", "Disabled")]
        [Parameter(Mandatory=$true)]
        [string]$Status,
        [Parameter(Mandatory=$true)]
        [string]$ProjectUUID,
        [Parameter(Mandatory=$true)]
        [string]$CrawlUUID
    )

    process{

        if ($PSCmdlet.ShouldProcess("$($ProjectUUID)/$($CrawlUUID)", "Change Crawl Status to $($Status)")) {
            # Complete URI with query parameters
            $RelativeUri = "platform/$($ProjectUUID)/data-source/crawl/$($CrawlUUID)/status"

            If($Status -eq 'Enabled'){
                $Body = @{
                    enabled = 'true'
                }
            }
            Else{
                $Body = @{
                    enabled = 'false'
                }
            }

            $RestSplat = @{
                Method = 'PATCH'
                RelativeURI = $RelativeUri
                Body = $Body
            }

            $Response = Invoke-FerootRestCall @RestSplat
            $Response
        }
    }
}
