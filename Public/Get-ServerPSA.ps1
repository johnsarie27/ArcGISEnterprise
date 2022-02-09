function Get-ServerPSA {
    <# =========================================================================
    .SYNOPSIS
        Get Portal user
    .DESCRIPTION
        Get Portal user
    .PARAMETER Context
        ArcGIS Server context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Username
        Portal username
    .PARAMETER Token
        Portal token
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-ServerPSA -Context 'https://arcgis.com/arcgis' -Token $token
        Get PSA user from Server
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
        [String] $Token,

        [Parameter(HelpMessage = 'Referer')]
        [string] $Referer = 'referer-value'
    )
    Process {
        $restParams = @{
            Uri     = '{0}/admin/security/psa' -f $Context
            Method  = 'POST'
            Headers = @{ Referer = $Referer }
            Body    = @{
                f     = 'pjson'
                token = $Token
            }
        }

        Invoke-RestMethod @restParams
    }
}