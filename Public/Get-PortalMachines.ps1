function Get-PortalMachines {
    <# =========================================================================
    .SYNOPSIS
        Get Portal machines
    .DESCRIPTION
        Get Portal machines
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-PortalMachines -Context 'https://arcgis.com/arcgis' -Token $token
        Get user from Portal
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target Portal context')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ $_.AbsoluteUri -match '^https://[\w\/\.-]+[^/]$' })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'Portal token')]
        [ValidatePattern('^[\w\.=-]+$')]
        [String] $Token
    )
    Process {
        $restParams = @{
            Uri    = '{0}/portaladmin/machines' -f $Context
            Method = 'GET'
            Body   = @{
                f     = 'pjson'
                token = $Token
            }
        }

        Invoke-RestMethod @restParams
    }
}