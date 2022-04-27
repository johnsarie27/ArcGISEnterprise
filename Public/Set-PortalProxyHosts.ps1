function Set-PortalProxyHosts {
    <# =========================================================================
    .SYNOPSIS
        Set Portal security configuration
    .DESCRIPTION
        Set Portal security configuration
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER ProxyHost
        Proxy host
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
        PS C:\> Set-PortalSecurityConfiugration -ProxyHost 'test.com' @cmn
        Set Portal allowedProxyHosts to 'test.com'
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'Proxy host')]
        [ValidateNotNullOrEmpty()]
        [System.String[]] $ProxyHost,

        [Parameter(HelpMessage = 'Referer')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Referer,

        [Parameter(Mandatory, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Process {
        # SET COMMON PARAMETERS
        $cmnParams = @{ Context = $Context; Token = $Token; ErrorAction = 'Stop' }
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $cmnParams['SkipCertificateCheck'] = $true }

        # GET PORTAL SECURITY CONFIGURATION
        $secConf = Get-PortalSecurityConfig @cmnParams

        # UPDATE HERE
        $newConfig = @{
            allowedProxyHosts              = ($ProxyHost -join ',')
            enableAutomaticAccountCreation = $secConf.enableAutomaticAccountCreation
            disableServicesDirectory       = $secConf.disableServicesDirectory
        }

        $Referer = if ($PSBoundParameters.ContainsKey('Referer')) { $Referer } else { '{0}://{1}' -f $Context.Scheme, $Context.Authority }

        $restParams = @{
            Uri    = '{0}/portaladmin/security/config/update' -f $Context
            Method = 'POST'
            Headers = @{ referer = $Referer }
            Body   = @{
                f     = 'json'
                token = $Token
                securityConfig = $newConfig | ConvertTo-Json -Compress
            }
        }
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }
        Invoke-RestMethod @restParams
    }
}