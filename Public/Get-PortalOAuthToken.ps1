function Get-PortalOAuthToken {
    <#
    .SYNOPSIS
        Get Portal OAuth token
    .DESCRIPTION
        Generate OAuth token for Portal application
    .PARAMETER Context
        Target Portal context
    .PARAMETER Credential
        PowerShell credential object containing username and password
    .PARAMETER Expiration
        Token expiration time in minutes
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> Get-PortalOAuthToken -Context 'https://arcgis.com/arcgis' -Credential $creds
        Get OAuth token for Portal application
    .NOTES
        General notes
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'PS Credential object containing un and pw')]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential] $Credential,

        [Parameter(HelpMessage = 'Token expiration time in minutes')]
        [ValidateRange(1, 1440)]
        [System.Int32] $Expiration = 15
    )
    Process {
        $requestParams = @{
            Uri    = '{0}/sharing/rest/oauth2/token/' -f $Context
            Method = 'POST'
            Body   = @{
                f             = 'json'
                client_id     = $Credential.UserName
                client_secret = $Credential.GetNetworkCredential().Password
                grant_type    = 'client_credentials'
                expiration    = $Expiration
            }
        }

        Invoke-RestMethod @requestParams
    }
}