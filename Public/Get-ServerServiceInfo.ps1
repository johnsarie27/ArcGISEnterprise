function Get-ServerServiceInfo {
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
        Service object returned from Get-Service or Get-ServerServiceList
    .PARAMETER Folder
        Folder in ArcGIS Server
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-ServerServiceInfo -Context 'https://arcgis.com/arcgis' -Token $token -Service $s
        Returns the service item info for service $s
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

        [Parameter(Mandatory, HelpMessage = 'Service object returned from Get-Service or Get-ServerServiceList')]
        [ValidateScript({$_.serviceName -and $_.type})]
        [System.Object] $Service,

        [Parameter(HelpMessage = 'Folder')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Folder,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
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
                f     = 'json'
                token = $Token
            }
        }
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }
        Invoke-RestMethod @restParams
    }
}