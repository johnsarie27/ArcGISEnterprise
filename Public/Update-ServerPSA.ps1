function Update-ServerPSA {
    <#
    .SYNOPSIS
        Update ArcGIS Server PSA Account
    .DESCRIPTION
        Update ArcGIS Server PSA Account
    .PARAMETER Context
        ArcGIS Server context (e.g., https://arcgis.com/arcgis)
    .PARAMETER Credential
        PSCredential object containing current username and password
    .PARAMETER NewPassword
        PSCredential object containing new password
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
    .NOTES
        General notes
        https://developers.arcgis.com/rest/enterprise-administration/server/psa.htm
        https://developers.arcgis.com/rest/enterprise-administration/server/updatepsa.htm
        https://developers.arcgis.com/rest/users-groups-and-items/update-user.htm
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Server base URI (a.k.a., context)')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'PSCredential object containing current username and password')]
        [System.Management.Automation.PSCredential] $Credential,

        [Parameter(Mandatory, HelpMessage = 'PSCredential object containing new password')]
        [System.Management.Automation.PSCredential] $NewPassword
    )

    Process {
        # GET TOKEN
        $token = Get-ServerToken -Context $Context -Credential $Credential -Client 'referer' -Referer 'referer'

        # CHECK USER STATUS
        $status = Get-ServerPSA -Context $Context -Token $token.token

        if ($status.disabled -eq $false) {
            # CHANGE PASSWORD
            $restParams = @{
                Uri     = '{0}/admin/security/psa/update' -f $Context
                Method  = 'POST'
                Headers = @{ Referer = 'referer-value' }
                Body    = @{
                    f        = 'json'
                    token    = $token.token
                    username = $Credential.GetNetworkCredential().UserName
                    password = $NewPassword.GetNetworkCredential().Password
                }
            }
            $rotate = Invoke-RestMethod @restParams

            if ($rotate.status -eq 'success') { $rotate }
            else { Throw ('Error updating PSA password for web application "{0}"' -f $Context) }
        }
        else {
            Throw ('Error retrieving user for web application "{0}"' -f $Context)
        }
    }
}