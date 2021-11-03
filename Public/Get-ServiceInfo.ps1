function Get-ServiceInfo {
    <# =========================================================================
    .SYNOPSIS
        Get service item info
    .DESCRIPTION
        Get service item info
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER Service
        Service object returned from Get-Service or Get-ServiceList
    .PARAMETER Folder
        Folder in ArcGIS Server
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-ServiceInfo -Context 'https://arcgis.com/arcgis' -Token $token -Service $s
        Returns the service item info for service $s
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target Portal context')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ $_.AbsoluteUri -match '^https://[\w\/\.-]+[^/]$' })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'Portal token')]
        [ValidatePattern('^[\w\.=-]+$')]
        [String] $Token,

        [Parameter(Mandatory, HelpMessage = 'Service object returned from Get-Service or Get-ServiceList')]
        [ValidateScript({$_.serviceName -and $_.type})]
        [ValidateNotNullOrEmpty()]
        [System.Object] $Service,

        [Parameter(HelpMessage = 'Folder')]
        [ValidateNotNullOrEmpty()]
        [String] $Folder,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [switch] $SkipCertificateCheck
    )
    Process {
        if ($PSBoundParameters.ContainsKey('Folder')) {
            $uri = '{0}/admin/services/{1}/{2}.{3}/iteminfo' -f $Context, $Folder, $Service.serviceName, $Service.type
        }
        else {
            $uri = '{0}/admin/services/{1}.{2}/iteminfo' -f $Context, $Service.serviceName, $Service.type
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