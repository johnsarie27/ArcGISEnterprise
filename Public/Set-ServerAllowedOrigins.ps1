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
        Version:  0.1.2 | Last Edit: 2023-04-06
        - 0.1.2 - Add validation to Origin parameter
        - 0.1.1 - Updates to account for all server properties
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'Origin to be allowed')]
        [ValidatePattern('^https?://.+[^/]$')]
        [System.Uri[]] $Origin,

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