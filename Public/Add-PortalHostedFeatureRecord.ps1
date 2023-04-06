function Add-PortalHostedFeatureRecord {
    <#
    .SYNOPSIS
        Add record to Portal Hosted Feature Service
    .DESCRIPTION
        Add records/data to a Portal Hosted Feature Service
    .PARAMETER Record
        Record or data to add to the Portal Hosted Feature Service
    .PARAMETER ServiceName
        Portal Hosted Feature Service Name
    .PARAMETER Layer
        Service Layer index
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
        PS C:\> Add-PortalHostedFeatureRecord @commonParams -Record $rec -ServiceName "dashboard"
        Add records to a Hosted Feature Service named "dashboard"
    .NOTES
        Name:     Add-PortalHostedFeatureRecord
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2023-04-04
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = 'Record or feature to add')]
        #[ValidateScript({ ($_ | Get-Member -MemberType NoteProperty).Name -contains 'attributes' })]
        [ValidateScript({ $_.psobject.Members.Name -contains 'attributes' })]
        [System.Object[]] $Record,

        [Parameter(Mandatory = $true, HelpMessage = 'Portal Hosted Feature Service Name')]
        [ValidateNotNullOrEmpty()]
        [System.String] $ServiceName,

        [Parameter(Mandatory = $false, HelpMessage = 'Layer index')]
        [ValidateNotNullOrEmpty()]
        [System.Int32] $Layer = 0,

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
    }
    Process {
        # SET PARAMETERS FOR ADDING DATA
        $restParams = @{
            Uri    = '{0}/rest/services/Hosted/{1}/FeatureServer/{2}/addFeatures' -f $Context, $ServiceName, $Layer
            Method = 'POST'
            Body   = @{
                features = $Record | ConvertTo-Json -Depth 5 -Compress
                f        = 'json'
                token    = $Token
            }
        }

        # INVOKE DATA ADD
        Invoke-RestMethod @restParams
    }
}