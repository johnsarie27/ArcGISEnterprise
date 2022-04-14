function Get-PortalConfiguration {
    <# =========================================================================
    .SYNOPSIS
        Get Portal configuration or "self"
    .DESCRIPTION
        Get Portal configuration or "self." This may also be a good test of
        Portal token validity
    .PARAMETER Context
        Target Portal context
    .PARAMETER Token
        Portal token
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-PortalConfiguration -Context 'https://arcgis.com/arcgis' -Token $token
        Gets Portal "self" configuration
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    [Alias('Test-PortalToken')]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token
    )
    Process {
        $restParams = @{
            Uri    = '{0}/sharing/rest/portals/self' -f $Context
            Method = 'POST'
            Body   = @{
                f     = 'json'
                token = $Token
            }
        }

        Invoke-RestMethod @restParams
    }
}