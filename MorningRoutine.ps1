#Requires -Version 5.1

# ============================================================
# Morning Routine - Steps 2b, 3 & 4 (non-GUI system tasks)
# Self-elevates to Administrator if not already elevated.
# Launches MorningRoutine.ahk immediately, then runs system tasks in parallel.
# ============================================================

# Self-elevate if not running as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Start-Process pwsh -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

# Hand off to AHK immediately so GUI steps start without waiting for system tasks below
Start-Process (Join-Path $PSScriptRoot "MorningRoutine.ahk")

# Step 2b: Registry Backup (full export to single file)
$backupDir = "D:\Dropbox\Computing1\MySystems\Backups\Registry Backups"
New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
$datestamp = Get-Date -Format "yyyy-MM-dd"
$regFile = Join-Path $backupDir "Registry_$datestamp.reg"
Start-Process -FilePath "regedit.exe" -ArgumentList "/e `"$regFile`"" -Wait -WindowStyle Hidden

# Step 3: Create System Restore Point
Checkpoint-Computer -Description "Morning Routine" -RestorePointType "MODIFY_SETTINGS"

# Step 4: Check for Chrome Update via Google Update scheduled task
foreach ($task in @("GoogleUpdateTaskMachineUA", "GoogleUpdateTaskMachineCore")) {
    if (Get-ScheduledTask -TaskName $task -ErrorAction SilentlyContinue) {
        Start-ScheduledTask -TaskName $task
    }
}
