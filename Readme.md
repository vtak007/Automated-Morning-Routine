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
| 12 | UT99 server log | Opens the most recently modified file in `D:\Dropbox\Gaming\UTLogs\ServerLogs` |
| 13 | ChatLog Analyzer report | Opens the most recently modified file in the UT99 ChatLog Analyzer's `_system\Reports` folder |
| 14 | Weight Tracker | Opens `weight-tracker.html` in Chrome and links its data directory to `D:\Dropbox\Computing1\BatchFiles_Scripts\Claude Projects\Weight Tracker\` — see the note below on the two manual clicks |

> **Note:** Steps run in the order shown above, not numerically — Bitwarden is triggered last intentionally so the popup is not dismissed by subsequent windows opening.

### Step 14 — Weight Tracker, and why it stops where it does

The script automates the folder picker only. Two clicks are left to you, on purpose:

1. Chrome's **"allow editing files"** permission prompt
2. The page's **"Open Data File"** button

This is deliberate, not an unfinished step. The permission prompt is dismissed on *human* time and the script has no reliable way to detect when it has gone. If it blind-sent keystrokes to click "Open Data File" while that prompt was still up, those keys would land on the prompt — and could hit **"Don't allow"**, silently denying folder access. A silent permission denial is a worse outcome than a manual click.

If the permission prompt *doesn't* appear, nothing breaks — the script never touches it, and Step 14 ends as soon as the picker closes. Its absence simply means the grant is already held. Note that the page runs from `file://`, where Chrome's persistent File System Access grants generally don't apply, so expect the prompt most mornings rather than only once.

**Implementation note:** the folder picker is matched by `ahk_class #32770 ahk_exe chrome.exe`, **not** by title. Its real window title is `Select where this site can save changes` — `Select Folder` is only the *button* text. Matching on `Select Folder` matches nothing, and because a failed `WinWait` lets the script continue, that failure is silent: `ControlClick` becomes a no-op and `WinGetPos` returns blank coordinates. The path is typed straight into the `Folder:` field (`Edit1`) rather than the address bar; the first press of `Button1` may only navigate *into* the folder, so the script clears the field and presses again (up to 3 times) to select the folder it is now in.

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
