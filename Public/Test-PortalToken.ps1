function Test-PortalToken {
    <# =========================================================================
    .SYNOPSIS
        Test Portal token for validity
    .DESCRIPTION
        Test Portal token for validity
    .PARAMETER Context
        Target Portal context
    .PARAMETER Token
        Portal token
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Test-PortalToken -Context 'https://arcgis.com/arcgis' -Token $token
        Tests Portal token $token for validity
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [String] $Token
    )
    Process {
        $restParams = @{
            Uri    = '{0}/sharing/rest/portals/self' -f $Context
            Method = 'POST'
            Body   = @{
                f     = 'pjson'
                token = $Token
            }
        }

        Invoke-RestMethod @restParams
    }
}