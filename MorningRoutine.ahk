#NoEnv
#SingleInstance Force
SetWorkingDir, %A_ScriptDir%

; ============================================================
; Morning Routine - GUI Steps
; Steps 2b (registry backup), 3 (restore point), and 4 (Chrome
; update) are handled by MorningRoutine.ps1 before this runs.
; ============================================================

; ----------------------------------------------------------
; Step 1: PhraseExpress — Min starts it minimized; as a tray app it settles into the tray
; ----------------------------------------------------------
Run, "C:\Program Files (x86)\PhraseExpress\phraseexpress.exe",,Min
Sleep, 2000

; ----------------------------------------------------------
; Step 2: Dropbox — omitting /home skips the Dropbox window; starts silently in tray
; ----------------------------------------------------------
Run, "C:\Program Files (x86)\Dropbox\Client\Dropbox.exe"
Sleep, 3000

; ----------------------------------------------------------
; Step 6: Raindrop — opens as a standalone app window (same as
; right-clicking the extension and choosing "Open App").
; Also starts the Chrome process used by later steps.
; ----------------------------------------------------------
Run, "C:\Program Files\Google\Chrome\Application\chrome.exe" --app=https://app.raindrop.io
WinWait, ahk_exe chrome.exe,, 30
Sleep, 3000

; ----------------------------------------------------------
; Step 7: Firefox
; ----------------------------------------------------------
Run, "C:\Program Files\Mozilla Firefox\firefox.exe"
WinWait, ahk_exe firefox.exe,, 30
Sleep, 5000

; ----------------------------------------------------------
; Step 8: Open Tech News page in Firefox
; ----------------------------------------------------------
WinActivate, ahk_exe firefox.exe
Sleep, 1000
Send, ^l
Sleep, 500
Send, https://start.me/p/vjR9QB/tech-news
Send, {Enter}
Sleep, 3000

; ----------------------------------------------------------
; Step 9: TradingView (Windows Store app)
; ----------------------------------------------------------
Run, shell:AppsFolder\TradingView.Desktop_n534cwy3pjxzj!TradingView.Desktop,, UseErrorLevel
Sleep, 5000

; ----------------------------------------------------------
; Step 10: The Advocate in Chrome
; ----------------------------------------------------------
Run, "C:\Program Files\Google\Chrome\Application\chrome.exe" "https://www.theadvocate.com"
Sleep, 2000

; ----------------------------------------------------------
; Step 11: CNN in Chrome
; ----------------------------------------------------------
Run, "C:\Program Files\Google\Chrome\Application\chrome.exe" "https://www.cnn.com"
Sleep, 2000

; ----------------------------------------------------------
; Step 5: Bitwarden via Chrome extension — opened last so the
; popup is not dismissed by subsequent tabs or windows opening.
; REQUIRED SETUP: In Chrome go to chrome://extensions/shortcuts
; and assign a shortcut to "Activate the extension" for Bitwarden
; (e.g. Ctrl+Shift+Y). Update the Send line below to match.
; ----------------------------------------------------------
WinActivate, ahk_exe chrome.exe
Sleep, 500
Send, ^+y

; ----------------------------------------------------------
; Step 12: Open latest UT99 server log
; ----------------------------------------------------------
latestFile := ""
latestTime := ""
Loop, Files, D:\Dropbox\Gaming\UTLogs\ServerLogs\*.*
{
    if (A_LoopFileTimeModified > latestTime) {
        latestTime := A_LoopFileTimeModified
        latestFile := A_LoopFileFullPath
    }
}
if (latestFile != "")
    Run, %latestFile%

; ----------------------------------------------------------
; Step 13: Open latest ChatLog Analyzer report
; ----------------------------------------------------------
latestFile2 := ""
latestTime2 := ""
Loop, Files, D:\Dropbox\Computing1\BatchFiles_Scripts\Claude Projects\UT99\UT99 ChatLog Analyzer\_system\Reports\*.*
{
    if (A_LoopFileTimeModified > latestTime2) {
        latestTime2 := A_LoopFileTimeModified
        latestFile2 := A_LoopFileFullPath
    }
}
if (latestFile2 != "")
    Run, %latestFile2%

; ----------------------------------------------------------
; Step 14: Weight Tracker — open html and link the data directory.
;
; The picker is matched by class+exe, NOT by title: its real title is
; "Select where this site can save changes" — "Select Folder" is only
; the button text, and matching on that silently matched nothing.
;
; Chrome's "allow editing files" permission prompt and the final
; "Open Data File" button are left as a manual click.
; ----------------------------------------------------------
weightDir := "D:\Dropbox\Computing1\BatchFiles_Scripts\Claude Projects\Weight Tracker\"
weightDlg := "ahk_class #32770 ahk_exe chrome.exe"

Run, "C:\Program Files\Google\Chrome\Application\chrome.exe" "%weightDir%weight-tracker.html"
WinWait, ahk_exe chrome.exe,, 30
Sleep, 3000

; Tab to the Browse button and press it
Send, {Tab}
Send, {Tab}
Send, {Enter}

WinWait, %weightDlg%,, 20
if ErrorLevel
{
    ; Most likely cause: Browse is no longer the second tab stop in the
    ; page's storage banner. Report it — a silent skip here means no
    ; tracker with nothing to indicate why.
    LogStep14("FAIL - folder picker never appeared. Browse may no longer be the second tab stop in weight-tracker.html")
    TrayTip, Morning Routine, Weight Tracker: folder picker did not open. See debug.log, 10, 2
}
else
{
    WinActivate, %weightDlg%
    Sleep, 800

    ; Wait until the confirm button is actually interactive. It stays
    ; disabled while the folder view is still populating (slow on a
    ; Dropbox-backed path) and clicks sent before then are dropped
    ; silently — the observed cause of intermittent failures here.
    btnReady := false
    Loop, 20
    {
        ControlGet, btnEnabled, Enabled,, Button1, %weightDlg%
        if (btnEnabled)
        {
            btnReady := true
            break
        }
        Sleep, 250
    }
    if !btnReady
        LogStep14("WARN - Select Folder still disabled after 5s. Trying anyway")

    ; Put the path straight into the "Folder:" field, then confirm by
    ; pressing Enter in that field — ControlClick on the button alone
    ; proved intermittent. The first confirm may only navigate INTO the
    ; folder; if the dialog is still up, clear the field and press again
    ; to select where we now are.
    ControlSetText, Edit1, %weightDir%, %weightDlg%
    Sleep, 400
    ControlFocus, Edit1, %weightDlg%
    Sleep, 200
    ControlSend, Edit1, {Enter}, %weightDlg%
    WinWaitClose, %weightDlg%,, 3

    Loop, 3
    {
        if !WinExist(weightDlg)
            break

        ; Record why the previous confirm did not take, so a future
        ; failure is diagnosable from debug.log alone.
        ControlGetText, curEdit, Edit1, %weightDlg%
        ControlGet, btnEnabled, Enabled,, Button1, %weightDlg%
        LogStep14("retry " . A_Index . " - Edit1=[" . curEdit . "] Button1enabled=" . btnEnabled)

        ; Clear the field so the button selects the folder we are now in
        ; rather than navigating deeper.
        WinActivate, %weightDlg%
        Sleep, 300
        ControlSetText, Edit1, , %weightDlg%
        Sleep, 300

        ; Activate via the keyboard first. ControlClick synthesises a
        ; mouse click at the control and is silently dropped by this
        ; dialog often enough to matter (observed failing 3x in a row
        ; with the button reporting enabled=1). Keep it as a fallback.
        ControlFocus, Button1, %weightDlg%
        Sleep, 200
        ControlSend, Button1, {Space}, %weightDlg%
        WinWaitClose, %weightDlg%,, 3

        if WinExist(weightDlg)
        {
            ControlClick, Button1, %weightDlg%
            WinWaitClose, %weightDlg%,, 3
        }
    }

    ; Wait for the teardown rather than sampling at a fixed delay — a
    ; bare WinExist here reports a false failure when the dialog is just
    ; slow to disappear.
    WinWaitClose, %weightDlg%,, 5

    if WinExist(weightDlg)
    {
        LogStep14("FAIL - picker still open after 4 attempts. Data directory not linked")
        TrayTip, Morning Routine, Weight Tracker: could not select the data folder. See debug.log, 10, 2
    }
    else
        LogStep14("OK - data directory linked")
}

; ----------------------------------------------------------
; Logging helper (also ends the auto-execute section)
; ----------------------------------------------------------
LogStep14(msg)
{
    FormatTime, ts,, yyyy-MM-dd HH:mm:ss
    FileAppend, %ts% Step 14: %msg%`n, %A_ScriptDir%\debug.log
}
