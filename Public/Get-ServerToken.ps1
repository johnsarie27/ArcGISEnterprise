function Get-ServerToken {
    <# =========================================================================
    .SYNOPSIS
        Generate token
    .DESCRIPTION
        Generate token for ArcGIS Server
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Credential
        PowerShell credential object containing username and password
    .PARAMETER Referer
        Referer
    .PARAMETER Client
        Client
    .PARAMETER Expiration
        Token expiration time in minutes
    .PARAMETER NonAdmin
        Use the non-Admin URL to generate the token
    .PARAMETER SkipCertificateCheck
        Ignore missing or invalid certificate
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-ServerToken -URL https://mydomain.com/arcgis -Credential $creds
        Generate token for mydomain.com
    .NOTES
        -- SERVER ENDPONITS --
        https://myDomain.com/arcgis/admin/login
        https://myDomain.com/arcgis/admin/generateToken
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target Portal URL')]
        [ValidatePattern('^https://[\w\/\.-]+[^/]$')]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'PS Credential object containing un and pw')]
        [ValidateNotNullOrEmpty()]
        [pscredential] $Credential,

        [Parameter(HelpMessage = 'Referer')]
        [string] $Referer,

        [Parameter(HelpMessage = 'Client')]
        [string] $Client,

        [Parameter(HelpMessage = 'Token expiration time in minutes')]
        [ValidateRange(1, 900)]
        [int] $Expiration,

        [Parameter(HelpMessage = 'Use a non-Admin URL')]
        [switch] $NonAdmin,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [switch] $SkipCertificateCheck
    )

    Process {
        $serverUri = '{0}/admin/generateToken' -f $Context
        if ( $PSBoundParameters.ContainsKey('NonAdmin') ) { $serverUri = '{0}/tokens/generateToken' -f $Context }

        $restParams = @{
            Uri    = $serverUri
            Method = 'POST'
            Body   = @{
                username   = $Credential.UserName
                password   = $Credential.GetNetworkCredential().password
                referer    = if ($PSBoundParameters.ContainsKey('Referer')) { $Referer } else { 'referer' }
                client     = if ($PSBoundParameters.ContainsKey('Client')) { $Client } else { 'requestip' } # 'referer'
                f          = 'pjson'
            }
        }

        # WHEN USING THE VALUES ABOVE FOR CLIENT AND REFERER, YOU MUST ADD THE HEADER BELOW TO ANY SUBSEQUENT CALLS
        # Headers = @{ Referer = 'referer-value' }

        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }
        if ($PSBoundParameters.ContainsKey('Expiration')) { $restParams.Body.Add('expiration', $Expiration) }

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