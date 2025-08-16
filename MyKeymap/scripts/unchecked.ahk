; 自定义的函数写在这个文件里,  然后能在 MyKeymap 中调用
; 使用如下写法，来加载当前目录下的其他 AutoHotKey v2 脚本
; #Include ../data/test.ahk

; #Requires AutoHotkey v2.0

; 定义全局变量用于控制提示窗口
global MyGui
global currentHandlerIndex := 1  ; 新增全局变量用于记录当前模式

ShowToolTip(message, x?, y?) {  ; 使用可选参数语法
    try {
        ; 设置坐标系为屏幕坐标
        CoordMode "Caret", "Screen"
        
        ; v2 正确获取方式
        CaretGetPos(&caretX, &caretY)  ; 通过引用传递参数
        
        x := caretX
        y := caretY+50
        
    } catch as e {
        x := A_ScreenWidth // 2
        y := 0
    }

    ; GUI 创建部分保持不变
    myGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    myGui.BackColor := "FF7F53"
    WinSetTransparent(255, myGui.Hwnd)
    myGui.SetFont("s12", "微软雅黑")
    myGui.MarginX := 5  ; 左右边距
    myGui.MarginY := 5   ; 上下边距
    myGui.Add("Text", "h25 Center", message)  ; 固定高并居中
    myGui.Show("x" x " y" y " NoActivate")
    
    SetTimer(() => myGui.Destroy(), 500)
}


; 循环切换函数小英，中文，大写，T代表在1-T之间切换；如果需要改为
CycleHandlers(T) {
    global currentHandlerIndex
    Switch currentHandlerIndex {
        Case 1:
            LShiftHandler()
        Case 2:
            RShiftHandler()
        Case 3:
            CapsLockHandler()
    }
    currentHandlerIndex := Mod(currentHandlerIndex, T) + 1  ; 在1-T之间循环
}

; 右Shift键处理函数
RShiftHandler() {
    ; 长按逻辑
    static longPressThreshold := 250  ;
    keyDownTime := A_TickCount

    ; 保持原有~LShift热键特性
    KeyWait "RShift"
    duration := A_TickCount - keyDownTime

    ; 长按逻辑（保持当前输入法）
    if (duration >= longPressThreshold) {
        if isEnglishMode() {
            ; ShowToolTip("aa")  ; 英文长按提示
        } else {
            ; ShowToolTip("中")  ; 中文长按提示
        }
        return
    }
    ; 短按逻辑
    if GetKeyState("CapsLock", "T") {
        SetCapsLockState 0
    }
    if isEnglishMode() {   ; 当前为英文时切换
        Send "^{Space}"
    }
    ShowToolTip("中")
}

; 左Shift键处理函数
; 英文 → 长按LShift，保持英文，不执行后续操作
; 中文→ 长按LShift，保持中文，不执行后续操作
; 中文 → 短按LShift，切英文
; 英文 → 短按LShift，英文
LShiftHandler() {
    ; 长按逻辑
    static longPressThreshold := 250  ;
    keyDownTime := A_TickCount

    ; 保持原有~LShift热键特性
    KeyWait "LShift"
    duration := A_TickCount - keyDownTime

    ; 长按逻辑（保持当前输入法）
    if (duration >= longPressThreshold) {
        if isEnglishMode() {
            ; ShowToolTip("aa")  ; 英文长按提示
        } else {
            ; ShowToolTip("中")  ; 中文长按提示
        }
        return
    }
    ; 短按逻辑
    if GetKeyState("CapsLock", "T") {
        SetCapsLockState 0
        if !isEnglishMode() {
            Send "^{Space}"
        }
    } else {
        if !isEnglishMode() {
            Send "^{Space}"
        }
    }
    ShowToolTip("aa")
}

; CapsLock键处理函数
CapsLockHandler() {
    if GetKeyState("CapsLock", "T") {
        SetCapsLockState 0
        if !isEnglishMode() {  ; 关闭CapsLock时强制切英文
            Send "^{Space}"
            ShowToolTip("aa")
        }
    } else {
        SetCapsLockState 1
        ShowToolTip("AA")
    }
}


isEnglishMode() {
    static IMC_GETCONVERSIONMODE := 0x001
    static WM_IME_CONTROL := 0x0283

    try {
        ; 启用隐藏窗口检测
        originalState := A_DetectHiddenWindows
        DetectHiddenWindows true

        ; 获取活动窗口句柄
        if !(hWnd := WinExist("A")) {
            throw Error("窗口句柄获取失败", -1)
        }

        ; 获取输入法窗口句柄
        if !(imeWnd := DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", hWnd, "Uint")) {
            throw Error("输入法窗口未找到", -2)
        }

        ; 发送控制消息
        result := SendMessage(
            WM_IME_CONTROL,
            IMC_GETCONVERSIONMODE,
            0,
            ,
            "ahk_id " imeWnd
        )

        return result == 0  ; 0=英文模式
    }
    catch as e {
        ; 显示错误提示（调试用）
        ToolTip "输入法检测错误: " e.Message
        SetTimer () => ToolTip(), -1000
        
        ; 安全返回值
        return true  ; 默认英文模式
    }
    finally {
        ; 恢复窗口检测状态
        DetectHiddenWindows originalState
    }
}


;-------------------------切换虚拟桌面-------------------------------------------------------------------
; 切换虚拟桌面的独立函数
SwitchVirtualDesktop() {
    static pressed := false           ; 静态变量保存切换状态
    pressed := !pressed               ; 每次调用翻转状态
    
    ; 根据状态发送不同的组合键
    if pressed {
        Send("^#{Right}")             ; 切换到右侧虚拟桌面
    } else {
        Send("^#{Left}")              ; 切换到左侧虚拟桌面
    }
    
}



; #Tab:: {  ; Win+Tab 热键切换两个窗口
;     static pressed := false          ; 静态变量保存状态
;     pressed := !pressed             ; 切换状态
;     if (pressed) {
;         Send("^#{Right}")           ; 切换到右侧虚拟桌面
;     } else {
;         Send("^#{Left}")            ; 切换到左侧虚拟桌面
;     }
; }


;--------------------所有窗口最大化和最小化（设置全局设置DetectHiddenWindows True的时候有冲突）------------------------------------------------------

; 切换最小化和还原所有窗口（排除 Rainmeter）
ToggleMinimizeAll() {
    static isMinimized := false
    if (isMinimized) {
        RestoreAllWindows()
        isMinimized := false
    } else {
        MinimizeAllWindows()
        isMinimized := true
    }
}

; 最小化所有窗口（排除 Rainmeter）
MinimizeAllWindows() {
  windows := WinGetList()
  for id in windows {
    try {  ; 防止无效窗口导致崩溃
      processName := WinGetProcessName(id)
      if (processName != "Rainmeter.exe") {
        WinMinimize(id)
      }
    }
  }
}

; 还原所有最小化窗口（排除 Rainmeter）
RestoreAllWindows() {
  windows := WinGetList()
  for id in windows {
    try {
      ; 先检查窗口是否存在，避免无效句柄
      if !WinExist("ahk_id " id)
        continue
      
      ; 排除 Rainmeter 进程
      processName := WinGetProcessName(id)
      if (processName == "Rainmeter.exe")
        continue
      
      ; 获取窗口状态（关键修正点）
      minMaxState := WinGetMinMax(id)
      
      ; AHK 中最小化状态值为 -1，最大化是 1，正常是 0
      if (minMaxState == -1) {
        WinRestore(id)
        ; 可选：激活窗口确保还原（部分系统需要）
        ; WinActivate(id)
      }
    } catch Error {
      ; 捕获异常（例如权限问题）
      continue
    }
  }
}



;--------------------窗口调整循环切换位置------------------------------------------------------
; ;函数切换windowtop，windowbottom，windowleft，windowright
; ; 窗口位置配置中心（默认参数）
global WindowPositions := {
    top:    { width: 2560, height: 460 },
    bottom: { width: 2560, height: 460 },
    left:   { width: 870, height: 1440 },
    right:  { width: 870, height: 1440 }
}

ToggleWindowPosition(params := "") {
    static state := 0
    state := Mod(state, 5) + 1
    
    ; 合并全局配置与自定义参数
    config := MergeConfig(WindowPositions.Clone(), params)
    
    switch state {
        case 1:
            windowtop(config.top.width, config.top.height)
        case 2:
            windowbottom(config.bottom.width, config.bottom.height)
        case 3:
            windowleft(config.left.width, config.left.height)
        case 4:
            windowright(config.right.width, config.right.height)
        case 5:
            MaximizeWindows()
    }
}

; 配置合并函数
MergeConfig(base, extend) {
    if !IsObject(extend)
        return base
    for k, v in extend {
        if IsObject(v) && base.HasKey(k)
            base[k] := MergeConfig(base[k], v)
        else
            base[k] := v
    }
    return base
}



; 调整窗口大小并定位到屏幕顶部（任务栏下方）且水平居中
windowtop(width, height) {
  if NotActiveWin() {
    return
  }

  DllCall("SetThreadDpiAwarenessContext", "ptr", -1, "ptr")

  WinExist("A")
  if (WindowMaxOrMin())
    WinRestore

  WinGetPos(&x, &y, &w, &h)

  ms := GetMonitorAt(x + w / 2, y + h / 2)
  MonitorGetWorkArea(ms, &l, &t, &r, &b)
  w := r - l   ; 工作区宽度
  h := b - t   ; 工作区高度

  ; 计算窗口尺寸（不超过工作区）
  winW := Min(width, w+20)
  winH := Min(height, h)
  
  ; 水平居中，顶部对齐
  winX := l + (w - winW) / 2
  winY := t  ; 关键修改：从工作区顶部开始定位

  WinMove(winX, winY, winW, winH)
  DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
  ; SetWindowTopMost()
}

; 将当前窗口调整至显示器底部并水平居中显示
windowbottom(width, height) {
    ; 检查当前是否有活动窗口，没有则直接返回
    if NotActiveWin() {
        return
    }

    ; 设置DPI感知模式为UNAWARE（-1），让系统自动处理缩放
    ; 当执行窗口移动操作时，即使指定固定像素尺寸，系统会自动适配显示器缩放比例
    DllCall("SetThreadDpiAwarenessContext", "ptr", -1, "ptr")

    ; 确保操作对象是当前活动窗口
    WinExist("A")
    
    ; 如果窗口处于最大化/最小化状态，先恢复窗口
    if (WindowMaxOrMin())
        WinRestore

    ; 获取窗口当前位置和尺寸（&表示输出变量）
    WinGetPos(&x, &y, &w, &h)

    ; 根据窗口中心点坐标获取所在显示器序号
    ms := GetMonitorAt(x + w / 2, y + h / 2)
    ; 获取该显示器的工作区域坐标（排除任务栏等区域）
    MonitorGetWorkArea(ms, &l, &t, &r, &b)
    w := r - l ; 计算工作区实际可用宽度
    h := b - t ; 计算工作区实际可用高度

    ; 计算最终窗口尺寸（不超过显示器工作区大小）
    winW := Min(width, w+20)    ; 取期望宽度与最大可用宽度的较小值
    winH := Min(height, h)   ; 取期望高度与最大可用高度的较小值
    
    ; 计算窗口位置（水平居中 + 底部对齐）
    winX := l + (w - winW) / 2  ; 水平居中：左边界 + (可用宽度-窗口宽度)/2
    winY := b - winH            ; 垂直底部：工作区下边界 - 窗口高度

    ; 移动窗口到计算位置（使用新的尺寸）
    WinMove(winX, winY, winW, winH)
    
    ; 还原DPI感知模式为PER_MONITOR_AWARE（-3），确保鼠标移动等操作精准
    DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
    
    ; 设置窗口置顶状态（根据之前的配置）
    ; SetWindowTopMost()
}

; 调整窗口大小并定位到屏幕左侧（垂直居中）
windowleft(width, height) {
  if NotActiveWin() {
    return
  }

  DllCall("SetThreadDpiAwarenessContext", "ptr", -1, "ptr")

  WinExist("A")
  if (WindowMaxOrMin())
    WinRestore

  WinGetPos(&x, &y, &w, &h)

  ms := GetMonitorAt(x + w / 2, y + h / 2)
  MonitorGetWorkArea(ms, &l, &t, &r, &b)
  w := r - l   ; 工作区宽度
  h := b - t   ; 工作区高度

  ; 计算窗口尺寸（不超过工作区）
  winW := Min(width, w)
  winH := Min(height, h)
  
  ; 左侧对齐，垂直居中
  winX := l-10               ; 关键修改：从工作区左侧开始
  winY := t + (h - winH) / 2  ; 垂直居中计算

  WinMove(winX, winY, winW, winH)
  DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
  ; SetWindowTopMost()
}

; 调整窗口大小并定位到屏幕右侧（垂直居中）

windowright(width, height) {
  if NotActiveWin() {
    return
  }

  DllCall("SetThreadDpiAwarenessContext", "ptr", -1, "ptr")

  WinExist("A")
  if (WindowMaxOrMin())
    WinRestore

  WinGetPos(&x, &y, &w, &h)

  ms := GetMonitorAt(x + w / 2, y + h / 2)
  MonitorGetWorkArea(ms, &l, &t, &r, &b)
  w := r - l   ; 工作区宽度
  h := b - t   ; 工作区高度

  ; 计算窗口尺寸（不超过工作区）
  winW := Min(width, w)
  winH := Min(height, h)
  
  ; 右侧对齐，垂直居中
  winX := r - winW +10          ; 关键修改：从工作区右侧向左计算
  winY := t + (h - winH) / 2  ; 垂直居中计算

  WinMove(winX, winY, winW, winH)
  DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
  ; SetWindowTopMost()
}

; 窗口最大化
MaximizeWindows() {
  if NotActiveWin() {
    return
  }

  if WindowMaxOrMin() {
    WinRestore("A")
    ; SetWindowTopMost()
  } else {
    WinMaximize("A")
    ; UnsetWindowTopMost()
  }
}

; 置顶窗口函数 
SetWindowTopMost() {
    WinSetAlwaysOnTop(true, "A")
    if (WinGetExStyle("A") & 0x8) {  ; 状态校验 
        Tip(Translation().always_on_top_on)
        ; 可扩展功能点：记录置顶日志/触发声音反馈 
    }
}
 
; 取消置顶函数 
UnsetWindowTopMost() {
    WinSetAlwaysOnTop(false, "A")
    if !(WinGetExStyle("A") & 0x8) {  ; 状态校验 
        Tip(Translation().always_on_top_off)
        ; 可扩展功能点：窗口位置复位/透明度重置 
    }
}