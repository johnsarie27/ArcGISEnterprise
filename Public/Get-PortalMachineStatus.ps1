function Get-PortalMachineStatus {
    <# =========================================================================
    .SYNOPSIS
        Get Portal machine status
    .DESCRIPTION
        Get Portal machine status
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Token
        Portal token
    .PARAMETER Machine
        Portal system to test
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-PortalMachineStatus -Machine 'myMachine.com' -Context 'https://arcgis.com/arcgis' -Token $token
        Get status of Portal system
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

        [Parameter(Mandatory, HelpMessage = 'Portal system to test')]
        [ValidateNotNullOrEmpty()]
        [string] $Machine,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [switch] $SkipCertificateCheck
    )
    Process {
        $restParams = @{
            Uri    = '{0}/portaladmin/machines/status/{1}' -f $Context, $Machine
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