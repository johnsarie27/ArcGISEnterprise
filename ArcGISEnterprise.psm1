# ==============================================================================
# Filename: ArcGISEnterprise.psm1
# Updated:  2022-02-09
# Author:   Justin Johns
# ==============================================================================

# IMPORT ALL FUNCTIONS
foreach ( $directory in @('Public', 'Private') ) {
    foreach ( $fn in (Get-ChildItem -Path "$PSScriptRoot\$directory\*.ps1") ) { . $fn.FullName }
}

# VARIABLES
New-Variable -Name 'context_regex' -Option Constant -Value '^https?://[\w\/\.:-]+[^/]$'
New-Variable -Name 'token_regex' -Option Constant -Value '^[\w\.=-]+$'

# EXPORT MEMBERS
# THESE ARE SPECIFIED IN THE MODULE MANIFEST AND THEREFORE DON'T NEED TO BE LISTED HERE
#Export-ModuleMember -Function *
#Export-ModuleMember -Variable *
