function Set-ServerServicesDirectory {
    <# =========================================================================
    .SYNOPSIS
        Set ArcGIS Server allowed origins
    .DESCRIPTION
        Set ArcGIS Server allowed origins
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Origin
        Origin to be allowed for Portal
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Set-ServerServicesDirectory -Origin 'https://test.com', 'https://mySite.com'
        Sets ArcGIS Server allowed origins to 'https://test.com,https://mySite.com'
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'Origin to be allowed')]
        [ValidateNotNullOrEmpty()]
        [System.Uri[]] $Origin,

        [Parameter(Mandatory, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Process {
        # SET COMMON PARAMETERS
        $cmnParams = @{ Token = $Token; Context = $Context; ErrorActon = 'Stop' }
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $cmnParams['SkipCertificateCheck'] = $true }

        # GET SERVICES DIRECTORY DATA
        $servDir = Get-ServerServicesDirectory @cmnParams

        # VALIDATE PREVIOUS CALL WAS SUCCESSFUL

        # SET NEW ORIGINS INTO PROPER FORMAT
        $restParams = @{
            Uri    = '{0}/admin/system/handlers/rest/servicesdirectory/edit' -f $Context
            Method = 'POST'
            Body   = @{
                f                     = 'json'
                token                 = $Token
                allowedOrigins        = ($Origin -join ',')
                servicesDirEnabled    = $servDir.enabled
                consoleLogging        = $servDir.consoleLogging
                'jsapi.arcgis'        = $servDir.'jsapi.arcgis'
                'jsapi.arcgis.sdk'    = $servDir.'jsapi.arcgis.sdk'
                'jsapi.arcgis.css'    = $servDir.'jsapi.arcgis.css'
                'arcgis.com.map.text' = $servDir.'arcgis.com.map.text'
                'arcgis.com.map'      = $servDir.'arcgis.com.map'
            }
        }
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }
        Invoke-RestMethod @restParams
    }
}