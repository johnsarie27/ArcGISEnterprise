function Test-ServerHealth {
    <# =========================================================================
    .SYNOPSIS
        Test Server health
    .DESCRIPTION
        Send a request to the ArcGIS Server health check endpoint
    .PARAMETER Context
        Target Server context
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Test-ServerHealth -Context 'https://arcgis.com/arcgis'
        Send a request to the ArcGIS Server heealth check endpoint
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target ArcGIS Server context')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ $_.AbsoluteUri -match '^https://[\w\/\.-]+[^/]$' })]
        [System.Uri] $Context
    )
    Process {
        $restParams = @{
            Uri    = '{0}/rest/info/healthCheck?f=json' -f $Context
            Method = 'GET'
        }
        Invoke-RestMethod @restParams
    }
}