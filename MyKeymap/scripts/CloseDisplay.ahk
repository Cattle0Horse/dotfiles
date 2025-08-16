#Requires AutoHotkey v2.0

; 参考自：https://meta.appinn.net/t/topic/20287/10
; 锁屏并且t毫秒后关闭显示器
lockAndCloseDisplay(t) {
  DllCall("LockWorkStation")
  closeDisplay(t)
}

; t毫秒后关闭显示屏
closeDisplay(t) {
  Sleep(t)
  PostMessage(0x112, 0xF170, 2,,"Program Manager")
}