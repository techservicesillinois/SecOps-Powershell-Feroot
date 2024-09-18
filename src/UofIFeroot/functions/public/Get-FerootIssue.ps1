<#
.Synopsis
    Returns a list of issues identified in your Feroot Project(s).
.DESCRIPTION
    Returns a list of issues identified in your Feroot Project(s). The function allows filtering, sorting, and paginating the results based on several optional parameters.
.PARAMETER ProjectUuids
    An array with at least one Feroot Project UUID. If the list is not provided, the issues from all projects in your organization's account will be used to create the report.
    Use Get-FerootProject to get Project UUIDs
.PARAMETER Limit
    The maximum number of issues to return in the response. Default is overwritten to 1000.
.PARAMETER SortKey
    The key used to sort the list of issues in the response. Possible values are 'violationCount' and 'status'.
.PARAMETER Status
    The status of issues to be returned. Possible values are 'open' or 'resolved'. Omit this parameter to fetch all detected issues regardless of their current status.
.PARAMETER Page
    The page number for handling pagination of the response. Use this parameter to navigate through the paginated list of issues.
.PARAMETER Ascending
    Order of the sorted elements, specify for ascending order
.PARAMETER Descending
    Order of the sorted elements, specify for descending order
.EXAMPLE
    Get-FerootIssue
.EXAMPLE
    Get-FerootIssue -Status "Open"
.EXAMPLE
    Get-FerootIssue -ProjectUUIDs $ProjectUUIDs -SortKey "violationCount" -Descending
#>
function Get-FerootIssue{
    [CmdletBinding(DefaultParameterSetName = 'NoSort')]
    param (
        [string[]] $ProjectUUIDs,
        [int]$Limit = 1000, # Override default limit of 20
        [ValidateSet("violationCount", "status")]
        [string]$SortKey,
        [ValidateSet("open", "resolved")]
        [string]$Status,
        [int]$Page,
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

        # Hashtable to store query parameters
        $queryParams = @{}
        $queryParams['limit'] = $Limit

        # Add parameters to hashtable if they are defined
        if ($PSCmdlet.MyInvocation.BoundParameters['SortKey']) { $queryParams['sortKey'] = $SortKey }
        if ($PSCmdlet.MyInvocation.BoundParameters['Status']) { $queryParams['status'] = $Status }
        if ($PSCmdlet.MyInvocation.BoundParameters['Page']) { $queryParams['page'] = $Page }

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

        # Remove the trailing '&'
        if ($queryString.EndsWith('&')) {
            $queryString = $queryString.Substring(0, $queryString.Length - 1)
        }

        # Complete URI with query parameters
        $RelativeUri = "platform/issues?$queryString"

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-FerootRestCall @RestSplat
        $Response
    }
}
