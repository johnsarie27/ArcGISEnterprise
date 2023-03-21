function Get-PortalUserGroup {
    <#
    .SYNOPSIS
        Get Portal for ArcGIS user group
    .DESCRIPTION
        Get groups owned by specified user in Portal for ArcGIS
    .PARAMETER Username
        Username
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
        PS C:\> Get-PortalUserGroup -Username jsmith -Context 'https://arcgis.com/arcgis' -Token $token
        Get groups owned by user 'jsmith'
    .NOTES
        Name:     Get-PortalUserGroup
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2023-03-20
        - 0.1.1 - Added automatic retrieval of paginated data
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes:
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Username')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Username,

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
        $groupList = [System.Collections.Generic.List[System.Object]]::new()
    }
    Process {
        # SET PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/community/groups' -f $Context
            Method = 'POST'
            Body   = @{
                f     = 'json'
                token = $Token
                num   = 100
                # THE SYNTAX 'q = "jsmith"' WILL FIND THE USER ACROSS MULTIPLE
                # FIELDS RATHER THAN JUST THE OWNER FIELD. USE Search-PortalContent
                # TO FIND A USERNAME AS A SEARCH TERM FOR MULTIPLE FIELDS
                q     = 'owner:"{0}"' -f $Username
            }
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
            foreach ($g in $rest.results) { $groupList.Add($g) | Out-Null }

            # SET REMAINING USERS
            $remainingGroups = $rest.total - 100
            Write-Verbose -Message ('Total groups: {0}' -f $rest.total)

            # GET REMAINING USERS
            if ($remainingGroups -GT 0) {

                do {

                    Write-Verbose -Message ('Remaining groups: {0}' -f $remainingGroups)

                    # RESET START
                    $restParams.Body['start'] = $rest.nextStart

                    # SEND REQUEST
                    $rest = Invoke-RestMethod @restParams

                    # ADD USER TO ARRAY
                    foreach ($g in $rest.results) { $groupList.Add($g) | Out-Null }

                    # DECREMENT REMAINING USERS
                    $remainingGroups -= 100
                }
                while ($remainingGroups -GT 0)
            }

            # RETURN USERS
            $groupList
        }
    }
}