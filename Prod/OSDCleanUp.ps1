<# 
Scriptnaam: cleanup.osdcloud
Datum: 26-04-2025
Beschrijving: Verzamelt OSDCloud- en OOBE-logbestanden, verplaatst deze naar IntuneManagementExtension, en voert daarna een opschoning uit.
Copyright: Novoferm Nederland BV
#>

# Start logging
Start-Transcript -Path (Join-Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD" ("Cleanup-" + (Get-Date -Format "yyyy-MM-dd-HHmmss") + ".log")) -ErrorAction Ignore

Write-Host "Execute OSD Cloud Cleanup Script" -ForegroundColor Green

# Zorg dat de log directory bestaat
If (-Not (Test-Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD")) {
    New-Item -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD" -ItemType Directory -Force | Out-Null
}

# Copy OOBEDeploy en AutopilotOOBE Logs uit Windows\Temp
If (Test-Path -Path 'C:\Windows\Temp') {
    Get-ChildItem 'C:\Windows\Temp' -Filter *OOBE* -ErrorAction SilentlyContinue | Copy-Item -Destination "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD" -Force
    Get-ChildItem 'C:\Windows\Temp' -Filter *Events* -ErrorAction SilentlyContinue | Copy-Item -Destination "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD" -Force
}

# Copy OOBEDeploy en AutopilotOOBE Logs uit C:\Temp
If (Test-Path -Path 'C:\Temp') {
    Get-ChildItem 'C:\Temp' -Filter *OOBE* -ErrorAction SilentlyContinue | Copy-Item -Destination "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD" -Force
}

# Copy OSDCloud Logs
If (Test-Path -Path 'C:\OSDCloud\Logs') {
    Move-Item 'C:\OSDCloud\Logs\*.*' -Destination "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD" -Force -ErrorAction SilentlyContinue
}

# Copy OSDeploy Logs
If (Test-Path -Path 'C:\ProgramData\OSDeploy') {
    Move-Item 'C:\ProgramData\OSDeploy\*.*' -Destination "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD" -Force -ErrorAction SilentlyContinue
}

# Cleanup directories
If (Test-Path -Path 'C:\OSDCloud') { Remove-Item -Path 'C:\OSDCloud' -Recurse -Force -ErrorAction SilentlyContinue }
If (Test-Path -Path 'C:\Drivers') { Remove-Item -Path 'C:\Drivers' -Recurse -Force -ErrorAction SilentlyContinue }
If (Test-Path -Path 'C:\Intel') { Remove-Item -Path 'C:\Intel' -Recurse -Force -ErrorAction SilentlyContinue }
If (Test-Path -Path 'C:\ProgramData\OSDeploy') { Remove-Item -Path 'C:\ProgramData\OSDeploy' -Recurse -Force -ErrorAction SilentlyContinue }

# Cleanup Setup Scripts folder (optioneel, uitgeschakeld)
# If (Test-Path -Path 'C:\Windows\Setup\Scripts') {
#     Remove-Item 'C:\Windows\Setup\Scripts\*.*' -Exclude *.TAG -Force -ErrorAction SilentlyContinue
# }

# Stop logging
Stop-Transcript
