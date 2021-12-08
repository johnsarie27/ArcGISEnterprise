function Get-PortalToken {
    <# =========================================================================
    .SYNOPSIS
        Generate token
    .DESCRIPTION
        Generate token for ArcGIS Portal
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Credential
        PowerShell credential object containing username and password
    .PARAMETER Referer
        Referer
    .PARAMETER Expiration
        Token expiration time in minutes
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-PortalToken -URL https://mydomain.com/arcgis -Credential $creds
        Generate token for mydomain.com
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target Portal URL')]
        #[Alias('Uri')]
        [ValidatePattern('^https://[\w\/\.-]+[^/]$')]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'PS Credential object containing un and pw')]
        [ValidateNotNullOrEmpty()]
        [pscredential] $Credential,

        [Parameter(HelpMessage = 'Referer')]
        [string] $Referer,

        [Parameter(HelpMessage = 'Token expiration time in minutes')]
        [ValidateRange(1,900)]
        [int] $Expiration = 60,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [switch] $SkipCertificateCheck
    )

    Process {

        $restParams = @{
            Uri    = '{0}/sharing/rest/generateToken' -f $Context
            Method = "POST"
            Body   = @{
                username   = $Credential.UserName
                password   = $Credential.GetNetworkCredential().password
                #client     = 'requestip'
                #referer    = 'http' # REQUIRED FOR PYTHON API
                referer    = if (!$PSBoundParameters.ContainsKey('Referer')) { '{0}://{1}' -f $Context.Scheme, $Context.Authority } else { $Referer }
                expiration = $Expiration #minutes
                f          = 'pjson'
            }
        }

        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        Write-Verbose -Message ('Referer: {0}' -f $restParams['Body']['referer'])

        try { $response = Invoke-RestMethod @restParams }
        catch { $response = $_.Exception.Response }

        # CHECK FOR ERRORS AND RETURN
        if ( -not $response.token ) {
            # CHECK FOR VALID JSON WITH ERROR DETAILS
            if ( $response.error ) {
                if ( $response.error.details.GetType().FullName -eq 'System.Object[]' ) { $details = $response.error.details -join "; " }
                else { $details = $response.error.details }

                $tokens = @($response.error.code, $response.error.message, $details)
                $msg = "Request failed with response:`n`tcode: {0}`n`tmessage: {1}`n`tdetails: {2}" -f $tokens
            }
            elseif ( $response.ReasonPhrase ) { $msg = $response.ReasonPhrase }
            else { $msg = "Request failed with unknown error. Username and/or password may be incorrect." }

            Throw $msg
        }
        else {
            $response
        }
    }
}