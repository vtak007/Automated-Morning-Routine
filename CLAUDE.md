# Automated Morning Routine — Project Instructions

## Key Files

| File | Purpose |
|---|---|
| `MorningRoutine.ps1` | Entry point — relaunches under PowerShell 7 if needed, self-elevates, updates Chrome via winget, launches AHK, then runs system tasks (admin) in parallel |
| `MEMORY.md` | Project memory — confirmed root causes, ruled-out theories, change log |
| `MorningRoutine.ahk` | GUI automation — launches all daily-use applications |
| `Readme.md` | Project readme — describes all steps and setup requirements |
| `debug.log` | Runtime debug output from the AHK script |

## PowerShell 7 requirement

The `Morning Routine` desktop shortcut (outside the repo) must target `C:\Program Files\PowerShell\7\pwsh.exe`, not `powershell.exe`. `Get-TaskErrors.ps1` has `#Requires -Version 7`; under 5.1 Step 5 fails silently (hidden window). `MorningRoutine.ps1` has a guard that relaunches itself in `pwsh` as a fallback, and keeps `#Requires -Version 5.1` so the guard can run under 5.1.

## External Dependencies

`MorningRoutine.ps1` Step 5 calls `D:\Dropbox\Computing1\BatchFiles_Scripts\PowershellScripts\Get-TaskErrors\Get-TaskErrors.ps1` (lives outside this repo) with `-Open`, which scans scheduled tasks and opens `TaskDashboard.html` (generated alongside that script) in the default browser.
