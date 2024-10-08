﻿<#
.Synopsis
    Deletes a Web Crawl data source from a Feroot Project.
.DESCRIPTION
    Deletes a Web Crawl data source from a Feroot Project.
.PARAMETER ProjectUUID
    Project UUID of the crawl to delete
    Use Get-FerootProject to get Project UUIDs
.PARAMETER CrawlUUID
    UUID of a crawl associated with the project
    Use Get-FerootProjectDataSource to get Crawl UUIDs
.EXAMPLE
    Remove-FerootCrawl -ProjectUUID '00000000-0000-0000-0000-000000000000' -CrawlUUID '00000000-0000-0000-0000-000000000000'
.EXAMPLE
    Set-FerootCrawlStatus -Status 'Disabled' -ProjectUUID '00000000-0000-0000-0000-000000000000' -CrawlUUID '00000000-0000-0000-0000-000000000000'
#>
function Remove-FerootCrawl{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProjectUUID,
        [Parameter(Mandatory=$true)]
        [string]$CrawlUUID
    )

    process{

        if ($PSCmdlet.ShouldProcess("$($ProjectUUID)/$($CrawlUUID)", "Delete Crawl")) {
            # Complete URI with query parameters
            $RelativeUri = "platform/$($ProjectUUID)/data-source/crawl/$($CrawlUUID)"

            $RestSplat = @{
                Method = 'DELETE'
                RelativeURI = $RelativeUri
            }

            $Response = Invoke-FerootRestCall @RestSplat
            $Response
    }
    }
}
