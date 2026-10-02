# Automated Morning Routine — Project Memory

Persistent notes for this project. Read at the start of every session.
See `CLAUDE.md` for project-specific details.

## CONFIRMED ROOT CAUSES

- 2026-09-24 — Get-TaskErrors dashboard "didn't open": it did — `Start-Process` on the HTML file succeeded and Chrome opened a tab for it (confirmed via matching file-write and process-creation timestamps), but the tab opened without focus (Windows foreground-lock: a background process can't steal focus) and landed unnoticed behind other windows opened by later routine steps. Not a script failure.

- 2026-10-02 — Dashboard not regenerated 9/25–10/1: the `Morning Routine.lnk` shortcut launched `MorningRoutine.ps1` with Windows PowerShell 5.1 (`powershell.exe`). Already elevated, so the script never self-elevated to `pwsh`, and Step 5 failed with `ScriptRequiresUnmatchedPSVersion` (`Get-TaskErrors.ps1` has `#Requires -Version 7`). Error was invisible (hidden window); found via `Start-Transcript`. Manual tests worked because they ran under `pwsh`. Fixed by a PS7 relaunch guard in the script plus retargeting the shortcut to `pwsh.exe`; confirmed by the user's run.

## RULED-OUT THEORIES

- 2026-09-30 — "Dashboard not appearing" is NOT the Get-TaskErrors script, elevation, `-Open`/foreground code, AHK, or the Desktop shortcut. Verified by running, elevated with transcripts: Step 5 alone, Step 5 with `-Open`, and Steps 2b+3+5 in sequence (scratchpad copy minus winget/AHK launch) — all wrote and opened the dashboard. AHK has no code that closes/kills PowerShell. `Morning Routine.lnk` targets the correct `.ps1`; `MorningRoutine.ahk.lnk` on the Desktop is stale (target `Desktop\MorningRoutine.ahk` missing).

## OPEN INVESTIGATIONS

- (none)

## PROJECT CONVENTIONS

- (none recorded yet)

## CHANGE LOG

Newest first. Format: `- YYYY-MM-DD — what changed`.

- 2026-10-02 — `MorningRoutine.ps1` now relaunches itself under PowerShell 7 when started in 5.1; `Morning Routine.lnk` retargeted to `pwsh.exe`. Fixes Step 5 dashboard never regenerating. Docs updated.
- 2026-09-24 — Fixed Get-TaskErrors.ps1 (external script) to force its dashboard window to the foreground after opening, via a P/Invoke window-title search + SetForegroundWindow, since it previously opened silently behind other windows.
- 2026-08-02 — Added MEMORY.md (standard project structure).
