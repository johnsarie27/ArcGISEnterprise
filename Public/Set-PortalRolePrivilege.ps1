function Set-PortalRolePrivilege {
    <# =========================================================================
    .SYNOPSIS
        Set privilege for Portal for ArcGIS Role
    .DESCRIPTION
        Set privilege for Portal for ArcGIS Role
    .PARAMETER RoleId
        Portal Role ID
    .PARAMETER Privilege
        Portal role privilege
    .PARAMETER PortalId
        Portal ID
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Set-PortalRolePrivilege @commonParams -RoleId 123456 -Privilege @("portal:user:createItem","portal:user:joinGroup")
        Set Portal role privileges for role ID '123456'
    .NOTES
        Name:     Set-PortalRolePrivilege
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2022-07-19
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
        https://developers.arcgis.com/rest/users-groups-and-items/set-role-privileges.htm
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Portal Role ID')]
        [ValidateNotNullOrEmpty()]
        [System.String] $RoleId,

        [Parameter(Mandatory, HelpMessage = 'Portal Role privilege')]
        [ValidateNotNullOrEmpty()]
        [System.String[]] $Privilege,

        [Parameter(HelpMessage = 'Portal ID')]
        [ValidateNotNullOrEmpty()]
        [System.String] $PortalId = '0123456789ABCDEF',

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
        # SET QUERY PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/portals/{1}/roles/{2}/setPrivileges' -f $Context, $PortalId, $RoleId
            Method = 'POST'
            Body   = @{
                f           = 'json'
                token       = $Token
                privileges  = @{ privileges = $Privilege } | ConvertTo-Json -Compress
            }
        }

        # ADD SKIP CERTIFICATE CHECK IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE QUERY
        Invoke-RestMethod @restParams
    }
}