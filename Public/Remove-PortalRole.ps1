function Remove-PortalRole {
    <#
    .SYNOPSIS
        Remove Role in Portal for ArcGIS
    .DESCRIPTION
        Remove Role in Portal for ArcGIS
    .PARAMETER RoleId
        Portal Role ID
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
        PS C:\> Remove-PortalRole -RoleId '123456' @commonParams
        Removes role with ID 123456 from Portal for ArcGIS
    .NOTES
        Name:     Remove-PortalRole
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2022-07-19
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
        https://developers.arcgis.com/rest/users-groups-and-items/delete-role.htm
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Portal Role ID')]
        [ValidateNotNullOrEmpty()]
        [System.String] $RoleId,

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
            Uri    = '{0}/sharing/rest/portals/{1}/roles/{2}/delete' -f $Context, $PortalId, $RoleId
            Method = 'POST'
            Body   = @{
                f     = 'json'
                token = $Token
            }
        }

        # ADD SKIP CERTIFICATE CHECK IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # INVOKE QUERY
        Invoke-RestMethod @restParams
    }
}