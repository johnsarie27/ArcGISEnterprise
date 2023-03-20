function Search-PortalContent {
    <#
    .SYNOPSIS
        Search Portal for ArcGIS content
    .DESCRIPTION
        Search Portal for ArcGIS content by user, item ID, etc.
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
        PS C:\> Search-PortalContent @commonParams -Username 'jsmith'
        Get all Portal items belonging to 'jsmith'
    .NOTES
        Name:     Search-PortalContent
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2023-13-20
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
        https://developers.arcgis.com/rest/users-groups-and-items/search-reference.htm
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = 'Id')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Id,

        [Parameter(Mandatory = $false, HelpMessage = 'Username')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Username,

        [Parameter(Mandatory = $false, HelpMessage = 'Title')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Title,

        [Parameter(Mandatory = $false, HelpMessage = 'Tags')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Tags,

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

        Write-Verbose -Message $PSBoundParameters.GetType().FullName

        Write-Verbose -Message ($PSBoundParameters | Out-String)
    }
    Process {
        # SET PARAMETERS
        $restParams = @{
            Uri    = '{0}/sharing/rest/search' -f $Context
            Method = 'POST'
            Body   = @{ f = 'json'; token = $Token }
        }

        # ADD SEARCH PARAMS
        switch ($PSBoundParameters.Keys) {
            'Id' {
                $restParams.Body['q'] = 'id:"{0}"' -f $Id
                $searchParams = 1
            }
            'Username' {
                if ($searchParams) { $restParams.Body['q'] += ' AND username:"{0}"' -f $Username }
                else { $restParams.Body['q'] = 'username:"{0}"' -f $Username }
                $searchParams++
            }
            'Tags' {
                if ($searchParams) { $restParams.Body['q'] += ' AND tags:"{0}"' -f $Tags }
                else { $restParams.Body['q'] = 'tags:"{0}"' -f $Tags }
                $searchParams++
            }
            'Title' {
                if ($searchParams) { $restParams.Body['q'] += ' AND title:"{0}"' -f $Title }
                else { $restParams.Body['q'] = 'title:"{0}"' -f $Title }
                $searchParams++
            }
        }

        # SHOW QUERY STRING
        Write-Verbose -Message ('Query string: {0}' -f $restParams.Body.q)

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        $rest = Invoke-RestMethod @restParams

        # ADD USER TO ARRAY
        foreach ($i in $rest.results) { $itemList.Add($i) | Out-Null }

        # SET REMAINING ITEMS
        $remainingItems = $rest.total - 100
        Write-Verbose -Message ('Total Items: {0}' -f $rest.total)

        # GET REMAINING USERS
        if ($remainingItems -GT 0) {

            do {

                Write-Verbose -Message ('Remaining items: {0}' -f $remainingItems)

                # RESET START
                $restParams.Body['start'] = $rest.nextStart

                # SEND REQUEST
                $rest = Invoke-RestMethod @restParams

                # ADD USER TO ARRAY
                foreach ($i in $rest.results) { $itemList.Add($i) | Out-Null }

                # DECREMENT REMAINING USERS
                $remainingItems -= 100
            }
            while ($remainingItems -GT 0)
        }

        # RETURN USERS
        $itemList
    }
}