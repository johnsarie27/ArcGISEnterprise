function Get-PortalSecurityPolicy {
    <#
    .SYNOPSIS
        Get Portal security policy
    .DESCRIPTION
        Get Portal security policy for user of provided token
    .PARAMETER Context
        Target Portal context
    .PARAMETER Token
        Portal token
    .PARAMETER Id
        Portal internal ID
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-SecurityPolicy -Context 'https://arcgis.com/arcgis' -Token $token
        Get security policy for Portal user
    .NOTES
        General notes
    #>
    [CmdletBinding()]
    [Alias('Get-SecurityPolicy')]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Portal application ID')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Id = '0123456789ABCDEF'
    )
    Process {
        $restParams = @{
            Uri    = '{0}/sharing/rest/portals/{1}/securityPolicy' -f $Context, $Id
            Method = 'POST'
            Body   = @{
                f     = 'json'
                token = $Token
            }
        }

        Invoke-RestMethod @restParams
    }
}