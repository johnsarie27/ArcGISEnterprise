function Test-PortalHealth {
    <# =========================================================================
    .SYNOPSIS
        Test Portal health
    .DESCRIPTION
        Send a request to the Portal health check endpoint
    .PARAMETER Context
        Target Portal context
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
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
        [ValidateScript({ $_.AbsoluteUri -match '^https://[\w\/\.:-]+[^/]$' })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $false, HelpMessage = 'Portal token')]
        [ValidatePattern('^[\w\.=-]+$')]
        [String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [switch] $SkipCertificateCheck
    )
    Process {
        $restParams = @{
            Uri    = '{0}/portaladmin/healthCheck?f=json' -f $Context
            Method = 'GET'
        }
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }
        if ($PSBoundParameters.ContainsKey('Token')) { $restParams['Body'] = @{ token = $Token } }
        Invoke-RestMethod @restParams
    }
}