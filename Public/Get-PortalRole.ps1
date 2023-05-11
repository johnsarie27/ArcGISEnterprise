function Get-PortalRole {
    <#
    .SYNOPSIS
        Get Portal for ArcGIS Role
    .DESCRIPTION
        Get Portal for ArcGIS Role
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
        PS C:\> Get-PortalRole @commonParams
        Get Portal for ArcGIS roles including privilege information
    .NOTES
        Name:     Get-PortalRole
        Author:   Justin Johns
        Version:  0.1.1 | Last Edit: 2023-05-11
        - 0.1.1 - Makes multiple requests to get all roles if more than 50
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
        https://developers.arcgis.com/rest/users-groups-and-items/roles.htm
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

        # CREATE ROLE ARRAY
        $roleList = [System.Collections.Generic.List[System.Object]]::new()
    }
    Process {
        # SET QUERY PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/portals/{1}/roles?returnPrivileges=true' -f $Context, $PortalId
            Method = 'GET'
            Body   = @{
                f     = 'json'
                token = $Token
                num = 50
            }
        }

        # ADD SKIP CERTIFICATE CHECK IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        $rest = Invoke-RestMethod @restParams

        # CHECK FOR ERRORS
        if ($rest.error) {
            # RETURN ANY ERRORS
            $rest
        }
        else {
            # ADD ROLE TO ARRAY
            foreach ($r in $rest.roles) { $roleList.Add($r) | Out-Null }

            # SET REMAINING ROLES
            $remainingRoles = $rest.total - 50
            Write-Verbose -Message ('Total roles: {0}' -f $rest.total)

            # GET REMAINING ROLES
            if ($remainingRoles -GT 0) {

                do {

                    Write-Verbose -Message ('Remaining roles: {0}' -f $remainingRoles)

                    # RESET START
                    $restParams.Body['start'] = $rest.nextStart

                    # SEND REQUEST
                    $rest = Invoke-RestMethod @restParams

                    # ADD ROLES TO ARRAY
                    foreach ($r in $rest.roles) { $roleList.Add($r) | Out-Null }

                    # DECREMENT REMAINING ROLES
                    $remainingRoles -= 50
                }
                while ($remainingRoles -GT 0)
            }

            # RETURN ROLES
            $roleList
        }
    }
}