function Clear-PortalHostedFeatureService {
    <#
    .SYNOPSIS
        Clear Portal Hosted Feature Service
    .DESCRIPTION
        Clear or purge all items from a table in a Hosted Feature Service Layer
    .PARAMETER ServiceName
        Portal Hosted Feature Service Name
    .PARAMETER Layer
        Service Layer index
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
        PS C:\> Clear-PortalHostedFeatureService @commonParams -ServiceName dashboard -Layer 0
        Clear or purge all data from the "dashboard" Hosted Feature Service layer 0
    .NOTES
        Name:     Clear-PortalHostedFeatureService
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2023-04-04
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Portal Hosted Feature Service Name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

        [Parameter(Mandatory = $true, HelpMessage = 'Layer index')]
        [ValidateNotNullOrEmpty()]
        [System.Int32] $Layer,

        [Parameter(Mandatory = $true, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory = $true, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
    }
    Process {
        # SET TRUNCATE PARAMETERS
        $restParams = @{
            Uri    = '{0}/rest/services/Hosted/{1}/FeatureServer/{2}/deleteFeatures' -f $Context, $ServiceName, $Layer
            Method = 'POST'
            Body   = @{
                where = 'objectid >= 0'
                f     = 'json'
                token = $Token
            }
        }

        Write-Verbose -Message ('Endpoint URI: [{0}]' -f $restParams['Uri'])

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SHOULD PROCESS
        if ($PSCmdlet.ShouldProcess($ServiceName, ('Purge all records from service layer [{0}]' -f $Layer))) {

            Write-Verbose -Message 'Invoking REST API endpoint "deleteFeatures"'

            # INVOKE TRUNCATE PROCESS
            Invoke-RestMethod @restParams
        }
    }
}