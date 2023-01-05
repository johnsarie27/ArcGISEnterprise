function Get-ServerServiceList {
    <#
    .SYNOPSIS
        Get list of services from ArcGIS Server
    .DESCRIPTION
        Get list of services and info from ArcGIS Server
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER Folder
        Folder in ArcGIS Server
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-ServerServiceList -Context 'https://arcgis.com/arcgis' -Token $token
        Returns all services in ArcGIS Server
    .NOTES
        General notes
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Folder')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Folder,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Process {
        # SET SERVICES URI
        if ($PSBoundParameters.ContainsKey('Folder')) { $uri = '{0}/admin/services/{1}' -f $Context, $Folder }
        else { $uri = '{0}/admin/services' -f $Context }

        # SET REQUEST PARAMETERS
        $restParams = @{
            Uri    = $uri
            Method = 'GET'
            Body   = @{ f = 'json' }
        }

        # ADD TOKEN IF PROVIDED
        if ($PSBoundParameters.ContainsKey('Token')) { $restParams.Body['token'] = $Token }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        Invoke-RestMethod @restParams
    }
}