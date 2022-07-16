function ConvertFrom-IISLog {
    <# =========================================================================
    .SYNOPSIS
        Convert from IIS log
    .DESCRIPTION
        Convert from IIS log to objects
    .PARAMETER Path
        Path to IIS log file
    .INPUTS
        None.
    .OUTPUTS
        System.Management.Automation.PSCustomObject.
    .EXAMPLE
        PS C:\> ConvertFrom-IISLog -Path C:\logs\myLog.log
        Converts log data into objects
    .NOTES
        Name:     ConvertFrom-IISLog
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2022-07-15
        - 0.1.0 - Initial version
        Comments: <Comment(s)>
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Path to IIS log file')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Filter "*.log" })]
        [System.String] $Path
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
    }
    Process {
        # PROCESS EACH LINE EXCLUDING THE HEADER
        foreach ($line in (Get-Content -Path $Path | Select-Object -Skip 4)) {

            # SPLIT LINE
            $split = $line.Split(' ')

            # CREATE AND OUTPUT CUSTOM OBJECT
            [PSCustomObject] @{
                date            = $split[0]
                time            = $split[1]
                s_ip            = $split[2]
                cs_method       = $split[3]
                cs_uri_stem     = $split[4]
                cs_uri_query    = $split[5]
                s_port          = $split[6]
                cs_username     = $split[7]
                c_ip            = $split[8]
                cs_ser_Agent    = $split[9]
                cs_Referer      = $split[10]
                sc_status       = $split[11]
                sc_substatus    = $split[12]
                sc_win32_status = $split[13]
                time_taken      = $split[14]
            }
        }
    }
}