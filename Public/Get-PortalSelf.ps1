function Get-PortalSelf {
    <# =========================================================================
    .SYNOPSIS
        Get Portal configuration or "self"
    .DESCRIPTION
        Get Portal configuration or "self." This may also be a good test of
        Portal token validity
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
        PS C:\> Get-PortalSelf -Context 'https://arcgis.com/arcgis' -Token $token
        Gets Portal "self" configuration
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    [Alias('Test-PortalToken')]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Process {
        $restParams = @{
            Uri    = '{0}/sharing/rest/portals/self' -f $Context
            Method = 'POST'
            Body   = @{
                f     = 'json'
                token = $Token
            }
        }
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }
        Invoke-RestMethod @restParams
    }
}