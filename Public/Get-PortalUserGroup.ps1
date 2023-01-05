function Get-PortalUserGroup {
    <#
    .SYNOPSIS
        Get Portal for ArcGIS user group
    .DESCRIPTION
        Get groups owned by specified Portal for ArcGIS user
    .PARAMETER Username
        Username
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
        PS C:\> Get-PortalUserGroup -Username jsmith -Context 'https://arcgis.com/arcgis' -Token $token
        Get groups owned by user 'jsmith'
    .NOTES
        Name:     Get-PortalUserGroup
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2022-09-29
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes:
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Username')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Username,

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
        # SET PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/community/groups' -f $Context
            Method = 'POST'
            Body   = @{ f = 'json'; token = $Token; q = $Username }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        Invoke-RestMethod @restParams
    }
}