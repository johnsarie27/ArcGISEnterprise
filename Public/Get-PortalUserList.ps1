function Get-PortalUserList {
    <#
    .SYNOPSIS
        Get Portal user list
    .DESCRIPTION
        Get list of all Portal users
    .PARAMETER PortalId
        Portal ID
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
        PS C:\> Get-PortalUserList -Context 'https://arcgis.com/arcgis' -Token $token
        Get users from Portal
    .NOTES
        Name:     Get-PortalUserList
        Author:   Justin Johns
        Version:  0.1.3 | Last Edit: 2023-03-20
        - 0.1.3 - Added error handling
        - 0.1.2 - Changed array to generic list
        - 0.1.1 - Makes multiple requests to get all users if more than 100
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
        https://developers.arcgis.com/rest/users-groups-and-items/users.htm
    #>
    [CmdletBinding()]
    Param(
        [Parameter(HelpMessage = 'Portal ID')]
        [ValidateNotNullOrEmpty()]
        [System.String] $PortalId = '0123456789ABCDEF',

        [Parameter(Mandatory, HelpMessage = 'Target Portal context')]
        [ValidateScript({ $_.AbsoluteUri -match $context_regex })]
        [System.Uri] $Context,

        [Parameter(Mandatory, HelpMessage = 'Portal token')]
        [ValidateScript({ $_ -match $token_regex })]
        [System.String] $Token,

        [Parameter(HelpMessage = 'Skip SSL certificate check')]
        [System.Management.Automation.SwitchParameter] $SkipCertificateCheck
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        # CREATE USER ARRAY
        $userList = [System.Collections.Generic.List[System.Object]]::new()
    }
    Process {
        # SET PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/portals/{1}/users' -f $Context, $PortalId
            Method = 'POST'
            Body   = @{ f = 'json'; token = $Token; num = 100 }
        }

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        $rest = Invoke-RestMethod @restParams

        # CHECK FOR ERRORS
        if ($rest.error) {
            # RETURN ANY ERRORS
            $rest
        }
        else {
            # ADD USER TO ARRAY
            foreach ($u in $rest.users) { $userList.Add($u) | Out-Null }

            # SET REMAINING USERS
            $remainingUsers = $rest.total - 100
            Write-Verbose -Message ('Total users: {0}' -f $rest.total)

            # GET REMAINING USERS
            if ($remainingUsers -GT 0) {

                do {

                    Write-Verbose -Message ('Remaining users: {0}' -f $remainingUsers)

                    # RESET START
                    $restParams.Body['start'] = $rest.nextStart

                    # SEND REQUEST
                    $rest = Invoke-RestMethod @restParams

                    # ADD USER TO ARRAY
                    foreach ($u in $rest.users) { $userList.Add($u) | Out-Null }

                    # DECREMENT REMAINING USERS
                    $remainingUsers -= 100
                }
                while ($remainingUsers -GT 0)
            }

            # RETURN USERS
            $userList
        }
    }
}