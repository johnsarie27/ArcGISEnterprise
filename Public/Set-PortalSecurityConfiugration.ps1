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
        PS C:\> Set-PortalSecurityConfiugration -Context 'https://arcgis.com/arcgis' -Token $token
        Set security configuration from Portal
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
        $SecurityConfiguration = $SecurityConfiguration | ConvertTo-Json -Compress

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
                securityConfig = $SecurityConfiguration
            }
        }
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }
        Invoke-RestMethod @restParams
    }
}