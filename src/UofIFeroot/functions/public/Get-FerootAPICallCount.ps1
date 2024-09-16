<#
.Synopsis
    Returns the number of times Invoke-FerootRestCall is called
.DESCRIPTION
    Returns the number of times Invoke-FerootRestCall is called
.EXAMPLE
    Get-FerootAPICallCount
    #>
function Get-FerootAPICallCount{
    [OutputType([int])]
    [CmdletBinding()]
    param (
    )

    process{
        return $Script:APICallCount
    }
}
