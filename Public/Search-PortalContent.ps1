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
        [Parameter(Mandatory = $false, HelpMessage = 'Username')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Username,

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
            'Username' {
                $restParams.Body['q'] = 'owner:"{0}"' -f $Username
                $searchParams = 1
            }
            'Tags' {
                if ($searchParams) { $restParams.Body['q'] += ' AND tags:"{0}"' -f $Tags }
                else { $restParams.Body['q'] = 'tags:{0}' -f $Tags }
            }
        }

        Write-Verbose -Message ($restParams.Body | Out-String)

        # ADD CERTIFICATE SKIP IF PROVIDED
        if ($PSBoundParameters.ContainsKey('SkipCertificateCheck')) { $restParams['SkipCertificateCheck'] = $true }

        # SEND REQUEST
        #Invoke-RestMethod @restParams
    }
}