function ConvertFrom-Epoch {
    <#
    .SYNOPSIS
        Convert from Epoch to DateTime
    .DESCRIPTION
        Convert from Epoch in milliseconds to DateTime
    .PARAMETER Milliseconds
        Epoch Time in milliseconds
    .INPUTS
        System.Int64.
    .OUTPUTS
        System.DateTime.
    .EXAMPLE
        PS C:\> 1618614176000 | ConvertFrom-Epoch
        Convert Epoch time of 1618614176000 to a DateTime object
    .NOTES
        Name:     ConvertFrom-Epoch
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2022-06-07
        - <VersionNotes> (or remove this line if no version notes)
        Comments: <Comment(s)>
        General notes
    #>
    [CmdletBinding()]
    [OutputType([System.DateTime])]
    Param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, HelpMessage = 'EPOCH Time in milliseconds')]
        [ValidateNotNullOrEmpty()]
        [System.Int64[]] $Milliseconds
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
    }
    Process {
        foreach ($ms in $Milliseconds) {

            [System.DateTimeOffset]::FromUnixTimeMilliseconds($ms).DateTime.ToLocalTime()
        }
    }
}