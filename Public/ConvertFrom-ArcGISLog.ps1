function ConvertFrom-ArcGISLog {
    <# =========================================================================
    .SYNOPSIS
        Convert from ArcGIS log
    .DESCRIPTION
        Convert from ArcGIS Server or Portal log to array of objects
    .PARAMETER Path
        Path to log file
    .INPUTS
        System.String.
    .OUTPUTS
        System.Management.Automation.PSCustomObject.
    .EXAMPLE
        PS C:\> ConvertFrom-ArcGISLog -Path "C:\logs\myLog.log"
        Converts all entries in the log to objects
    .NOTES
        Name:     ConvertFrom-ArcGISLog
        Author:   Justin Johns
        Version:  0.1.3 | Last Edit: 2022-07-21
        - 0.1.0 - Initial version
        - 0.1.1 - Added pipeline input and ordered properties
        - 0.1.2 - Added support for ArcGIS Server logs and renamed function
        - 0.1.3 - Updated logic with try/catch for XML parsing errors
        Comments: <Comment(s)>
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, HelpMessage = 'Path to log file')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [System.String] $Path
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
    }
    Process {
        # GET CONTENT OF LOG FILE
        foreach ($line in (Get-Content -Path $Path)) {

            # IF LINE DOES EMD WITH CLOSING TAG APPEND CORRECT TAG
            if (-Not $line.EndsWith('</Msg>')) { $line += '</Msg>' }

            try {
                # CONVERT LINE TO XMLS OR CATCH ERROR
                $l = ([System.Xml.XmlDocument] $line).Msg

                # CREATE AND OUTPUT CUSTOM OBJECT FOR LOG ENTRY
                [PSCustomObject] [Ordered] @{
                    time       = $l.time
                    type       = $l.type
                    code       = $l.code
                    source     = $l.source
                    process    = $l.process
                    thread     = $l.thread
                    methodName = $l.methodName
                    machine    = $l.machine
                    user       = $l.user
                    elapsed    = $l.elapsed
                    requestID  = $l.requestID
                    message    = $l.'#text'
                }
            }
            catch {
                Write-Warning -Message ('Invalid log entry "{0}"' -f $line)
            }
        }
    }
}