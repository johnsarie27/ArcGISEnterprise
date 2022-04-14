function Set-PortalAllowedOrigins {
    <# =========================================================================
    .SYNOPSIS
        Set the allowed origins property for Portal
    .DESCRIPTION
        Set the allowed origins property for Portal
    .PARAMETER Context
        Target Portal context
    .PARAMETER Origin
        Origin to be allowed for Portal
    .PARAMETER Token
        Portal token
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Set-PortalAllowedOrigins -Origin 'https://arcgis.com', 'https://test.com'
        Sets the allowed origins property to 'https://arcgis.com,https://test.com'
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    [Alias('Test-PortalToken')]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'Origin to be allowed')]
        [ValidateNotNullOrEmpty()]
        [System.String[]] $Origin,

        [Parameter(Mandatory, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token
    )
    Process {
        $restParams = @{
            Uri    = '{0}/sharing/rest/portals/self/update' -f $Context
            Method = 'POST'
            Body   = @{
                f              = 'json'
                token          = $Token
                allowedOrigins = ($Origin -join ',')
            }
        }
        Invoke-RestMethod @restParams
    }
}