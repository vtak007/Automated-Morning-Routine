# Automated Morning Routine — Project Instructions

## Key Files

| File | Purpose |
|---|---|
| `MorningRoutine.ps1` | Entry point — updates Chrome via winget, launches AHK, then runs system tasks (admin) in parallel |
| `MorningRoutine.ahk` | GUI automation — launches all daily-use applications |
| `Readme.md` | Project readme — describes all steps and setup requirements |
| `debug.log` | Runtime debug output from the AHK script |

## External Dependencies

`MorningRoutine.ps1` Step 5 calls `D:\Dropbox\Computing1\BatchFiles_Scripts\PowershellScripts\Get-TaskErrors\Get-TaskErrors.ps1` (lives outside this repo) with `-Open`, which scans scheduled tasks and opens `TaskDashboard.html` (generated alongside that script) in the default browser.
