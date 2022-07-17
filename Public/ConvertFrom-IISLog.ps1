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
        Version:  0.1.2 | Last Edit: 2022-07-16
        - 0.1.0 - Initial version
        - 0.1.1 - Updated code to skip header rows
        - 0.1.2 - Get headers from log file
        Comments: <Comment(s)>
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, HelpMessage = 'Path to IIS log file')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf -Filter "*.log" })]
        [System.String] $Path
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"

        <# # SET HEADERS
        $headers = @(
            'date'
            'cs_Referer'
            'cs_ser_Agent'
            'sc_win32_status'
            'cs_uri_query'
            'time'
            'cs_uri_stem'
            'time_taken'
            'cs_username'
            's_ip'
            'sc_status'
            'cs_method'
            's_port'
            'sc_substatus'
            'c_ip'
        ) #>
    }
    Process {

        # PROCESS EACH LINE
        foreach ($line in (Get-Content -Path $Path)) {

            # GET HEADERS
            if ($line.StartsWith('#Fields:')) {

                # SET HEADERS
                $headers = $line.Replace('#Fields: ', '').Split(' ')
            }
            # CREATE OBJECTS FROM DATA ROWS
            if ($line -NotMatch '^#') {

                # SPLIT LINE
                $split = $line.Split(' ')

                <# # CREATE AND OUTPUT CUSTOM OBJECT
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
                } #>

                # CREATE HASHTABLE
                $hash = @{}

                # ADD PROPERTY NAME AND VALUE TO HASHTABLE
                for ($i = 0; $i -LT $headers.Count; $i++) { $hash[$headers[$i]] = $split[$i] }

                # CAST HASHTABLE AS OBJECT AND OUTPUT
                [PSCustomObject] $hash
            }
        }
    }
}