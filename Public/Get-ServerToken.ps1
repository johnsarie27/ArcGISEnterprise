function Get-ServerToken {
    <#
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
    .PARAMETER Admin
        Use the Admin URL to generate the token
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
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target Portal URL')]
        #[ValidatePattern('^https://[\w\/\.-]+[^/]$')]
        [ValidateScript({ $_.OriginalString -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'PS Credential object containing un and pw')]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential] $Credential,

        [Parameter(HelpMessage = 'Referer')]
        [System.String] $Referer = 'referer',

        [Parameter(HelpMessage = 'Client')]
        [System.String] $Client = 'requestip',

        [Parameter(HelpMessage = 'Token expiration time in minutes')]
        [ValidateRange(1, 900)]
        [System.Int32] $Expiration,

        [Parameter(HelpMessage = 'Use the Admin URL to get a token')]
        [System.Management.Automation.SwitchParameter] $Admin,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )

    Process {
        $serverUri = '{0}/tokens/generateToken' -f $Context
        if ( $PSBoundParameters.ContainsKey('Admin') ) { $serverUri = '{0}/admin/generateToken' -f $Context }

        # WHEN USING 'referer' FOR BOTH CLIENT AND REFERER, YOU MUST ADD THE HEADER BELOW TO ANY SUBSEQUENT CALLS
        # Headers = @{ Referer = 'referer-value' }

        $restParams = @{
            Uri    = $serverUri
            Method = 'POST'
            Body   = @{
                username   = $Credential.UserName
                password   = $Credential.GetNetworkCredential().password
                referer    = $Referer
                client     = $Client
                f          = 'json'
            }
        }

        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }
        if ($PSBoundParameters.ContainsKey('Expiration')) { $restParams.Body.Add('expiration', $Expiration) }

        try { $response = Invoke-RestMethod @restParams }
        catch { $response = $_.Exception.Response }

        # CHECK FOR ERRORS AND RETURN
        if ( -not $response.token ) {
            # CHECK FOR VALID JSON WITH ERROR DETAILS
            if ( $response.error.details ) {
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