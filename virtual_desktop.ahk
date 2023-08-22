;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SETUP STUFF ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#SETUP START
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force
ListLines Off
SetBatchLines -1
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
#KeyHistory 0
#WinActivateForce

Process, Priority,, H

SetWinDelay -1
SetControlDelay -1

;include the Virtual desktop library
#Include VD.ahk

;you should WinHide invisible programs that have a window.
WinHide, % "Malwarebytes Tray Application"
;#SETUP END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;; CHECK IF ARRAY HAS A VALUE  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
HasVal(haystack, needle) {
  ; nothing in array
	if !(IsObject(haystack)) || (haystack.Length() = 0)
		return 0
  
  ; checks for the needle in the haystack
	for index, value in haystack
		if (value = needle)
			return index
  
  ; returns 0 if it was not found
	return 0
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; WRITE TO THE SCREEN  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
close_gui()
{
 Gui, mygui:Destroy
}

Write_to_screen(workspace_number)
{
  Gui, mygui:new
  Gui, -Caption +AlwaysOnTop
  Gui, Font, s50 w700 q4, Arial
  Gui, Color, White
  Gui, Margin, 10, 5
  Gui, Add, Text, Center, %workspace_number%
  Gui, Show,NA
  SetTimer, close_gui, -200
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;; SETTING UP THE ROWS AND COLMNS ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NUM_OF_ROWS := 4
NUM_OF_COLMS := 3
NUMBER_OF_WORKSPACES:= NUM_OF_ROWS * NUM_OF_COLMS
LEFT_BORDER := []
RIGHT_BORDER := []
TOP_BORDER := []
BOTTOM_BORDER := []

; create the left border array
LEFT_BORDER[1] := 1
index := 2
workspace := 1
while ( (workspace + NUM_OF_COLMS) <= NUMBER_OF_WORKSPACES){
  LEFT_BORDER[index] := (workspace + NUM_OF_COLMS)
  workspace := (workspace + NUM_OF_COLMS)
  index++
}

; create the right border array
RIGHT_BORDER[1] := NUM_OF_COLMS
index := 2
workspace := NUM_OF_COLMS
while ( (workspace + NUM_OF_COLMS) <= NUMBER_OF_WORKSPACES){
  RIGHT_BORDER[index] := (workspace + NUM_OF_COLMS)
  workspace := (workspace + NUM_OF_COLMS)
  index++
}

; create the top border array
TOP_BORDER[1] := 1
index := 2
workspace := 1
while( (workspace + 1) <= NUM_OF_COLMS){
  TOP_BORDER[index] := (workspace + 1)
  workspace := (workspace + 1)
  index++
}

; create the bottom border array
BOTTOM_BORDER[1] := (NUMBER_OF_WORKSPACES - (NUM_OF_COLMS-1))
index := 2
workspace := (NUMBER_OF_WORKSPACES - (NUM_OF_COLMS-1))
while( (workspace + 1) <= NUMBER_OF_WORKSPACES){
  BOTTOM_BORDER[index] := (workspace + 1)
  workspace := (workspace + 1)
  index++
}

; Create enough virtual desktops
VD.createUntil(NUMBER_OF_WORKSPACES)

return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;; MOVE UP,DOWN & LEFT,RIGHT ;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;  GO UP ;;;;; 
!k::
current_desktop_num := VD.getCurrentDesktopNum()
request_desktop_num := ( current_desktop_num - (NUM_OF_COLMS) )
if HasVal(TOP_BORDER, current_desktop_num){
  Write_to_screen(current_desktop_num)
}
else{
  VD.goToDesktopNum(request_desktop_num)
  Write_to_screen(request_desktop_num)
}
Return


; go down
!j::
current_desktop_num := VD.getCurrentDesktopNum()
request_desktop_num := ( current_desktop_num + (NUM_OF_COLMS) )
if HasVal(BOTTOM_BORDER, current_desktop_num){
  Write_to_screen(current_desktop_num)
}
else{
  VD.goToDesktopNum(request_desktop_num)
  Write_to_screen(request_desktop_num)
}
Return

; go left
!h::
current_desktop_num := VD.getCurrentDesktopNum()
request_desktop_num := ( current_desktop_num - 1 )
if HasVal(LEFT_BORDER, current_desktop_num){
  Write_to_screen(current_desktop_num)
}
else{
  VD.goToDesktopNum(request_desktop_num)
  Write_to_screen(request_desktop_num)
}
Return


; go right
!l::
current_desktop_num := VD.getCurrentDesktopNum()
request_desktop_num := ( current_desktop_num + 1 )
if HasVal(RIGHT_BORDER, current_desktop_num){
  Write_to_screen(current_desktop_num)
}
else{
  VD.goToDesktopNum(request_desktop_num)
  Write_to_screen(request_desktop_num)
}
Return


; show the current window number
!space::
current_desktop_num := VD.getCurrentDesktopNum()
Write_to_screen(current_desktop_num)
Return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;; MOVE CURRENT WINDOW ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; move active window to the left
!+H::
current_desktop_num := VD.getCurrentDesktopNum()
request_desktop_num := ( current_desktop_num - 1 )
if HasVal(LEFT_BORDER, current_desktop_num){
  Write_to_screen(current_desktop_num)
}
else{
  VD.MoveWindowToDesktopNum("A",request_desktop_num)
  VD.goToDesktopNum(request_desktop_num)
  WinActivate, "A"
  Write_to_screen(request_desktop_num)
}
Return

; move active window to the right
!+L::
current_desktop_num := VD.getCurrentDesktopNum()
request_desktop_num := ( current_desktop_num + 1 )
if HasVal(RIGHT_BORDER, current_desktop_num){
  Write_to_screen(current_desktop_num)
}
else{
  VD.MoveWindowToDesktopNum("A",request_desktop_num)
  VD.goToDesktopNum(request_desktop_num)
  WinActivate, "A"
  Write_to_screen(request_desktop_num)
}
Return

; move active window up
!+K::
current_desktop_num := VD.getCurrentDesktopNum()
request_desktop_num := ( current_desktop_num - NUM_OF_COLMS )
if HasVal(TOP_BORDER, current_desktop_num){
  Write_to_screen(current_desktop_num)
}
else{
  VD.MoveWindowToDesktopNum("A",request_desktop_num)
  VD.goToDesktopNum(request_desktop_num)
  WinActivate, "A"
  Write_to_screen(request_desktop_num)
}
Return

; move active window down
!+J::
current_desktop_num := VD.getCurrentDesktopNum()
request_desktop_num := ( current_desktop_num + NUM_OF_COLMS )
if HasVal(BOTTOM_BORDER, current_desktop_num){
  Write_to_screen(current_desktop_num)
}
else{
  VD.MoveWindowToDesktopNum("A",request_desktop_num)
  VD.goToDesktopNum(request_desktop_num)
  WinActivate, "A"
  Write_to_screen(request_desktop_num)
}
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MOVE TO ROW # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
!1::
row_num := 1
desired_num := ( 1 +  ( (row_num-1) *  NUM_OF_COLMS )   )
if (desired_num <= NUMBER_OF_WORKSPACES) {
  VD.goToDesktopNum(desired_num)
  ; Write_to_screen(desired_num)
  Write_to_screen("Email and Teams")
}
Return

!2::
row_num := 2
desired_num := ( 1 +  ( (row_num-1) *  NUM_OF_COLMS )   )
if (desired_num <= NUMBER_OF_WORKSPACES) {
  VD.goToDesktopNum(desired_num)
  Write_to_screen(desired_num)
}
Return

!3::
row_num := 3
desired_num := ( 1 +  ( (row_num-1) *  NUM_OF_COLMS )   )
if (desired_num <= NUMBER_OF_WORKSPACES) {
  VD.goToDesktopNum(desired_num)
  Write_to_screen(desired_num)
}
Return

!4::
row_num := 4
desired_num := ( 1 +  ( (row_num-1) *  NUM_OF_COLMS )   )
if (desired_num <= NUMBER_OF_WORKSPACES) {
  VD.goToDesktopNum(desired_num)
  ; Write_to_screen(desired_num)
  Write_to_screen("Viciniti")
}
Return

!5::
row_num := 5
desired_num := ( 1 +  ( (row_num-1) *  NUM_OF_COLMS )   )
if (desired_num <= NUMBER_OF_WORKSPACES) {
  VD.goToDesktopNum(desired_num)
  Write_to_screen(desired_num)
}
else{
  Write_to_screen("Not enough workspaces")
}
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; MOVE SPECIFIC WINDOW TO CURRENT DESKTOP  ;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; bring the onenote to the current desktop
!z::
VD.MoveWindowToCurrentDesktop("OneNote", activateYourWindow:=true)
Write_to_screen(VD.getCurrentDesktopNum())
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; MOVE SPECIFIC WINDOW TO SPECIFIC DESKTOP  ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; bring the onenote to the current desktop
; !z::
; VD.MoveWindowToCurrentDesktop("OneNote", activateYourWindow:=true)
; Write_to_screen(VD.getCurrentDesktopNum())
; Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





























;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Miscellaneous ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Bring up overview
!o::SendInput #{Tab}
return

; Minimize current window
;!n::SendInput #{Down}
;return

; Maximize the current window
!m::SendInput #{Up}
return

; Caps lock, to switch windows
CapsLock::
SendInput, !{Tab}
return

; Go to the prev window
!CapsLock:: 
SendInput, !+{Tab}
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;; Replicate Home/End keys ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Swap page down for Home
PgDn::
SendInput, {Home}
return

; Swap page down for Home
+PgDn::
SendInput, +{Home}
return