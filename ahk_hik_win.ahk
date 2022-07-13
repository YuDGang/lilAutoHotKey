; 按键已被重新映射(注册表)：
; LCtrl == LWin(#)
; LWin == Option(LAlt !)
; LAlt == Command(LCtrl ^)

;<Mac Command-Tab/>
LCtrl & Tab::AltTab

;<Mac Ctrl+C/>
;Terminal中的终止命令
>#C::^C

;<Mac window>
;最小化
^m:: WinMinimize, A
;最大化
^#f:: 
  WinGet, OutputVar, MinMax, A
  if(OutputVar = 1)
    WinRestore, A
  else
    WinMaximize, A
  return
;退出
^q:: WinClose, A
;</Mac window>

;<Mac page>
;页面刷新
^r::Send {F5}
#+Tab::Send ^{PgUp}
#Tab::Send ^{PgDn}
;</Mac page>

;<Mac text>
;选择文字    
; ^,::Send ^+{Left}    
; ^.::Send ^+{Right}    return   
;选择文字 从当前位置到行首行末 
^+Left::Send +{Home}    
^+Right::Send +{End}   
;跳转光标 行首行末 页首页末
^Left::Send {Home}
^Right::Send {End}
^Up::Home
^Down::End
;Option + jkli 映射方向键
; !j:: Send {left}
; !l:: Send {right}
; !i:: Send {up}
; !k:: Send {down}
;</Mac text>

;<Mac CapsLock>
;轻击 中英文切换 长按 大小写切换
Capslock::
	KeyWait, CapsLock
	if (A_TimeSinceThisHotkey > 300)
		SetTimer, switchState, -1
	else
    SetCapsLockState Off
		Send {Shift}
  return

switchState:
  SetCapsLockState % !GetKeyState("CapsLock", "T")
	
;</Mac CapsLock>


;<New Func>
;窗口置顶
#SPACE:: Winset, Alwaysontop, , A


;窗口尺寸切换
>^/::CycleWindowSize()

FindNextSize(width, height) {
  SizeCandidates := [ [800,600], [1280,800], [593,880] ]
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


;<常用exe的焦点转移或打开>
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode 2    

Activate(t)
{
  IfWinActive, %t%
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

;QuickOpen
#B::run http://www.bilibili.com
#E::run D:\Proj\
!D::ActivateAndOpen("钉钉", "C:\Program Files (x86)\DingDing\main\current\DingTalk.exe")

;连击热键快捷键
~LCtrl Up::
  if (GetKeyState(LCtrl [P]) != 1 && A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)
    ActivateAndOpen("Google Chrome","C:\Program Files\Google\Chrome\Application\Chrome.exe")
  return
~LAlt Up::
  if (GetKeyState(LAlt [P]) != 1 && A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 200)
    ActivateAndOpen("Visual Studio Code", "C:\Program Files\Microsoft VS Code\Code.exe")
  return
~LWin Up::
  if (GetKeyState(LWin [P]) != 1 && A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 600)
    ActivateAndOpen("Tabby", "C:\Program Files\Tabby\Tabby.exe --cd=D:\Proj")
  return
;</常用exe的焦点转移或打开>


;缩写
::/lhg::梁洪刚
::/long::这是一段测试文本，用于测试缩写是否正常显示
::/rai::// {#} request & init
::/dpcat::npm run build:deploy; cat dist/public/version.txt
;</New Func>