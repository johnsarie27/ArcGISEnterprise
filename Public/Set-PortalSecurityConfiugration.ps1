function Set-PortalSecurityConfiugration {
    <# =========================================================================
    .SYNOPSIS
        Set Portal security configuration
    .DESCRIPTION
        Set Portal security configuration
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER SecurityConfiguration
        Security configuration object
    .PARAMETER Referer
        Referer
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> $cmn = @{ Context = 'https://arcgis.com/arcgis'; Token = $token }
        PS C:\> $secConf = Get-PortalSecurityConfiguration @cmn
        PS C:\> $body = [PSCustomObject] @{
        PS C:\>     allowedProxyHosts = 'test.com'
        PS C:\>     enableAutomaticAccountCreation = $secConf.enableAutomaticAccountCreation
        PS C:\>     disableServicesDirectory = $secConf.disableServicesDirectory
        PS C:\> }
        PS C:\> Set-PortalSecurityConfiugration -SecurityConfiguration $body @cmn
        Set security configuration for Portal from existing config with a change to allowedProxyHosts
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'Security configuration')]
        [ValidateScript({$_ | Get-Member -MemberType NoteProperty})]
        [System.Object] $SecurityConfiguration,

        [Parameter(HelpMessage = 'Referer')]
        [System.String] $Referer,

        [Parameter(Mandatory, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Process {
        $Referer = if ($PSBoundParameters.ContainsKey('Referer')) { $Referer } else { '{0}://{1}' -f $Context.Scheme, $Context.Authority }
        $newConfig = $SecurityConfiguration | ConvertTo-Json -Compress

        $restParams = @{
            Uri    = '{0}/portaladmin/security/config/update' -f $Context
            Method = 'POST'
            Headers = @{
                accept         = 'text/plain'
                referer        = $Referer
                'content-type' = 'application/x-www-form-urlencoded'
            }
            Body   = @{
                f     = 'json'
                token = $Token
                securityConfig = $newConfig
            }
        }
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }
        Invoke-RestMethod @restParams
    }
}