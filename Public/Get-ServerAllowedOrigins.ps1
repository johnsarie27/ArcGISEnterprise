function Get-ServerAllowedOrigins {
    <#
    .DESCRIPTION
        Get the allowed origins for ArcGIS Server
    .PARAMETER SOAP
        Get SOAP Allowed Origins
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
        Version:  0.1.1 | Last Edit: 2023-05-10 [0.1.1]
        - 0.1.1 - Added switch parameter for SOAP
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
    #>
    [CmdletBinding()]
    Param(
        [Parameter(HelpMessage = 'Get SOAP Allowed Origins')]
        [System.Management.Automation.SwitchParameter] $SOAP,

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
        if ($PSBoundParameters.ContainsKey('SOAP')) {
            $restParams = @{
                Uri    = '{0}/admin/system/handlers/soap/soaphandlerconfig' -f $Context
                Method = 'GET'
                Body   = @{ f = 'json'; token = $Token }
            }
            if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }
            (Invoke-RestMethod @restParams).allowedOrigins.Split(',')
        }
        else {
            ((Get-ServerServicesDirectory @PSBoundParameters).allowedOrigins).Split(',')
        }
    }
}