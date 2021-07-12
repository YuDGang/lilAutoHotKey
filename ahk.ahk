;置顶
^SPACE::  Winset, Alwaysontop, , A


;窗口尺寸切换
#/::CycleWindowSize()

FindNextSize(width, height) {
  SizeCandidates := [ [800,600], [1280,800], [593,960] ]
  a := SizeCandidates.MaxIndex()
  Loop %a% {    
    w := SizeCandidates[A_Index][1]
    h := SizeCandidates[A_Index][2]
    if (width == w and height == h) {
      ; got a match, return next in cycle
      i := A_Index + 1
      if (i > SizeCandidates.MaxIndex()) {
        i := 1
      }
      return SizeCandidates[i]
    }
  }
  return SizeCandidates[1] ; return first
}

CycleWindowSize() {
  WinGet, Maximized, MinMax, A
  WinGetPos, x, y, width, height, A
  result := FindNextSize(width,height)
  new_width := result[1]
  new_height := result[2]
  if Maximized {
    WinRestore, A
  }
  flash_text = (%new_width%x%new_height%)
  WinGet, hwnd, ID, A
  WinMove, A, , , , %new_width%, %new_height%
  FlashTitle(hwnd, flash_text)
}

FlashTitle(hwnd, text, prepend=true) {
  global TextCache
  if (TextCache == "") {
    TextCache := Object()
  }
  WinGetTitle, orig_text, ahk_id %hwnd%
  if (TextCache[hwnd] == "") {
    TextCache[hwnd] := orig_text
  }
  orig_text := TextCache[hwnd]
  if (prepend) {
    text = %text% %orig_text%
  }
  WinSetTitle, A,, %text%
  SetTimer, FlashTitleRestore, 1000
}

FlashTitleRestore() {
  global TextCache
  SetTimer, FlashTitleRestore, Off
  for hwnd, orig_text in TextCache {
    WinSetTitle, ahk_id %hwnd%,, %orig_text%
    TextCache.Remove(hwnd)
  }
}


;QuickOpen
#B::run http://www.bilibili.com

#A::run D:\Program\

!N::run, D:\Program Files (x86)\CloudMusic\cloudmusic.exe
!M::run, D:\Program Files (x86)\Tencent\QQMusic\QQMusic.exe
!F::run, C:\Program Files\Mozilla Firefox\firefox.exe


;常用exe的焦点转移或打开
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode 2    

Activate(t)
{
  IfWinActive,%t%
  {
    WinMinimize
    return
  }
  SetTitleMatchMode 2    
  DetectHiddenWindows,on
  IfWinExist,%t%
  {
    WinShow
    WinActivate           
    return 1
  }
  return 0
}

ActivateAndOpen(t,p)
{
  if Activate(t)==0
  {
    Run %p%
    WinActivate
    return
  }
}


;连击热键动作
~Alt::
  if (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 600)
    ActivateAndOpen("Google Chrome","C:\Program Files\Google\Chrome\Application\Chrome.exe")
  return
~LWin::
  if (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 600)
    ActivateAndOpen("Visual Studio Code", "C:\Program Files\Microsoft VS Code\Code.exe")
  return
;TODO
~LCtrl::
  if (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 600)
    ActivateAndOpen("Visual Studio Code", "C:\Program Files\Microsoft VS Code\Code.exe")
  return

;缩写
::/lhg::梁洪刚
::/long::这是一段测试文本，用于测试缩写是否正常显示