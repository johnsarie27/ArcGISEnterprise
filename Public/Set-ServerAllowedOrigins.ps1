function Set-ServerAllowedOrigins {
    <#
    .SYNOPSIS
        Set ArcGIS Server allowed origins
    .DESCRIPTION
        Set ArcGIS Server allowed origins
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Origin
        Origin to be allowed for Portal
    .PARAMETER SOAP
        Set SOAP handler allowed origins
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Set-ServerAllowedOrigins -Origin 'https://test.com', 'https://mySite.com'
        Sets ArcGIS Server allowed origins to 'https://test.com,https://mySite.com'
    .NOTES
        Name:     Set-ServerAllowedOrigins
        Author:   Justin Johns
        Version:  0.1.4 | Last Edit: 2023-05-10
        - 0.1.4 - Added switch parameter for SOAP handler
        - 0.1.3 - Fixed issue with [System.Uri] adding trailing slash to Origin parameter
        - 0.1.2 - Add validation to Origin parameter
        - 0.1.1 - Updates to account for all server properties
        - 0.1.0 - Initial version
        General notes
        https://developers.arcgis.com/rest/enterprise-administration/server/edit-soap-handler-config.htm
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'Origin to be allowed')]
        [ValidatePattern('^(https?://.+[^/]|\*)$')]
        [System.String[]] $Origin,

        [Parameter(HelpMessage = 'Set CORS for SOAP endpoints')]
        [System.Management.Automation.SwitchParameter] $SOAP,

        [Parameter(Mandatory, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Process {
        # SET COMMON PARAMETERS
        $cmnParams = @{ Token = $Token; Context = $Context; ErrorAction = 'Stop' }
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $cmnParams['SkipCertificateCheck'] = $true }

        if ($PSBoundParameters.ContainsKey('SOAP')) {
            $restParams = @{
                Uri    = '{0}/admin/system/handlers/soap/soaphandlerconfig/edit' -f $Context
                Method = 'POST'
                Body   = @{ f = 'json'; token = $Token; allowedOrigins = ($Origin -join ',') }
            }
            if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }
            Invoke-RestMethod @restParams
        }
        else {
            # GET SERVICES DIRECTORY DATA
            $servDir = Get-ServerServicesDirectory @cmnParams

            # VALIDATE PREVIOUS CALL WAS SUCCESSFUL
            if (-NOT $servDir) { Throw 'Unable to retrieve ArcGIS Server properties' }

            # RETAIN PREVIOUS SETTINGS
            $newConfig = @{}; $members = $servDir.psobject.Members.Where({ $_.MemberType -EQ 'NoteProperty' })
            foreach ($mbr in $members) { $newConfig[$mbr.Name] = $mbr.Value }

            # FOR SOME REASON THE PROPERTY 'servicesDirEnabled' IS STORED AS 'enabled' AS THE NAME
            # BUT NEEDS TO BE DECLARED AS 'servicesDirEnabled' WHEN UPDATING
            $newConfig['servicesDirEnabled'] = $servDir.enabled; $newConfig.Remove('enabled')

            # ADD ALLOWED ORIGINS AND REQUEST PARAMS
            $newConfig['allowedOrigins'] = ($Origin -join ',')
            $newConfig['f'] = 'json'; $newConfig['token'] = $Token

            # SET NEW ORIGINS INTO PROPER FORMAT
            $restParams = @{
                Uri    = '{0}/admin/system/handlers/rest/servicesdirectory/edit' -f $Context
                Method = 'POST'
                Body   = $newConfig
            }
            if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }
            Invoke-RestMethod @restParams
        }
    }
}