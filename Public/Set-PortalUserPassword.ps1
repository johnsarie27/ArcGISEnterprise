function Set-PortalUserPassword {
    <#
    .SYNOPSIS
        Update Portal for ArcGIS PSA Account
    .DESCRIPTION
        Update Portal for ArcGIS PSA Account
    .PARAMETER Context
        Portal context (e.g., https://arcgis.com/arcgis)
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
    #>
    [CmdletBinding()]
    [Alias('Update-PortalPSA')]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Portal base URI (a.k.a., context)')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'PSCredential object containing current username and password')]
        [System.Management.Automation.PSCredential] $Credential,

        [Parameter(Mandatory, HelpMessage = 'PSCredential object containing new password')]
        [System.Management.Automation.PSCredential] $NewPassword
    )
    Process {
        # GET TOKEN
        $token = Get-PortalToken -Context $Context -Credential $Credential

        # GET USERNAME FROM CREDENTIAL
        $username = $Credential.GetNetworkCredential().UserName

        # GET USER FROM PROVIDED CREDENTIAL
        $status = Get-PortalUser -Context $Context -Username $username -Token $token.token

        # VALIDATE USER EXISTENCE USING ROLE PROPERTY
        if ($status.role) {
            # CHANGE PASSWORD
            $restParams = @{
                Uri    = '{0}/sharing/rest/community/users/{1}/update' -f $Context, $username
                Method = 'POST'
                Body   = @{
                    f        = 'json'
                    token    = $token.token
                    password = $NewPassword.GetNetworkCredential().Password
                }
            }
            $rotate = Invoke-RestMethod @restParams

            if ($true -eq $rotate.success) {
                $rotate
            }
            else {
                $details = $rotate.error.details | Out-String
                $errArray = @($rotate.error.code, $rotate.error.messageCode, $rotate.error.message, $details)
                Throw ('{0} -- {1} -- {2} -- {3}' -f $errArray)
            }
        }
        else {
            Throw ('Error validating user "{0}" in Portal for ArcGIS "{1}"' -f $username, $Context)
        }
    }
}