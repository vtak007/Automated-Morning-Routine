# Automated Morning Routine

An automated startup sequence that runs system maintenance tasks and launches all daily-use applications in the correct order. Triggered by running `MorningRoutine.ps1`.

---

## How it works

The routine runs in two stages that execute in parallel:

**Stage 1 — `MorningRoutine.ps1`** (runs first, requires Administrator)
Updates Chrome via `winget`, then launches the AHK script, then handles remaining system-level tasks in the background.

**Stage 2 — `MorningRoutine.ahk`** (launched immediately by the PS1)
Handles all GUI automation — launching applications and navigating to pages.

---

## Running it

Right-click `MorningRoutine.ps1` → **Run with PowerShell**. It self-elevates to Administrator if needed, launches the AHK script immediately, then runs the system tasks in parallel in the background.

---

## Steps

### Stage 1 — PowerShell (system tasks)

| Step | Action | Detail |
|---|---|---|
| 2b | Registry backup | Full registry export saved to `D:\Dropbox\Computing1\MySystems\Backups\Registry Backups\Registry_YYYY-MM-DD.reg` |
| 3 | System restore point | Creates a "Morning Routine" restore point via `Checkpoint-Computer` |
| 4 | Chrome update | Runs `winget upgrade --id Google.Chrome --silent` before AHK launches Chrome |

### Stage 2 — AutoHotkey (app launches)

| Step | Action | Detail |
|---|---|---|
| 1 | PhraseExpress | Launched minimized; settles into the system tray |
| 2 | Dropbox | Launched silently into the system tray |
| 5 | Bitwarden | Opened last via Chrome extension shortcut (Ctrl+Shift+Y) so the popup isn't dismissed by later steps |
| 6 | Raindrop | Opened as a standalone Chrome app window |
| 7 | Firefox | Launched and waited on |
| 8 | Tech News | Navigates Firefox to the Start.me tech news page |
| 9 | TradingView | Launched from the Windows Store app folder |
| 10 | The Advocate | Opened in Chrome (`theadvocate.com`) |
| 11 | CNN | Opened in Chrome (`cnn.com`) |

> **Note:** Steps run in the order shown above, not numerically — Bitwarden is triggered last intentionally so the popup is not dismissed by subsequent windows opening.

---

## Setup requirement

Bitwarden is opened via a Chrome keyboard shortcut. Before first use:

1. In Chrome, go to `chrome://extensions/shortcuts`
2. Find **Bitwarden** and assign a shortcut to *Activate the extension* (the script uses `Ctrl+Shift+Y`)
3. If you use a different shortcut, update the `Send, ^+y` line in `MorningRoutine.ahk` to match

---

## Files

| File | Purpose |
|---|---|
| `MorningRoutine.ps1` | Entry point — runs system tasks (admin), then launches the AHK script |
| `MorningRoutine.ahk` | GUI automation — launches all daily-use applications |
| `debug.log` | Runtime debug output written by the AHK script |
