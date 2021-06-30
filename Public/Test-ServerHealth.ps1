function Test-ServerHealth {
    <# =========================================================================
    .SYNOPSIS
        Test Server health
    .DESCRIPTION
        Send a request to the ArcGIS Server health check endpoint
    .PARAMETER Context
        Target Server context
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
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
        [ValidateScript({ $_.AbsoluteUri -match '^https://[\w\/\.:-]+?[^/]$' })]
        [System.Uri] $Context,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [switch] $SkipCertificateCheck
    )
    Process {
        $restParams = @{
            Uri    = '{0}/rest/info/healthCheck?f=json' -f $Context
            Method = 'GET'
        }
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }
        Invoke-RestMethod @restParams
    }
}