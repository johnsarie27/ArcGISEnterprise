function Get-PortalMachines {
    <# =========================================================================
    .SYNOPSIS
        Get Portal machines
    .DESCRIPTION
        Get Portal machines
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-PortalMachines -Context 'https://arcgis.com/arcgis' -Token $token
        Get user from Portal
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [switch] $SkipCertificateCheck
    )
    Process {
        $restParams = @{
            Uri    = '{0}/portaladmin/machines' -f $Context
            Method = 'GET'
            Body   = @{
                f     = 'pjson'
                token = $Token
            }
        }
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }
        Invoke-RestMethod @restParams
    }
}