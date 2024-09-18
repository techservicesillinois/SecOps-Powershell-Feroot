<#
.Synopsis
    Returns the configuration of a Web Crawl data source in a Feroot Project
.DESCRIPTION
    Returns the configuration of a Web Crawl data source in a Feroot Project
.PARAMETER ProjectUUID
    Project UUID of the crawl to return the configuration of
    Use Get-FerootProject to get Project UUIDs
.PARAMETER CrawlUUID
    UUID of a crawl data source associated with the project
    Use Get-FerootProjectDataSource to get Crawl UUIDs
.EXAMPLE
    Get-FerootCrawlConfiguration -ProjectUUID '00000000-0000-0000-0000-000000000000' -CrawlUUID '00000000-0000-0000-0000-000000000000'
#>
function Get-FerootCrawlConfiguration{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProjectUUID,
        [Parameter(Mandatory=$true)]
        [string]$CrawlUUID
    )

    process{

        # Complete URI with query parameters
        $RelativeUri = "platform/$($ProjectUUID)/data-source/crawl/$($CrawlUUID)"

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-FerootRestCall @RestSplat
        $Response
    }
}
