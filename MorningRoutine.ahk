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
