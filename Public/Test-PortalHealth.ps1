function Test-PortalHealth {
    <# =========================================================================
    .SYNOPSIS
        Test Portal health
    .DESCRIPTION
        Send a request to the Portal health check endpoint
    .PARAMETER Context
        Target Portal context
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Test-PortalHealth -Context 'https://arcgis.com/arcgis'
        Send a request to the Portal heealth check endpoint
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target Portal context')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ $_.AbsoluteUri -match '^https://[\w\/\.-]+[^/]$' })]
        [System.Uri] $Context
    )
    Process {
        $restParams = @{
            Uri    = '{0}/portaladmin/healthCheck?f=json' -f $Context
            Method = 'GET'
        }
        Invoke-RestMethod @restParams
    }
}