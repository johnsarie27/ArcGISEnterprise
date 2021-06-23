function Get-PortalUser {
    <# =========================================================================
    .SYNOPSIS
        Get Portal user
    .DESCRIPTION
        Get Portal user
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Username
        Portal username
    .PARAMETER Token
        Portal token
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-PortalUser -Context 'https://arcgis.com/arcgis' -Username 'joe' -Token $token
        Get user 'joe' from Portal
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target Portal context')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { $_.AbsoluteUri -match '^https://[\w\/\.-]+[^/]$' })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'Portal username')]
        [ValidatePattern('^[\w\.@-]+$')]
        [String] $Username,

        [Parameter(Mandatory, HelpMessage = 'Portal token')]
        [ValidatePattern('^[\w\.=-]+$')]
        [String] $Token
    )
    Process {
        $restParams = @{
            Uri    = '{0}/sharing/rest/community/users/{1}' -f $Context, $Username
            Method = 'POST'
            Body   = @{
                f     = 'pjson'
                token = $Token
            }
        }

        Invoke-RestMethod @restParams
    }
}