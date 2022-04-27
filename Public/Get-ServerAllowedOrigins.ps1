function Get-ServerAllowedOrigins {
    <# =========================================================================
    .DESCRIPTION
        Get the allowed origins for ArcGIS Server
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
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
        PS C:\> Get-ServerAllowedOrigins @params
        Gets the allowed origins for ArcGIS Server
    .NOTES
        Name:     Get-ServerAllowedOrigins
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2022-04-27 [0.1.0]
        Comments: <Comment(s)>
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
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
    }
    Process {
        ((Get-ServerServicesDirectory @PSBoundParameters).allowedOrigins).Split(',')
    }
}