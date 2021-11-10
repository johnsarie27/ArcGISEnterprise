function Get-PortalIndexStatus {
    <# =========================================================================
    .SYNOPSIS
        Get Portal index status
    .DESCRIPTION
        Get Portal index status
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
        PS C:\> Get-PortalIndexStatus -Context 'https://arcgis.com/arcgis' -Token $token
        Get status of Portal indexes
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
        [String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [switch] $SkipCertificateCheck
    )
    Process {
        $restParams = @{
            Uri    = '{0}/portaladmin/system/indexer/status' -f $Context
            Method = 'GET'
            Body   = @{
                f     = 'pjson'
                token = $Token
            }
        }
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }
        Invoke-RestMethod @restParams
    }
}