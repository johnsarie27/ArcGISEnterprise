function Get-PortalAllowedOrigins {
    <#
    .DESCRIPTION
        Get the allowed origins configured for ArcGIS Portal
    .PARAMETER Context
        Target Portal context
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.String.
    .EXAMPLE
        PS C:\> $params = @{ Context = 'https://arcgis.com/arcgis'; Token = $token }
        PS C:\> Get-PortalAllowedOrigins @params
        Gets the allowed origins for ArcGIS Portal
    .NOTES
        Name:     Get-PortalAllowedOrigins
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2022-04-27
        Comments: <Comment(s)>
        General notes
    #>
    [CmdletBinding()]
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
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
    }
    Process {
        <# $restParams = @{
            Uri    = '{0}/sharing/rest/portals/self' -f $Context
            Method = 'POST'
            Body   = @{
                f     = 'json'
                token = $Token
            }
        }
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }
        (Invoke-RestMethod @restParams).allowedOrigins #>

        ((Get-PortalSelf @PSBoundParameters).allowedOrigins).Split(',')
    }
}