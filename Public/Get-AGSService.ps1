function Get-AGSService {
    <# =========================================================================
    .SYNOPSIS
        Get ArcGIS service
    .DESCRIPTION
        Get ArcGIS service
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER ServiceName
        Name of service
    .PARAMETER ServiceType
        Type of service (e.g., FeatureServer or MapServer)
    .PARAMETER Folder
        Folder in ArcGIS Server
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-AGSService -Context 'https://arcgis.com/arcgis' -Token $token -ServiceName SampleWorldCities -ServiceType MapServer
        Returns the service object for the SampleWorldCities service
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

        [Parameter(Mandatory, HelpMessage = 'Service name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

        [Parameter(Mandatory, HelpMessage = 'Service name')]
        [ValidateNotNullOrEmpty()]
        #[ValidateSet('FeatureServer', 'MapServer')]
        [System.String] $ServiceType,

        [Parameter(HelpMessage = 'Folder')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Folder,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [switch] $SkipCertificateCheck
    )
    Process {
        if ($PSBoundParameters.ContainsKey('Folder')) {
            $uri = '{0}/admin/services/{1}/{2}.{3}' -f $Context, $Folder, $ServiceName, $ServiceType
        }
        else {
            $uri = '{0}/admin/services/{1}.{2}' -f $Context, $ServiceName, $ServiceType
        }

        $restParams = @{
            Uri    = $uri
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