[CmdletBinding()]
param (
    [Parameter()]
    [ValidateSet('Default', 'Init', 'Clean', 'CombineFunctionsAndStage', 'ImportStagingModule', 'Analyze', 'Test', 'UpdateDocumentation', 'CreateBuildArtifact')]
    [System.String[]]
    $TaskList = 'Default',

    [Parameter()]
    [System.Collections.Hashtable]
    $Parameters,

    [Parameter()]
    [System.Collections.Hashtable]
    $Properties,

    [Parameter()]
    [Switch]
    $ResolveDependency
)

Write-Output "`nSTARTED TASKS: $($TaskList -join ',')`n"

Write-Output "`nPowerShell Version Information:"
$PSVersionTable

# Load dependencies
if ($PSBoundParameters.Keys -contains 'ResolveDependency') {
    # Bootstrap environment
    Get-PackageProvider -Name 'NuGet' -ForceBootstrap | Out-Null

    # Install PSDepend module if it is not already installed
    if (-not (Get-Module -Name 'PSDepend' -ListAvailable)) {
        Write-Output "`nPSDepend is not yet installed...installing PSDepend now..."
        Install-Module -Name 'PSDepend' -Scope 'CurrentUser' -Force
    }
    else {
        Write-Output "`nPSDepend already installed...skipping."
    }

    # Install build dependencies
    $psdependencyConfigPath = Join-Path -Path $PSScriptRoot -ChildPath 'depend.psd1'
    Write-Output "Checking / resolving module dependencies from [$psdependencyConfigPath]..."
    Import-Module -Name 'PSDepend'
    $invokePSDependParams = @{
        Path    = $psdependencyConfigPath
        # Tags = 'Bootstrap'
        Import  = $true
        Confirm = $false
        Install = $true
        Force   = $true

        # Verbose = $true
    }
    Invoke-PSDepend @invokePSDependParams

    # Remove ResolveDependency PSBoundParameter ready for passthru to PSake
    $PSBoundParameters.Remove('ResolveDependency')
}
else {
    Write-Output "Skipping dependency check...`n" -ForegroundColor 'Yellow'
}

# Init BuildHelpers
Set-BuildEnvironment -Force

# Execute PSake tasts
$invokePsakeParams = @{
    buildFile = (Join-Path -Path $env:BHProjectPath -ChildPath 'Build\build.psake.ps1')
    nologo    = $true
}
Invoke-psake @invokePsakeParams @PSBoundParameters

Write-Output "`nFINISHED TASKS: $($TaskList -join ',')"
exit ( [int](-not $psake.build_success) )
