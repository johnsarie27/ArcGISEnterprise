function ConvertFrom-PortalLog {
    <# =========================================================================
    .SYNOPSIS
        Convert from Portal log
    .DESCRIPTION
        Convert from Portal log to array of objects
    .PARAMETER Path
        Path to Portal log file
    .INPUTS
        None.
    .OUTPUTS
        System.Management.Automation.PSCustomObject.
    .EXAMPLE
        PS C:\> ConvertFrom-PortalLog -Path "C:\logs\myLog.log"
        Converts all entries in the log to objects
    .NOTES
        Name:     ConvertFrom-PortalLog
        Author:   Justin Johns
        Version:  0.1.0 | Last Edit: 2022-07-14
        - <VersionNotes> (or remove this line if no version notes)
        Comments: <Comment(s)>
        General notes
    ========================================================================= #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Path to Portal log file')]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [System.String] $Path
    )
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
    }
    Process {
        # GET CONTENT OF LOG FILE
        foreach ($line in (Get-Content -Path $Path)) {

            # CONVERT LINE TO XMLS
            $l = ([System.Xml.XmlDocument] $line).Msg

            # CREATE AND OUTPUT CUSTOM OBJECT FOR LOG ENTRY
            [PSCustomObject] @{
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
    }
}