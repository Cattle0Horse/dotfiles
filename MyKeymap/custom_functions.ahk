; 自定义的函数写在这个文件里,  然后能在 MyKeymap 中调用

; 使用如下写法，来加载当前目录下的其他 AutoHotKey v2 脚本
; #Include ../data/test.ahk

; sendSomeChinese() {
;   Send("{text}你好中文!")
; }

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

; windows 窗口拖拽，不需要将鼠标放到窗口边框上了
; https://fanlumaster.github.io/2025/03/05/use-ahk-v2-to-simulate-kde-s-window-dragging-behavior-on-windows/
