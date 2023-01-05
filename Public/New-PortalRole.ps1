function New-PortalRole {
    <#
    .SYNOPSIS
        Create new Role in Portal for ArcGIS
    .DESCRIPTION
        Create new Role in Portal for ArcGIS
    .PARAMETER Name
        Role name
    .PARAMETER Description
        Role description
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
        PS C:\> New-PortalRole @commonParams -Name 'testRole' -Description 'testRole'
        Create new role 'testRole' in Portal for ArcGIS
    .NOTES
        Name:     New-PortalRole
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2022-07-19
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
        https://developers.arcgis.com/rest/users-groups-and-items/create-role.htm
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Portal role name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Name,

        [Parameter(Mandatory, HelpMessage = 'Portal role description')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Description,

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
            Uri    = '{0}/sharing/rest/portals/{1}/createRole' -f $Context, $PortalId
            Method = 'POST'
            Body   = @{
                f           = 'json'
                token       = $Token
                name        = $Name
                description = $Description
            }
        }

        # ADD SKIP CERTIFICATE CHECK IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE QUERY
        Invoke-RestMethod @restParams
    }
}