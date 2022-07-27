function ConvertFrom-ArcGISLog2 {
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
        Version:  0.1.4 | Last Edit: 2022-07-26
        - 0.1.0 - Initial version
        - 0.1.1 - Added pipeline input and ordered properties
        - 0.1.2 - Added support for ArcGIS Server logs and renamed function
        - 0.1.3 - Updated logic with try/catch for XML parsing errors
        - 0.1.4 - Added dynamically changing columns
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
        $content = Get-Content -Path $Path

        # GET HEADERS
        $headers = (([System.Xml.XmlDocument] $content[0]).Msg | Get-Member -MemberType NoteProperty).Name

        foreach ($line in $content) {

            # IF LINE DOES EMD WITH CLOSING TAG APPEND CORRECT TAG
            if (-Not $line.EndsWith('</Msg>')) { $line += '</Msg>' }

            try {
                # CONVERT LINE TO XML OR CATCH ERROR
                $l = ([System.Xml.XmlDocument] $line).Msg

                # OBJECT CREATION SHOULD STAY IN THE TRY BLOCK SO THAT ANY FAILURE
                # IN THE XML CONVERSION WILL TERMINATE THE ENTIRE LINE RATHER THAN
                # CREATING A NEW OBJECT WITH THE PREVIOUS LINE DATA

                # CREATE HASHTABLE
                $hash = [Ordered] @{}

                # ADD PROPERTY NAME AND VALUE TO HASHTABLE
                for ($i = 0; $i -LT $headers.Count; $i++) {

                    if ($headers[$i] -EQ '#text') {
                        $hash['message'] = $l."$headers[$i]"
                    }
                    else {
                        $hash[$headers[$i]] = $l."$headers[$i]"
                    }
                }

                # CAST HASHTABLE AS OBJECT AND OUTPUT
                [PSCustomObject] $hash
            }
            catch {
                Write-Warning -Message ('Invalid log entry "{0}"' -f $line)
            }
        }
    }
}