<#
.Synopsis
    Returns a list of pages detected in your Feroot Project(s) within a specified time range.
.DESCRIPTION
    Returns a list of pages detected in your Feroot Project(s) within a specified time range.
.PARAMETER StartDate
    Timestamp of the start of the date range
.PARAMETER EndDate
    Timestamp of the end of the date range
.PARAMETER ProjectUuids
    An array with at least one Feroot Project UUID. If the list is not provided, the issues from all projects in your organization's account will be used to create the report.
    Use Get-FerootProjects to get Project UUIDs
.PARAMETER Limit
    The maximum number of issues to return in the response. Default is overwritten to 1000.
.PARAMETER SortKey
    The key used to sort the list of issues in the response. Possible values are "vendors", "scripts", and "category".
.PARAMETER Categories
    Filters for any vulnerabilities or sensitive information detected on the pages to be included in the response. Possible values are password, billing, threats, and dataAssets
.PARAMETER Search
    Search keyword that will be applied to the titles and URLs of pages to be included in the API response
.PARAMETER Ascending
    Order of the sorted elements, specify for ascending order
.PARAMETER Descending
    Order of the sorted elements, specify for descending order
.EXAMPLE
    Get-FerootPages -StartDate (Get-Date).AddDays(-30) -EndDate (Get-Date)
.EXAMPLE
    Get-FerootPages -StartDate (Get-Date).AddDays(-30) -EndDate (Get-Date) -Search 'Health'
.EXAMPLE
    Get-FerootPages -ProjectUUIDs $ProjectUUIDs -SortKey "scripts" -Categories ("password", "threats") -Descending -StartDate (Get-Date).AddDays(-30) -EndDate (Get-Date)
#>
function Get-FerootPages{
    [CmdletBinding(DefaultParameterSetName = 'NoSort')]
    param (
        [Parameter(Mandatory=$true)]
        [datetime]$StartDate,
        [Parameter(Mandatory=$true)]
        [datetime]$EndDate,
        [string[]] $ProjectUUIDs,
        [int]$Limit = 1000, # Override default limit of 20
        [ValidateSet("vendors", "scripts", "category")]
        [string]$SortKey,
        [ValidateSet("password", "billing", "threats", "dataAssets")]
        [string[]]$Categories,
        [string]$Search,
        # Mutually exclusive switches in a parameter set
        [Parameter(ParameterSetName = 'Ascending')]
        [ValidateScript({
            if ($null -eq $SortKey) {
                throw "You can only use '-Ascending' when 'SortField' is specified."
            }
            $true
        })]
        [switch]$Ascending,
        [Parameter(ParameterSetName = 'Descending')]
        [ValidateScript({
            if ($null -eq $SortKey) {
                throw "You can only use '-Descending' when 'SortField' is specified."
            }
            $true
        })]
        [switch]$Descending
    )

    process{

        #Convert to UNIX Time
        $Start = ([DateTimeOffset]$StartDate).ToUnixTimeSeconds()*1000
        $End = ([DateTimeOffset]$EndDate).ToUnixTimeSeconds()*1000

        # Hashtable to store query parameters
        $queryParams = @{}
        $queryParams['limit'] = $Limit

        # Add parameters to hashtable if they are defined
        if ($PSCmdlet.MyInvocation.BoundParameters['SortKey']) { $queryParams['sortKey'] = $SortKey }
        if ($PSCmdlet.MyInvocation.BoundParameters['Categories']) { $queryParams['categories'] = $Categories }
        if ($PSCmdlet.MyInvocation.BoundParameters['Search']) { $queryParams['search'] = $Search }

        # Handle mutually exclusive Ascending/Descending
        if ($PSCmdlet.ParameterSetName -eq 'Ascending') { $queryParams['sortDir'] = 'asc' }
        elseif ($PSCmdlet.ParameterSetName -eq 'Descending') { $queryParams['sortDir'] = 'desc' }

        # Build the query string manually
        $queryString = ""
        foreach ($param in $queryParams.GetEnumerator()) {
            $queryString += "$($param.Key)=$([System.Uri]::EscapeDataString($param.Value))&"
        }

        # Handle ProjectUUIDs array
        if($ProjectUUIDs){
            $ProjectUUIDParam = $ProjectUUIDs | ForEach-Object { "platformProjectUuids[]=$_" }
            $ProjectUUIDParam = $ProjectUUIDParam -join "&"
            $queryString += $ProjectUUIDParam
        }

        # Handle ProjectUUIDs array
        if($Categories){
            $CategoriesParam = $Categories | ForEach-Object { "categories[]=$_" }
            $CategoriesParam = $CategoriesParam -join "&"
            $queryString += $CategoriesParam
        }

        # Remove the trailing '&'
        if ($queryString.EndsWith('&')) {
            $queryString = $queryString.Substring(0, $queryString.Length - 1)
        }

        # Complete URI with query parameters
        $RelativeUri = "platform/pages?startDate=$($Start)&endDate=$($End)&$($queryString)"

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-FerootRestCall @RestSplat
        $Response
    }
}
