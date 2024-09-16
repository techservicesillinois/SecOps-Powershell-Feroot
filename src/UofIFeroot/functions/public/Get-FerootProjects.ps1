<#
.Synopsis
    Returns projects from Feroot
.DESCRIPTION
    Returns projects from Feroot
.PARAMETER Search
    Search query (applied to projects' names)
.PARAMETER SortField
    Field to sort by. Values can be: name, createdAt, updatedAt. If not provided, items in the response will be sorted based on createdAt (i.e. the creation timestamp)
.PARAMETER ProjectGroup
    The uuid of a project group (also called "project folder"). If projectGroup is not specified, the response will contain all projects that are not assigned to any project group/folder
.PARAMETER TotalCount
    Specify this parameter to cause the response to have the totalCount of projects that can be accessed through the API request.
    If the projectGroup parameter is not provided in the request, the value of totalCount in the response will be the number of all projects not assigned to any project groups
.PARAMETER Skip
    Pagination control. Can be 0 or a positive integer, handles pagination and indicates the number of projects to "skip" before including projects in the response
.PARAMETER Limit
    Amount of items/projects returned. Default is overwritten to 1000
.PARAMETER Ascending
    Order of the sorted elements, specify for ascending order
.PARAMETER Descending
    Order of the sorted elements, specify for descending order
.EXAMPLE
    Get-FerootProjects -Search 'Health' -SortField 'name' -Descending
#>
function Get-FerootProjects{
    [CmdletBinding(DefaultParameterSetName = 'NoSort')]
    param (
        [string]$Search,
        [ValidateSet("name", "updateAt", "createdAt")]
        [string]$SortField,
        [System.Guid]$ProjectGroup,
        [switch]$TotalCount,
        [int]$Skip,
        [int]$Limit = 1000, # Override default limit of 20
        # Mutually exclusive switches in a parameter set
        [Parameter(ParameterSetName = 'Ascending')]
        [ValidateScript({
            if ($null -eq $SortField) {
                throw "You can only use '-Ascending' when 'SortField' is specified."
            }
            $true
        })]
        [switch]$Ascending,
        [Parameter(ParameterSetName = 'Descending')]
        [ValidateScript({
            if ($null -eq $SortField) {
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
        if ($PSCmdlet.MyInvocation.BoundParameters['Search']) { $queryParams['search'] = $Search }
        if ($PSCmdlet.MyInvocation.BoundParameters['SortField']) { $queryParams['sortField'] = $SortField }
        if ($PSCmdlet.MyInvocation.BoundParameters['ProjectGroup']) { $queryParams['projectGroup'] = $ProjectGroup }
        if ($PSCmdlet.MyInvocation.BoundParameters['Skip']) { $queryParams['skip'] = $Skip }
        if ($PSCmdlet.MyInvocation.BoundParameters['ProjectId']) { $queryParams['projectId'] = $ProjectId.ToString() }

        # Handle mutually exclusive Ascending/Descending
        if ($PSCmdlet.ParameterSetName -eq 'Ascending') { $queryParams['desc'] = 'false' }
        elseif ($PSCmdlet.ParameterSetName -eq 'Descending') { $queryParams['desc'] = 'true' }
        # Handle TotalCount switch
        if ($TotalCount) { $queryParams['totalCount'] = 'true' }

        # Build the query string manually
        $queryString = ""
        foreach ($param in $queryParams.GetEnumerator()) {
            $queryString += "$($param.Key)=$([System.Uri]::EscapeDataString($param.Value))&"
        }

        # Remove the trailing '&'
        if ($queryString.EndsWith('&')) {
            $queryString = $queryString.Substring(0, $queryString.Length - 1)
        }

        # Complete URI with query parameters
        $RelativeUri = "platform?$queryString"

        $RestSplat = @{
            Method = 'GET'
            RelativeURI = $RelativeUri
        }

        $Response = Invoke-FerootRestCall @RestSplat
        $Response
    }
}
