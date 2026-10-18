-- CHUPPY HUB V5 — Mobile (menu nhỏ, bay chuẩn, farm đánh được, Fishing + Elite)
-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐾 CHUPPY HUB V2 — PART 1/10: UI LIBRARY
-- Phiên bản sạch: IIFE scope · không return giữa file · export qua getgenv()
-- ═══════════════════════════════════════════════════════════════════════════════
(function()

-- ═══════════════════════════════════════════════════════════════════════════════
-- [1.0] SERVICES
-- ═══════════════════════════════════════════════════════════════════════════════
local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local UIS          = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui      = game:GetService("CoreGui")
local LP           = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════════════════════════
-- [1.1] THEME — Bảng màu & config
-- ═══════════════════════════════════════════════════════════════════════════════
local Theme = {
    Background     = Color3.fromRGB(12, 13, 18),
    Surface        = Color3.fromRGB(20, 22, 30),
    Surface2       = Color3.fromRGB(28, 30, 40),
    Surface3       = Color3.fromRGB(36, 38, 50),
    SurfaceDeep    = Color3.fromRGB(8, 9, 13),

    Border         = Color3.fromRGB(40, 42, 55),
    BorderLight    = Color3.fromRGB(55, 58, 75),

    Accent         = Color3.fromRGB(0, 190, 255),
    AccentDim      = Color3.fromRGB(0, 90, 130),
    AccentGlow     = Color3.fromRGB(80, 220, 255),

    Success        = Color3.fromRGB(0, 220, 130),
    SuccessDark    = Color3.fromRGB(0, 60, 35),
    Warning        = Color3.fromRGB(255, 180, 50),
    WarningDark    = Color3.fromRGB(80, 50, 10),
    Danger         = Color3.fromRGB(255, 75, 95),
    DangerDark     = Color3.fromRGB(80, 20, 28),
    Info           = Color3.fromRGB(100, 160, 255),

    Text           = Color3.fromRGB(240, 242, 248),
    TextBright     = Color3.fromRGB(255, 255, 255),
    TextDim        = Color3.fromRGB(150, 158, 175),
    TextMuted      = Color3.fromRGB(90, 96, 115),

    Radius         = UDim.new(0, 8),
    RadiusSmall    = UDim.new(0, 6),
    RadiusTiny     = UDim.new(0, 4),
    RadiusLarge    = UDim.new(0, 12),
    RadiusXL       = UDim.new(0, 16),
    RadiusFull     = UDim.new(1, 0),

    AnimInstant    = TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    AnimFast       = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    AnimNormal     = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    AnimSmooth     = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    AnimSpring     = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),

    FontBlack      = Enum.Font.GothamBlack,
    FontBold       = Enum.Font.GothamBold,
    FontMedium     = Enum.Font.GothamMedium,
    FontRegular    = Enum.Font.Gotham,
    FontMono       = Enum.Font.Code,

    SizeSmall      = 10,
    SizeNormal     = 11,
    SizeMedium     = 12,
    SizeTitle      = 14,
    SizeHeader     = 16,
}
getgenv().ChuppyTheme = Theme

-- ═══════════════════════════════════════════════════════════════════════════════
-- [1.2] HELPERS
-- ═══════════════════════════════════════════════════════════════════════════════
local function New(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            pcall(function() obj[k] = v end)
        end
    end
    if parent then obj.Parent = parent end
    return obj
end

local function Corner(radius, parent)
    return New("UICorner", { CornerRadius = radius or Theme.Radius }, parent)
end

local function Stroke(color, thickness, transparency, parent)
    return New("UIStroke", {
        Color = color or Theme.Border,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
    }, parent)
end

local function Padding(t, b, l, r, parent)
    return New("UIPadding", {
        PaddingTop = UDim.new(0, t or 0),
        PaddingBottom = UDim.new(0, b or 0),
        PaddingLeft = UDim.new(0, l or 0),
        PaddingRight = UDim.new(0, r or 0),
    }, parent)
end

local function Tween(obj, info, props)
    if not obj or not obj.Parent then return nil end
    local t = TweenService:Create(obj, info or Theme.AnimNormal, props)
    t:Play()
    return t
end

local function TextBounds(font, size, text)
    local label = Instance.new("TextLabel")
    label.TextSize = size
    label.Font = font
    label.Text = text or ""
    local bounds = label.TextBounds
    label:Destroy()
    return bounds
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [1.3] ANIMATIONS
-- ═══════════════════════════════════════════════════════════════════════════════
local Anim = {}
local activeGlows = {}

function Anim.Pulse(obj, scale, duration)
    if not obj or not obj.Parent then return end
    scale = scale or 1.05
    duration = duration or 0.3
    local origSize = obj.Size
    local info = TweenInfo.new(duration / 2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, {
        Size = UDim2.new(
            origSize.X.Scale * scale, origSize.X.Offset * scale,
            origSize.Y.Scale * scale, origSize.Y.Offset * scale
        ),
    })
    t:Play()
    t.Completed:Connect(function()
        if obj and obj.Parent then
            TweenService:Create(obj, info, { Size = origSize }):Play()
        end
    end)
end

function Anim.Ripple(parent, x, y, color)
    if not parent or not parent.Parent then return end
    color = color or Theme.Accent
    local ripple = New("Frame", {
        Name = "RippleEffect",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, x, 0, y),
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = color,
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        ZIndex = 10,
    }, parent)
    Corner(Theme.RadiusFull, ripple)
    local maxSize = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2
    Tween(ripple, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1,
    })
    task.delay(0.7, function()
        if ripple and ripple.Parent then ripple:Destroy() end
    end)
end

function Anim.Glow(obj, stroke, baseColor, glowColor)
    if not obj or not obj.Parent or not stroke then return end
    if activeGlows[obj] then
        activeGlows[obj]:Disconnect()
        activeGlows[obj] = nil
    end
    baseColor = baseColor or Theme.Border
    glowColor = glowColor or Theme.AccentGlow
    local startTime = tick()
    local period = 1.5
    activeGlows[obj] = RunService.Heartbeat:Connect(function()
        if not obj or not obj.Parent or not stroke or not stroke.Parent then
            if activeGlows[obj] then
                activeGlows[obj]:Disconnect()
                activeGlows[obj] = nil
            end
            return
        end
        local t = ((tick() - startTime) % period) / period
        local alpha = (math.sin(t * math.pi * 2) + 1) / 2
        alpha = 0.3 + alpha * 0.5
        stroke.Color = baseColor:Lerp(glowColor, alpha)
        stroke.Transparency = 1 - alpha
    end)
end

function Anim.StopGlow(obj)
    if activeGlows[obj] then
        activeGlows[obj]:Disconnect()
        activeGlows[obj] = nil
    end
end

function Anim.RotateChevron(chevron, toAngle, duration)
    if not chevron or not chevron.Parent then return end
    duration = duration or 0.25
    Tween(chevron, TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Rotation = toAngle,
    })
end

getgenv().ChuppyAnim = Anim

-- ═══════════════════════════════════════════════════════════════════════════════
-- [1.4] NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════
local Notification = {}
local notiStack = {}
local notiHolder = nil
local NOTI_W, NOTI_H, NOTI_GAP = 300, 68, 8

local NOTI_ICONS = { info = "ℹ", success = "✓", warning = "⚠", danger = "✕" }
local NOTI_COLORS = {
    info    = function() return Theme.Info end,
    success = function() return Theme.Success end,
    warning = function() return Theme.Warning end,
    danger  = function() return Theme.Danger end,
}

local function InitNotiHolder(screenGui)
    if notiHolder and notiHolder.Parent then return end
    notiHolder = New("Frame", {
        Name = "NotificationHolder",
        Size = UDim2.new(0, NOTI_W, 0, 0),
        Position = UDim2.new(0, 12, 0, 60),
        BackgroundTransparency = 1,
        ZIndex = 9999,
    }, screenGui)
end

local function ReorganizeNoti()
    local yPos = 0
    for _, noti in ipairs(notiStack) do
        if noti.frame and noti.frame.Parent then
            Tween(noti.frame, Theme.AnimNormal, { Position = UDim2.new(0, 0, 0, yPos) })
            yPos = yPos + NOTI_H + NOTI_GAP
        end
    end
end

local function DismissNoti(noti)
    if not noti or not noti.frame or not noti.frame.Parent then return end
    for i, n in ipairs(notiStack) do
        if n == noti then
            table.remove(notiStack, i)
            break
        end
    end
    if noti.timerConn then pcall(function() noti.timerConn:Disconnect() end) end
    local frame = noti.frame
    Tween(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        Position = UDim2.new(0, -NOTI_W - 20, 0, frame.Position.Y.Offset),
        BackgroundTransparency = 1,
    })
    for _, desc in ipairs(frame:GetDescendants()) do
        if desc:IsA("TextLabel") then
            Tween(desc, Theme.AnimFast, { TextTransparency = 1 })
        elseif desc:IsA("TextButton") then
            Tween(desc, Theme.AnimFast, { TextTransparency = 1, BackgroundTransparency = 1 })
        elseif desc:IsA("Frame") then
            Tween(desc, Theme.AnimFast, { BackgroundTransparency = 1 })
        elseif desc:IsA("UIStroke") then
            Tween(desc, Theme.AnimFast, { Transparency = 1 })
        end
    end
    task.delay(0.3, function()
        if frame and frame.Parent then frame:Destroy() end
        ReorganizeNoti()
    end)
end

function Notification.Show(config)
    if not notiHolder or not notiHolder.Parent then return nil end
    config = config or {}
    local nType = config.Type or "info"
    local title = config.Title or "Thông báo"
    local desc  = config.Desc or config.Text or ""
    local dur   = config.Duration or 4
    local icon  = config.Icon or NOTI_ICONS[nType] or "ℹ"
    local color = NOTI_COLORS[nType] and NOTI_COLORS[nType]() or Theme.Info

    local frame = New("Frame", {
        Name = "Noti_" .. tostring(math.random(10000, 99999)),
        Size = UDim2.new(0, NOTI_W, 0, NOTI_H),
        Position = UDim2.new(0, -NOTI_W - 20, 0, 0),
        BackgroundColor3 = Theme.Surface,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 9999,
    }, notiHolder)
    Corner(Theme.RadiusLarge, frame)
    local stroke = Stroke(Theme.Border, 1, 1, frame)

    local accent = New("Frame", {
        Name = "AccentBar",
        Size = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = color,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 10000,
    }, frame)
    Corner(Theme.RadiusTiny, accent)

    local iconF = New("Frame", {
        Name = "IconFrame",
        Size = UDim2.new(0, 36, 0, 36),
        Position = UDim2.new(0, 16, 0.5, -18),
        BackgroundColor3 = color,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 10000,
    }, frame)
    Corner(Theme.RadiusFull, iconF)
    New("TextLabel", {
        Name = "Icon",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = icon,
        Font = Theme.FontBlack,
        TextSize = 16,
        TextColor3 = Theme.Background,
        TextTransparency = 1,
        ZIndex = 10001,
    }, iconF)

    New("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -80, 0, 18),
        Position = UDim2.new(0, 62, 0, 14),
        BackgroundTransparency = 1,
        Text = title,
        Font = Theme.FontBold,
        TextSize = Theme.SizeMedium,
        TextColor3 = color,
        TextTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 10000,
    }, frame)

    New("TextLabel", {
        Name = "Desc",
        Size = UDim2.new(1, -80, 0, 26),
        Position = UDim2.new(0, 62, 0, 32),
        BackgroundTransparency = 1,
        Text = desc,
        Font = Theme.FontRegular,
        TextSize = Theme.SizeNormal,
        TextColor3 = Theme.TextDim,
        TextTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 10000,
    }, frame)

    local progBar, progFill
    if dur > 0 then
        progBar = New("Frame", {
            Name = "ProgressBar",
            Size = UDim2.new(1, -20, 0, 2),
            Position = UDim2.new(0, 10, 1, -4),
            BackgroundColor3 = Theme.SurfaceDeep,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 10000,
        }, frame)
        Corner(Theme.RadiusTiny, progBar)
        progFill = New("Frame", {
            Name = "Fill",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = color,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 10001,
        }, progBar)
        Corner(Theme.RadiusTiny, progFill)
    end

    local click = New("TextButton", {
        Name = "ClickArea",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 10002,
    }, frame)

    local noti = { frame = frame, type = nType, timerConn = nil }
    table.insert(notiStack, noti)

    Tween(frame, Theme.AnimSmooth, {
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 0,
    })
    task.delay(0.05, function()
        if not frame or not frame.Parent then return end
        Tween(accent, Theme.AnimNormal, { BackgroundTransparency = 0 })
        Tween(iconF, Theme.AnimNormal, { BackgroundTransparency = 0 })
        Tween(iconF.Icon, Theme.AnimNormal, { TextTransparency = 0 })
        Tween(frame.Title, Theme.AnimNormal, { TextTransparency = 0 })
        Tween(frame.Desc, Theme.AnimNormal, { TextTransparency = 0 })
        Tween(stroke, Theme.AnimNormal, { Transparency = 0 })
        if progBar then
            Tween(progBar, Theme.AnimNormal, { BackgroundTransparency = 0.3 })
            Tween(progFill, Theme.AnimNormal, { BackgroundTransparency = 0 })
        end
    end)

    if dur > 0 then
        local startTime = tick()
        local conn
        conn = RunService.Heartbeat:Connect(function()
            if not frame or not frame.Parent then
                if conn then conn:Disconnect() end
                return
            end
            local elapsed = tick() - startTime
            local prog = math.clamp(1 - elapsed / dur, 0, 1)
            if progFill and progFill.Parent then
                progFill.Size = UDim2.new(prog, 0, 1, 0)
                if prog < 0.25 then
                    progFill.BackgroundColor3 = Theme.Danger
                elseif prog < 0.5 then
                    progFill.BackgroundColor3 = Theme.Warning
                else
                    progFill.BackgroundColor3 = color
                end
            end
            if elapsed >= dur then
                if conn then conn:Disconnect() end
                DismissNoti(noti)
            end
        end)
        noti.timerConn = conn
    end

    click.MouseButton1Click:Connect(function() DismissNoti(noti) end)
    ReorganizeNoti()
    return noti
end

function Notification.Info(t, d, dur)    return Notification.Show({ Type = "info",    Title = t, Desc = d, Duration = dur }) end
function Notification.Success(t, d, dur) return Notification.Show({ Type = "success", Title = t, Desc = d, Duration = dur }) end
function Notification.Warning(t, d, dur) return Notification.Show({ Type = "warning", Title = t, Desc = d, Duration = dur }) end
function Notification.Danger(t, d, dur)  return Notification.Show({ Type = "danger",  Title = t, Desc = d, Duration = dur }) end

getgenv().ChuppyNotification = Notification

-- ═══════════════════════════════════════════════════════════════════════════════
-- [1.5] TOOLTIP SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════
local Tooltip = {}
local tFrame, tVisible = nil, false

local function InitTooltip(screenGui)
    if tFrame and tFrame.Parent then return end
    tFrame = New("Frame", {
        Name = "TooltipFrame",
        Size = UDim2.new(0, 0, 0, 26),
        BackgroundColor3 = Theme.Surface3,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 99999,
        Visible = false,
    }, screenGui)
    Corner(Theme.RadiusSmall, tFrame)
    Stroke(Theme.BorderLight, 1, 1, tFrame)
    New("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        Font = Theme.FontMedium,
        TextSize = Theme.SizeSmall,
        TextColor3 = Theme.Text,
        TextTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 100000,
    }, tFrame)
end

function Tooltip.Show(text, x, y)
    if not tFrame or not tFrame.Parent or not text or text == "" then return end
    local label = tFrame:FindFirstChild("Label")
    if not label then return end
    local bounds = TextBounds(Theme.FontMedium, Theme.SizeSmall, text)
    local w = math.max(50, bounds.X + 20)
    label.Text = text
    tFrame.Size = UDim2.new(0, w, 0, 26)
    tFrame.Position = UDim2.new(0, x - w / 2, 0, y)
    if not tVisible then
        tVisible = true
        tFrame.Visible = true
        tFrame.BackgroundTransparency = 0.05
        Tween(label, Theme.AnimFast, { TextTransparency = 0 })
    end
end

function Tooltip.Hide()
    if not tFrame or not tFrame.Parent then return end
    tVisible = false
    local label = tFrame:FindFirstChild("Label")
    if label then Tween(label, Theme.AnimFast, { TextTransparency = 1 }) end
    Tween(tFrame, Theme.AnimFast, { BackgroundTransparency = 1 })
    task.delay(0.2, function()
        if tFrame and tFrame.Parent and not tVisible then
            tFrame.Visible = false
        end
    end)
end

function Tooltip.Attach(element, text)
    if not element or not text then return end
    local hoverTime, isHovering = 0, false
    element.MouseEnter:Connect(function()
        isHovering = true
        hoverTime = tick()
        task.delay(0.4, function()
            if isHovering and (tick() - hoverTime) >= 0.35 then
                local pos, size = element.AbsolutePosition, element.AbsoluteSize
                Tooltip.Show(text, pos.X + size.X / 2, pos.Y - 32)
            end
        end)
    end)
    element.MouseLeave:Connect(function()
        isHovering = false
        Tooltip.Hide()
    end)
end

getgenv().ChuppyTooltip = Tooltip

-- ═══════════════════════════════════════════════════════════════════════════════
-- [1.6] MODAL DIALOG
-- ═══════════════════════════════════════════════════════════════════════════════
local Modal = {}

local function CreateModalBase(screenGui)
    local overlay = New("TextButton", {
        Name = "ModalOverlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 99998,
    }, screenGui)
    local modal = New("Frame", {
        Name = "Modal",
        Size = UDim2.new(0, 300, 0, 0),
        Position = UDim2.new(0.5, -150, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Theme.Surface2,
        BorderSizePixel = 0,
        ZIndex = 99999,
        AutomaticSize = Enum.AutomaticSize.Y,
    }, overlay)
    Corner(Theme.RadiusXL, modal)
    Stroke(Theme.BorderLight, 1, 0, modal)
    return overlay, modal
end

function Modal.Confirm(config)
    config = config or {}
    local title    = config.Title or "Xác nhận"
    local message  = config.Message or "Bạn có chắc chắn?"
    local yesText  = config.YesText or "Đồng ý"
    local noText   = config.NoText or "Hủy"
    local onYes    = config.OnYes or function() end
    local onNo     = config.OnNo or function() end
    local yesColor = config.YesColor or Theme.Success
    local noColor  = config.NoColor or Theme.Danger
    local parent   = config.Parent or getgenv().ChuppyScreenGui
    if not parent then return end

    local overlay, modal = CreateModalBase(parent)

    New("TextLabel", {
        Size = UDim2.new(1, -32, 0, 24),
        Position = UDim2.new(0, 16, 0, 18),
        BackgroundTransparency = 1,
        Text = title,
        Font = Theme.FontBold,
        TextSize = Theme.SizeHeader,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 100000,
    }, modal)

    New("TextLabel", {
        Size = UDim2.new(1, -32, 0, 40),
        Position = UDim2.new(0, 16, 0, 48),
        BackgroundTransparency = 1,
        Text = message,
        Font = Theme.FontRegular,
        TextSize = Theme.SizeMedium,
        TextColor3 = Theme.TextDim,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        ZIndex = 100000,
    }, modal)

    local btnRow = New("Frame", {
        Size = UDim2.new(1, -32, 0, 36),
        Position = UDim2.new(0, 16, 0, 96),
        BackgroundTransparency = 1,
        ZIndex = 100000,
    }, modal)
    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
    }, btnRow)

    local noBtn = New("TextButton", {
        Size = UDim2.new(0, 110, 1, 0),
        BackgroundColor3 = noColor,
        BorderSizePixel = 0,
        Text = noText,
        Font = Theme.FontBold,
        TextSize = Theme.SizeMedium,
        TextColor3 = Theme.TextBright,
        AutoButtonColor = false,
        LayoutOrder = 1,
        ZIndex = 100001,
    }, btnRow)
    Corner(Theme.RadiusSmall, noBtn)

    local yesBtn = New("TextButton", {
        Size = UDim2.new(0, 110, 1, 0),
        BackgroundColor3 = yesColor,
        BorderSizePixel = 0,
        Text = yesText,
        Font = Theme.FontBold,
        TextSize = Theme.SizeMedium,
        TextColor3 = Theme.TextBright,
        AutoButtonColor = false,
        LayoutOrder = 2,
        ZIndex = 100001,
    }, btnRow)
    Corner(Theme.RadiusSmall, yesBtn)

    modal.Size = UDim2.new(0, 300, 0, 150)
    overlay.BackgroundTransparency = 1
    modal.Position = UDim2.new(0.5, -150, 0.5, 20)
    modal.BackgroundTransparency = 1
    Tween(overlay, Theme.AnimNormal, { BackgroundTransparency = 0.5 })
    Tween(modal, Theme.AnimSpring, {
        Position = UDim2.new(0.5, -150, 0.5, 0),
        BackgroundTransparency = 0,
    })

    local function close()
        Tween(overlay, Theme.AnimFast, { BackgroundTransparency = 1 })
        Tween(modal, Theme.AnimFast, {
            Position = UDim2.new(0.5, -150, 0.5, 20),
            BackgroundTransparency = 1,
        })
        task.delay(0.2, function()
            if overlay and overlay.Parent then overlay:Destroy() end
        end)
    end

    yesBtn.MouseButton1Click:Connect(function() close(); pcall(onYes) end)
    noBtn.MouseButton1Click:Connect(function()  close(); pcall(onNo)  end)
    overlay.MouseButton1Click:Connect(function() close(); pcall(onNo) end)
    return overlay
end

function Modal.Prompt(config)
    config = config or {}
    local title       = config.Title or "Nhập liệu"
    local placeholder = config.Placeholder or "Nhập ở đây..."
    local default     = config.Default or ""
    local onSubmit    = config.OnSubmit or function() end
    local onCancel    = config.OnCancel or function() end
    local parent      = config.Parent or getgenv().ChuppyScreenGui
    if not parent then return end

    local overlay, modal = CreateModalBase(parent)

    New("TextLabel", {
        Size = UDim2.new(1, -32, 0, 24),
        Position = UDim2.new(0, 16, 0, 18),
        BackgroundTransparency = 1,
        Text = title,
        Font = Theme.FontBold,
        TextSize = Theme.SizeHeader,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 100000,
    }, modal)

    local input = New("TextBox", {
        Size = UDim2.new(1, -32, 0, 34),
        Position = UDim2.new(0, 16, 0, 52),
        BackgroundColor3 = Theme.SurfaceDeep,
        BorderSizePixel = 0,
        Text = default,
        PlaceholderText = placeholder,
        PlaceholderColor3 = Theme.TextMuted,
        Font = Theme.FontRegular,
        TextSize = Theme.SizeMedium,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        ZIndex = 100000,
    }, modal)
    Corner(Theme.RadiusSmall, input)
    Padding(0, 0, 10, 10, input)

    local inputStroke = Stroke(Theme.Border, 1, 0, input)
    input.Focused:Connect(function()
        Tween(inputStroke, Theme.AnimFast, { Color = Theme.Accent })
    end)
    input.FocusLost:Connect(function()
        Tween(inputStroke, Theme.AnimFast, { Color = Theme.Border })
    end)

    local btnRow = New("Frame", {
        Size = UDim2.new(1, -32, 0, 34),
        Position = UDim2.new(0, 16, 0, 100),
        BackgroundTransparency = 1,
        ZIndex = 100000,
    }, modal)
    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
    }, btnRow)

    local cancelBtn = New("TextButton", {
        Size = UDim2.new(0, 100, 1, 0),
        BackgroundColor3 = Theme.Surface3,
        BorderSizePixel = 0,
        Text = "Hủy",
        Font = Theme.FontBold,
        TextSize = Theme.SizeMedium,
        TextColor3 = Theme.Text,
        AutoButtonColor = false,
        LayoutOrder = 1,
        ZIndex = 100001,
    }, btnRow)
    Corner(Theme.RadiusSmall, cancelBtn)

    local okBtn = New("TextButton", {
        Size = UDim2.new(0, 100, 1, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Text = "OK",
        Font = Theme.FontBold,
        TextSize = Theme.SizeMedium,
        TextColor3 = Theme.Background,
        AutoButtonColor = false,
        LayoutOrder = 2,
        ZIndex = 100001,
    }, btnRow)
    Corner(Theme.RadiusSmall, okBtn)

    modal.Size = UDim2.new(0, 300, 0, 150)
    overlay.BackgroundTransparency = 1
    modal.Position = UDim2.new(0.5, -150, 0.5, 20)
    Tween(overlay, Theme.AnimNormal, { BackgroundTransparency = 0.5 })
    Tween(modal, Theme.AnimSpring, {
        Position = UDim2.new(0.5, -150, 0.5, 0),
        BackgroundTransparency = 0,
    })

    local function close()
        Tween(overlay, Theme.AnimFast, { BackgroundTransparency = 1 })
        Tween(modal, Theme.AnimFast, {
            Position = UDim2.new(0.5, -150, 0.5, 20),
            BackgroundTransparency = 1,
        })
        task.delay(0.2, function()
            if overlay and overlay.Parent then overlay:Destroy() end
        end)
    end

    okBtn.MouseButton1Click:Connect(function()
        local txt = input.Text
        close()
        pcall(onSubmit, txt)
    end)
    cancelBtn.MouseButton1Click:Connect(function()
        close()
        pcall(onCancel)
    end)
    task.defer(function() pcall(function() input:CaptureFocus() end) end)
    return overlay
end

getgenv().ChuppyModal = Modal

-- ═══════════════════════════════════════════════════════════════════════════════
-- [1.7] UI LIBRARY CLASS
-- ═══════════════════════════════════════════════════════════════════════════════
local UILibrary = {}
UILibrary.__index = UILibrary
UILibrary.Theme        = Theme
UILibrary.Notification = Notification
UILibrary.Tooltip      = Tooltip
UILibrary.Modal        = Modal
UILibrary.Anim         = Anim

function UILibrary:CreateWindow(config)
    config = config or {}
    local title    = config.Title or "Chuppy Hub V2"
    local subtitle = config.SubTitle or "Premium Edition"
    local width    = config.Width or 360
    local height   = config.Height or 460
    pcall(function()
        local vp = workspace.CurrentCamera.ViewportSize
        width, height = math.min(width, vp.X * 0.62, 300), math.clamp(vp.Y * 0.72, 220, math.min(height, 320))
    end)

    local self = setmetatable({}, UILibrary)
    self.config, self.title, self.tabs = config, title, {}
    self.currentTab, self.flags = nil, {}
    self.minimized, self._elementCount = false, 0

    local gui = New("ScreenGui", {
        Name = "ChuppyUI_" .. tostring(math.random(10000, 99999)),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        DisplayOrder = 999,
    })
    pcall(function() gui.Parent = (gethui and gethui()) or CoreGui end)
    if not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end
    self.screenGui = gui
    getgenv().ChuppyScreenGui = gui

    InitNotiHolder(gui)
    InitTooltip(gui)

    local main = New("Frame", {
        Name = "MainWindow",
        Size = UDim2.new(0, width, 0, height),
        Position = UDim2.new(0.5, -width / 2, 0.5, -height / 2),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Active = true,
        ClipsDescendants = true,
    }, gui)
    Corner(Theme.RadiusXL, main)
    Stroke(Theme.Border, 1, 0, main)
    self.mainFrame = main

    -- Title bar
    local titleBar = New("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
    }, main)
    Corner(Theme.RadiusXL, titleBar)
    New("Frame", {
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 1, -14),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        ZIndex = 2,
    }, titleBar)

    local logoDot = New("Frame", {
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(0, 12, 0.5, -13),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 3,
    }, titleBar)
    Corner(Theme.RadiusFull, logoDot)
    New("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "🐾",
        Font = Theme.FontBold,
        TextSize = 14,
        TextColor3 = Theme.Background,
        ZIndex = 4,
    }, logoDot)

    New("TextLabel", {
        Size = UDim2.new(0, width - 140, 0, 16),
        Position = UDim2.new(0, 46, 0, 6),
        BackgroundTransparency = 1,
        Text = title:upper(),
        Font = Theme.FontBlack,
        TextSize = Theme.SizeTitle,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3,
    }, titleBar)

    New("TextLabel", {
        Size = UDim2.new(0, width - 140, 0, 12),
        Position = UDim2.new(0, 46, 0, 24),
        BackgroundTransparency = 1,
        Text = subtitle,
        Font = Theme.FontRegular,
        TextSize = Theme.SizeSmall,
        TextColor3 = Theme.TextDim,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3,
    }, titleBar)

    local ctrl = New("Frame", {
        Size = UDim2.new(0, 70, 0, 30),
        Position = UDim2.new(1, -78, 0.5, -15),
        BackgroundTransparency = 1,
        ZIndex = 3,
    }, titleBar)
    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 6),
    }, ctrl)

    local minBtn = New("TextButton", {
        Size = UDim2.new(0, 28, 0, 28),
        BackgroundColor3 = Theme.Surface2,
        BorderSizePixel = 0,
        Text = "—",
        Font = Theme.FontBlack,
        TextSize = 14,
        TextColor3 = Theme.Warning,
        AutoButtonColor = false,
        ZIndex = 4,
    }, ctrl)
    Corner(Theme.RadiusSmall, minBtn)

    local closeBtn = New("TextButton", {
        Size = UDim2.new(0, 28, 0, 28),
        BackgroundColor3 = Theme.Surface2,
        BorderSizePixel = 0,
        Text = "✕",
        Font = Theme.FontBlack,
        TextSize = 12,
        TextColor3 = Theme.Danger,
        AutoButtonColor = false,
        ZIndex = 4,
    }, ctrl)
    Corner(Theme.RadiusSmall, closeBtn)

    minBtn.MouseEnter:Connect(function()
        Tween(minBtn, Theme.AnimFast, { BackgroundColor3 = Theme.Surface3 })
    end)
    minBtn.MouseLeave:Connect(function()
        Tween(minBtn, Theme.AnimFast, { BackgroundColor3 = Theme.Surface2 })
    end)
    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, Theme.AnimFast, { BackgroundColor3 = Theme.DangerDark })
    end)
    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, Theme.AnimFast, { BackgroundColor3 = Theme.Surface2 })
    end)

    -- Drag
    local dragging, dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                        or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Sidebar
    local sidebar = New("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 54, 1, -60),
        Position = UDim2.new(0, 8, 0, 52),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, main)
    Corner(Theme.RadiusLarge, sidebar)
    Stroke(Theme.Border, 1, 0.5, sidebar)

    local sidebarScroll = New("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, sidebar)
    Padding(6, 6, 6, 6, sidebarScroll)
    New("UIListLayout", {
        Padding = UDim.new(0, 4),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
    }, sidebarScroll)

    -- Content
    local content = New("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -78, 1, -60),
        Position = UDim2.new(0, 70, 0, 52),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, main)
    Corner(Theme.RadiusLarge, content)
    Stroke(Theme.Border, 1, 0.5, content)

    self.sidebar, self.sidebarScroll = sidebar, sidebarScroll
    self.content, self.titleBar = content, titleBar

    minBtn.MouseButton1Click:Connect(function()
        self.minimized = not self.minimized
        Tween(main, Theme.AnimSmooth, {
            Size = self.minimized
                and UDim2.new(0, width, 0, 46)
                or  UDim2.new(0, width, 0, height),
        })
        sidebar.Visible = not self.minimized
        content.Visible = not self.minimized
    end)

    function self:Toggle(v)
        if v == nil then v = not main.Visible end
        main.Visible = v
    end
    closeBtn.MouseButton1Click:Connect(function() self:Toggle(false) end)

    -- Nút nổi (kéo được, chạm để ẩn/hiện menu)
    local fb = New("TextButton", {
        Name = "FloatButton", Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 10, 0.35, 0), BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0, Text = "🐾", TextSize = 20, Font = Theme.FontBold,
        TextColor3 = Theme.Background, AutoButtonColor = false, ZIndex = 100,
    }, gui)
    Corner(Theme.RadiusFull, fb)
    Stroke(Theme.AccentGlow, 2, 0.3, fb)
    local fdrag, fstart, fpos, fmoved = false, nil, nil, false
    fb.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            fdrag, fmoved, fstart, fpos = true, false, i.Position, fb.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    fdrag = false
                    if not fmoved then self:Toggle() end
                end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if fdrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - fstart
            if d.Magnitude > 6 then fmoved = true end
            if fmoved then
                fb.Position = UDim2.new(fpos.X.Scale, fpos.X.Offset + d.X, fpos.Y.Scale, fpos.Y.Offset + d.Y)
            end
        end
    end)
    self.floatButton = fb

    main.Position = UDim2.new(0.5, -width / 2, 0.7, -height / 2)
    main.BackgroundTransparency = 1
    Tween(main, Theme.AnimSpring, {
        Position = UDim2.new(0.5, -width / 2, 0.5, -height / 2),
        BackgroundTransparency = 0,
    })

    return self
end

function UILibrary:MakeTab(config)
    config = config or {}
    local name  = config.Name or config[1] or "Tab"
    local icon  = config.Icon or config[2] or "•"
    local order = config.Order or (#self.tabs + 1)

    local tabBtn = New("TextButton", {
        Name = "TabBtn_" .. name,
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Theme.Surface,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = order,
    }, self.sidebarScroll)
    Corner(Theme.RadiusSmall, tabBtn)

    local iconLabel = New("TextLabel", {
        Name = "Icon",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = icon,
        Font = Theme.FontBold,
        TextSize = 18,
        TextColor3 = Theme.TextDim,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
    }, tabBtn)

    local indicator = New("Frame", {
        Name = "Indicator",
        Size = UDim2.new(0, 3, 0, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 2,
    }, tabBtn)
    Corner(UDim.new(1, 0), indicator)

    local page = New("ScrollingFrame", {
        Name = "Page_" .. name,
        Size = UDim2.new(1, -16, 1, -16),
        Position = UDim2.new(0, 8, 0, 8),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Border,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false,
    }, self.content)
    New("UIListLayout", { Padding = UDim.new(0, 8) }, page)

    local tab = {
        name = name, icon = icon, _window = self, _btn = tabBtn,
        _icon = iconLabel, _indicator = indicator, _page = page,
        _elementCount = 0,
        flags = self.flags, -- [Chuppy fix] AddToggle/AddKeybind dùng self.flags nhưng chỉ Window có
    }
    setmetatable(tab, UILibrary)
    table.insert(self.tabs, tab)

    tabBtn.MouseButton1Click:Connect(function() self:SelectTab(name) end)
    tabBtn.MouseEnter:Connect(function()
        if self.currentTab ~= name then
            Tween(tabBtn, Theme.AnimFast, { BackgroundTransparency = 0.5, BackgroundColor3 = Theme.Surface2 })
            Tween(iconLabel, Theme.AnimFast, { TextColor3 = Theme.Text })
            Tooltip.Show(name, tabBtn.AbsolutePosition.X + 40, tabBtn.AbsolutePosition.Y + 8)
        end
    end)
    tabBtn.MouseLeave:Connect(function()
        if self.currentTab ~= name then
            Tween(tabBtn, Theme.AnimFast, { BackgroundTransparency = 1, BackgroundColor3 = Theme.Surface })
            Tween(iconLabel, Theme.AnimFast, { TextColor3 = Theme.TextDim })
        end
        Tooltip.Hide()
    end)

    return tab
end

function UILibrary:SelectTab(name)
    for _, t in ipairs(self.tabs) do
        if t.name == name then
            t._page.Visible = true
            t._btn.BackgroundColor3 = Theme.Surface3
            t._btn.BackgroundTransparency = 0
            t._icon.TextColor3 = Theme.Accent
            t._indicator.Size = UDim2.new(0, 3, 0, 18)
            t._indicator.Position = UDim2.new(0, 0, 0.5, -9)
            self.currentTab = name
        else
            t._page.Visible = false
            t._btn.BackgroundColor3 = Theme.Surface
            t._btn.BackgroundTransparency = 1
            t._icon.TextColor3 = Theme.TextDim
            t._indicator.Size = UDim2.new(0, 3, 0, 0)
            t._indicator.Position = UDim2.new(0, 0, 0.5, 0)
        end
    end
end

function UILibrary:CreateSection(config)
    local name      = type(config) == "table" and (config.Name or config[1]) or (config or "Section")
    local collapsed = type(config) == "table" and config.Collapsed or false

    local wrapper = New("Frame", {
        Name = "SectionWrapper",
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = self._elementCount + 1,
    }, self._page)
    self._elementCount = self._elementCount + 1

    local header = New("TextButton", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = Theme.Surface2,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
    }, wrapper)
    Corner(Theme.RadiusSmall, header)

    local chevron = New("TextLabel", {
        Name = "Chevron",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 8, 0.5, -10),
        BackgroundTransparency = 1,
        Text = "▶",
        Font = Theme.FontBold,
        TextSize = 10,
        TextColor3 = Theme.Accent,
        Rotation = collapsed and 0 or 90,
    }, header)

    New("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 30, 0, 0),
        BackgroundTransparency = 1,
        Text = name:upper(),
        Font = Theme.FontBold,
        TextSize = Theme.SizeSmall,
        TextColor3 = Theme.Accent,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, header)

    local container = New("Frame", {
        Name = "Container",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 32),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = not collapsed,
    }, wrapper)
    New("UIListLayout", { Padding = UDim.new(0, 5) }, container)

    local section = {
        _wrapper = wrapper, _header = header, _container = container,
        _chevron = chevron, _collapsed = collapsed, _name = name,
        _window = self,
        _elementCount = 0, -- [Chuppy fix] thiếu trường này nên AddToggle/AddButton trong section bị lỗi nil + 1
        flags = self.flags,
    }
    setmetatable(section, UILibrary)

    header.MouseButton1Click:Connect(function()
        section._collapsed = not section._collapsed
        if section._collapsed then
            container.Visible = false
            Anim.RotateChevron(chevron, 0)
        else
            container.Visible = true
            Anim.RotateChevron(chevron, 90)
        end
    end)

    header.MouseEnter:Connect(function()
        Tween(header, Theme.AnimFast, { BackgroundTransparency = 0 })
    end)
    header.MouseLeave:Connect(function()
        Tween(header, Theme.AnimFast, { BackgroundTransparency = 0.4 })
    end)

    return section
end

function UILibrary:AddToggle(config, callback)
    config = config or {}
    local name     = config.Name or "Toggle"
    local desc     = config.Desc
    local default  = config.Default or false
    local flag     = config.Flag or name
    local disabled = config.Disabled or false
    local tooltip  = config.Tooltip
    local hasDesc  = desc ~= nil and desc ~= ""
    local height   = hasDesc and 54 or 42

    local frame = New("TextButton", {
        Name = "Toggle_" .. name,
        Size = UDim2.new(1, 0, 0, height),
        BackgroundColor3 = Theme.Surface2,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = self._elementCount + 1,
    }, self._container or self._page)
    Corner(Theme.RadiusSmall, frame)
    local frameStroke = Stroke(Theme.Border, 1, 0.7, frame)
    self._elementCount = self._elementCount + 1

    local title = New("TextLabel", {
        Size = UDim2.new(1, -80, 0, 16),
        Position = UDim2.new(0, 12, 0, hasDesc and 8 or 0),
        BackgroundTransparency = 1,
        Text = name,
        Font = Theme.FontMedium,
        TextSize = Theme.SizeMedium,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, frame)

    if hasDesc then
        New("TextLabel", {
            Size = UDim2.new(1, -80, 0, 14),
            Position = UDim2.new(0, 12, 0, 26),
            BackgroundTransparency = 1,
            Text = desc,
            Font = Theme.FontRegular,
            TextSize = Theme.SizeSmall,
            TextColor3 = Theme.TextDim,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, frame)
    end

    local switch = New("Frame", {
        Size = UDim2.new(0, 42, 0, 22),
        Position = UDim2.new(1, -54, 0.5, -11),
        BackgroundColor3 = default and Theme.Success or Theme.Surface3,
        BorderSizePixel = 0,
    }, frame)
    Corner(Theme.RadiusFull, switch)

    local knob = New("Frame", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
        BackgroundColor3 = Theme.TextBright,
        BorderSizePixel = 0,
    }, switch)
    Corner(Theme.RadiusFull, knob)

    local state = default
    local function updateVisual(instant)
        local info       = instant and Theme.AnimInstant or Theme.AnimSmooth
        local springInfo = instant and Theme.AnimInstant or Theme.AnimSpring
        if state then
            Tween(switch, info, { BackgroundColor3 = Theme.Success })
            Tween(knob, springInfo, {
                Position = UDim2.new(1, -20, 0.5, -9),
                BackgroundColor3 = Theme.TextBright,
            })
            Tween(frameStroke, info, { Color = Theme.Success, Transparency = 0.6 })
            Tween(title, info, { TextColor3 = Theme.TextBright })
        else
            Tween(switch, info, { BackgroundColor3 = Theme.Surface3 })
            Tween(knob, springInfo, {
                Position = UDim2.new(0, 2, 0.5, -9),
                BackgroundColor3 = Theme.TextDim,
            })
            Tween(frameStroke, info, { Color = Theme.Border, Transparency = 0.7 })
            Tween(title, info, { TextColor3 = Theme.Text })
        end
    end

    local clickable = New("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 5,
    }, frame)

    clickable.MouseButton1Click:Connect(function()
        if disabled then return end
        state = not state
        updateVisual()
        Anim.Pulse(frame, 1.015, 0.15)
        if callback then pcall(callback, state) end
    end)

    clickable.MouseEnter:Connect(function()
        if disabled then return end
        Tween(frame, Theme.AnimFast, { BackgroundColor3 = Theme.Surface3 })
    end)
    clickable.MouseLeave:Connect(function()
        Tween(frame, Theme.AnimFast, { BackgroundColor3 = Theme.Surface2 })
    end)

    if tooltip then Tooltip.Attach(frame, tooltip) end
    self.flags[flag] = { type = "toggle", value = state }

    return {
        Set = function(v)
            if state ~= v then
                state = v
                updateVisual(true)
                if callback then pcall(callback, state) end
            end
        end,
        Get = function() return state end,
        SetDisabled = function(v)
            disabled = v
            frame.BackgroundTransparency = v and 0.5 or 0
        end,
        Flag = flag,
    }
end

function UILibrary:AddButton(config, callback)
    config = config or {}
    local name    = config.Name or "Button"
    local desc    = config.Desc
    local color   = config.Color or Theme.Accent
    local tooltip = config.Tooltip
    local hasDesc = desc ~= nil and desc ~= ""
    local height  = hasDesc and 50 or 40

    local btn = New("TextButton", {
        Name = "Button_" .. name,
        Size = UDim2.new(1, 0, 0, height),
        BackgroundColor3 = Theme.Surface2,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        ClipsDescendants = true,
        LayoutOrder = self._elementCount + 1,
    }, self._container or self._page)
    Corner(Theme.RadiusSmall, btn)
    local btnStroke = Stroke(color, 1, 0.5, btn)
    self._elementCount = self._elementCount + 1

    New("TextLabel", {
        Size = UDim2.new(1, -40, 0, 16),
        Position = UDim2.new(0, 12, 0, hasDesc and 8 or 0),
        BackgroundTransparency = 1,
        Text = name,
        Font = Theme.FontMedium,
        TextSize = Theme.SizeMedium,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, btn)

    if hasDesc then
        New("TextLabel", {
            Size = UDim2.new(1, -40, 0, 14),
            Position = UDim2.new(0, 12, 0, 26),
            BackgroundTransparency = 1,
            Text = desc,
            Font = Theme.FontRegular,
            TextSize = Theme.SizeSmall,
            TextColor3 = Theme.TextDim,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, btn)
    end

    New("TextLabel", {
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -26, 0, 0),
        BackgroundTransparency = 1,
        Text = "›",
        Font = Theme.FontBlack,
        TextSize = 18,
        TextColor3 = color,
    }, btn)

    btn.MouseButton1Click:Connect(function()
        local mouse = UIS:GetMouseLocation()
        Anim.Ripple(btn, mouse.X - btn.AbsolutePosition.X, mouse.Y - btn.AbsolutePosition.Y, color)
        Anim.Pulse(btn, 0.98, 0.1)
        if callback then pcall(callback) end
    end)

    btn.MouseEnter:Connect(function()
        Tween(btn, Theme.AnimFast, { BackgroundColor3 = Theme.Surface3 })
        Tween(btnStroke, Theme.AnimFast, { Transparency = 0.2 })
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, Theme.AnimFast, { BackgroundColor3 = Theme.Surface2 })
        Tween(btnStroke, Theme.AnimFast, { Transparency = 0.5 })
    end)

    if tooltip then Tooltip.Attach(btn, tooltip) end
    return btn
end

function UILibrary:AddSlider(config, callback)
    config = config or {}
    local name    = config.Name or "Slider"
    local min     = config.Min or 0
    local max     = config.Max or 100
    local default = config.Default or min
    local step    = config.Step or 1
    local suffix  = config.Suffix or ""
    local value   = math.clamp(default, min, max)

    local frame = New("Frame", {
        Name = "Slider_" .. name,
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = Theme.Surface2,
        BorderSizePixel = 0,
        LayoutOrder = self._elementCount + 1,
    }, self._container or self._page)
    Corner(Theme.RadiusSmall, frame)
    local frameStroke = Stroke(Theme.Border, 1, 0.7, frame)
    self._elementCount = self._elementCount + 1

    New("TextLabel", {
        Size = UDim2.new(0.6, -12, 0, 18),
        Position = UDim2.new(0, 12, 0, 6),
        BackgroundTransparency = 1,
        Text = name,
        Font = Theme.FontMedium,
        TextSize = Theme.SizeMedium,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, frame)

    local valueLabel = New("TextLabel", {
        Size = UDim2.new(0.4, -12, 0, 18),
        Position = UDim2.new(0.6, 0, 0, 6),
        BackgroundTransparency = 1,
        Text = tostring(value) .. suffix,
        Font = Theme.FontBold,
        TextSize = Theme.SizeMedium,
        TextColor3 = Theme.Accent,
        TextXAlignment = Enum.TextXAlignment.Right,
    }, frame)

    local track = New("Frame", {
        Size = UDim2.new(1, -24, 0, 8),
        Position = UDim2.new(0, 12, 0, 32),
        BackgroundColor3 = Theme.SurfaceDeep,
        BorderSizePixel = 0,
    }, frame)
    Corner(Theme.RadiusFull, track)

    local fill = New("Frame", {
        Size = UDim2.new((value - min) / math.max(max - min, 1), 0, 1, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
    }, track)
    Corner(Theme.RadiusFull, fill)

    local knob = New("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new((value - min) / math.max(max - min, 1), -8, 0.5, -8),
        BackgroundColor3 = Theme.TextBright,
        BorderSizePixel = 0,
        ZIndex = 3,
    }, track)
    Corner(Theme.RadiusFull, knob)

    local dragging = false
    local trackInput = New("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 5,
    }, track)

    local function updateFromX(relX)
        relX = math.clamp(relX, 0, 1)
        local rawValue = min + (max - min) * relX
        local finalValue = math.clamp(math.floor(rawValue / step + 0.5) * step, min, max)
        value = finalValue
        local rel = (value - min) / math.max(max - min, 1)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, -8, 0.5, -8)
        valueLabel.Text = tostring(value) .. suffix
        if callback then pcall(callback, value) end
    end

    trackInput.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromX((input.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1))
        end
    end)
    trackInput.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                        or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromX((input.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1))
        end
    end)

    trackInput.MouseEnter:Connect(function()
        Tween(frameStroke, Theme.AnimFast, { Transparency = 0.4 })
    end)
    trackInput.MouseLeave:Connect(function()
        Tween(frameStroke, Theme.AnimFast, { Transparency = 0.7 })
    end)

    return {
        Set = function(v)
            v = math.clamp(v, min, max)
            value = v
            local rel = (value - min) / math.max(max - min, 1)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            knob.Position = UDim2.new(rel, -8, 0.5, -8)
            valueLabel.Text = tostring(value) .. suffix
            if callback then pcall(callback, value) end
        end,
        Get = function() return value end,
    }
end

function UILibrary:AddDropdown(config, callback)
    config = config or {}
    local name    = config.Name or "Dropdown"
    local options = config.Options or config.List or {}
    local default = config.Default or options[1]
    local search  = config.Search or false

    local frame = New("Frame", {
        Name = "Dropdown_" .. name,
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Theme.Surface2,
        BorderSizePixel = 0,
        LayoutOrder = self._elementCount + 1,
        ZIndex = 3,
    }, self._container or self._page)
    Corner(Theme.RadiusSmall, frame)
    local frameStroke = Stroke(Theme.Border, 1, 0.7, frame)
    self._elementCount = self._elementCount + 1

    local valueLabel = New("TextLabel", {
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = name .. ": " .. tostring(default or "None"),
        Font = Theme.FontMedium,
        TextSize = Theme.SizeMedium,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, frame)

    local arrow = New("TextLabel", {
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -26, 0, 0),
        BackgroundTransparency = 1,
        Text = "▾",
        Font = Theme.FontBlack,
        TextSize = 14,
        TextColor3 = Theme.Accent,
    }, frame)

    local clickBtn = New("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 4,
    }, frame)

    local menu = New("ScrollingFrame", {
        Name = "Menu",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 4),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false,
        ZIndex = 100,
    }, frame)
    Corner(Theme.RadiusSmall, menu)
    Stroke(Theme.BorderLight, 1, 0, menu)
    New("UIListLayout", { Padding = UDim.new(0, 2) }, menu)
    Padding(4, 4, 4, 4, menu)

    local selected = { [default] = true }
    local currentValue = default
    local optBtns = {}

    local searchBox
    if search then
        searchBox = New("TextBox", {
            Size = UDim2.new(1, 0, 0, 26),
            BackgroundColor3 = Theme.Surface2,
            BorderSizePixel = 0,
            Text = "",
            PlaceholderText = "🔍 Tìm kiếm...",
            PlaceholderColor3 = Theme.TextMuted,
            Font = Theme.FontRegular,
            TextSize = Theme.SizeSmall,
            TextColor3 = Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            ClearTextOnFocus = false,
            LayoutOrder = 0,
        }, menu)
        Corner(Theme.RadiusSmall, searchBox)
        Padding(0, 0, 8, 8, searchBox)
    end

    for i, opt in ipairs(options) do
        local optBtn = New("TextButton", {
            Name = "Opt_" .. tostring(opt),
            Size = UDim2.new(1, 0, 0, 26),
            BackgroundColor3 = Theme.Surface2,
            BorderSizePixel = 0,
            Text = "  " .. tostring(opt),
            Font = Theme.FontRegular,
            TextSize = Theme.SizeSmall,
            TextColor3 = selected[opt] and Theme.Accent or Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            LayoutOrder = i + (search and 1 or 0),
        }, menu)
        Corner(Theme.RadiusSmall, optBtn)
        table.insert(optBtns, { btn = optBtn, name = tostring(opt) })

        optBtn.MouseEnter:Connect(function()
            Tween(optBtn, Theme.AnimFast, { BackgroundColor3 = Theme.Surface3 })
        end)
        optBtn.MouseLeave:Connect(function()
            Tween(optBtn, Theme.AnimFast, { BackgroundColor3 = Theme.Surface2 })
        end)
        optBtn.MouseButton1Click:Connect(function()
            for _, data in ipairs(optBtns) do
                data.btn.TextColor3 = Theme.Text
            end
            optBtn.TextColor3 = Theme.Accent
            currentValue = opt
            valueLabel.Text = name .. ": " .. tostring(opt)
            menu.Visible = false
            menu.Size = UDim2.new(1, 0, 0, 0)
            arrow.Rotation = 0
            if callback then pcall(callback, opt) end
        end)
    end

    if searchBox then
        searchBox:GetPropertyChangedSignal("Text"):Connect(function()
            local txt = searchBox.Text:lower()
            for _, data in ipairs(optBtns) do
                data.btn.Visible = txt == "" or data.name:lower():find(txt, 1, true) ~= nil
            end
        end)
    end

    local isOpen = false
    clickBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            local layout = menu:FindFirstChildOfClass("UIListLayout")
            local h = math.min((layout and layout.AbsoluteContentSize.Y or 30) + 10, 180)
            menu.Visible = true
            Tween(menu, Theme.AnimSpring, { Size = UDim2.new(1, 0, 0, h) })
            Tween(arrow, Theme.AnimSpring, { Rotation = 180 })
            Tween(frameStroke, Theme.AnimFast, { Color = Theme.Accent, Transparency = 0.3 })
        else
            Tween(menu, Theme.AnimFast, { Size = UDim2.new(1, 0, 0, 0) })
            Tween(arrow, Theme.AnimFast, { Rotation = 0 })
            Tween(frameStroke, Theme.AnimFast, { Color = Theme.Border, Transparency = 0.7 })
            task.delay(0.15, function()
                if not isOpen then menu.Visible = false end
            end)
        end
    end)

    clickBtn.MouseEnter:Connect(function()
        Tween(frame, Theme.AnimFast, { BackgroundColor3 = Theme.Surface3 })
    end)
    clickBtn.MouseLeave:Connect(function()
        Tween(frame, Theme.AnimFast, { BackgroundColor3 = Theme.Surface2 })
    end)

    return {
        Set = function(v)
            currentValue = v
            selected = { [v] = true }
            for _, data in ipairs(optBtns) do
                data.btn.TextColor3 = (data.name == tostring(v)) and Theme.Accent or Theme.Text
            end
            valueLabel.Text = name .. ": " .. tostring(v)
            if callback then pcall(callback, v) end
        end,
        Get = function() return currentValue end,
    }
end

function UILibrary:AddLabel(config)
    if type(config) == "string" then config = { Text = config } end
    config = config or {}
    local text   = config.Text or config.Title or "Label"
    local color  = config.Color or Theme.TextDim
    local size   = config.Size or Theme.SizeSmall
    local bold   = config.Bold or false
    local center = config.Center or false

    local lbl = New("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = text,
        Font = bold and Theme.FontBold or Theme.FontRegular,
        TextSize = size,
        TextColor3 = color,
        TextXAlignment = center and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left,
        TextWrapped = true,
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = self._elementCount + 1,
    }, self._container or self._page)
    Padding(2, 2, 4, 4, lbl)
    self._elementCount = self._elementCount + 1

    return {
        SetText = function(t) lbl.Text = tostring(t) end,
        GetText = function() return lbl.Text end,
        Instance = lbl,
    }
end

function UILibrary:AddDivider(config)
    config = config or {}
    local div = New("Frame", {
        Name = "Divider",
        Size = UDim2.new(1, -20, 0, 1),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundColor3 = config.Color or Theme.Border,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        LayoutOrder = self._elementCount + 1,
    }, self._container or self._page)
    self._elementCount = self._elementCount + 1
    return div
end

function UILibrary:AddKeybind(config, callback)
    config = config or {}
    local name    = config.Name or "Keybind"
    local default = config.Default or Enum.KeyCode.RightShift
    local flag    = config.Flag or name
    local current = default
    local listening = false

    local frame = New("Frame", {
        Name = "Keybind_" .. name,
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Theme.Surface2,
        BorderSizePixel = 0,
        LayoutOrder = self._elementCount + 1,
    }, self._container or self._page)
    Corner(Theme.RadiusSmall, frame)
    self._elementCount = self._elementCount + 1

    New("TextLabel", {
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        Font = Theme.FontMedium,
        TextSize = Theme.SizeMedium,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, frame)

    local keyBtn = New("TextButton", {
        Size = UDim2.new(0, 80, 0, 26),
        Position = UDim2.new(1, -92, 0.5, -13),
        BackgroundColor3 = Theme.SurfaceDeep,
        BorderSizePixel = 0,
        Text = current.Name,
        Font = Theme.FontBold,
        TextSize = Theme.SizeSmall,
        TextColor3 = Theme.Accent,
        AutoButtonColor = false,
    }, frame)
    Corner(Theme.RadiusSmall, keyBtn)

    keyBtn.MouseButton1Click:Connect(function()
        listening = true
        keyBtn.Text = "..."
        keyBtn.TextColor3 = Theme.Warning
    end)

    UIS.InputBegan:Connect(function(input, gp)
        if listening and not gp and input.UserInputType == Enum.UserInputType.Keyboard then
            current = input.KeyCode
            keyBtn.Text = current.Name
            keyBtn.TextColor3 = Theme.Accent
            listening = false
            if callback then pcall(callback, current) end
        elseif not listening and input.KeyCode == current and not gp then
            if callback then pcall(callback, current) end
        end
    end)

    self.flags[flag] = { type = "keybind", value = current }
    return {
        Get = function() return current end,
        Set = function(k)
            current = k
            keyBtn.Text = k.Name
            if callback then pcall(callback, k) end
        end,
    }
end

function UILibrary:AddInput(config, callback)
    config = config or {}
    local name        = config.Name or "Input"
    local placeholder = config.Placeholder or "Nhập..."
    local default     = config.Default or ""

    local frame = New("Frame", {
        Name = "Input_" .. name,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Theme.Surface2,
        BorderSizePixel = 0,
        LayoutOrder = self._elementCount + 1,
    }, self._container or self._page)
    Corner(Theme.RadiusSmall, frame)
    local inputStroke = Stroke(Theme.Border, 1, 0.7, frame)
    self._elementCount = self._elementCount + 1

    New("TextLabel", {
        Size = UDim2.new(0.4, 0, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        Font = Theme.FontMedium,
        TextSize = Theme.SizeSmall,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, frame)

    local box = New("TextBox", {
        Size = UDim2.new(0.55, -12, 0, 26),
        Position = UDim2.new(0.45, 0, 0.5, -13),
        BackgroundColor3 = Theme.SurfaceDeep,
        BorderSizePixel = 0,
        Text = default,
        PlaceholderText = placeholder,
        PlaceholderColor3 = Theme.TextMuted,
        Font = Theme.FontRegular,
        TextSize = Theme.SizeSmall,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
    }, frame)
    Corner(Theme.RadiusSmall, box)
    Padding(0, 0, 8, 8, box)

    box.Focused:Connect(function()
        Tween(inputStroke, Theme.AnimFast, { Color = Theme.Accent })
    end)
    box.FocusLost:Connect(function()
        Tween(inputStroke, Theme.AnimFast, { Color = Theme.Border })
        if callback then pcall(callback, box.Text) end
    end)

    return {
        Set = function(v) box.Text = tostring(v) end,
        Get = function() return box.Text end,
        Instance = box,
    }
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [1.8] EXPORT
-- ═══════════════════════════════════════════════════════════════════════════════
getgenv().ChuppyUI = UILibrary

print("═══════════════════════════════════════════════════════════════════════════════")
print("  ✅ PART 1/10 — UI LIBRARY LOADED")
print("  📦 ChuppyTheme · ChuppyUI · ChuppyNotification · ChuppyModal · ChuppyTooltip · ChuppyAnim")
print("  👉 Gõ 'tiếp' để nhận PART 2/10: CORE SYSTEM (State + Config + Remote + Webhook)")
print("═══════════════════════════════════════════════════════════════════════════════")

end)() -- End IIFE
-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐾 CHUPPY HUB V2 — PART 2/10: CORE SYSTEM
-- Phiên bản sạch: IIFE scope · không return giữa file · export qua getgenv()
-- ═══════════════════════════════════════════════════════════════════════════════
;(function()

-- ═══════════════════════════════════════════════════════════════════════════════
-- [2.0] SERVICES + CONSTANTS
-- ═══════════════════════════════════════════════════════════════════════════════
local Players              = game:GetService("Players")
local ReplicatedStorage    = game:GetService("ReplicatedStorage")
local Workspace            = game:GetService("Workspace")
local RunService           = game:GetService("RunService")
local UserInputService     = game:GetService("UserInputService")
local TweenService         = game:GetService("TweenService")
local HttpService          = game:GetService("HttpService")
local TeleportService      = game:GetService("TeleportService")
local CollectionService    = game:GetService("CollectionService")
local Lighting             = game:GetService("Lighting")
local VirtualUser          = game:GetService("VirtualUser")
local VirtualInputManager  = game:GetService("VirtualInputManager")
local CoreGui              = game:GetService("CoreGui")

local LP     = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Lấy module từ Part 1
local Notification = getgenv().ChuppyNotification
local Modal        = getgenv().ChuppyModal

local Constant = {
    PLACE_IDS = {
        SEA1 = { 2753915549, 85211729168715 },
        SEA2 = { 4442272183, 79091703265657 },
        SEA3 = { 7449423635, 100117331123089 },
    },
    CONFIG_FOLDER = "ChuppyHub",
    CONFIG_FILE   = "config.json",
    STATS_FILE    = "stats.json",
    TICK_RATE     = 0.1,
    FAST_TICK     = 0.05,
    SLOW_TICK     = 0.5,
    CONFIG_AUTOSAVE  = 30,
    MAX_LEVEL        = 2850,
    MAX_BELI_CAP     = 999999999,
    BASE_WALKSPEED   = 16,
    BASE_JUMPPOWER   = 50,
    WEBHOOK_COOLDOWN = 2,
    WEBHOOK_MAX_QUEUE = 10,
    NOTI_SPAM_COOLDOWN = 3,
}
getgenv().ChuppyConstant = Constant

-- ═══════════════════════════════════════════════════════════════════════════════
-- [2.1] GLOBAL STATE & UTILS
-- ═══════════════════════════════════════════════════════════════════════════════
local State = {
    Running     = true,
    Unloaded    = false,
    Version     = "2.0.0",
    StartTime   = tick(),
    World       = 0,
    
    -- Feature toggles
    AutoFarm        = false, AutoFarmBoss = false, AutoFarmMaterial = false, 
    AutoFarmChest   = false, AutoRaid = false, AutoSeaBeast = false, 
    AutoLeviathan   = false, KillAura = false, AutoRace = false, 
    AutoCDK         = false, ESPEnabled = false, AimbotEnabled = false, 
    AutoHaki        = true, AutoStoreFruit = false, AutoRedeem = false,

    -- Player Cache
    PlayerData = { Level = 0, Beli = 0, Fragments = 0, DevilFruit = "", Race = "", Team = "", LastUpdate = 0 },
    Stats      = { MobsKilled = 0, BossesKilled = 0, ChestsCollected = 0, FruitsStored = 0, RaidsCompleted = 0, Deaths = 0, DamageDealt = 0, SessionTime = 0 },

    CurrentTarget = nil, CurrentQuest = nil, CurrentBoss = nil, CurrentMaterial = nil,
    CurrentWeapon = "Melee", CurrentFarmMode = "Quest",

    _connections = {}, _threads = {}, _cache = {}, _cooldowns = {}, _notiSpam = {},
}
getgenv().ChuppyState = State

local function Track(conn)
    if conn then table.insert(State._connections, conn) end
    return conn
end

local function TrackThread(thread)
    if thread then table.insert(State._threads, thread) end
    return thread
end

local function SafeSpawn(fn, ...)
    local args = { ... }
    local thread = task.spawn(function()
        local ok, err = pcall(fn, table.unpack(args))
        if not ok then warn("[Chuppy] Thread error:", err) end
    end)
    TrackThread(thread)
    return thread
end

local function CheckCooldown(key, duration)
    if not State._cooldowns[key] then State._cooldowns[key] = tick(); return true end
    if tick() - State._cooldowns[key] >= duration then State._cooldowns[key] = tick(); return true end
    return false
end

local function Notify(title, desc, notiType, duration)
    notiType = notiType or "info"
    duration = duration or 4
    local key = tostring(title) .. "|" .. tostring(desc or "")
    local now = tick()
    if State._notiSpam[key] and (now - State._notiSpam[key]) < Constant.NOTI_SPAM_COOLDOWN then return end
    State._notiSpam[key] = now

    if Notification and Notification.Show then
        return Notification.Show({ Type = notiType, Title = title, Desc = desc, Duration = duration })
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [2.2] PLAYER / CHARACTER UTILITIES
-- ═══════════════════════════════════════════════════════════════════════════════
local function GetCharacter()
    local char = LP.Character
    if char and char:FindFirstChild("HumanoidRootPart") then return char end
    return nil
end

local function GetHRP() local char = GetCharacter(); return char and char:FindFirstChild("HumanoidRootPart") end
local function GetHumanoid() local char = GetCharacter(); return char and char:FindFirstChildOfClass("Humanoid") end
local function IsAlive() local hum = GetHumanoid(); return hum and hum.Health > 0 end
local function GetPosition() local hrp = GetHRP(); return hrp and hrp.Position or Vector3.zero end
local function GetCFrame() local hrp = GetHRP(); return hrp and hrp.CFrame or CFrame.new() end

local function GetDataFolder() return LP:FindFirstChild("Data") end
local function GetLevel() local d = GetDataFolder(); local v = d and d:FindFirstChild("Level"); return v and v.Value or 0 end
local function GetBeli() local d = GetDataFolder(); local v = d and d:FindFirstChild("Beli"); return v and v.Value or 0 end
local function GetFragments() local d = GetDataFolder(); local v = d and d:FindFirstChild("Fragments"); return v and v.Value or 0 end
local function GetDevilFruit() local d = GetDataFolder(); local v = d and d:FindFirstChild("DevilFruit"); return v and v.Value or "" end
local function GetRace() local d = GetDataFolder(); local v = d and d:FindFirstChild("Race"); return v and v.Value or "" end
local function GetTeam() local team = LP.Team; return team and team.Name or "None" end

local function UpdatePlayerData()
    local now = tick()
    if now - State.PlayerData.LastUpdate < 0.5 then return end
    State.PlayerData.Level      = GetLevel()
    State.PlayerData.Beli       = GetBeli()
    State.PlayerData.Fragments  = GetFragments()
    State.PlayerData.DevilFruit = GetDevilFruit()
    State.PlayerData.Race       = GetRace()
    State.PlayerData.Team       = GetTeam()
    State.PlayerData.LastUpdate = now
end

local function GetWorld()
    local pid = game.PlaceId
    for _, id in ipairs(Constant.PLACE_IDS.SEA1) do if pid == id then return 1 end end
    for _, id in ipairs(Constant.PLACE_IDS.SEA2) do if pid == id then return 2 end end
    for _, id in ipairs(Constant.PLACE_IDS.SEA3) do if pid == id then return 3 end end
    return 0
end
State.World = GetWorld()

local PlayerUtils = {
    GetCharacter = GetCharacter, GetHRP = GetHRP, GetHumanoid = GetHumanoid, IsAlive = IsAlive,
    GetPosition = GetPosition, GetCFrame = GetCFrame, GetLevel = GetLevel, GetBeli = GetBeli,
    GetFragments = GetFragments, GetDevilFruit = GetDevilFruit, GetRace = GetRace, GetTeam = GetTeam,
    UpdateData = UpdatePlayerData, GetWorld = GetWorld,
}
getgenv().ChuppyPlayer = PlayerUtils

-- ═══════════════════════════════════════════════════════════════════════════════
-- [2.3] CONFIG SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════
local Config = {}
Config.SaveKeys = {
    "AutoFarm", "AutoFarmBoss", "AutoFarmMaterial", "AutoFarmChest", "AutoHaki", "AutoStoreFruit", 
    "CurrentWeapon", "CurrentFarmMode", "AutoRaid", "AutoSeaBeast", "AutoLeviathan", "AutoRace", 
    "AutoCDK", "AutoRedeem", "KillAura", "AimbotEnabled", "ESPFruit", "ESPChest", "WalkSpeed", 
    "JumpPower", "FarmSpeed", "MobAuraRange", "AimbotFOV", "BringMobDistance", "SelectedBoss", 
    "SelectedMaterial", "SelectedRaid", "WebhookURL", "WebhookEnabled", "WebhookNotiFruit", 
    "WebhookNotiBoss", "NoClip", "FullBright", "WalkWater",
}

local function EnsureFolder()
    pcall(function() if not isfolder(Constant.CONFIG_FOLDER) then makefolder(Constant.CONFIG_FOLDER) end end)
end
local function GetConfigPath() return Constant.CONFIG_FOLDER .. "/" .. Constant.CONFIG_FILE end

function Config.Save()
    if not writefile then return false end
    EnsureFolder()
    local data = {}
    for _, key in ipairs(Config.SaveKeys) do if State[key] ~= nil then data[key] = State[key] end end
    local ok = pcall(function() writefile(GetConfigPath(), HttpService:JSONEncode(data)) end)
    return ok
end

function Config.Load()
    if not readfile or not isfile then return false end
    EnsureFolder()
    local path = GetConfigPath()
    if not isfile(path) then return false end
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
    if not ok or type(data) ~= "table" then return false end
    for key, value in pairs(data) do if State[key] ~= nil then State[key] = value end end
    return true
end

function Config.Reset()
    if not delfile then return false end
    pcall(function() if isfile(GetConfigPath()) then delfile(GetConfigPath()) end end)
    return true
end

function Config.ToJSON()
    local data = {}
    for _, key in ipairs(Config.SaveKeys) do if State[key] ~= nil then data[key] = State[key] end end
    local ok, json = pcall(function() return HttpService:JSONEncode(data) end)
    return ok and json or ""
end

function Config.FromJSON(json)
    local ok, data = pcall(function() return HttpService:JSONDecode(json) end)
    if not ok or type(data) ~= "table" then return false end
    for key, value in pairs(data) do if State[key] ~= nil then State[key] = value end end
    return true
end

local Stats = {}
function Stats.Save()
    if not writefile then return false end
    EnsureFolder()
    local path = Constant.CONFIG_FOLDER .. "/" .. Constant.STATS_FILE
    return pcall(function() writefile(path, HttpService:JSONEncode(State.Stats)) end)
end

function Stats.Load()
    if not readfile or not isfile then return false end
    local path = Constant.CONFIG_FOLDER .. "/" .. Constant.STATS_FILE
    if not isfile(path) then return false end
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
    if not ok or type(data) ~= "table" then return false end
    for k, v in pairs(data) do if type(v) == "number" then State.Stats[k] = v end end
    return true
end

function Stats.Reset()
    for k in pairs(State.Stats) do State.Stats[k] = 0 end
    Stats.Save()
end

-- Autosave Loop
SafeSpawn(function()
    while State.Running do
        task.wait(Constant.CONFIG_AUTOSAVE)
        if not State.Running then break end
        pcall(Config.Save)
        pcall(Stats.Save)
    end
end)

getgenv().ChuppyConfig = Config
getgenv().ChuppyStats = Stats
Config.Load()
Stats.Load()

-- ═══════════════════════════════════════════════════════════════════════════════
-- [2.4] REMOTE WRAPPER
-- ═══════════════════════════════════════════════════════════════════════════════
local Remote = {}
local function GetCommF() local r = ReplicatedStorage:FindFirstChild("Remotes"); return r and r:FindFirstChild("CommF_") end
local function GetCommE() local r = ReplicatedStorage:FindFirstChild("Remotes"); return r and r:FindFirstChild("CommE") end

function Remote.Invoke(...)
    local commF = GetCommF()
    if not commF then return nil end
    local args = { ... }
    local unpackFn = table.unpack or unpack
    local ok, res = pcall(function() return commF:InvokeServer(unpackFn(args)) end)
    if not ok then return nil end
    return res
end

function Remote.FireCommE(...)
    local commE = GetCommE()
    if not commE then return false end
    local args = { ... }
    local unpackFn = table.unpack or unpack
    return pcall(function() commE:FireServer(unpackFn(args)) end)
end

function Remote.Fire(remote, ...)
    if not remote then return false end
    local args = { ... }
    local unpackFn = table.unpack or unpack
    return pcall(function() remote:FireServer(unpackFn(args)) end)
end

Remote.StartQuest  = function(q, lv) return Remote.Invoke("StartQuest", q, lv) end
Remote.AbandonQuest = function() return Remote.Invoke("AbandonQuest") end
Remote.BuyHaki      = function(h) return Remote.Invoke("BuyHaki", h) end
Remote.Buso         = function() return Remote.Invoke("Buso") end
Remote.StoreFruit   = function(n, t) return Remote.Invoke("StoreFruit", n, t) end
Remote.LoadFruit    = function(n) return Remote.Invoke("LoadItem", n) end
Remote.BuyBoat      = function(b) return Remote.Invoke("BuyBoat", b) end
getgenv().ChuppyRemote = Remote

-- ═══════════════════════════════════════════════════════════════════════════════
-- [2.5] MONSTER HELPERS
-- ═══════════════════════════════════════════════════════════════════════════════
local Monster = {}

function Monster.Find(name)
    local search = name and string.lower(name) or nil
    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if enemiesFolder then
        for _, v in pairs(enemiesFolder:GetChildren()) do
            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                if not search or string.find(string.lower(v.Name), search, 1, true) then return v end
            end
        end
    end
    if search then
        for _, v in pairs(Workspace:GetChildren()) do
            if v:IsA("Model") and string.find(string.lower(v.Name), search, 1, true) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                return v
            end
        end
    end
    if name then
        local rsMob = ReplicatedStorage:FindFirstChild(name)
        if rsMob and rsMob:FindFirstChild("HumanoidRootPart") then return rsMob end
    end
    return nil
end

function Monster.FindNearest(maxDistance)
    maxDistance = maxDistance or 5000
    local hrp = GetHRP()
    if not hrp then return nil end
    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return nil end
    local nearest, shortest = nil, maxDistance
    for _, v in pairs(enemiesFolder:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            local d = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
            if d < shortest then shortest = d; nearest = v end
        end
    end
    return nearest
end

function Monster.FindInRange(range)
    range = range or 300
    local hrp = GetHRP()
    if not hrp then return {} end
    local list = {}
    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return list end
    for _, v in pairs(enemiesFolder:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            local d = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
            if d <= range then table.insert(list, { mob = v, distance = d }) end
        end
    end
    table.sort(list, function(a, b) return a.distance < b.distance end)
    return list
end

function Monster.Bring(mob, targetCF)
    if not mob or not mob:FindFirstChild("HumanoidRootPart") then return end
    pcall(function()
        local hrp = mob.HumanoidRootPart
        local hum = mob:FindFirstChildOfClass("Humanoid")
        hrp.CFrame = targetCF
        if hum then hum.JumpPower = 0; hum.WalkSpeed = 0 end
        hrp.CanCollide = false
        if not hrp:FindFirstChild("BringLock") then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "BringLock"; bv.MaxForce = Vector3.new(1e5, 1e5, 1e5); bv.Velocity = Vector3.zero; bv.Parent = hrp
        end
    end)
end

function Monster.IsAlive(mob)
    if not mob or not mob.Parent then return false end
    local hum = mob:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local BOSS_KEYWORDS = { "King", "Lord", "Boss", "Prince", "Queen", "Beast", "Reaper", "Admiral", "Warden", "Leader" }
function Monster.IsBoss(mob)
    if not mob then return false end
    for _, kw in ipairs(BOSS_KEYWORDS) do if string.find(mob.Name, kw, 1, true) then return true end end
    return false
end
getgenv().ChuppyMonster = Monster

-- ═══════════════════════════════════════════════════════════════════════════════
-- [2.6] DISCORD WEBHOOK SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════
local Webhook = {}
local webhookQueue, webhookSending, webhookCooldowns = {}, false, {}
local WEBHOOK_COLORS = { info = 3447003, success = 5763719, warning = 16776960, danger = 15548997, fruit = 16711935, boss = 16750592, level = 10181046 }

local function BuildEmbed(data)
    local fields = data.Fields or {}
    table.insert(fields, { name = "👤 Player", value = "```" .. LP.Name .. "```", inline = true })
    table.insert(fields, { name = "📊 Level", value = "```" .. tostring(GetLevel()) .. "```", inline = true })
    table.insert(fields, { name = "🌍 Sea", value = "```" .. tostring(State.World) .. "```", inline = true })
    return { title = data.Title or "Chuppy Hub", description = data.Description or "", color = data.Color or WEBHOOK_COLORS.info, fields = fields, footer = { text = "Chuppy Hub V2 | " .. os.date("%H:%M:%S") }, timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ") }
end

local function ProcessQueue()
    if webhookSending or #webhookQueue == 0 then return end
    webhookSending = true
    local item = table.remove(webhookQueue, 1)
    local req = request or http_request or (syn and syn.request) or (http and http.request)
    if not req then webhookSending = false; return end
    SafeSpawn(function()
        pcall(function() req({ Url = item.url, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = HttpService:JSONEncode(item.payload) }) end)
        task.wait(Constant.WEBHOOK_COOLDOWN)
        webhookSending = false
        if #webhookQueue > 0 then ProcessQueue() end
    end)
end

function Webhook.Send(config)
    if not State.WebhookEnabled or not State.WebhookURL or State.WebhookURL == "" then return end
    local type_ = config.Type or "info"
    local now = tick()
    if webhookCooldowns[type_] and (now - webhookCooldowns[type_]) < Constant.WEBHOOK_COOLDOWN then return end
    webhookCooldowns[type_] = now
    local embed = BuildEmbed({ Title = config.Title, Description = config.Description, Color = config.Color or WEBHOOK_COLORS[type_] or WEBHOOK_COLORS.info, Fields = config.Fields })
    local payload = { content = config.Ping and "@everyone" or "", username = "Chuppy Hub V2", embeds = { embed } }
    if #webhookQueue >= Constant.WEBHOOK_MAX_QUEUE then table.remove(webhookQueue, 1) end
    table.insert(webhookQueue, { url = State.WebhookURL, payload = payload, type = type_ })
    ProcessQueue()
end

Webhook.Info = function(t, d, f) Webhook.Send({ Type = "info", Title = t, Description = d, Fields = f }) end
Webhook.Success = function(t, d, f) Webhook.Send({ Type = "success", Title = t, Description = d, Fields = f }) end
Webhook.Warning = function(t, d, f) Webhook.Send({ Type = "warning", Title = t, Description = d, Fields = f }) end
Webhook.Danger = function(t, d, f) Webhook.Send({ Type = "danger", Title = t, Description = d, Fields = f }) end
Webhook.Fruit = function(n, p) if State.WebhookNotiFruit then Webhook.Send({ Type = "fruit", Title = "🍎 Fruit Found", Description = "Đã tìm thấy **" .. n .. "**", Fields = { { name = "💰 Giá", value = "```" .. tostring(p or "?") .. "```", inline = true } } }) end end
Webhook.Boss = function(n, d) if State.WebhookNotiBoss then Webhook.Send({ Type = "boss", Title = "👑 Boss Defeated", Description = "Đã hạ gục **" .. n .. "**", Fields = { { name = "🎁 Drops", value = "```" .. tostring(d or "Không có") .. "```", inline = false } } }) end end
Webhook.LevelUp = function(o, n) Webhook.Send({ Type = "level", Title = "⬆️ Level Up", Description = "Level: **" .. o .. "** → **" .. n .. "**" }) end
Webhook.Test = function() if not State.WebhookURL or State.WebhookURL == "" then Notify("Lỗi", "Chưa nhập URL webhook", "danger"); return end Webhook.Send({ Type = "info", Title = "🔔 Test Webhook", Description = "Webhook hoạt động tốt!" }) end
getgenv().ChuppyWebhook = Webhook

-- ═══════════════════════════════════════════════════════════════════════════════
-- [2.7] GLOBAL KEYBIND MANAGER
-- ═══════════════════════════════════════════════════════════════════════════════
local KeybindManager = {}
local binds = {}

function KeybindManager.Bind(action, keyCode, callback)
    if not keyCode or not callback then return end
    if not binds[keyCode] then binds[keyCode] = {} end
    table.insert(binds[keyCode], { action = action, callback = callback })
end

function KeybindManager.Unbind(action)
    for keyCode, list in pairs(binds) do
        for i = #list, 1, -1 do if list[i].action == action then table.remove(list, i) end end
    end
end

Track(UserInputService.InputBegan:Connect(function(input, gp)
    if gp or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    local list = binds[input.KeyCode]
    if not list then return end
    for _, item in ipairs(list) do pcall(item.callback, input.KeyCode) end
end))

KeybindManager.Bind("ToggleUI", Enum.KeyCode.RightShift, function()
    local screenGui = getgenv().ChuppyScreenGui
    if not screenGui then return end
    local main = screenGui:FindFirstChild("MainWindow")
    if main then main.Visible = not main.Visible end -- (nút nổi dùng cùng cờ Visible)
end)

KeybindManager.Bind("PanicStop", Enum.KeyCode.End, function()
    State.AutoFarm = false; State.KillAura = false
    Notify("Panic", "Đã dừng tất cả farm", "danger")
end)
getgenv().ChuppyKeybind = KeybindManager

-- ═══════════════════════════════════════════════════════════════════════════════
-- [2.8] NOTIFICATION QUEUE
-- ═══════════════════════════════════════════════════════════════════════════════
local NotiQueue = { queue = {}, processing = false, interval = 0.8 }

function NotiQueue.Push(config)
    table.insert(NotiQueue.queue, config)
    if #NotiQueue.queue > 20 then table.remove(NotiQueue.queue, 1) end
    if not NotiQueue.processing then NotiQueue.Process() end
end

function NotiQueue.Process()
    if NotiQueue.processing then return end
    NotiQueue.processing = true
    SafeSpawn(function()
        while #NotiQueue.queue > 0 do
            local item = table.remove(NotiQueue.queue, 1)
            if Notification and Notification.Show then pcall(Notification.Show, item) end
            task.wait(NotiQueue.interval)
        end
        NotiQueue.processing = false
    end)
end
getgenv().ChuppyNotiQueue = NotiQueue

-- ═══════════════════════════════════════════════════════════════════════════════
-- [2.9] SERVER MANAGER
-- ═══════════════════════════════════════════════════════════════════════════════
local ServerManager = {}

function ServerManager.Rejoin()
    Notify("Server", "Đang rejoin...", "info")
    task.delay(0.5, function() pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP) end) end)
end

function ServerManager.Hop()
    local lastHop = State._cooldowns["serverhop"]
    if lastHop and (tick() - lastHop) < 15 then Notify("Server", "Vui lòng đợi " .. math.ceil(15 - (tick() - lastHop)) .. "s", "warning"); return end
    State._cooldowns["serverhop"] = tick()
    Notify("Server", "Đang tìm server...", "info")
    SafeSpawn(function()
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local ok, res = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
        if not ok or not res or not res.data then Notify("Server", "Không tìm thấy server", "danger"); return end
        for _, srv in ipairs(res.data) do
            if srv.id ~= game.JobId and srv.playing < srv.maxPlayers then
                pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, LP) end)
                return
            end
        end
        Notify("Server", "Không có server trống", "warning")
    end)
end

Track(LP.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Started and State.AutoRejoinDisconnect then pcall(Config.Save); pcall(Stats.Save) end
end))

SafeSpawn(function()
    while State.Running do
        task.wait(1)
        if not State.AutoRejoinDisconnect then continue end
        pcall(function()
            local promptGui = LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("RobloxPromptGui")
            local overlay = promptGui and promptGui:FindFirstChild("promptOverlay")
            if overlay then Notify("Disconnect", "Đang rejoin...", "danger"); ServerManager.Rejoin() end
        end)
    end
end)
getgenv().ChuppyServer = ServerManager

-- ═══════════════════════════════════════════════════════════════════════════════
-- [2.10] INIT + EXPORTS
-- ═══════════════════════════════════════════════════════════════════════════════
UpdatePlayerData()
SafeSpawn(function() while State.Running do task.wait(1); pcall(UpdatePlayerData) end end)
SafeSpawn(function()
    local lastSave = tick()
    while State.Running do
        task.wait(5)
        State.Stats.SessionTime = math.floor(tick() - State.StartTime)
        if tick() - lastSave >= 30 then pcall(Stats.Save); lastSave = tick() end
    end
end)
pcall(function() game:BindToClose(function() pcall(Config.Save); pcall(Stats.Save) end) end)

getgenv().Chuppy = getgenv().Chuppy or {}
local Chuppy = getgenv().Chuppy

Chuppy.State        = State
Chuppy.Constant     = Constant
Chuppy.Config       = Config
Chuppy.Stats        = Stats
Chuppy.Remote       = Remote
Chuppy.Monster      = Monster
Chuppy.Webhook      = Webhook
Chuppy.Keybind      = KeybindManager
Chuppy.NotiQueue    = NotiQueue
Chuppy.Server       = ServerManager
Chuppy.Player       = PlayerUtils
Chuppy.Track        = Track
Chuppy.SafeSpawn    = SafeSpawn
Chuppy.Notify       = Notify
Chuppy.CheckCooldown = CheckCooldown

print("═══════════════════════════════════════════════════════════════════════════════")
print("  ✅ PART 2/10 — CORE SYSTEM LOADED")
print("  📦 State · Config · Remote · Monster · Webhook · Keybind · Server")
print("  👉 Gõ 'tiếp' để nhận PART 3/10: QUEST DB & AUTO FARM LEVEL")
print("═══════════════════════════════════════════════════════════════════════════════")

end)() -- End IIFE
-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐾 CHUPPY HUB V2 — PART 3/10: QUEST DB & AUTO FARM LEVEL
-- Phiên bản sạch: IIFE scope · Fix lỗi nil Farm · export qua getgenv()
-- ═══════════════════════════════════════════════════════════════════════════════
;(function()

-- ═══════════════════════════════════════════════════════════════════════════════
-- [3.0] SERVICES & IMPORTS
-- ═══════════════════════════════════════════════════════════════════════════════
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local VirtualUser       = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LP = Players.LocalPlayer

-- Lấy biến toàn cục từ Part 2
local State        = getgenv().ChuppyState
local PlayerUtils  = getgenv().ChuppyPlayer
local Monster      = getgenv().ChuppyMonster
local Remote       = getgenv().ChuppyRemote
local Notify       = getgenv().Chuppy.Notify
local Track        = getgenv().Chuppy.Track
local SafeSpawn    = getgenv().Chuppy.SafeSpawn
local CheckCooldown= getgenv().Chuppy.CheckCooldown

if not State or not PlayerUtils then
    warn("[Chuppy Farm] LỖI: Chưa load Part 2!")
    return
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [3.1] QUEST DATABASE
-- ═══════════════════════════════════════════════════════════════════════════════
local QuestDB = {
    -- ═══ SEA 1 ═══
    { minLv=1,   maxLv=9,   world=1, mob="Bandit",              quest="BanditQuest1",   qlv=1, island="Starter Island", questCF=CFrame.new(1059.37, 15.44, 1550.42), mobCF=CFrame.new(1045.96, 27.00, 1560.82) },
    { minLv=10,  maxLv=14,  world=1, mob="Monkey",              quest="JungleQuest",    qlv=1, island="Jungle",         questCF=CFrame.new(-1598.08, 35.55, 153.37), mobCF=CFrame.new(-1448.51, 67.85, 11.46) },
    { minLv=15,  maxLv=29,  world=1, mob="Gorilla",             quest="JungleQuest",    qlv=2, island="Jungle",         questCF=CFrame.new(-1598.08, 35.55, 153.37), mobCF=CFrame.new(-1129.88, 40.46, -525.42) },
    { minLv=30,  maxLv=39,  world=1, mob="Pirate",              quest="BuggyQuest1",    qlv=1, island="Pirate Village", questCF=CFrame.new(-1141.07, 4.10, 3831.54), mobCF=CFrame.new(-1103.51, 13.75, 3896.09) },
    { minLv=40,  maxLv=59,  world=1, mob="Brute",               quest="BuggyQuest1",    qlv=2, island="Pirate Village", questCF=CFrame.new(-1141.07, 4.10, 3831.54), mobCF=CFrame.new(-1140.08, 14.80, 4322.92) },
    { minLv=60,  maxLv=74,  world=1, mob="Desert Bandit",       quest="DesertQuest",    qlv=1, island="Desert",         questCF=CFrame.new(894.48, 5.14, 4392.43),   mobCF=CFrame.new(924.79, 6.44, 4481.58) },
    { minLv=75,  maxLv=89,  world=1, mob="Desert Officer",      quest="DesertQuest",    qlv=2, island="Desert",         questCF=CFrame.new(894.48, 5.14, 4392.43),   mobCF=CFrame.new(1608.28, 8.61, 4371.00) },
    { minLv=90,  maxLv=99,  world=1, mob="Snow Bandit",         quest="SnowQuest",      qlv=1, island="Snow Island",    questCF=CFrame.new(1389.74, 88.15, -1298.90),mobCF=CFrame.new(1354.34, 87.27, -1393.94) },
    { minLv=100, maxLv=119, world=1, mob="Snowman",             quest="SnowQuest",      qlv=2, island="Snow Island",    questCF=CFrame.new(1389.74, 88.15, -1298.90),mobCF=CFrame.new(1201.64, 144.57, -1550.06) },
    { minLv=120, maxLv=149, world=1, mob="Chief Petty Officer", quest="MarineQuest2",   qlv=1, island="Marine Fortress",questCF=CFrame.new(-5039.58, 27.35, 4324.68),mobCF=CFrame.new(-4881.23, 22.65, 4273.75) },
    { minLv=150, maxLv=174, world=1, mob="Sky Bandit",          quest="SkyQuest",       qlv=1, island="Sky Island",     questCF=CFrame.new(-4839.53, 716.36, -2619.44),mobCF=CFrame.new(-4953.20, 295.74, -2899.22) },
    { minLv=175, maxLv=189, world=1, mob="Dark Master",         quest="SkyQuest",       qlv=2, island="Sky Island",     questCF=CFrame.new(-4839.53, 716.36, -2619.44),mobCF=CFrame.new(-5259.84, 391.39, -2229.03) },
    { minLv=190, maxLv=209, world=1, mob="Prisoner",            quest="PrisonerQuest",  qlv=1, island="Prison",         questCF=CFrame.new(5308.93, 1.65, 475.12),   mobCF=CFrame.new(5098.97, -0.32, 474.23) },
    { minLv=210, maxLv=249, world=1, mob="Dangerous Prisoner",  quest="PrisonerQuest",  qlv=2, island="Prison",         questCF=CFrame.new(5308.93, 1.65, 475.12),   mobCF=CFrame.new(5654.56, 15.63, 866.29) },
    { minLv=250, maxLv=274, world=1, mob="Toga Warrior",        quest="ColosseumQuest", qlv=1, island="Colosseum",      questCF=CFrame.new(-1580.04, 6.35, -2986.47),mobCF=CFrame.new(-1820.21, 51.68, -2740.66) },
    { minLv=275, maxLv=299, world=1, mob="Gladiator",           quest="ColosseumQuest", qlv=2, island="Colosseum",      questCF=CFrame.new(-1580.04, 6.35, -2986.47),mobCF=CFrame.new(-1292.83, 56.38, -3339.03) },
    { minLv=300, maxLv=324, world=1, mob="Military Soldier",    quest="MagmaQuest",     qlv=1, island="Magma Village",  questCF=CFrame.new(-5313.37, 10.95, 8515.29),mobCF=CFrame.new(-5411.16, 11.08, 8454.29) },
    { minLv=325, maxLv=374, world=1, mob="Military Spy",        quest="MagmaQuest",     qlv=2, island="Magma Village",  questCF=CFrame.new(-5313.37, 10.95, 8515.29),mobCF=CFrame.new(-5802.86, 86.26, 8828.85) },
    { minLv=375, maxLv=399, world=1, mob="Fishman Warrior",     quest="FishmanQuest",   qlv=1, island="Underwater City",questCF=CFrame.new(61122.65, 18.49, 1569.39),mobCF=CFrame.new(60878.30, 18.48, 1543.75) },
    { minLv=400, maxLv=449, world=1, mob="Fishman Commando",    quest="FishmanQuest",   qlv=2, island="Underwater City",questCF=CFrame.new(61122.65, 18.49, 1569.39),mobCF=CFrame.new(61922.63, 18.48, 1493.93) },
    { minLv=450, maxLv=474, world=1, mob="God's Guard",         quest="SkyExp1Quest",   qlv=1, island="Upper Sky",      questCF=CFrame.new(-4721.88, 843.87, -1949.96),mobCF=CFrame.new(-4710.04, 845.27, -1927.30) },
    { minLv=475, maxLv=524, world=1, mob="Shanda",              quest="SkyExp1Quest",   qlv=2, island="Upper Sky",      questCF=CFrame.new(-7859.09, 5544.19, -381.47),mobCF=CFrame.new(-7678.48, 5566.40, -497.21) },
    { minLv=525, maxLv=549, world=1, mob="Royal Squad",         quest="SkyExp2Quest",   qlv=1, island="Upper Sky",      questCF=CFrame.new(-7906.81, 5634.66, -1411.99),mobCF=CFrame.new(-7624.25, 5658.13, -1467.35) },
    { minLv=550, maxLv=624, world=1, mob="Royal Soldier",       quest="SkyExp2Quest",   qlv=2, island="Upper Sky",      questCF=CFrame.new(-7906.81, 5634.66, -1411.99),mobCF=CFrame.new(-7836.75, 5645.66, -1790.62) },
    { minLv=625, maxLv=649, world=1, mob="Galley Pirate",       quest="FountainQuest",  qlv=1, island="Fountain City",  questCF=CFrame.new(5259.81, 37.35, 4050.02), mobCF=CFrame.new(5551.02, 78.90, 3930.41) },
    { minLv=650, maxLv=699, world=1, mob="Galley Captain",      quest="FountainQuest",  qlv=2, island="Fountain City",  questCF=CFrame.new(5259.81, 37.35, 4050.02), mobCF=CFrame.new(5441.95, 42.50, 4950.09) },

    -- ═══ SEA 2 ═══
    { minLv=700,  maxLv=724,  world=2, mob="Raider",             quest="Area1Quest",         qlv=1, island="Kingdom of Rose", questCF=CFrame.new(-429.54, 71.76, 1836.18), mobCF=CFrame.new(-728.32, 52.77, 2345.77) },
    { minLv=725,  maxLv=774,  world=2, mob="Mercenary",          quest="Area1Quest",         qlv=2, island="Kingdom of Rose", questCF=CFrame.new(-429.54, 71.76, 1836.18), mobCF=CFrame.new(-1004.32, 80.15, 1424.61) },
    { minLv=775,  maxLv=799,  world=2, mob="Swan Pirate",        quest="Area2Quest",         qlv=1, island="Kingdom of Rose", questCF=CFrame.new(638.43, 71.76, 918.28),   mobCF=CFrame.new(1068.66, 137.61, 1322.10) },
    { minLv=800,  maxLv=874,  world=2, mob="Factory Staff",      quest="Area2Quest",         qlv=2, island="Factory",         questCF=CFrame.new(632.69, 73.10, 918.66),   mobCF=CFrame.new(73.07, 81.86, -27.47) },
    { minLv=875,  maxLv=899,  world=2, mob="Marine Lieutenant",  quest="MarineQuest3",       qlv=1, island="Marine Fortress", questCF=CFrame.new(-2440.79, 71.71, -3216.06),mobCF=CFrame.new(-2821.37, 75.89, -3070.08) },
    { minLv=900,  maxLv=949,  world=2, mob="Marine Captain",     quest="MarineQuest3",       qlv=2, island="Marine Fortress", questCF=CFrame.new(-2440.79, 71.71, -3216.06),mobCF=CFrame.new(-1861.23, 80.17, -3254.69) },
    { minLv=950,  maxLv=974,  world=2, mob="Zombie",             quest="ZombieQuest",        qlv=1, island="Graveyard",       questCF=CFrame.new(-5497.06, 47.59, -795.23), mobCF=CFrame.new(-5657.77, 78.96, -928.68) },
    { minLv=975,  maxLv=999,  world=2, mob="Vampire",            quest="ZombieQuest",        qlv=2, island="Graveyard",       questCF=CFrame.new(-5497.06, 47.59, -795.23), mobCF=CFrame.new(-6037.66, 32.18, -1340.65) },
    { minLv=1000, maxLv=1049, world=2, mob="Snow Trooper",       quest="SnowMountainQuest",  qlv=1, island="Snow Mountain",   questCF=CFrame.new(609.85, 400.11, -5372.25), mobCF=CFrame.new(549.14, 427.38, -5563.69) },
    { minLv=1050, maxLv=1099, world=2, mob="Winter Warrior",     quest="SnowMountainQuest",  qlv=2, island="Snow Mountain",   questCF=CFrame.new(609.85, 400.11, -5372.25), mobCF=CFrame.new(1142.74, 475.63, -5199.41) },
    { minLv=1100, maxLv=1124, world=2, mob="Lab Subordinate",    quest="IceSideQuest",       qlv=1, island="Frosted Island",  questCF=CFrame.new(-6064.06, 15.24, -4902.97),mobCF=CFrame.new(-5707.47, 15.95, -4513.39) },
    { minLv=1125, maxLv=1174, world=2, mob="Horned Warrior",     quest="IceSideQuest",       qlv=2, island="Frosted Island",  questCF=CFrame.new(-6064.06, 15.24, -4902.97),mobCF=CFrame.new(-6341.36, 15.95, -5723.16) },
    { minLv=1175, maxLv=1199, world=2, mob="Magma Ninja",        quest="FireSideQuest",      qlv=1, island="Hot and Cold",    questCF=CFrame.new(-5428.03, 15.06, -5299.43),mobCF=CFrame.new(-5449.67, 76.65, -5808.20) },
    { minLv=1200, maxLv=1249, world=2, mob="Lava Pirate",        quest="FireSideQuest",      qlv=2, island="Hot and Cold",    questCF=CFrame.new(-5428.03, 15.06, -5299.43),mobCF=CFrame.new(-5213.33, 49.73, -4701.45) },
    { minLv=1250, maxLv=1274, world=2, mob="Ship Deckhand",      quest="ShipQuest1",         qlv=1, island="Cursed Ship",     questCF=CFrame.new(1037.80, 125.09, 32911.60),mobCF=CFrame.new(1212.01, 150.79, 33059.24) },
    { minLv=1275, maxLv=1299, world=2, mob="Ship Engineer",      quest="ShipQuest1",         qlv=2, island="Cursed Ship",     questCF=CFrame.new(1037.80, 125.09, 32911.60),mobCF=CFrame.new(919.47, 43.54, 32779.96) },
    { minLv=1300, maxLv=1324, world=2, mob="Ship Steward",       quest="ShipQuest2",         qlv=1, island="Cursed Ship",     questCF=CFrame.new(968.80, 125.09, 33244.12), mobCF=CFrame.new(919.43, 129.55, 33436.03) },
    { minLv=1325, maxLv=1349, world=2, mob="Ship Officer",       quest="ShipQuest2",         qlv=2, island="Cursed Ship",     questCF=CFrame.new(968.80, 125.09, 33244.12), mobCF=CFrame.new(1036.01, 181.43, 33315.72) },
    { minLv=1350, maxLv=1374, world=2, mob="Arctic Warrior",     quest="FrostQuest",         qlv=1, island="Frosted Island",  questCF=CFrame.new(5667.65, 26.79, -6486.08), mobCF=CFrame.new(5966.24, 62.97, -6179.38) },
    { minLv=1375, maxLv=1424, world=2, mob="Snow Lurker",        quest="FrostQuest",         qlv=2, island="Frosted Island",  questCF=CFrame.new(5667.65, 26.79, -6486.08), mobCF=CFrame.new(5407.07, 69.19, -6880.88) },
    { minLv=1425, maxLv=1449, world=2, mob="Sea Soldier",        quest="ForgottenQuest",     qlv=1, island="Forgotten Island",questCF=CFrame.new(-3054.44, 235.54, -10142.81),mobCF=CFrame.new(-3028.22, 64.67, -9775.42) },
    { minLv=1450, maxLv=1499, world=2, mob="Water Fighter",      quest="ForgottenQuest",     qlv=2, island="Forgotten Island",questCF=CFrame.new(-3054.44, 235.54, -10142.81),mobCF=CFrame.new(-3352.90, 285.01, -10534.84) },

    -- ═══ SEA 3 ═══
    { minLv=1500, maxLv=1524, world=3, mob="Pirate Millionaire",    quest="PiratePortQuest",     qlv=1, island="Port Town",      questCF=CFrame.new(-290.07, 42.90, 5581.58), mobCF=CFrame.new(-245.99, 47.30, 5584.10) },
    { minLv=1525, maxLv=1574, world=3, mob="Pistol Billionaire",    quest="PiratePortQuest",     qlv=2, island="Port Town",      questCF=CFrame.new(-290.07, 42.90, 5581.58), mobCF=CFrame.new(-187.33, 86.23, 6013.51) },
    { minLv=1575, maxLv=1599, world=3, mob="Dragon Crew Warrior",   quest="AmazonQuest",         qlv=1, island="Hydra Island",   questCF=CFrame.new(5832.83, 51.68, -1101.51),mobCF=CFrame.new(6141.14, 51.35, -1340.73) },
    { minLv=1600, maxLv=1624, world=3, mob="Dragon Crew Archer",    quest="AmazonQuest",         qlv=2, island="Hydra Island",   questCF=CFrame.new(5833.11, 51.60, -1103.06),mobCF=CFrame.new(6616.41, 441.76, 446.04) },
    { minLv=1625, maxLv=1649, world=3, mob="Female Islander",       quest="AmazonQuest2",        qlv=1, island="Hydra Island",   questCF=CFrame.new(5446.87, 601.62, 749.45), mobCF=CFrame.new(4685.25, 735.80, 815.34) },
    { minLv=1650, maxLv=1699, world=3, mob="Giant Islander",        quest="AmazonQuest2",        qlv=2, island="Hydra Island",   questCF=CFrame.new(5446.87, 601.62, 749.45), mobCF=CFrame.new(4729.09, 590.43, -36.97) },
    { minLv=1700, maxLv=1724, world=3, mob="Marine Commodore",      quest="MarineTreeIsland",    qlv=1, island="Great Tree",     questCF=CFrame.new(2180.54, 27.81, -6741.54),mobCF=CFrame.new(2286.00, 73.13, -7159.80) },
    { minLv=1725, maxLv=1774, world=3, mob="Marine Rear Admiral",   quest="MarineTreeIsland",    qlv=2, island="Great Tree",     questCF=CFrame.new(2179.98, 28.73, -6740.05),mobCF=CFrame.new(3656.77, 160.52, -7001.59) },
    { minLv=1775, maxLv=1799, world=3, mob="Fishman Raider",        quest="DeepForestIsland3",   qlv=1, island="Floating Turtle",questCF=CFrame.new(-10581.65, 330.87, -8761.18),mobCF=CFrame.new(-10407.52, 331.76, -8368.51) },
    { minLv=1800, maxLv=1824, world=3, mob="Fishman Captain",       quest="DeepForestIsland3",   qlv=2, island="Floating Turtle",questCF=CFrame.new(-10581.65, 330.87, -8761.18),mobCF=CFrame.new(-10994.70, 352.38, -9002.11) },
    { minLv=1825, maxLv=1849, world=3, mob="Forest Pirate",         quest="DeepForestIsland",    qlv=1, island="Floating Turtle",questCF=CFrame.new(-13234.04, 331.48, -7625.40),mobCF=CFrame.new(-13274.47, 332.37, -7769.58) },
    { minLv=1850, maxLv=1899, world=3, mob="Mythological Pirate",   quest="DeepForestIsland",    qlv=2, island="Floating Turtle",questCF=CFrame.new(-13234.04, 331.48, -7625.40),mobCF=CFrame.new(-13680.60, 501.08, -6991.18) },
    { minLv=1900, maxLv=1924, world=3, mob="Jungle Pirate",         quest="DeepForestIsland2",   qlv=1, island="Floating Turtle",questCF=CFrame.new(-12680.38, 389.97, -9902.01),mobCF=CFrame.new(-12256.16, 331.73, -10485.83) },
    { minLv=1925, maxLv=1974, world=3, mob="Musketeer Pirate",      quest="DeepForestIsland2",   qlv=2, island="Floating Turtle",questCF=CFrame.new(-12680.38, 389.97, -9902.01),mobCF=CFrame.new(-13457.90, 391.54, -9859.17) },
    { minLv=1975, maxLv=1999, world=3, mob="Reborn Skeleton",       quest="HauntedQuest1",       qlv=1, island="Haunted Castle", questCF=CFrame.new(-9479.21, 141.21, 5566.09),mobCF=CFrame.new(-8763.72, 165.72, 6159.86) },
    { minLv=2000, maxLv=2024, world=3, mob="Living Zombie",         quest="HauntedQuest1",       qlv=2, island="Haunted Castle", questCF=CFrame.new(-9479.21, 141.21, 5566.09),mobCF=CFrame.new(-10144.13, 138.62, 5838.08) },
    { minLv=2025, maxLv=2049, world=3, mob="Demonic Soul",          quest="HauntedQuest2",       qlv=1, island="Haunted Castle", questCF=CFrame.new(-9516.99, 172.01, 6078.46),mobCF=CFrame.new(-9505.87, 172.10, 6158.99) },
    { minLv=2050, maxLv=2074, world=3, mob="Posessed Mummy",        quest="HauntedQuest2",       qlv=2, island="Haunted Castle", questCF=CFrame.new(-9516.99, 172.01, 6078.46),mobCF=CFrame.new(-9582.02, 6.25, 6205.47) },
    { minLv=2075, maxLv=2099, world=3, mob="Peanut Scout",          quest="NutsIslandQuest",     qlv=1, island="Peanut Island",  questCF=CFrame.new(-2104.39, 38.10, -10194.21),mobCF=CFrame.new(-2143.24, 47.72, -10029.99) },
    { minLv=2100, maxLv=2124, world=3, mob="Peanut President",      quest="NutsIslandQuest",     qlv=2, island="Peanut Island",  questCF=CFrame.new(-2104.39, 38.10, -10194.21),mobCF=CFrame.new(-1859.35, 38.10, -10422.42) },
    { minLv=2125, maxLv=2149, world=3, mob="Ice Cream Chef",        quest="IceCreamIslandQuest", qlv=1, island="Ice Cream Island",questCF=CFrame.new(-820.64, 65.81, -10965.79),mobCF=CFrame.new(-872.24, 65.81, -10919.95) },
    { minLv=2150, maxLv=2199, world=3, mob="Ice Cream Commander",   quest="IceCreamIslandQuest", qlv=2, island="Ice Cream Island",questCF=CFrame.new(-820.64, 65.81, -10965.79),mobCF=CFrame.new(-558.06, 112.04, -11290.77) },
    { minLv=2200, maxLv=2224, world=3, mob="Cookie Crafter",        quest="CakeQuest1",          qlv=1, island="Cake Island",    questCF=CFrame.new(-2021.32, 37.79, -12028.72),mobCF=CFrame.new(-2374.13, 37.79, -12125.30) },
    { minLv=2225, maxLv=2249, world=3, mob="Cake Guard",            quest="CakeQuest1",          qlv=2, island="Cake Island",    questCF=CFrame.new(-2021.32, 37.79, -12028.72),mobCF=CFrame.new(-1598.30, 43.77, -12244.58) },
    { minLv=2250, maxLv=2274, world=3, mob="Baking Staff",          quest="CakeQuest2",          qlv=1, island="Cake Island",    questCF=CFrame.new(-1927.91, 37.79, -12842.53),mobCF=CFrame.new(-1887.80, 77.61, -12998.35) },
    { minLv=2275, maxLv=2299, world=3, mob="Head Baker",            quest="CakeQuest2",          qlv=2, island="Cake Island",    questCF=CFrame.new(-1927.91, 37.79, -12842.53),mobCF=CFrame.new(-2216.18, 82.88, -12869.29) },
    { minLv=2300, maxLv=2324, world=3, mob="Cocoa Warrior",         quest="ChocQuest1",          qlv=1, island="Chocolate Island",questCF=CFrame.new(233.22, 29.87, -12201.23),mobCF=CFrame.new(-21.55, 80.57, -12352.38) },
    { minLv=2325, maxLv=2349, world=3, mob="Chocolate Bar Battler", quest="ChocQuest1",          qlv=2, island="Chocolate Island",questCF=CFrame.new(233.22, 29.87, -12201.23),mobCF=CFrame.new(582.59, 77.18, -12463.16) },
    { minLv=2350, maxLv=2374, world=3, mob="Sweet Thief",           quest="ChocQuest2",          qlv=1, island="Chocolate Island",questCF=CFrame.new(150.50, 30.69, -12774.50),mobCF=CFrame.new(165.18, 76.05, -12600.83) },
    { minLv=2375, maxLv=2399, world=3, mob="Candy Rebel",           quest="ChocQuest2",          qlv=2, island="Chocolate Island",questCF=CFrame.new(150.50, 30.69, -12774.50),mobCF=CFrame.new(134.86, 77.24, -12876.54) },
    { minLv=2400, maxLv=2424, world=3, mob="Candy Pirate",          quest="CandyQuest1",         qlv=1, island="Candy Island",  questCF=CFrame.new(-1150.04, 20.37, -14446.33),mobCF=CFrame.new(-1310.50, 26.01, -14562.40) },
    { minLv=2425, maxLv=2449, world=3, mob="Snow Demon",            quest="CandyQuest1",         qlv=2, island="Candy Island",  questCF=CFrame.new(-1150.04, 20.37, -14446.33),mobCF=CFrame.new(-880.20, 71.24, -14538.60) },
    { minLv=2450, maxLv=2474, world=3, mob="Isle Outlaw",           quest="TikiQuest1",          qlv=1, island="Tiki Outpost",  questCF=CFrame.new(-16547.74, 61.13, -173.41),mobCF=CFrame.new(-16442.81, 116.13, -264.46) },
    { minLv=2475, maxLv=2524, world=3, mob="Island Boy",            quest="TikiQuest1",          qlv=2, island="Tiki Outpost",  questCF=CFrame.new(-16547.74, 61.13, -173.41),mobCF=CFrame.new(-16901.26, 84.06, -192.88) },
    { minLv=2525, maxLv=2550, world=3, mob="Isle Champion",         quest="TikiQuest2",          qlv=2, island="Tiki Outpost",  questCF=CFrame.new(-16539.07, 55.68, 1051.57),mobCF=CFrame.new(-16641.67, 235.78, 1031.28) },
    { minLv=2551, maxLv=2850, world=3, mob="Isle Champion",         quest="TikiQuest2",          qlv=2, island="Tiki Outpost",  questCF=CFrame.new(-16539.07, 55.68, 1051.57),mobCF=CFrame.new(-16641.67, 235.78, 1031.28) },
}
getgenv().ChuppyQuestDB = QuestDB

-- ═══════════════════════════════════════════════════════════════════════════════
-- [3.2] QUEST LOOKUP
-- ═══════════════════════════════════════════════════════════════════════════════
local Quest = {}

function Quest.Find(level, world)
    level = level or State.PlayerData.Level
    world = world or State.World
    for _, entry in ipairs(QuestDB) do
        if entry.world == world and level >= entry.minLv and level <= entry.maxLv then return entry end
    end
    return nil
end

function Quest.FindByMob(mobName)
    local search = string.lower(mobName or "")
    for _, entry in ipairs(QuestDB) do
        if string.lower(entry.mob) == search then return entry end
    end
    return nil
end

function Quest.GetCurrentIsland()
    local q = Quest.Find()
    return q and q.island or "Unknown"
end
getgenv().ChuppyQuest = Quest

-- ═══════════════════════════════════════════════════════════════════════════════
-- [3.3] QUEST STATUS READER
-- ═══════════════════════════════════════════════════════════════════════════════
local QuestStatus = {}

function QuestStatus.GetInfo()
    local pg = LP:FindFirstChild("PlayerGui")
    local main = pg and pg:FindFirstChild("Main")
    local questUI = main and main:FindFirstChild("Quest")
    
    if not questUI or not questUI.Visible then 
        return { hasQuest = false, title = "", mob = "" } 
    end

    local title, mob = "", ""
    pcall(function()
        local container = questUI:FindFirstChild("Container")
        local qTitle = container and container:FindFirstChild("QuestTitle")
        local tLbl = qTitle and qTitle:FindFirstChild("Title")
        if tLbl then title = tLbl.Text or "" end
    end)

    if title ~= "" then
        pcall(function()
            local m = string.match(title, "Defeat%s+%d+%s+(.+)")
            if m then mob = m end
        end)
    end

    return { hasQuest = true, title = title, mob = mob }
end

function QuestStatus.IsOnQuest(questName, mobName)
    local info = QuestStatus.GetInfo()
    if not info.hasQuest then return false end
    if mobName then
        if not string.find(string.lower(info.title), string.lower(mobName), 1, true) then return false end
    end
    return true
end
getgenv().ChuppyQuestStatus = QuestStatus

-- ═══════════════════════════════════════════════════════════════════════════════
-- [3.4] QUEST ACTIONS
-- ═══════════════════════════════════════════════════════════════════════════════
local QuestAction = {}

function QuestAction.Abandon() 
    if Remote then Remote.Invoke("AbandonQuest") end 
end

function QuestAction.Start(qName, qlv) 
    if Remote then return Remote.Invoke("StartQuest", qName, qlv) end 
end

function QuestAction.AutoStart(targetQuest)
    if not targetQuest then return false end
    local info = QuestStatus.GetInfo()
    local needSwitch = false

    if not info.hasQuest then
        needSwitch = true
    else
        local key = tostring(targetQuest.quest) .. ":" .. tostring(targetQuest.qlv)
        local t, m = string.lower(info.title), string.lower(targetQuest.mob)
        local match = string.find(t, m, 1, true) or string.find(t, string.sub(m, 1, math.max(4, #m - 1)), 1, true)
        if not match and QuestAction.lastKey ~= key then needSwitch = true end
    end

    if not needSwitch then return false end
    if info.hasQuest then QuestAction.Abandon(); task.wait(0.3) end

    local Farm = getgenv().ChuppyFarm
    if Farm and Farm.Teleport then
        local goFn = Farm.TeleportWait or Farm.Teleport
        goFn(targetQuest.questCF * CFrame.new(0, 4, 2))
        task.wait(0.4)
    end

    -- Đứng yên ~1.5s cho server cập nhật vị trí rồi mới nhận (như Banana), thử lại tối đa 4 lần
    task.wait(1.5)
    local lastRes
    for i = 1, 4 do
        lastRes = QuestAction.Start(targetQuest.quest, targetQuest.qlv)
        task.wait(0.8)
        if QuestStatus.GetInfo().hasQuest then
            QuestAction.lastKey = tostring(targetQuest.quest) .. ":" .. tostring(targetQuest.qlv)
            return true
        end
        local h = PlayerUtils.GetHRP()
        if h then h.CFrame = targetQuest.questCF * CFrame.new(0, 3, 1) end
        task.wait(1)
    end
    warn("[Chuppy Farm] StartQuest thất bại:", tostring(targetQuest.quest), tostring(targetQuest.qlv), tostring(lastRes))
    return true
end
getgenv().ChuppyQuestAction = QuestAction

-- ═══════════════════════════════════════════════════════════════════════════════
-- [3.5] TELEPORT HELPERS
-- ═══════════════════════════════════════════════════════════════════════════════
-- Quest ĐỘNG: đọc thẳng từ module của game (giống Banana), không phụ thuộc bảng cứng
do
    local RSvc = game:GetService("ReplicatedStorage")
    local okQ, QuestsMod = pcall(function() return require(RSvc:WaitForChild("Quests", 10)) end)
    local okG, Guide = pcall(function() return require(RSvc:WaitForChild("GuideModule", 10)) end)
    local EXCL = { "Control-Control", "Buddha-Buddha", "Diamond-Diamond", "Falcon-Falcon" }
    local origFind, spawnCache = Quest.Find, {}
    local function SpawnFor(mob)
        local c = spawnCache[mob]
        if c and c.Parent then return c end
        local wo = workspace:FindFirstChild("_WorldOrigin")
        local folder = wo and wo:FindFirstChild("EnemySpawns")
        if not folder then return nil end
        local lm = string.lower(mob)
        for _, p in ipairs(folder:GetChildren()) do
            if p:IsA("BasePart") and string.find(string.lower(p.Name), lm, 1, true) then spawnCache[mob] = p return p end
        end
    end
    function Quest.Find(level, world)
        if okQ and okG and Guide.Data and Guide.Data.NPCList then
            local best, minLv = nil, 0
            for _, info in pairs(Guide.Data.NPCList) do
                local qd = QuestsMod[info.InternalQuestName]
                if qd and not table.find(EXCL, info.InternalQuestName) then
                    for id, lv in pairs(info.Levels) do
                        local q = qd[id]
                        local mob, cnt
                        if q and q.Task then mob, cnt = next(q.Task) end
                        if cnt and cnt > 1 and lv <= level and lv >= minLv then
                            minLv = lv
                            best = { mob = mob, quest = info.InternalQuestName, qlv = id, minLv = lv, maxLv = lv,
                                     questCF = CFrame.new(info.Position), world = world }
                        end
                    end
                end
            end
            if best then
                local sp = SpawnFor(best.mob)
                best.mobCF = sp and sp.CFrame or best.questCF
                return best
            end
        end
        return origFind(level, world)
    end
end

local Farm = {}
local currentTween = nil

local FarmRS = game:GetService("RunService")
Farm._target, Farm._speed, Farm._nc = nil, 350, 0
FarmRS.Heartbeat:Connect(function(dt)
    local tgt = Farm._target
    if not tgt then return end
    local hrp = PlayerUtils.GetHRP()
    if not hrp then Farm._target = nil return end
    local delta = tgt.Position - hrp.Position
    local d = delta.Magnitude
    local step = Farm._speed * math.min(dt, 0.05)
    local rot = tgt - tgt.Position
    if d <= math.max(step, 2) then
        hrp.CFrame = tgt
        Farm._target = nil
    else
        hrp.CFrame = CFrame.new(hrp.Position + delta.Unit * step) * rot
    end
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    Farm._nc = Farm._nc + 1
    if Farm._nc % 6 == 0 and hrp.Parent then
        for _, v in ipairs(hrp.Parent:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- Đặt đích bay (gọi liên tục mỗi frame cũng không bị giật/khởi động lại)
function Farm.Teleport(targetCF, speed)
    if not targetCF then return false end
    local hrp = PlayerUtils.GetHRP()
    if not hrp then return false end
    if not hrp:FindFirstChild("FloatForce") then
        local bv = Instance.new("BodyVelocity")
        bv.Name, bv.MaxForce, bv.Velocity = "FloatForce", Vector3.new(1e9, 1e9, 1e9), Vector3.zero
        bv.Parent = hrp
    end
    Farm._speed = speed or State.FarmSpeed or 350
    if (hrp.Position - targetCF.Position).Magnitude < 150 then
        Farm._target = nil
        hrp.CFrame = targetCF
        hrp.AssemblyLinearVelocity = Vector3.zero
        return true
    end
    Farm._target = targetCF
    return true
end

function Farm.StopTween()
    Farm._target = nil
    local h = PlayerUtils.GetHRP()
    local f = h and h:FindFirstChild("FloatForce")
    if f then f:Destroy() end
end

-- Bay và CHỜ tới nơi (dùng cho nhận quest, chuyển đảo)
function Farm.TeleportWait(cf, speed, timeout)
    if not Farm.Teleport(cf, speed) then return false end
    local hrp = PlayerUtils.GetHRP()
    local t0 = tick()
    timeout = timeout or (hrp and (hrp.Position - cf.Position).Magnitude / (Farm._speed or 350) + 3 or 8)
    while Farm._target and tick() - t0 < timeout do task.wait(0.05) end
    if Farm._target then Farm._target = nil; local h = PlayerUtils.GetHRP(); if h then h.CFrame = cf end end
    return true
end

function Farm.Snap(targetCF)
    local hrp = PlayerUtils.GetHRP()
    if not hrp or not targetCF then return false end
    hrp.CFrame = targetCF
    return true
end
getgenv().ChuppyFarm = Farm

-- ═══════════════════════════════════════════════════════════════════════════════
-- [3.6] COMBAT HELPERS
-- ═══════════════════════════════════════════════════════════════════════════════
local Combat = {}

function Combat.EquipWeapon(weaponType)
    if not weaponType then return false end
    local char = PlayerUtils.GetCharacter()
    local hum = PlayerUtils.GetHumanoid()
    if not char or not hum then return false end

    local current = char:FindFirstChildOfClass("Tool")
    if current and current.ToolTip == weaponType then return true end

    for _, tool in pairs(LP.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.ToolTip == weaponType then
            pcall(function() hum:EquipTool(tool) end)
            return true
        end
    end
    return false
end

function Combat.AutoHaki()
    local char = PlayerUtils.GetCharacter()
    if char and not char:FindFirstChild("HasBuso") then pcall(function() Remote.Buso() end) end
end

function Combat.Attack()
    local char = PlayerUtils.GetCharacter()
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then pcall(function() tool:Activate() end) end
end

local noclipConn = nil
function Combat.SetNoclip(enable)
    if enable then
        if noclipConn then return end
        noclipConn = RunService.Stepped:Connect(function()
            local char = PlayerUtils.GetCharacter()
            if not char then return end
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
            end
        end)
        Track(noclipConn)
    else
        if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
    end
end

function Combat.FreezeMob(mob)
    if not mob then return end
    pcall(function()
        local hrp = mob:FindFirstChild("HumanoidRootPart")
        local hum = mob:FindFirstChildOfClass("Humanoid")
        if hrp then hrp.CanCollide = false end
        if hum then hum.WalkSpeed = 0; hum.JumpPower = 0 end
    end)
end

-- FIX: Thêm 2 hàm bị thiếu từ bản cũ
function Combat.SetWalkSpeed(speed)
    local hum = PlayerUtils.GetHumanoid()
    if hum then pcall(function() hum.WalkSpeed = speed end) end
end

function Combat.SetJumpPower(power)
    local hum = PlayerUtils.GetHumanoid()
    if hum then pcall(function() hum.JumpPower = power end) end
end

getgenv().ChuppyCombat = Combat

-- ═══════════════════════════════════════════════════════════════════════════════
-- [3.7] AUTO FARM LEVEL LOOP
-- ═══════════════════════════════════════════════════════════════════════════════
local lastPos = Vector3.zero
local lastPosTime = tick()
local stuckCount = 0
local lastLevel = PlayerUtils.GetLevel()

local function FarmStep()
    PlayerUtils.UpdateData()
    local level = State.PlayerData.Level
    local world = State.World

    if level > lastLevel then
        local Webhook = getgenv().ChuppyWebhook
        if Webhook then Webhook.LevelUp(lastLevel, level) end
        Notify("Level Up", "Lv " .. lastLevel .. " → " .. level, "success")
        lastLevel = level
    end

    local quest = Quest.Find(level, world)
    if not quest then return end
    State.CurrentQuest = quest

    if State.CurrentFarmMode == "Quest" then
        if QuestAction.AutoStart(quest) then return end

        -- Học từ Banana: đánh DỨT ĐIỂM từng con, bay cạnh quái (7,20,0), gom quái, chưa thấy quái thì bay tới spawn
        local mob = Monster.Find(quest.mob)
        if not mob then
            local sp = quest.mobCF
            repeat
                task.wait()
                Farm.Teleport(sp * CFrame.new(0, 60, 0), 350)
                local h = PlayerUtils.GetHRP()
                local near = h and (h.Position - sp.Position).Magnitude <= 100
            until near or Monster.Find(quest.mob) or not State.AutoFarm or not PlayerUtils.IsAlive()
            task.wait(0.3)
            return
        end

        State.CurrentTarget = mob
        local counted = false
        repeat
            task.wait()
            local root = mob:FindFirstChild("HumanoidRootPart")
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local hrp = PlayerUtils.GetHRP()
            if not root or not hum or hum.Health <= 0 or not hrp then break end

            -- sizepart: tắt va chạm quái trong tầm 50
            if (hrp.Position - root.Position).Magnitude <= 50 then
                for _, p in ipairs(mob:GetDescendants()) do
                    if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
                end
            end
            -- gom quái cùng tên về chỗ con đang đánh
            if State.BringMob ~= false then
                local n = 0
                local folder = workspace:FindFirstChild("Enemies")
                if folder then
                    for _, o in ipairs(folder:GetChildren()) do
                        if o ~= mob and o.Name == mob.Name and n < (State.BringCount or 3) then
                            local oh, orr = o:FindFirstChildOfClass("Humanoid"), o:FindFirstChild("HumanoidRootPart")
                            if oh and orr and oh.Health > 0 and (orr.Position - root.Position).Magnitude <= 200 then
                                orr.CFrame = root.CFrame
                                orr.CanCollide = false
                                oh.WalkSpeed = 0
                                n = n + 1
                            end
                        end
                    end
                end
            end
            Combat.EquipWeapon(State.CurrentWeapon or "Melee")
            if State.AutoHaki then Combat.AutoHaki() end
            Combat.Attack()
            local side = (State.CurrentWeapon == "Blox Fruit") and -7 or 7
            Farm.Teleport(root.CFrame * CFrame.new(side, State.Height or 20, 0), 350)
            if not counted and hum.Health <= 0 then counted = true end
        until not State.AutoFarm or not PlayerUtils.IsAlive() or not Monster.IsAlive(mob)
        if not Monster.IsAlive(mob) then State.Stats.MobsKilled = State.Stats.MobsKilled + 1 end
        return
    else
        local mob = Monster.FindNearest(3000)
        if not mob then return end
        local hrp = PlayerUtils.GetHRP()
        if not hrp then return end

        local mobPos = mob.HumanoidRootPart.Position + Vector3.new(0, 15, 0)
        Farm.Teleport(CFrame.new(mobPos), 320)
        Combat.EquipWeapon(State.CurrentWeapon or "Melee")
        if State.AutoHaki then Combat.AutoHaki() end
        Combat.Attack()
        if State.BringMob then Monster.Bring(mob, hrp.CFrame * CFrame.new(0, 0, -5)) end
    end

    local hrp = PlayerUtils.GetHRP()
    if hrp then
        if (hrp.Position - lastPos).Magnitude < 1 then
            if tick() - lastPosTime > 5 then
                stuckCount = stuckCount + 1
                if stuckCount >= 2 then hrp.CFrame = hrp.CFrame + Vector3.new(0, 20, 0); stuckCount = 0 end
                lastPosTime = tick()
            end
        else
            lastPosTime = tick()
            stuckCount = 0
        end
        lastPos = hrp.Position
    end
end

SafeSpawn(function()
    while State.Running do
        task.wait(State.TickRate or 0.1)
        if State.AutoFarm and PlayerUtils.IsAlive() then
            local ok, err = pcall(FarmStep)
            if not ok then warn("[Chuppy Farm] Error:", err); task.wait(1) end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [3.8] LEVEL STATS TRACKING
-- ═══════════════════════════════════════════════════════════════════════════════
local LevelStats = {}
local startLevel = PlayerUtils.GetLevel()

function LevelStats.GetSession()
    local cur = PlayerUtils.GetLevel()
    return {
        startLevel = startLevel, currentLevel = cur, levelsGained = cur - startLevel,
        mobsKilled = State.Stats.MobsKilled, sessionTime = math.floor(tick() - State.StartTime)
    }
end
getgenv().ChuppyLevelStats = LevelStats

-- ═══════════════════════════════════════════════════════════════════════════════
-- [3.9] PUBLIC API + EXPORTS
-- ═══════════════════════════════════════════════════════════════════════════════
local Chuppy = getgenv().Chuppy
if not Chuppy then warn("[Chuppy Farm] LỖI: Chưa load Part 2!"); return end

-- ✅ FIX LỖI DÒNG 518: Khởi tạo Chuppy.Farm là 1 table trống trước khi gán
Chuppy.Farm = Chuppy.Farm or {}

-- Gán các module từ Part 3
Chuppy.Quest        = Quest
Chuppy.QuestStatus  = QuestStatus
Chuppy.QuestAction  = QuestAction
Chuppy.Combat       = Combat
Chuppy.LevelStats   = LevelStats

-- Gán các hàm vào Chuppy.Farm an toàn
Chuppy.Farm.Find      = Quest.Find
Chuppy.Farm.GetIsland = Quest.GetCurrentIsland
Chuppy.Farm.Teleport  = Farm.Teleport
Chuppy.Farm.StopTween = Farm.StopTween
Chuppy.Farm.Snap      = Farm.Snap

function Chuppy.StartFarm()
    State.AutoFarm = true
    Notify("Auto Farm", "Đã BẬT", "success")
end

function Chuppy.StopFarm()
    State.AutoFarm = false
    Farm.StopTween()
    Notify("Auto Farm", "Đã TẮT", "warning")
end

function Chuppy.ToggleFarm()
    if State.AutoFarm then Chuppy.StopFarm() else Chuppy.StartFarm() end
end

function Chuppy.SetFarmMode(mode)
    State.CurrentFarmMode = mode
    Notify("Farm", "Mode: " .. mode, "info")
end

function Chuppy.SetWeapon(weaponType)
    State.CurrentWeapon = weaponType
    Combat.EquipWeapon(weaponType)
    Notify("Weapon", "Đã chọn: " .. weaponType, "info")
end

-- Khôi phục weapon từ config
if State.CurrentWeapon then Combat.EquipWeapon(State.CurrentWeapon) end

print("═══════════════════════════════════════════════════════════════════════════════")
print("  ✅ PART 3/10 — AUTO FARM LEVEL LOADED")
print("  📦 QuestDB · Combat · Teleport · Anti-Stuck · Public API")
print("  👉 Gõ 'tiếp' để nhận PART 4/10: BOSS + MATERIAL + CHEST + FRUIT")
print("═══════════════════════════════════════════════════════════════════════════════")

end)() -- End IIFE
-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐾 CHUPPY HUB V2 — PART 4/10: BOSS + MATERIAL + CHEST + FRUIT
-- Phiên bản sạch: IIFE scope · không return giữa file · export qua getgenv()
-- ═══════════════════════════════════════════════════════════════════════════════
;(function()

-- ═══════════════════════════════════════════════════════════════════════════════
-- [4.0] SERVICES + IMPORTS
-- ═══════════════════════════════════════════════════════════════════════════════
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LP = Players.LocalPlayer

-- Lấy module từ Part 2 + Part 3
local State        = getgenv().ChuppyState
local PlayerUtils  = getgenv().ChuppyPlayer
local Monster      = getgenv().ChuppyMonster
local Remote       = getgenv().ChuppyRemote
local Farm         = getgenv().ChuppyFarm
local Combat       = getgenv().ChuppyCombat
local Notify       = getgenv().Chuppy.Notify
local Track        = getgenv().Chuppy.Track
local SafeSpawn    = getgenv().Chuppy.SafeSpawn
local CheckCooldown = getgenv().Chuppy.CheckCooldown

if not State or not PlayerUtils or not Farm or not Combat then
    warn("[Chuppy Part 4] LỖI: Chưa load Part 2 & 3!")
    return
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [4.1] BOSS DATABASE
-- ═══════════════════════════════════════════════════════════════════════════════
local BossDB = {
    -- SEA 1
    { name="The Gorilla King",   world=1, level=1,    hp=1000,    note="Starter boss" },
    { name="Bobby",              world=1, level=10,   hp=1000,    note="Jungle" },
    { name="Yeti",               world=1, level=90,   hp=2500,    note="Snow Island" },
    { name="Mob Leader",         world=1, level=120,  hp=5000,    note="Swan Quest" },
    { name="Vice Admiral",       world=1, level=130,  hp=5000,    note="Marine Fortress" },
    { name="Saber Expert",       world=1, level=200,  hp=15000,   note="Saber Sword" },
    { name="Warden",             world=1, level=220,  hp=20000,   note="Prison" },
    { name="Chief Warden",       world=1, level=230,  hp=25000,   note="Prison" },
    { name="Swan",               world=1, level=240,  hp=25000,   note="Swan Room" },
    { name="Magma Admiral",      world=1, level=330,  hp=30000,   note="Magma Village" },
    { name="Fishman Lord",       world=1, level=400,  hp=40000,   note="Underwater" },
    { name="Wysper",             world=1, level=475,  hp=40000,   note="Upper Sky" },
    { name="Thunder God",        world=1, level=525,  hp=50000,   note="Upper Sky" },
    { name="Cyborg",             world=1, level=600,  hp=50000,   note="Fountain" },
    { name="Ice Admiral",        world=1, level=600,  hp=50000,   note="Frozen Village" },
    -- SEA 2
    { name="Diamond",            world=2, level=800,  hp=25000,   note="Ice Quest" },
    { name="Jeremy",             world=2, level=850,  hp=35000,   note="Human V2" },
    { name="Fajita",             world=2, level=875,  hp=40000,   note="Zone 2" },
    { name="Don Swan",           world=2, level=900,  hp=50000,   note="Swan Mansion" },
    { name="Smoke Admiral",      world=2, level=950,  hp=60000,   note="Smoke Island" },
    { name="Awakened Ice Admiral", world=2, level=1000, hp=80000, note="Snow Mountain" },
    { name="Tide Keeper",        world=2, level=1100, hp=100000,  note="Hot and Cold" },
    { name="Cursed Captain",     world=2, level=1250, hp=100000,  note="Cursed Ship" },
    { name="Darkbeard",          world=2, level=1400, hp=250000,  note="Dark Arena" },
    { name="Order",              world=2, level=1350, hp=150000,  note="Cyborg Quest" },
    -- SEA 3
    { name="Stone",              world=3, level=1600, hp=75000,   note="Port" },
    { name="Island Empress",     world=3, level=1675, hp=100000,  note="Amazon" },
    { name="Kilo Admiral",       world=3, level=1725, hp=150000,  note="Great Tree" },
    { name="Captain Elephant",   world=3, level=1750, hp=200000,  note="Great Tree" },
    { name="Beautiful Pirate",   world=3, level=1850, hp=200000,  note="Floating Turtle" },
    { name="Longma",             world=3, level=2000, hp=250000,  note="Tushita Quest" },
    { name="Cake Queen",         world=3, level=2250, hp=300000,  note="Cake Island" },
    { name="Soul Reaper",        world=3, level=2050, hp=300000,  note="Haunted Castle" },
    { name="rip_indra True Form", world=3, level=2500, hp=500000, note="God's Chalice" },
    { name="Cake Prince",        world=3, level=2275, hp=500000,  note="Summon Boss" },
    { name="Dough King",         world=3, level=2400, hp=700000,  note="Summon Boss" },
    { name="Tyrant of the Skies", world=3, level=2550, hp=1000000, note="Tiki Event" },
}
getgenv().ChuppyBossDB = BossDB

-- ═══════════════════════════════════════════════════════════════════════════════
-- [4.2] BOSS FARM
-- ═══════════════════════════════════════════════════════════════════════════════
local BossFarm = {}

function BossFarm.Find(bossName) return Monster.Find(bossName) end

function BossFarm.GetNames(world)
    world = world or State.World
    local names = {}
    for _, boss in ipairs(BossDB) do
        if boss.world == world then table.insert(names, boss.name) end
    end
    return names
end

function BossFarm.GetAvailable()
    local lv = PlayerUtils.GetLevel()
    local world = State.World
    local list = {}
    for _, boss in ipairs(BossDB) do
        if boss.world == world and boss.level <= lv then table.insert(list, boss) end
    end
    return list
end

local bossTracking = {}
local function TrackBossDeath(boss)
    if not boss or bossTracking[boss] then return end
    bossTracking[boss] = true
    local hum = boss:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local conn
    conn = hum.Died:Connect(function()
        State.Stats.BossesKilled = (State.Stats.BossesKilled or 0) + 1
        local Webhook = getgenv().ChuppyWebhook
        if Webhook then Webhook.Boss(boss.Name, nil) end
        Notify("Boss Killed", boss.Name, "success", 3)
        if conn then conn:Disconnect() end
        bossTracking[boss] = nil
    end)
    Track(conn)
end

local function FarmBossStep(bossName)
    local boss = BossFarm.Find(bossName)
    if not boss then
        State.CurrentBoss = nil
        if State.HopBoss then
            local ServerManager = getgenv().ChuppyServer
            if ServerManager and CheckCooldown("hop-boss", 20) then
                ServerManager.Hop()
            end
        else
            Farm.StopTween()
        end
        return
    end
    State.CurrentBoss = boss
    if not Monster.IsAlive(boss) then return end

    local hrp = PlayerUtils.GetHRP()
    if not hrp then return end

    Combat.FreezeMob(boss)
    local offset = State.Height or 15
    local targetPos = boss.HumanoidRootPart.Position + Vector3.new(0, offset, 0)
    Farm.Teleport(CFrame.new(targetPos), 320)

    Combat.EquipWeapon(State.CurrentWeapon or "Melee")
    if State.AutoHaki then Combat.AutoHaki() end
    Combat.Attack()
    TrackBossDeath(boss)
end

SafeSpawn(function()
    while State.Running do
        task.wait(0.15)
        if State.AutoFarmBoss and PlayerUtils.IsAlive() then
            local bossName = State.CurrentBoss or State.SelectedBoss
            if bossName and bossName ~= "" then
                local ok, err = pcall(FarmBossStep, bossName)
                if not ok then warn("[Chuppy Boss] Error:", err); task.wait(1) end
            end
        end
    end
end)
getgenv().ChuppyBossFarm = BossFarm

-- ═══════════════════════════════════════════════════════════════════════════════
-- [4.3] BOSS HOP
-- ═══════════════════════════════════════════════════════════════════════════════
local BossHop = {}

function BossHop.Find(bossName, callback)
    if not bossName then return end
    Notify("Boss Hop", "Đang tìm " .. bossName, "info")
    SafeSpawn(function()
        for attempt = 1, 10 do
            if not State.Running then return end
            local boss = Monster.Find(bossName)
            if boss and Monster.IsAlive(boss) then
                Notify("Boss Hop", "Đã tìm thấy " .. bossName, "success")
                if callback then pcall(callback, boss) end
                return
            end
            local ServerManager = getgenv().ChuppyServer
            if not ServerManager then break end
            ServerManager.Hop()
            task.wait(15)
        end
        Notify("Boss Hop", "Không tìm thấy sau 10 lần", "warning")
    end)
end
getgenv().ChuppyBossHop = BossHop

-- ═══════════════════════════════════════════════════════════════════════════════
-- [4.4] MATERIAL DATABASE
-- ═══════════════════════════════════════════════════════════════════════════════
local MaterialDB = {
    -- SEA 1
    { name="Leather",       world=1, mobs={"Brute"},                              mobCF=CFrame.new(-1140.08, 14.80, 4322.92) },
    { name="Scrap Metal",   world=1, mobs={"Brute", "Desert Officer"},            mobCF=CFrame.new(-1140.08, 14.80, 4322.92) },
    { name="Magma Ore",     world=1, mobs={"Military Spy", "Military Soldier"},   mobCF=CFrame.new(-5802.86, 86.26, 8828.85) },
    { name="Angel Wings",   world=1, mobs={"Royal Soldier", "God's Guard"},       mobCF=CFrame.new(-7836.75, 5645.66, -1790.62) },
    -- SEA 2
    { name="Radioactive Material", world=2, mobs={"Factory Staff"},               mobCF=CFrame.new(73.07, 81.86, -27.47) },
    { name="Mystic Droplet", world=2, mobs={"Water Fighter", "Sea Soldier"},      mobCF=CFrame.new(-3352.90, 285.01, -10534.84) },
    { name="Magma Ore",     world=2, mobs={"Lava Pirate", "Magma Ninja"},         mobCF=CFrame.new(-5213.33, 49.73, -4701.45) },
    { name="Leather",       world=2, mobs={"Marine Captain", "Marine Lieutenant"}, mobCF=CFrame.new(-1861.23, 80.17, -3254.69) },
    { name="Scrap Metal",   world=2, mobs={"Mercenary", "Raider"},                mobCF=CFrame.new(-1004.32, 80.15, 1424.61) },
    { name="Ectoplasm",     world=2, mobs={"Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer"}, mobCF=CFrame.new(1037.80, 125.09, 32911.60) },
    -- SEA 3
    { name="Leather",       world=3, mobs={"Pirate Millionaire"},                 mobCF=CFrame.new(-245.99, 47.30, 5584.10) },
    { name="Scrap Metal",   world=3, mobs={"Pirate Millionaire"},                 mobCF=CFrame.new(-245.99, 47.30, 5584.10) },
    { name="Conjured Cocoa", world=3, mobs={"Chocolate Bar Battler", "Cocoa Warrior"}, mobCF=CFrame.new(582.59, 77.18, -12463.16) },
    { name="Dragon Scale",  world=3, mobs={"Dragon Crew Warrior", "Dragon Crew Archer"}, mobCF=CFrame.new(6141.14, 51.35, -1340.73) },
    { name="Gunpowder",     world=3, mobs={"Pistol Billionaire"},                 mobCF=CFrame.new(-187.33, 86.23, 6013.51) },
    { name="Fish Tail",     world=3, mobs={"Fishman Captain", "Fishman Raider"},  mobCF=CFrame.new(-10994.70, 352.38, -9002.11) },
    { name="Mini Tusk",     world=3, mobs={"Mythological Pirate"},                mobCF=CFrame.new(-13680.60, 501.08, -6991.18) },
}
getgenv().ChuppyMaterialDB = MaterialDB

-- ═══════════════════════════════════════════════════════════════════════════════
-- [4.5] MATERIAL FARM
-- ═══════════════════════════════════════════════════════════════════════════════
local MaterialFarm = {}

function MaterialFarm.GetNames(world)
    world = world or State.World
    local seen, list = {}, {}
    for _, m in ipairs(MaterialDB) do
        if m.world == world and not seen[m.name] then
            seen[m.name] = true
            table.insert(list, m.name)
        end
    end
    return list
end

function MaterialFarm.GetData(name, world)
    world = world or State.World
    for _, m in ipairs(MaterialDB) do
        if m.name == name and m.world == world then return m end
    end
    return nil
end

function MaterialFarm.FarmStep(materialName)
    local data = MaterialFarm.GetData(materialName)
    if not data then return end

    local targetMob
    for _, mobName in ipairs(data.mobs) do
        targetMob = Monster.Find(mobName)
        if targetMob and Monster.IsAlive(targetMob) then break end
    end

    if not targetMob or not Monster.IsAlive(targetMob) then
        Farm.Teleport(data.mobCF + Vector3.new(0, 15, 0), 320)
        return
    end

    local hrp = PlayerUtils.GetHRP()
    if not hrp then return end

    State.CurrentTarget = targetMob
    local mobPos = targetMob.HumanoidRootPart.Position + Vector3.new(0, State.Height or 15, 0)
    Farm.Teleport(CFrame.new(mobPos), 320)

    Combat.EquipWeapon(State.CurrentWeapon or "Melee")
    if State.AutoHaki then Combat.AutoHaki() end
    Combat.Attack()
    if State.BringMob then Monster.Bring(targetMob, hrp.CFrame * CFrame.new(0, 0, -5)) end
    Combat.FreezeMob(targetMob)
end

SafeSpawn(function()
    while State.Running do
        task.wait(0.1)
        if State.AutoFarmMaterial and PlayerUtils.IsAlive() then
            local matName = State.SelectedMaterial
            if matName and matName ~= "" then
                local ok, err = pcall(MaterialFarm.FarmStep, matName)
                if not ok then warn("[Chuppy Material] Error:", err); task.wait(1) end
            end
        end
    end
end)
getgenv().ChuppyMaterialFarm = MaterialFarm

-- ═══════════════════════════════════════════════════════════════════════════════
-- [4.6] CHEST SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════
local Chest = {}

function Chest.GetAll()
    local list = {}
    local tagged = CollectionService:GetTagged("_ChestTagged")
    for _, ch in ipairs(tagged) do
        if not ch:GetAttribute("IsDisabled") and not ch:FindFirstChild("Ignored") then
            table.insert(list, ch)
        end
    end
    return list
end

function Chest.FindNearest()
    local hrp = PlayerUtils.GetHRP()
    if not hrp then return nil end
    local nearest, shortest = nil, math.huge
    for _, ch in ipairs(Chest.GetAll()) do
        local ok, pos = pcall(function() return ch:GetPivot().Position end)
        if ok and pos then
            local d = (pos - hrp.Position).Magnitude
            if d < shortest then shortest = d; nearest = ch end
        end
    end
    return nearest
end

function Chest.MarkCollected(ch)
    if not ch or ch:FindFirstChild("Ignored") then return end
    local tag = Instance.new("IntValue"); tag.Name = "Ignored"; tag.Parent = ch
end

function Chest.Collect(ch)
    if not ch then return false end
    local hrp = PlayerUtils.GetHRP()
    if not hrp then return false end
    local pos = ch:GetPivot().Position
    if (hrp.Position - pos).Magnitude > 5 then
        Farm.Teleport(ch:GetPivot(), 400)
        return false
    end
    Farm.StopTween()
    pcall(function()
        firetouchinterest(hrp, ch, 0)
        task.wait(0.05)
        firetouchinterest(hrp, ch, 1)
    end)
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, "Space", false, true)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, "Space", false, true)
    end)
    State.Stats.ChestsCollected = (State.Stats.ChestsCollected or 0) + 1
    Chest.MarkCollected(ch)
    return true
end

SafeSpawn(function()
    while State.Running do
        task.wait(0.5)
        if State.AutoFarmChest and PlayerUtils.IsAlive() then
            local ch = Chest.FindNearest()
            if ch then
                local ok, err = pcall(Chest.Collect, ch)
                if not ok then warn("[Chuppy Chest] Error:", err) end
            end
        end
    end
end)
getgenv().ChuppyChest = Chest

-- ═══════════════════════════════════════════════════════════════════════════════
-- [4.7] FRUIT SNIPER
-- ═══════════════════════════════════════════════════════════════════════════════
local FruitSniper = {}

local FRUIT_VALUES = {
    ["Dragon-Dragon"] = 3500000, ["Leopard-Leopard"] = 5000000, ["Kitsune-Kitsune"] = 8000000,
    ["Venom-Venom"] = 3000000, ["Dough-Dough"] = 2800000, ["Spirit-Spirit"] = 3400000,
    ["T-Rex-T-Rex"] = 2700000, ["Mammoth-Mammoth"] = 2300000, ["Gravity-Gravity"] = 2500000,
    ["Shadow-Shadow"] = 2450000, ["Blizzard-Blizzard"] = 2400000, ["Portal-Portal"] = 2000000,
    ["Pain-Pain"] = 2300000, ["Control-Control"] = 3200000, ["Phoenix-Phoenix"] = 1800000,
    ["Buddha-Buddha"] = 1200000, ["Love-Love"] = 1300000, ["Spider-Spider"] = 1500000,
    ["Sound-Sound"] = 1700000, ["Rumble-Rumble"] = 2100000,
}

function FruitSniper.GetAllFruits()
    local list = {}
    for _, v in ipairs(workspace:GetChildren()) do
        if (v:IsA("Tool") or v:IsA("Model")) and v.Name:find("Fruit") and v:FindFirstChild("Handle") then
            table.insert(list, v)
        end
    end
    return list
end

function FruitSniper.FindNearest()
    local hrp = PlayerUtils.GetHRP()
    if not hrp then return nil end
    local nearest, shortest = nil, math.huge
    for _, fruit in ipairs(FruitSniper.GetAllFruits()) do
        local handle = fruit:FindFirstChild("Handle")
        if handle then
            local d = (handle.Position - hrp.Position).Magnitude
            if d < shortest then shortest = d; nearest = fruit end
        end
    end
    return nearest
end

function FruitSniper.GetValue(fruitName)
    local clean = fruitName:gsub(" Fruit", ""):gsub(" %-.*", "")
    for k, v in pairs(FRUIT_VALUES) do
        local kClean = k:gsub(" %-.*", "")
        if kClean == clean or k == fruitName then return v end
    end
    return 0
end

SafeSpawn(function()
    while State.Running do
        task.wait(0.3)
        if State.TeleportToFruit and PlayerUtils.IsAlive() then
            local fruit = FruitSniper.FindNearest()
            if fruit and fruit:FindFirstChild("Handle") then
                local handle = fruit.Handle
                local hrp = PlayerUtils.GetHRP()
                if not hrp then continue end
                local d = (hrp.Position - handle.Position).Magnitude
                if d <= 5 then
                    Farm.StopTween()
                    pcall(function()
                        firetouchinterest(hrp, handle, 0)
                        task.wait(0.05)
                        firetouchinterest(hrp, handle, 1)
                    end)
                else
                    Farm.Teleport(handle.CFrame, 500)
                end
            end
        end
    end
end)
getgenv().ChuppyFruitSniper = FruitSniper

-- ═══════════════════════════════════════════════════════════════════════════════
-- [4.8] FRUIT SHOP SNIPER
-- ═══════════════════════════════════════════════════════════════════════════════
local FruitShop = {}

function FruitShop.GetStock()
    if not Remote then return {} end
    local res = Remote.Invoke("GetFruits", false)
    if type(res) ~= "table" then return {} end
    return res
end

function FruitShop.IsWanted(fruitName, whitelist)
    if not whitelist then return false end
    for _, wl in ipairs(whitelist) do
        if string.find(string.lower(fruitName), string.lower(wl), 1, true) then return true end
    end
    return false
end

function FruitShop.TryBuy(wantedList)
    if not wantedList or #wantedList == 0 then return false end
    local stock = FruitShop.GetStock()
    local Data = LP:FindFirstChild("Data")
    local df = Data and Data:FindFirstChild("DevilFruit")
    local currentFruit = df and df.Value or ""

    for _, fruit in ipairs(stock) do
        if fruit.OnSale and FruitShop.IsWanted(fruit.Name, wantedList) then
            if currentFruit ~= fruit.Name then
                Remote.Invoke("PurchaseRawFruit", fruit.Name)
                local Webhook = getgenv().ChuppyWebhook
                if Webhook then Webhook.Fruit(fruit.Name, fruit.Price or 0) end
                Notify("Fruit Shop", "Đã mua: " .. fruit.Name, "success", 4)
                return true
            end
        end
    end
    return false
end

SafeSpawn(function()
    while State.Running do
        task.wait(5)
        if State.BuyBloxFruitShop and State.BloxFruitSniperList then
            local whitelist = {}
            for name, on in pairs(State.BloxFruitSniperList) do
                if on then table.insert(whitelist, name) end
            end
            if #whitelist > 0 then pcall(function() FruitShop.TryBuy(whitelist) end) end
        end
    end
end)
getgenv().ChuppyFruitShop = FruitShop

-- ═══════════════════════════════════════════════════════════════════════════════
-- [4.9] AUTO STORE FRUIT
-- ═══════════════════════════════════════════════════════════════════════════════
local AutoStore = {}

function AutoStore.GetHeld()
    local list = {}
    for _, item in ipairs(LP.Backpack:GetChildren()) do
        if item:IsA("Tool") and item.Name:find("Fruit") then table.insert(list, item) end
    end
    local char = PlayerUtils.GetCharacter()
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") and item.Name:find("Fruit") then table.insert(list, item) end
        end
    end
    return list
end

function AutoStore.StoreOne(fruit)
    if not fruit or not fruit.Parent or not Remote then return false end
    local originalName = fruit:GetAttribute("OriginalName") or fruit.Name
    local ok = Remote.Invoke("StoreFruit", originalName, fruit)
    if ok then
        State.Stats.FruitsStored = (State.Stats.FruitsStored or 0) + 1
        return true
    end
    return false
end

function AutoStore.StoreAll()
    local fruits = AutoStore.GetHeld()
    if #fruits == 0 then return 0 end
    local count = 0
    for _, fruit in ipairs(fruits) do
        if AutoStore.StoreOne(fruit) then count = count + 1 end
        task.wait(0.35)
    end
    return count
end

SafeSpawn(function()
    while State.Running do
        task.wait(3)
        if State.AutoStoreFruit then
            local ok, count = pcall(AutoStore.StoreAll)
            if ok and count > 0 then Notify("Store Fruit", "Đã cất " .. count .. " fruits", "success", 3) end
        end
    end
end)
getgenv().ChuppyAutoStore = AutoStore

-- ═══════════════════════════════════════════════════════════════════════════════
-- [4.10] PUBLIC API + EXPORTS
-- ═══════════════════════════════════════════════════════════════════════════════
local Chuppy = getgenv().Chuppy
if not Chuppy then warn("[Chuppy Part 4] LỖI: Chưa load Part 2!"); return end

Chuppy.BossDB       = BossDB
Chuppy.BossFarm     = BossFarm
Chuppy.BossHop      = BossHop
Chuppy.MaterialDB   = MaterialDB
Chuppy.MaterialFarm = MaterialFarm
Chuppy.Chest        = Chest
Chuppy.FruitSniper  = FruitSniper
Chuppy.FruitShop    = FruitShop
Chuppy.AutoStore    = AutoStore

function Chuppy.ToggleBossFarm(enable, bossName)
    State.AutoFarmBoss = enable
    if bossName then State.SelectedBoss = bossName end
    Notify("Boss Farm", enable and "Đã BẬT" or "Đã TẮT", enable and "success" or "warning")
end

function Chuppy.SelectBoss(name)
    State.SelectedBoss = name
    Notify("Boss", "Chọn: " .. name, "info", 3)
end

function Chuppy.ToggleMaterialFarm(enable, matName)
    State.AutoFarmMaterial = enable
    if matName then State.SelectedMaterial = matName end
    Notify("Material Farm", enable and "Đã BẬT" or "Đã TẮT", enable and "success" or "warning")
end

function Chuppy.SelectMaterial(name)
    State.SelectedMaterial = name
    Notify("Material", "Chọn: " .. name, "info", 3)
end

function Chuppy.ToggleChest(enable)
    State.AutoFarmChest = enable
    Notify("Chest", enable and "Đã BẬT" or "Đã TẮT", enable and "success" or "warning")
end

function Chuppy.ToggleFruitSniper(enable)
    State.TeleportToFruit = enable
    Notify("Fruit Sniper", enable and "Đã BẬT" or "Đã TẮT", enable and "success" or "warning")
end

function Chuppy.ToggleAutoStore(enable)
    State.AutoStoreFruit = enable
    Notify("Auto Store", enable and "Đã BẬT" or "Đã TẮT", enable and "success" or "warning")
end

function Chuppy.StoreFruitsNow()
    local count = AutoStore.StoreAll()
    Notify("Store Fruit", "Đã cất " .. count .. " fruits", "success")
end

-- Restore state từ config
if State.SelectedBoss then Chuppy.SelectBoss(State.SelectedBoss) end
if State.SelectedMaterial then Chuppy.SelectMaterial(State.SelectedMaterial) end

print("═══════════════════════════════════════════════════════════════════════════════")
print("  ✅ PART 4/10 — BOSS + MATERIAL + CHEST + FRUIT SNIPER LOADED")
print("  📦 36 Bosses · 17 Materials · Chest · FruitSniper · FruitShop · AutoStore")
print("  👉 Gõ 'tiếp' để nhận PART 5/10: SEA EVENTS + RAID + DUNGEON + AUTO BOAT")
print("═══════════════════════════════════════════════════════════════════════════════")

end)() -- End IIFE
-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐾 CHUPPY HUB V2 — PART 5/10: SEA EVENTS + RAID + DUNGEON
-- Phiên bản sạch: IIFE scope · Fix lỗi getconnections · export qua getgenv()
-- ═══════════════════════════════════════════════════════════════════════════════
;(function()

-- ═══════════════════════════════════════════════════════════════════════════════
-- [5.0] SERVICES + IMPORTS
-- ═══════════════════════════════════════════════════════════════════════════════
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local RunService        = game:GetService("RunService")
local Lighting          = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LP = Players.LocalPlayer

-- Lấy module từ Part 2, 3, 4
local State        = getgenv().ChuppyState
local PlayerUtils  = getgenv().ChuppyPlayer
local Monster      = getgenv().ChuppyMonster
local Remote       = getgenv().ChuppyRemote
local Farm         = getgenv().ChuppyFarm
local Combat       = getgenv().ChuppyCombat
local Notify       = getgenv().Chuppy.Notify
local Track        = getgenv().Chuppy.Track
local SafeSpawn    = getgenv().Chuppy.SafeSpawn
local CheckCooldown= getgenv().Chuppy.CheckCooldown

if not State or not PlayerUtils or not Farm or not Combat then
    warn("[Chuppy Part 5] LỖI: Chưa load Part 2 & 3!")
    return
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [5.1] SEA BEAST FARM
-- ═══════════════════════════════════════════════════════════════════════════════
local SeaBeast = {}

function SeaBeast.FindAll()
    local list = {}
    local folder = Workspace:FindFirstChild("SeaBeasts")
    if not folder then return list end
    for _, v in pairs(folder:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") then
            local hp = v:FindFirstChild("Health") or v:FindFirstChild("HealthBBG")
            if hp and (hp:IsA("NumberValue") or hp:IsA("IntValue")) then
                if hp.Value > 0 then table.insert(list, v) end
            else
                table.insert(list, v)
            end
        end
    end
    return list
end

function SeaBeast.FindNearest(maxDist)
    maxDist = maxDist or 3000
    local hrp = PlayerUtils.GetHRP()
    if not hrp then return nil end
    local nearest, shortest = nil, maxDist
    for _, beast in ipairs(SeaBeast.FindAll()) do
        local rp = beast:FindFirstChild("HumanoidRootPart")
        if rp then
            local d = (rp.Position - hrp.Position).Magnitude
            if d < shortest then shortest = d; nearest = beast end
        end
    end
    return nearest
end

function SeaBeast.Teleport(beast)
    if not beast then return end
    local rp = beast:FindFirstChild("HumanoidRootPart")
    if not rp then return end
    local offset = State.Height or 150
    Farm.Teleport(rp.CFrame * CFrame.new(0, offset, 0), 300)
end

function SeaBeast.Attack(beast)
    if not beast then return end
    Combat.EquipWeapon(State.CurrentWeapon or "Melee")
    if State.AutoHaki then Combat.AutoHaki() end
    Combat.Attack()
end

SafeSpawn(function()
    while State.Running do
        task.wait(0.2)
        if State.AutoSeaBeast and PlayerUtils.IsAlive() then
            local beast = SeaBeast.FindNearest()
            if beast then
                State.CurrentTarget = beast
                SeaBeast.Teleport(beast)
                SeaBeast.Attack(beast)
                task.spawn(function()
                    local hp = beast:FindFirstChild("Health")
                    if hp and hp.Value > 0 then
                        State.Stats.DamageDealt = (State.Stats.DamageDealt or 0) + 1
                    end
                end)
            end
        end
    end
end)
getgenv().ChuppySeaBeast = SeaBeast

-- ═══════════════════════════════════════════════════════════════════════════════
-- [5.2] PIRATE RAID
-- ═══════════════════════════════════════════════════════════════════════════════
local PirateRaid = {}

local PIRATE_BOATS = { "PirateBrigade", "PirateGrandBrigade", "PirateSloop", "FishBoat", "MerchantBoat" }

function PirateRaid.FindAll()
    local list = {}
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return list end
    for _, v in pairs(enemies:GetChildren()) do
        for _, name in ipairs(PIRATE_BOATS) do
            if v.Name == name or string.find(v.Name, name, 1, true) then
                table.insert(list, v)
                break
            end
        end
    end
    return list
end

function PirateRaid.FindNearest(maxDist)
    maxDist = maxDist or 5000
    local hrp = PlayerUtils.GetHRP()
    if not hrp then return nil end
    local nearest, shortest = nil, maxDist
    for _, boat in ipairs(PirateRaid.FindAll()) do
        local part = boat:FindFirstChild("Engine") or boat:FindFirstChild("HumanoidRootPart") or boat.PrimaryPart
        if part then
            local d = (part.Position - hrp.Position).Magnitude
            if d < shortest then shortest = d; nearest = boat end
        end
    end
    return nearest
end

function PirateRaid.AttackBoat(boat)
    if not boat then return end
    local part = boat:FindFirstChild("Engine") or boat:FindFirstChild("HumanoidRootPart") or boat.PrimaryPart
    if not part then return end
    Farm.Teleport(part.CFrame * CFrame.new(0, 20, 0), 350)
    Combat.EquipWeapon(State.CurrentWeapon or "Melee")
    if State.AutoHaki then Combat.AutoHaki() end
    Combat.Attack()
end

SafeSpawn(function()
    while State.Running do
        task.wait(0.3)
        if State.AutoPirateRaid and PlayerUtils.IsAlive() then
            local boat = PirateRaid.FindNearest()
            if boat then
                State.CurrentTarget = boat
                PirateRaid.AttackBoat(boat)
            else
                local hrp = PlayerUtils.GetHRP()
                if hrp then
                    local searchPos = hrp.Position + Vector3.new(500, 0, 500)
                    Farm.Teleport(CFrame.new(searchPos.X, -60, searchPos.Z), 400)
                end
            end
        end
    end
end)
getgenv().ChuppyPirateRaid = PirateRaid

-- ═══════════════════════════════════════════════════════════════════════════════
-- [5.3] LAW RAID
-- ═══════════════════════════════════════════════════════════════════════════════
local LawRaid = {}

function LawRaid.HasChip()
    if LP.Backpack:FindFirstChild("Microchip") then return true end
    local char = PlayerUtils.GetCharacter()
    if char and char:FindFirstChild("Microchip") then return true end
    return false
end

function LawRaid.BuyChip()
    if LawRaid.HasChip() then return true end
    local frag = PlayerUtils.GetFragments()
    if frag < 1000 then return false end
    if Remote then
        Remote.Invoke("BlackbeardReward", "Microchip", "1")
        task.wait(0.3)
        Remote.Invoke("BlackbeardReward", "Microchip", "2")
        task.wait(0.5)
    end
    return LawRaid.HasChip()
end

function LawRaid.FindOrder()
    local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        local order = enemies:FindFirstChild("Order")
        if order then return order end
    end
    return nil
end

function LawRaid.GetSummonButton()
    local map = Workspace:FindFirstChild("Map")
    local ci = map and map:FindFirstChild("CircleIsland")
    local summon = ci and ci:FindFirstChild("RaidSummon")
    local button = summon and summon:FindFirstChild("Button")
    return button and button:FindFirstChild("Main")
end

SafeSpawn(function()
    while State.Running do
        task.wait(0.5)
        if State.AutoLawRaid and PlayerUtils.IsAlive() and State.World == 2 then
            local order = LawRaid.FindOrder()
            if not order then
                if State.AutoBuyChip then LawRaid.BuyChip() end
                if LawRaid.HasChip() then
                    local btn = LawRaid.GetSummonButton()
                    if btn then
                        Farm.Teleport(btn.CFrame, 350)
                        task.wait(0.4)
                        local cd = btn:FindFirstChild("ClickDetector")
                        if cd then pcall(fireclickdetector, cd) end
                        task.wait(2)
                    else
                        Farm.Teleport(CFrame.new(-6217.20, 28.04, -5053.13), 350)
                    end
                end
            else
                State.CurrentTarget = order
                local hrp = order:FindFirstChild("HumanoidRootPart")
                if hrp then
                    Farm.Teleport(hrp.CFrame * CFrame.new(0, 20, 0), 320)
                    Combat.EquipWeapon(State.CurrentWeapon or "Melee")
                    if State.AutoHaki then Combat.AutoHaki() end
                    Combat.Attack()
                    Combat.FreezeMob(order)
                    hrp.Size = Vector3.new(60, 60, 60)
                end
            end
        end
    end
end)
getgenv().ChuppyLawRaid = LawRaid

-- ═══════════════════════════════════════════════════════════════════════════════
-- [5.4] AUTO RAID
-- ═══════════════════════════════════════════════════════════════════════════════
local AutoRaid = {}

function AutoRaid.InRaid()
    local pg = LP:FindFirstChild("PlayerGui")
    local main = pg and pg:FindFirstChild("Main")
    local hud = main and main:FindFirstChild("TopHUDList")
    local timer = hud and hud:FindFirstChild("RaidTimer")
    return timer and timer.Visible or false
end

function AutoRaid.HasNormalChip()
    if LP.Backpack:FindFirstChild("Special Microchip") then return true end
    local char = PlayerUtils.GetCharacter()
    if char and char:FindFirstChild("Special Microchip") then return true end
    return false
end

function AutoRaid.GetRaidButton()
    local map = Workspace:FindFirstChild("Map")
    if not map then return nil end
    local button
    if State.World == 2 then
        local ci = map:FindFirstChild("CircleIsland")
        local rs = ci and ci:FindFirstChild("RaidSummon2")
        button = rs and rs:FindFirstChild("Button")
    elseif State.World == 3 then
        local bc = map:FindFirstChild("Boat Castle")
        local rs = bc and bc:FindFirstChild("RaidSummon2")
        button = rs and rs:FindFirstChild("Button")
    end
    return button and button:FindFirstChild("Main")
end

function AutoRaid.FireRaidButton()
    local btn = AutoRaid.GetRaidButton()
    if not btn then return false end
    local cd = btn:FindFirstChild("ClickDetector")
    if cd then pcall(fireclickdetector, cd); return true end
    return false
end

function AutoRaid.SelectRaid(raidType)
    if not Remote then return end
    raidType = raidType or State.SelectedRaid or "Flame"
    Remote.Invoke("RaidsNpc", "Check")
    task.wait(0.3)
    Remote.Invoke("RaidsNpc", "Select", raidType)
    task.wait(0.3)
end

function AutoRaid.GetLastIsland()
    local wOrigin = Workspace:FindFirstChild("_WorldOrigin")
    local locations = wOrigin and wOrigin:FindFirstChild("Locations")
    if not locations then return nil end
    local lastNum = 0
    local lastLoc = nil
    for _, loc in ipairs(locations:GetChildren()) do
        if string.find(loc.Name, "Island ") then
            local n = tonumber(loc.Name:gsub("Island ", ""))
            if n and n > lastNum then lastNum = n; lastLoc = loc end
        end
    end
    return lastLoc
end

function AutoRaid.FindRaidMob()
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    local hrp = PlayerUtils.GetHRP()
    if not hrp then return nil end
    local nearest, shortest = nil, 400
    for _, mob in ipairs(enemies:GetChildren()) do
        if Monster.IsAlive(mob) then
            local rp = mob:FindFirstChild("HumanoidRootPart")
            if rp then
                local d = (rp.Position - hrp.Position).Magnitude
                if d < shortest then shortest = d; nearest = mob end
            end
        end
    end
    return nearest
end

SafeSpawn(function()
    while State.Running do
        task.wait(0.5)
        if not State.AutoRaid or not PlayerUtils.IsAlive() then
            task.wait(0.5)
            continue
        end
        
        local inRaid = AutoRaid.InRaid()
        if not inRaid then
            local btn = AutoRaid.GetRaidButton()
            if not btn then
                Farm.Teleport(CFrame.new(-5500, 314, -2855), 350)
            else
                if AutoRaid.HasNormalChip() then
                    Farm.Teleport(btn.CFrame, 350)
                    task.wait(0.5)
                    AutoRaid.FireRaidButton()
                else
                    if PlayerUtils.GetFragments() >= 100000 then AutoRaid.SelectRaid() end
                end
            end
        else
            local mob = AutoRaid.FindRaidMob()
            if mob then
                State.CurrentTarget = mob
                local rp = mob:FindFirstChild("HumanoidRootPart")
                if rp then
                    Farm.Teleport(rp.CFrame * CFrame.new(0, 15, 0), 320)
                    Combat.EquipWeapon(State.CurrentWeapon or "Melee")
                    if State.AutoHaki then Combat.AutoHaki() end
                    Combat.Attack()
                    Monster.Bring(mob, PlayerUtils.GetHRP().CFrame * CFrame.new(0, 0, -5))
                end
            else
                local island = AutoRaid.GetLastIsland()
                if island then
                    if island.Name == "Island 2" and State.SelectedRaid == "Phoenix" then
                        Farm.Teleport(island.CFrame * CFrame.new(300, 60, 0), 350)
                    else
                        Farm.Teleport(island.CFrame * CFrame.new(0, 60, 0), 350)
                    end
                end
            end
        end
    end
end)
getgenv().ChuppyAutoRaid = AutoRaid

-- ═══════════════════════════════════════════════════════════════════════════════
-- [5.5] DUNGEON AUTO
-- ═══════════════════════════════════════════════════════════════════════════════
local Dungeon = {}

function Dungeon.InDungeon()
    return Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Dungeon") ~= nil
end

function Dungeon.GetCurrentFloor()
    local guid = LP:GetAttribute("ExplorerGUID")
    if not guid then return nil end
    local dr = ReplicatedStorage:FindFirstChild("DungeonReplicationObjects")
    if not dr then return nil end
    local data = dr:FindFirstChild(guid, true)
    if not data then return nil end
    return data:GetAttribute("FloorId")
end

function Dungeon.GetHighestFloor()
    local guid = LP:GetAttribute("ExplorerGUID")
    if not guid then return nil end
    local dr = ReplicatedStorage:FindFirstChild("DungeonReplicationObjects")
    if not dr then return nil end
    local data = dr:FindFirstChild(guid, true)
    if not data then return nil end
    return data.Parent.Parent:GetAttribute("CurrentExploredLevel")
end

local function PointInModel(pos, model)
    local ok, inBox = pcall(function() return model:GetBoundingBox() end)
    if not ok or not inBox then return false end
    local center, size = model:GetBoundingBox()
    local rel = center:PointToObjectSpace(pos)
    local half = size * 0.5
    return math.abs(rel.X) <= half.X and math.abs(rel.Y) <= half.Y and math.abs(rel.Z) <= half.Z
end

function Dungeon.FindMob()
    local floor = Dungeon.GetHighestFloor()
    if not floor then return nil end
    local mapD = Workspace.Map:FindFirstChild("Dungeon")
    if not mapD then return nil end
    local floorModel = mapD:FindFirstChild(tostring(floor))
    if not floorModel then return nil end

    local hrp = PlayerUtils.GetHRP()
    if not hrp then return nil end

    local nearest, shortest = nil, math.huge
    local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        for _, mob in ipairs(enemies:GetChildren()) do
            if Monster.IsAlive(mob) and mob.Name ~= "Blank Buddy" then
                local rp = mob:FindFirstChild("HumanoidRootPart")
                if rp and PointInModel(rp.Position, floorModel) then
                    local d = (rp.Position - hrp.Position).Magnitude
                    if d < shortest then shortest = d; nearest = mob end
                end
            end
        end
    end
    return nearest
end

function Dungeon.GoNextFloor()
    local current = Dungeon.GetCurrentFloor()
    local highest = Dungeon.GetHighestFloor()
    if not current or not highest or current == highest then return end
    
    local prev = highest - 1
    local mapD = Workspace.Map:FindFirstChild("Dungeon")
    if not mapD then return end
    local floorModel = mapD:FindFirstChild(tostring(prev))
    if not floorModel then return end

    local exit = floorModel:FindFirstChild("ExitTeleporter")
    local root = exit and exit:FindFirstChild("Root")
    if root then
        local hrp = PlayerUtils.GetHRP()
        if hrp and (root.Position - hrp.Position).Magnitude > 15 then
            Farm.Teleport(root.CFrame * CFrame.new(0, 5, 0), 350)
        end
    end
end

function Dungeon.AutoPickCard()
    local pg = LP:FindFirstChild("PlayerGui")
    if not pg then return false end
    local best
    for _, obj in ipairs(pg:GetChildren()) do
        if obj:IsA("ScreenGui") and obj.Name:find("Buff") then
            for _, desc in ipairs(obj:GetDescendants()) do
                if desc:IsA("TextButton") and desc.Visible then best = desc; break end
            end
        end
    end
    if best then
        -- FIX: Bọc kiểm tra getconnections để tránh lỗi nil trên các Executor cũ
        if getconnections then
            local ok, conns = pcall(getconnections, best.MouseButton1Click)
            if ok and conns then
                for _, conn in pairs(conns) do
                    pcall(function() conn.Function() end)
                end
            end
        else
            pcall(function() best:Activate() end)
        end
        return true
    end
    return false
end

SafeSpawn(function()
    while State.Running do
        task.wait(0.2)
        if State.AutoDungeon and PlayerUtils.IsAlive() then
            if Dungeon.InDungeon() then
                local current = Dungeon.GetCurrentFloor()
                local highest = Dungeon.GetHighestFloor()
                if current and highest and current ~= highest then
                    Dungeon.GoNextFloor()
                else
                    local mob = Dungeon.FindMob()
                    if mob then
                        State.CurrentTarget = mob
                        local rp = mob:FindFirstChild("HumanoidRootPart")
                        if rp then
                            Combat.EquipWeapon(State.CurrentWeapon or "Melee")
                            if State.AutoHaki then Combat.AutoHaki() end
                            Combat.Attack()
                            Farm.Teleport(rp.CFrame * CFrame.new(0, 12, 0), 320)
                        end
                    end
                end
            end
        end
        if State.AutoPickCardDungeon then pcall(Dungeon.AutoPickCard) end
    end
end)
getgenv().ChuppyDungeon = Dungeon

-- ═══════════════════════════════════════════════════════════════════════════════
-- [5.6] LEVIATHAN EVENT
-- ═══════════════════════════════════════════════════════════════════════════════
local Leviathan = {}

function Leviathan.HasFrozen()
    local wOrigin = Workspace:FindFirstChild("_WorldOrigin")
    local locations = wOrigin and wOrigin:FindFirstChild("Locations")
    if not locations then return false end
    return locations:FindFirstChild("Frozen Dimension") ~= nil
end

function Leviathan.Find()
    local beasts = Workspace:FindFirstChild("SeaBeasts")
    if not beasts then return nil end
    for _, b in ipairs(beasts:GetChildren()) do
        if string.find(b.Name, "Leviathan", 1, true) then
            local hp = b:FindFirstChild("Health")
            if hp and hp.Value > 0 then return b end
        end
    end
    return nil
end

SafeSpawn(function()
    while State.Running do
        task.wait(1)
        if State.AutoLeviathan and State.World == 3 then
            if not Leviathan.HasFrozen() then
                local boats = Workspace:FindFirstChild("Boats")
                if boats then
                    local hasBoat = false
                    for _, boat in pairs(boats:GetChildren()) do
                        local owner = boat:FindFirstChild("Owner")
                        if owner and owner.Value == LP then hasBoat = true; break end
                    end
                    if not hasBoat and PlayerUtils.GetBeli() >= 500000 and Remote then
                        Remote.Invoke("BuyBoat", "Beast Hunter")
                        task.wait(3)
                    end
                end
            else
                local wOrigin = Workspace:FindFirstChild("_WorldOrigin")
                local locations = wOrigin and wOrigin:FindFirstChild("Locations")
                local frozen = locations and locations:FindFirstChild("Frozen Dimension")
                if frozen then Farm.Teleport(frozen.CFrame, 300) end
            end
        end
        
        if State.AutoLeviathanAttack and State.World == 3 then
            local lev = Leviathan.Find()
            if lev then
                State.CurrentTarget = lev
                local rp = lev:FindFirstChild("HumanoidRootPart")
                if rp then
                    Farm.Teleport(rp.CFrame * CFrame.new(0, 140, 0), 300)
                    Combat.EquipWeapon(State.CurrentWeapon or "Melee")
                    if State.AutoHaki then Combat.AutoHaki() end
                    Combat.Attack()
                end
            end
        end
    end
end)
getgenv().ChuppyLeviathan = Leviathan

-- ═══════════════════════════════════════════════════════════════════════════════
-- [5.7] KITSUNE EVENT
-- ═══════════════════════════════════════════════════════════════════════════════
local Kitsune = {}

function Kitsune.HasIsland()
    local map = Workspace:FindFirstChild("Map")
    return map and map:FindFirstChild("KitsuneIsland") ~= nil
end

function Kitsune.FindShrine()
    local map = Workspace:FindFirstChild("Map")
    local ki = map and map:FindFirstChild("KitsuneIsland")
    if not ki then return nil end
    return ki:FindFirstChild("ShrineInactive") or ki:FindFirstChild("ShrineActive")
end

function Kitsune.FindEmber()
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj.Name == "EmberTemplate" and obj:FindFirstChild("Part") then
            if obj.Part.Position.Y > -100 then return obj end
        end
    end
    return nil
end

function Kitsune.TeleportToIsland()
    local wOrigin = Workspace:FindFirstChild("_WorldOrigin")
    local locations = wOrigin and wOrigin:FindFirstChild("Locations")
    local ki = locations and locations:FindFirstChild("Kitsune Island")
    if ki then Farm.Teleport(ki.CFrame, 350); return true end
    return false
end

SafeSpawn(function()
    while State.Running do
        task.wait(0.3)
        if State.TeleportToKitsune and State.World == 3 then Kitsune.TeleportToIsland() end
        
        if State.AutoCollectSoulEmber and State.World == 3 then
            local ember = Kitsune.FindEmber()
            if ember then
                local p = ember:FindFirstChild("Part")
                if p then
                    local hrp = PlayerUtils.GetHRP()
                    if hrp then
                        if (hrp.Position - p.Position).Magnitude > 100 then
                            Farm.Teleport(p.CFrame, 400)
                        else
                            hrp.CFrame = p.CFrame
                        end
                    end
                end
            else
                Kitsune.TeleportToIsland()
            end
        end
        
        if State.AutoSummonEmber and State.World == 3 then
            local shrine = Kitsune.FindShrine()
            if shrine then
                local hrp = PlayerUtils.GetHRP()
                if hrp and (hrp.Position - shrine.WorldPivot.Position).Magnitude >= 10 then
                    Farm.Teleport(shrine.WorldPivot, 350)
                else
                    local net = ReplicatedStorage:FindFirstChild("Modules")
                    net = net and net:FindFirstChild("Net")
                    local remote = net and net:FindFirstChild("RE/TouchKitsuneStatue")
                    if remote then pcall(function() remote:FireServer() end) end
                    task.wait(5)
                end
            end
        end
    end
end)
getgenv().ChuppyKitsune = Kitsune

-- ═══════════════════════════════════════════════════════════════════════════════
-- [5.8] MIRAGE ISLAND & FULL MOON
-- ═══════════════════════════════════════════════════════════════════════════════
local Mirage = {}

function Mirage.HasIsland()
    local map = Workspace:FindFirstChild("Map")
    return map and map:FindFirstChild("MysticIsland") ~= nil
end

function Mirage.GetHighestPoint()
    local map = Workspace:FindFirstChild("Map")
    local mirage = map and map:FindFirstChild("MysticIsland")
    if not mirage then return nil end
    local highest, maxY = nil, -math.huge
    for _, part in pairs(mirage:GetDescendants()) do
        if part:IsA("BasePart") and part.Position.Y > maxY then
            maxY = part.Position.Y
            highest = part
        end
    end
    return highest
end

SafeSpawn(function()
    while State.Running do
        task.wait(3)
        if State.AutoFindMirage and State.World == 3 then
            if Mirage.HasIsland() then
                local highest = Mirage.GetHighestPoint()
                if highest then
                    Farm.Teleport(CFrame.new(highest.Position.X, highest.Position.Y + 212, highest.Position.Z), 300)
                end
                State.AutoFindMirage = false
                Notify("Mirage", "Đã tìm thấy đảo Mirage!", "success", 5)
                local Webhook = getgenv().ChuppyWebhook
                if Webhook then Webhook.Info("Mirage", "Đã tìm thấy Mirage Island") end
            else
                local ServerManager = getgenv().ChuppyServer
                if ServerManager and CheckCooldown("hop-mirage", 8) then ServerManager.Hop() end
            end
        end
    end
end)
getgenv().ChuppyMirage = Mirage

local FullMoon = {}
local MOON_IDS = {
    ["http://www.roblox.com/asset/?id=9709149052"] = "Full Moon",
    ["http://www.roblox.com/asset/?id=9709149431"] = "Full Moon",
}

function FullMoon.IsFullMoon()
    local sky = Lighting:FindFirstChild("Sky")
    if not sky then return false end
    return MOON_IDS[sky.MoonTextureId] ~= nil
end

SafeSpawn(function()
    while State.Running do
        task.wait(2)
        if State.AutoHopFullMoon then
            if not FullMoon.IsFullMoon() then
                local ServerManager = getgenv().ChuppyServer
                if ServerManager and CheckCooldown("hop-moon", 10) then ServerManager.Hop() end
            else
                Notify("Moon", "Đã tìm thấy Full Moon!", "success", 5)
                State.AutoHopFullMoon = false
            end
        end
    end
end)
getgenv().ChuppyFullMoon = FullMoon

-- ═══════════════════════════════════════════════════════════════════════════════
-- [5.9] AUTO BOAT
-- ═══════════════════════════════════════════════════════════════════════════════
local BoatSystem = {}

function BoatSystem.Buy(boatType)
    if not Remote then return end
    boatType = boatType or "Guardian"
    if boatType == "Brigade" or boatType == "GrandBrigade" then
        Remote.Invoke("BuyBoat", "Pirate" .. boatType)
    else
        Remote.Invoke("BuyBoat", boatType)
    end
end

function BoatSystem.FindMyBoat()
    local boats = Workspace:FindFirstChild("Boats")
    if not boats then return nil end
    for _, boat in pairs(boats:GetChildren()) do
        local owner = boat:FindFirstChild("Owner")
        if owner and tostring(owner.Value) == LP.Name then
            local hum = boat:FindFirstChild("Humanoid")
            if hum and hum.Value > 0 then return boat end
        end
    end
    return nil
end

function BoatSystem.SetSpeed(speed)
    local boat = BoatSystem.FindMyBoat()
    if not boat then return end
    local seat = boat:FindFirstChild("VehicleSeat")
    if seat then seat.MaxSpeed = speed end
end

function BoatSystem.NoclipBoat()
    local boat = BoatSystem.FindMyBoat()
    if not boat then return end
    for _, part in pairs(boat:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
end

SafeSpawn(function()
    while State.Running do
        task.wait(0.5)
        if State.AutoBoatNoclip then pcall(BoatSystem.NoclipBoat) end
        if State.ChangeSpeedBoat then pcall(BoatSystem.SetSpeed, State.ValueSpeedBoat or 200) end
    end
end)
getgenv().ChuppyBoatSystem = BoatSystem

-- ═══════════════════════════════════════════════════════════════════════════════
-- [5.10] PUBLIC API + EXPORTS
-- ═══════════════════════════════════════════════════════════════════════════════
local Chuppy = getgenv().Chuppy
if not Chuppy then warn("[Chuppy Part 5] LỖI: Chưa load Part 2!"); return end

Chuppy.SeaBeast      = SeaBeast
Chuppy.PirateRaid    = PirateRaid
Chuppy.LawRaid       = LawRaid
Chuppy.AutoRaid      = AutoRaid
Chuppy.Dungeon       = Dungeon
Chuppy.Leviathan     = Leviathan
Chuppy.Kitsune       = Kitsune
Chuppy.Mirage        = Mirage
Chuppy.FullMoon      = FullMoon
Chuppy.BoatSystem    = BoatSystem

function Chuppy.ToggleSeaBeast(enable)
    State.AutoSeaBeast = enable
    Notify("Sea Beast", enable and "Đã BẬT" or "Đã TẮT", enable and "success" or "warning")
end

function Chuppy.TogglePirateRaid(enable)
    State.AutoPirateRaid = enable
    Notify("Pirate Raid", enable and "Đã BẬT" or "Đã TẮT", enable and "success" or "warning")
end

function Chuppy.ToggleLawRaid(enable, autoBuy)
    State.AutoLawRaid = enable
    if autoBuy ~= nil then State.AutoBuyChip = autoBuy end
    Notify("Law Raid", enable and "Đã BẬT" or "Đã TẮT", enable and "success" or "warning")
end

function Chuppy.ToggleAutoRaid(enable, raidType)
    State.AutoRaid = enable
    if raidType then State.SelectedRaid = raidType end
    Notify("Auto Raid", enable and "Đã BẬT" or "Đã TẮT", enable and "success" or "warning")
end

function Chuppy.ToggleDungeon(enable)
    State.AutoDungeon = enable
    Notify("Dungeon", enable and "Đã BẬT" or "Đã TẮT", enable and "success" or "warning")
end

function Chuppy.ToggleLeviathan(enable, autoAttack)
    State.AutoLeviathan = enable
    if autoAttack ~= nil then State.AutoLeviathanAttack = autoAttack end
    Notify("Leviathan", enable and "Đã BẬT" or "Đã TẮT", enable and "success" or "warning")
end

function Chuppy.ToggleMirage(enable)
    State.AutoFindMirage = enable
    Notify("Mirage Finder", enable and "Đã BẬT" or "Đã TẮT", enable and "success" or "warning")
end

function Chuppy.ToggleFullMoonHop(enable)
    State.AutoHopFullMoon = enable
    Notify("Full Moon Hop", enable and "Đã BẬT" or "Đã TẮT", enable and "success" or "warning")
end

function Chuppy.GoKitsune()
    if Kitsune.TeleportToIsland() then Notify("Kitsune", "Đã bay đến Kitsune Island", "success")
    else Notify("Kitsune", "Không tìm thấy đảo", "warning") end
end

function Chuppy.BuyBoat(type)
    BoatSystem.Buy(type)
    Notify("Boat", "Đã mua: " .. (type or "Guardian"), "info")
end

print("═══════════════════════════════════════════════════════════════════════════════")
print("  ✅ PART 5/10 — SEA EVENTS + RAID + DUNGEON + AUTO BOAT LOADED")
print("  📦 SeaBeast · PirateRaid · LawRaid · AutoRaid · Dungeon")
print("  📦 Leviathan · Kitsune · Mirage · FullMoon · AutoBoat")
print("  👉 Gõ 'tiếp' để nhận PART 6/10: RACE V1-V4 + DRACO + QUEST CHAINS")
print("═══════════════════════════════════════════════════════════════════════════════")

end)() -- End IIFE
-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐾 CHUPPY HUB V2 — PART 6/10: RACE + DRACO + QUEST CHAINS
-- Phiên bản sạch: IIFE scope · Fix lỗi syntax Godhuman · export qua getgenv()
-- ═══════════════════════════════════════════════════════════════════════════════
;(function()

-- ═══════════════════════════════════════════════════════════════════════════════
-- [6.0] SERVICES + IMPORTS
-- ═══════════════════════════════════════════════════════════════════════════════
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local RunService        = game:GetService("RunService")
local Lighting          = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LP = Players.LocalPlayer

-- Lấy module từ Part 2, 3, 4, 5
local State        = getgenv().ChuppyState
local PlayerUtils  = getgenv().ChuppyPlayer
local Monster      = getgenv().ChuppyMonster
local Remote       = getgenv().ChuppyRemote
local Farm         = getgenv().ChuppyFarm
local Combat       = getgenv().ChuppyCombat
local SeaBeast     = getgenv().ChuppySeaBeast
local Notify       = getgenv().Chuppy.Notify
local Track        = getgenv().Chuppy.Track
local SafeSpawn    = getgenv().Chuppy.SafeSpawn

if not State or not PlayerUtils or not Farm or not Combat then
    warn("[Chuppy Part 6] LỖI: Chưa load Part 2 & 3!")
    return
end

-- Helper đếm item (fix lỗi dùng trước khi khai báo trong bản cũ)
local function CheckCountItem(item, count)
    local total = 0
    for _, tool in ipairs(LP.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == item then total = total + 1 end
    end
    local char = PlayerUtils.GetCharacter()
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == item then total = total + 1 end
        end
    end
    return total >= count
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [6.1] RACE INFO READER
-- ═══════════════════════════════════════════════════════════════════════════════
local RaceInfo = {}

function RaceInfo.GetRace()
    local data = LP:FindFirstChild("Data")
    local race = data and data:FindFirstChild("Race")
    return race and race.Value or "Human"
end

function RaceInfo.GetVersion()
    local char = PlayerUtils.GetCharacter()
    if char and char:FindFirstChild("RaceTransformed") then return "V4" end
    
    if Remote then
        local v3 = Remote.Invoke("Wenlocktoad", "1")
        if v3 == -2 then return "V3" end
        local v2 = Remote.Invoke("Alchemist", "1")
        if v2 == -2 then return "V2" end
    end
    return "V1"
end

function RaceInfo.Format()
    return RaceInfo.GetRace() .. " " .. RaceInfo.GetVersion()
end

function RaceInfo.IsDraco()
    return RaceInfo.GetRace() == "Draco"
end

function RaceInfo.GetEnergy()
    local char = PlayerUtils.GetCharacter()
    if not char then return 0 end
    local energy = char:FindFirstChild("RaceEnergy")
    return energy and energy.Value or 0
end
getgenv().ChuppyRaceInfo = RaceInfo

-- ═══════════════════════════════════════════════════════════════════════════════
-- [6.2] RACE V2 (Alchemist)
-- ═══════════════════════════════════════════════════════════════════════════════
local RaceV2 = {}

local ALCHEMIST_CF = CFrame.new(-2777.60, 72.96, -3571.42)
local V2_ELITE_MOBS = {
    Human = { "Jeremy" }, Fishman = { "Fishman Lord" }, Skypiea = { "Wysper" },
    Mink = { "Mob Leader" }, Cyborg = { "Order" }, Ghoul = { "Cursed Captain" },
}

function RaceV2.FarmElite(race)
    local mobs = V2_ELITE_MOBS[race]
    if not mobs then return false end
    local target
    for _, mobName in ipairs(mobs) do
        target = Monster.Find(mobName)
        if target and Monster.IsAlive(target) then break end
    end
    if not target or not Monster.IsAlive(target) then return false end
    
    local rp = target:FindFirstChild("HumanoidRootPart")
    if rp then
        Farm.Teleport(rp.CFrame * CFrame.new(0, 15, 0), 320)
        Combat.EquipWeapon(State.CurrentWeapon or "Melee")
        if State.AutoHaki then Combat.AutoHaki() end
        Combat.Attack()
        Combat.FreezeMob(target)
    end
    return true
end

function RaceV2.Step()
    if RaceInfo.GetVersion() ~= "V1" or PlayerUtils.GetBeli() < 500000 then return end
    local progress = Remote.Invoke("Alchemist", "1")

    if progress == 0 then
        Farm.Teleport(ALCHEMIST_CF, 320)
        task.wait(0.5)
        Remote.Invoke("Alchemist", "2")
    elseif progress == 1 then
        if not LP.Backpack:FindFirstChild("Flower 1") then
            local flower = Workspace:FindFirstChild("Flower1")
            if flower then Farm.Teleport(flower.CFrame, 320); return end
        end
        RaceV2.FarmElite(RaceInfo.GetRace())
    elseif progress == 2 then
        Farm.Teleport(ALCHEMIST_CF, 320)
        task.wait(0.5)
        Remote.Invoke("Alchemist", "3")
    elseif progress == -2 then
        Notify("Race V2", "Đã hoàn thành!", "success", 5)
        State.AutoRaceV2 = false
    end
end

SafeSpawn(function()
    while State.Running do
        task.wait(0.5)
        if State.AutoRaceV2 and State.World == 1 and PlayerUtils.IsAlive() then
            pcall(RaceV2.Step)
        end
    end
end)
getgenv().ChuppyRaceV2 = RaceV2

-- ═══════════════════════════════════════════════════════════════════════════════
-- [6.3] RACE V3 (Wenlocktoad + Bartilo)
-- ═══════════════════════════════════════════════════════════════════════════════
local RaceV3 = {}

local WENLOCKTOAD_CF = CFrame.new(-2777.60, 72.96, -3571.42)
local BARTILO_CF = CFrame.new(-456.29, 73.02, 299.89)

function RaceV3.AutoBartilo()
    local progress = Remote.Invoke("BartiloQuestProgress", "Bartilo")
    if progress == 0 then
        local swan = Monster.Find("Swan Pirate")
        if swan and Monster.IsAlive(swan) then
            Farm.Teleport(swan.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0), 320)
            Combat.EquipWeapon(State.CurrentWeapon or "Melee")
            Combat.Attack()
        else
            Farm.Teleport(BARTILO_CF, 320)
            Remote.Invoke("StartQuest", "BartiloQuest", 1)
        end
    elseif progress == 1 then
        local jeremy = Monster.Find("Jeremy")
        if jeremy and Monster.IsAlive(jeremy) then
            Farm.Teleport(jeremy.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0), 320)
            Combat.EquipWeapon(State.CurrentWeapon or "Melee")
            Combat.Attack()
        end
    elseif progress == 2 then
        local map = Workspace:FindFirstChild("Map")
        local dress = map and map:FindFirstChild("Dressrosa")
        local plates = dress and dress:FindFirstChild("BartiloPlates")
        if plates then
            for i = 1, 8 do
                local plate = plates:FindFirstChild("Plate" .. i)
                if plate and plate.BrickColor ~= BrickColor.new("Sand yellow") then
                    local hrp = PlayerUtils.GetHRP()
                    if hrp then
                        hrp.CFrame = plate.CFrame
                        pcall(function() firetouchinterest(plate, hrp, 0); firetouchinterest(plate, hrp, 1) end)
                        break
                    end
                end
            end
        end
    end
end

function RaceV3.Step()
    if RaceInfo.GetVersion() ~= "V2" then return end
    local bartilo = Remote.Invoke("BartiloQuestProgress", "Bartilo")
    if bartilo ~= 3 then RaceV3.AutoBartilo(); return end

    local hrp = PlayerUtils.GetHRP()
    if (hrp.Position - WENLOCKTOAD_CF.Position).Magnitude > 10 then
        Farm.Teleport(WENLOCKTOAD_CF, 320); return
    end

    local progress = Remote.Invoke("Wenlocktoad", "1")
    if progress == 0 then Remote.Invoke("Wenlocktoad", "2"); task.wait(1)
    elseif progress == 2 then Remote.Invoke("Wenlocktoad", "3"); task.wait(0.5)
    elseif progress == -2 then
        Notify("Race V3", "Đã hoàn thành!", "success", 5)
        State.AutoRaceV3 = false
    end
end

SafeSpawn(function()
    while State.Running do
        task.wait(0.5)
        if State.AutoRaceV3 and State.World == 2 and PlayerUtils.IsAlive() then
            pcall(RaceV3.Step)
        end
    end
end)
getgenv().ChuppyRaceV3 = RaceV3

-- ═══════════════════════════════════════════════════════════════════════════════
-- [6.4] RACE V4 (Temple of Time)
-- ═══════════════════════════════════════════════════════════════════════════════
local RaceV4 = {}

local TEMPLE_CF = CFrame.new(28282.57, 14896.85, 105.10)
local RACE_TRIALS = {
    Human = "Trial of Strength", Fishman = "Trial of Water", Skypiea = "Trial of the King",
    Mink = "Trial of Speed", Cyborg = "Trial of the Machine", Ghoul = "Trial of Carnage",
}

function RaceV4.InTrial()
    local wOrigin = Workspace:FindFirstChild("_WorldOrigin")
    local locations = wOrigin and wOrigin:FindFirstChild("Locations")
    if not locations then return nil end
    for _, trialName in pairs(RACE_TRIALS) do
        local trial = locations:FindFirstChild(trialName)
        if trial then
            local hrp = PlayerUtils.GetHRP()
            if hrp and (trial.Position - hrp.Position).Magnitude < 1500 then return trialName end
        end
    end
    return nil
end

function RaceV4.CollectBlueGear()
    local map = Workspace:FindFirstChild("Map")
    local mirage = map and map:FindFirstChild("MysticIsland")
    if not mirage then return false end
    local blueGear
    for _, part in pairs(mirage:GetChildren()) do
        if part:IsA("MeshPart") and part.MeshId == "rbxassetid://10153114969" then blueGear = part; break end
    end
    if not blueGear then return false end
    if not blueGear.CanCollide and blueGear.Transparency ~= 1 then
        Farm.Teleport(blueGear.CFrame, 300)
    elseif blueGear.Transparency == 1 then
        local cam = Workspace.CurrentCamera
        if cam then
            cam.CFrame = CFrame.new(cam.CFrame.Position, Lighting:GetMoonDirection() + cam.CFrame.Position)
            task.wait(0.5)
            VirtualInputManager:SendKeyEvent(true, "T", false, true)
            VirtualInputManager:SendKeyEvent(false, "T", false, true)
        end
    end
    return true
end

function RaceV4.Step()
    local version = RaceInfo.GetVersion()
    if version == "V4" then State.AutoRaceV4 = false; return end
    if version ~= "V3" then return end

    local trial = RaceV4.InTrial()
    if trial then
        local mob = Monster.FindNearest(1000)
        if mob then Farm.Teleport(mob.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0), 320); Combat.Attack() end
        return
    end

    local map = Workspace:FindFirstChild("Map")
    if map and map:FindFirstChild("MysticIsland") then
        if Lighting.ClockTime >= 18 or Lighting.ClockTime < 5 then RaceV4.CollectBlueGear(); return end
    end

    local checkDoor = Remote.Invoke("CheckTempleDoor")
    if checkDoor then
        Farm.Teleport(CFrame.new(28576.47, 14935.95, 75.47), 350) -- Lever CF
    else
        local progress = Remote.Invoke("RaceV4Progress", "Check")
        if progress == 1 then Remote.Invoke("RaceV4Progress", "Begin")
        elseif progress == 2 then Farm.Teleport(CFrame.new(3032.78, 2280.85, -7325.48), 350); task.wait(0.5); Remote.Invoke("RaceV4Progress", "Teleport")
        elseif progress == 3 then Remote.Invoke("RaceV4Progress", "Continue") end
    end
end

SafeSpawn(function()
    while State.Running do
        task.wait(1)
        if State.AutoTurnOnV4 then
            local char = PlayerUtils.GetCharacter()
            if char and char:FindFirstChild("RaceTransformed") then
                local energy = char:FindFirstChild("RaceEnergy")
                if energy and energy.Value >= 1 and not char.RaceTransformed.Value then
                    local aw = LP.Backpack:FindFirstChild("Awakening") or char:FindFirstChild("Awakening")
                    if aw then pcall(function() aw.RemoteFunction:InvokeServer(true) end) end
                end
            end
        end
    end
end)

SafeSpawn(function()
    while State.Running do
        task.wait(0.5)
        if State.AutoRaceV4 and PlayerUtils.IsAlive() then pcall(RaceV4.Step) end
    end
end)
getgenv().ChuppyRaceV4 = RaceV4

-- ═══════════════════════════════════════════════════════════════════════════════
-- [6.5] DRACO RACE
-- ═══════════════════════════════════════════════════════════════════════════════
local Draco = {}

function Draco.GetQuestState()
    local net = ReplicatedStorage:FindFirstChild("Modules")
    net = net and net:FindFirstChild("Net")
    local rf = net and net:FindFirstChild("RF/InteractDragonQuest")
    if not rf then return nil end
    local ok, result = pcall(function() return rf:InvokeServer({ NPC = "Dragon Wizard", Command = "Speak" }) end)
    if ok then return result end
    return nil
end

function Draco.Step()
    if not RaceInfo.IsDraco() then State.AutoDraco = false; return end
    if LP.Backpack:FindFirstChild("Primordial Reign") then State.AutoDraco = false; return end

    local quest = Draco.GetQuestState()
    if not quest then return end
    local available = quest.AvailableVQuest

    if available == "V2" or available == "V3" then
        local net = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Net")
        local rf = net and net:FindFirstChild("RF/InteractDragonQuest")
        if rf then rf:InvokeServer({ NPC = "Dragon Wizard", Command = "Ascension", Action = "Begin" }) end
    elseif available == "V2TurnInReady" or available == "V3TurnInReady" then
        local net = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Net")
        local rf = net and net:FindFirstChild("RF/InteractDragonQuest")
        if rf then rf:InvokeServer({ NPC = "Dragon Wizard", Command = "Ascension", Action = "Complete" }) end
    elseif available == "V2InProgress" then
        if not CheckCountItem("Fire Flower", 5) then
            local flowers = Workspace:FindFirstChild("FireFlowers")
            if flowers then
                for _, f in ipairs(flowers:GetChildren()) do
                    local part = f.PrimaryPart or f:FindFirstChildWhichIsA("BasePart")
                    if part then
                        Farm.Teleport(part.CFrame, 320)
                        local pp = f:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if pp then pcall(fireproximityprompt, pp, 1) end
                        break
                    end
                end
            end
        end
    elseif available == "V3InProgress" then
        local terror = Monster.Find("Terrorshark")
        if terror and Monster.IsAlive(terror) then
            SeaBeast.Teleport(terror)
            Combat.EquipWeapon(State.CurrentWeapon or "Melee")
            Combat.Attack()
        end
    end
end

SafeSpawn(function()
    while State.Running do
        task.wait(0.5)
        if State.AutoDraco and PlayerUtils.IsAlive() then pcall(Draco.Step) end
    end
end)
getgenv().ChuppyDraco = Draco

-- ═══════════════════════════════════════════════════════════════════════════════
-- [6.6] CYBORG & GHOUL QUEST
-- ═══════════════════════════════════════════════════════════════════════════════
local CyborgQuest = {}
function CyborgQuest.Step()
    if Remote.Invoke("CyborgTrainer", "Check") == 2 then State.AutoCyborgQuest = false; return end
    if State.World ~= 2 then Remote.Invoke("TravelDressrosa"); return end
    
    if LP.Backpack:FindFirstChild("Core Brain") then
        local cyborg = Workspace:FindFirstChild("CyborgTrainer")
        if cyborg and cyborg:FindFirstChild("HumanoidRootPart") then
            Farm.Teleport(cyborg.HumanoidRootPart.CFrame, 320)
            task.wait(1)
            Remote.Invoke("CyborgTrainer", "Buy")
        end
        return
    end

    if not LP.Backpack:FindFirstChild("Microchip") then
        if PlayerUtils.GetFragments() >= 1000 then
            Remote.Invoke("BlackbeardReward", "Microchip", "1")
            task.wait(0.3)
            Remote.Invoke("BlackbeardReward", "Microchip", "2")
        end
        return
    end

    local lawRaid = getgenv().ChuppyLawRaid
    if lawRaid then
        local order = lawRaid.FindOrder()
        if order then
            Farm.Teleport(order.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0), 320)
            Combat.Attack()
        else
            local btn = lawRaid.GetSummonButton()
            if btn then Farm.Teleport(btn.CFrame, 320); task.wait(0.5); pcall(fireclickdetector, btn.ClickDetector) end
        end
    end
end
SafeSpawn(function() while State.Running do task.wait(0.5); if State.AutoCyborgQuest and PlayerUtils.IsAlive() then pcall(CyborgQuest.Step) end end end)
getgenv().ChuppyCyborgQuest = CyborgQuest

local GhoulQuest = {}
local GHOUL_MOBS = { "Ship Deckhand", "Ship Steward", "Ship Officer", "Ship Engineer" }
function GhoulQuest.Step()
    if RaceInfo.GetRace() == "Ghoul" then State.AutoGhoulQuest = false; return end
    if State.World ~= 2 then Remote.Invoke("TravelDressrosa"); return end
    
    if not CheckCountItem("Ectoplasm", 100) then
        local target
        for _, name in ipairs(GHOUL_MOBS) do target = Monster.Find(name); if target then break end end
        if target then
            Farm.Teleport(target.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0), 320)
            Combat.Attack()
        else
            Farm.Teleport(CFrame.new(1037.80, 125.09, 32911.60), 320)
        end
        return
    end

    if not LP.Backpack:FindFirstChild("Hellfire Torch") then
        local boss = Monster.Find("Cursed Captain")
        if boss then Farm.Teleport(boss.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0), 320); Combat.Attack() end
        return
    end
    Remote.Invoke("Ectoplasm", "BuyCheck", 4)
    task.wait(0.5)
    Remote.Invoke("Ectoplasm", "Buy", 4)
end
SafeSpawn(function() while State.Running do task.wait(0.5); if State.AutoGhoulQuest and PlayerUtils.IsAlive() then pcall(GhoulQuest.Step) end end end)
getgenv().ChuppyGhoulQuest = GhoulQuest

-- ═══════════════════════════════════════════════════════════════════════════════
-- [6.7] FIGHTING STYLES & GODHUMAN
-- ═══════════════════════════════════════════════════════════════════════════════
local FightingStyles = {}
local STYLE_NPCS = {
    BlackLeg = "Dark Step Teacher", FishmanKarate = "Water Kung-fu Teacher", Electro = "Mad Scientist",
    Superhuman = "Martial Arts Master", DeathStep = "Phoeyu, the Reformed", SharkmanKarate = "Sharkman Teacher",
    DragonTalon = "Uzoth", ElectricClaw = "Previous Hero", SanguineArt = "Shafi", DragonClaw = "Sabi", Godhuman = "Ancient Monk",
}

local function FindNPC(name)
    local npcs = Workspace:FindFirstChild("NPCs")
    if npcs then for _, npc in pairs(npcs:GetChildren()) do if npc.Name == name then return npc end end end
    return nil
end

function FightingStyles.Step()
    local styleName = State.AutoFightingStyle
    if not styleName then return end
    local npc = FindNPC(STYLE_NPCS[styleName])
    if npc and npc:FindFirstChild("HumanoidRootPart") then
        local dist = (PlayerUtils.GetHRP().Position - npc.HumanoidRootPart.Position).Magnitude
        if dist > 10 then Farm.Teleport(npc.HumanoidRootPart.CFrame * CFrame.new(0, 4, 4), 320)
        else
            if Remote.Invoke("Buy" .. styleName) then Notify("Style", "Đã mua " .. styleName, "success", 5); State.AutoFightingStyle = nil end
        end
    end
end
SafeSpawn(function() while State.Running do task.wait(0.5); if State.AutoFightingStyle and PlayerUtils.IsAlive() then pcall(FightingStyles.Step) end end end)
getgenv().ChuppyFightingStyles = FightingStyles

local Godhuman = {}
local GODHUMAN_MATERIALS = {
    { name="Fish Tail", mob="Fishman Captain", cf=CFrame.new(-10994.70, 352.38, -9002.11) },
    { name="Mystic Droplet", mob="Water Fighter", cf=CFrame.new(-3352.90, 285.01, -10534.84) },
    { name="Mini Tusk", mob="Mythological Pirate", cf=CFrame.new(-13680.60, 501.08, -6991.18) },
    { name="Magma Ore", mob="Lava Pirate", cf=CFrame.new(-5213.33, 49.73, -4701.45) },
}

function Godhuman.Step()
    if Remote.Invoke("BuyGodhuman", true) == 1 then State.AutoGodhuman = false; return end
    
    for _, mat in ipairs(GODHUMAN_MATERIALS) do
        local res = Remote.Invoke("getInventory", "Check", mat.name)
        if type(res) == "table" and res.Amount < 10 then
            local mob = Monster.Find(mat.mob)
            if mob then Farm.Teleport(mob.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0), 320); Combat.Attack()
            else Farm.Teleport(mat.cf, 320) end
            return
        end
    end

    local npc = FindNPC("Ancient Monk")
    if npc and npc:FindFirstChild("HumanoidRootPart") then
        Farm.Teleport(npc.HumanoidRootPart.CFrame * CFrame.new(0, 4, 4), 320)
        task.wait(1)
        Remote.Invoke("BuyGodhuman")
    end
end
SafeSpawn(function() while State.Running do task.wait(0.5); if State.AutoGodhuman and PlayerUtils.IsAlive() then pcall(Godhuman.Step) end end end)
getgenv().ChuppyGodhuman = Godhuman

-- ═══════════════════════════════════════════════════════════════════════════════
-- [6.8] PUBLIC API + EXPORTS
-- ═══════════════════════════════════════════════════════════════════════════════
local Chuppy = getgenv().Chuppy
if not Chuppy then warn("[Chuppy Part 6] LỖI: Chưa load Part 2!"); return end

Chuppy.RaceInfo        = RaceInfo
Chuppy.RaceV2          = RaceV2
Chuppy.RaceV3          = RaceV3
Chuppy.RaceV4          = RaceV4
Chuppy.Draco           = Draco
Chuppy.CyborgQuest     = CyborgQuest
Chuppy.GhoulQuest      = GhoulQuest
Chuppy.FightingStyles  = FightingStyles
Chuppy.Godhuman        = Godhuman

function Chuppy.GetRace() return RaceInfo.Format() end

function Chuppy.ToggleRaceV2(enable) State.AutoRaceV2 = enable; Notify("Race V2", enable and "BẬT" or "TẮT", enable and "success" or "warning") end
function Chuppy.ToggleRaceV3(enable) State.AutoRaceV3 = enable; Notify("Race V3", enable and "BẬT" or "TẮT", enable and "success" or "warning") end
function Chuppy.ToggleRaceV4(enable) State.AutoRaceV4 = enable; Notify("Race V4", enable and "BẬT" or "TẮT", enable and "success" or "warning") end
function Chuppy.ToggleDraco(enable) State.AutoDraco = enable; Notify("Draco", enable and "BẬT" or "TẮT", enable and "success" or "warning") end
function Chuppy.ToggleCyborgQuest(enable) State.AutoCyborgQuest = enable; Notify("Cyborg", enable and "BẬT" or "TẮT", enable and "success" or "warning") end
function Chuppy.ToggleGhoulQuest(enable) State.AutoGhoulQuest = enable; Notify("Ghoul", enable and "BẬT" or "TẮT", enable and "success" or "warning") end
function Chuppy.ToggleGodhuman(enable) State.AutoGodhuman = enable; Notify("Godhuman", enable and "BẬT" or "TẮT", enable and "success" or "warning") end
function Chuppy.BuyFightingStyle(styleName) State.AutoFightingStyle = styleName; Notify("Style", "Đang mua: " .. styleName, "info") end

function Chuppy.TurnOnV4()
    local char = PlayerUtils.GetCharacter()
    local energy = char and char:FindFirstChild("RaceEnergy")
    if not energy or energy.Value < 1 then Notify("V4", "Chưa đủ năng lượng", "warning"); return end
    local aw = LP.Backpack:FindFirstChild("Awakening") or (char and char:FindFirstChild("Awakening"))
    if aw then pcall(function() aw.RemoteFunction:InvokeServer(true) end) end
end

if State.AutoTurnOnV4 == nil then State.AutoTurnOnV4 = false end
task.spawn(function() task.wait(2); Notify("Race", "Bạn đang là: " .. RaceInfo.Format(), "info", 5) end)

print("═══════════════════════════════════════════════════════════════════════════════")
print("  ✅ PART 6/10 — RACE + DRACO + QUEST CHAINS LOADED")
print("  📦 RaceV2-V4 · Draco · Cyborg · Ghoul · Styles · Godhuman")
print("  👉 Gõ 'tiếp' để nhận PART 7/10: ITEMS (YAMA/TUSHITA/CDK/MASTERY)")
print("═══════════════════════════════════════════════════════════════════════════════")

end)() -- End IIFE
-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐾 CHUPPY HUB V2 — PART 7/10: ITEMS + CRAFTING + MASTERY
-- Phiên bản sạch: IIFE scope · không return giữa file · export qua getgenv()
-- ═══════════════════════════════════════════════════════════════════════════════
;(function()

-- ═══════════════════════════════════════════════════════════════════════════════
-- [7.0] SERVICES + IMPORTS
-- ═══════════════════════════════════════════════════════════════════════════════
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local RunService        = game:GetService("RunService")

local LP = Players.LocalPlayer

-- Lấy module từ Part 2, 3, 4
local State        = getgenv().ChuppyState
local PlayerUtils  = getgenv().ChuppyPlayer
local Monster      = getgenv().ChuppyMonster
local Remote       = getgenv().ChuppyRemote
local Farm         = getgenv().ChuppyFarm
local Combat       = getgenv().ChuppyCombat
local Notify       = getgenv().Chuppy.Notify
local SafeSpawn    = getgenv().Chuppy.SafeSpawn

if not State or not PlayerUtils or not Farm or not Combat then
    warn("[Chuppy Part 7] LỖI: Chưa load Part 2 & 3!")
    return
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [7.1] ITEM UTILITIES
-- ═══════════════════════════════════════════════════════════════════════════════
local ItemUtils = {}

function ItemUtils.HasItem(itemName)
    if not itemName then return false end
    if LP.Backpack:FindFirstChild(itemName) then return true end
    local char = PlayerUtils.GetCharacter()
    if char and char:FindFirstChild(itemName) then return true end
    return false
end

function ItemUtils.CountItem(itemName)
    if not itemName then return 0 end
    local count = 0
    for _, item in ipairs(LP.Backpack:GetChildren()) do
        if item.Name == itemName then count = count + 1 end
    end
    local char = PlayerUtils.GetCharacter()
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item.Name == itemName then count = count + 1 end
        end
    end
    return count
end

function ItemUtils.GetMastery(toolName)
    if not toolName then return 0 end
    local tool = LP.Backpack:FindFirstChild(toolName)
    if not tool then
        local char = PlayerUtils.GetCharacter()
        tool = char and char:FindFirstChild(toolName)
    end
    if not tool then return 0 end
    local level = tool:FindFirstChild("Level")
    return level and level.Value or 0
end

function ItemUtils.GetToolByType(toolType)
    local char = PlayerUtils.GetCharacter()
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool.ToolTip == toolType then return tool end
        end
    end
    for _, tool in ipairs(LP.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.ToolTip == toolType then return tool end
    end
    return nil
end
getgenv().ChuppyItemUtils = ItemUtils

-- ═══════════════════════════════════════════════════════════════════════════════
-- [7.2] SABER QUEST
-- ═══════════════════════════════════════════════════════════════════════════════
local SaberQuest = {}

local SABER_EXPERT_CF = CFrame.new(-1405.37, 29.98, 4.57)
local CUP_CF          = CFrame.new(1112.47, 4.92, 4364.55)
local CUP_TURN_IN_CF  = CFrame.new(1395.77, 37.47, -1324.35)
local SICK_MAN_CF     = CFrame.new(1457.88, 88.38, -1390.69)

function SaberQuest.Step()
    if ItemUtils.HasItem("Saber") then State.AutoSaber = false; return end
    if PlayerUtils.GetLevel() < 200 or State.World ~= 1 then State.AutoSaber = false; return end

    local map = Workspace:FindFirstChild("Map")
    local jungle = map and map:FindFirstChild("Jungle")
    local desert = map and map:FindFirstChild("Desert")
    
    -- Check doors
    local doorCupOpen = false
    local burn = desert and desert:FindFirstChild("Burn")
    if burn then for _, p in ipairs(burn:GetChildren()) do if p:IsA("Part") and not p.CanCollide then doorCupOpen = true; break end end end
    
    local doorSaberOpen = false
    local final = jungle and jungle:FindFirstChild("Final")
    if final then for _, p in ipairs(final:GetChildren()) do if p:IsA("Part") and not p.CanCollide then doorSaberOpen = true; break end end end

    if doorSaberOpen then
        local boss = Monster.Find("Saber Expert")
        if boss then Farm.Teleport(boss.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0), 320); Combat.Attack() 
        else Farm.Teleport(SABER_EXPERT_CF, 320) end
        return
    end

    if doorCupOpen then
        local progress = Remote.Invoke("ProQuestProgress", "RichSon")
        if progress == 0 then
            local boss = Monster.Find("Mob Leader")
            if boss then Farm.Teleport(boss.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0), 320); Combat.Attack() end
        elseif progress == 1 then
            if not LP.Backpack:FindFirstChild("Relic") then
                Farm.Teleport(SICK_MAN_CF, 320); task.wait(0.5); Remote.Invoke("ProQuestProgress", "RichSon")
            else
                Farm.Teleport(SABER_EXPERT_CF, 320)
            end
        else
            if not LP.Backpack:FindFirstChild("Cup") then
                Farm.Teleport(CUP_CF, 320); task.wait(0.5)
                local cup = Workspace:FindFirstChild("Cup")
                local hrp = PlayerUtils.GetHRP()
                if cup and hrp then pcall(function() firetouchinterest(cup, hrp, 0); firetouchinterest(cup, hrp, 1) end) end
            else
                Farm.Teleport(CUP_TURN_IN_CF, 320)
            end
        end
        return
    end

    -- Torch logic
    if not LP.Backpack:FindFirstChild("Torch") and not (PlayerUtils.GetCharacter() and PlayerUtils.GetCharacter():FindFirstChild("Torch")) then
        local torch = jungle and jungle:FindFirstChild("Torch")
        if torch then Farm.Teleport(torch.CFrame, 320) end
        return
    end

    local questPlates = jungle and jungle:FindFirstChild("QuestPlates")
    if questPlates then
        for _, plate in ipairs(questPlates:GetChildren()) do
            local btn = plate:FindFirstChild("Button")
            if btn then
                Farm.Teleport(btn.CFrame, 320)
                local char = PlayerUtils.GetCharacter()
                if char and char:FindFirstChild("Torch") then
                    pcall(function() firetouchinterest(char.Torch.Handle, btn, 0); firetouchinterest(char.Torch.Handle, btn, 1) end)
                end
                break
            end
        end
    end
end

SafeSpawn(function() while State.Running do task.wait(0.5); if State.AutoSaber and PlayerUtils.IsAlive() then pcall(SaberQuest.Step) end end end)
getgenv().ChuppySaberQuest = SaberQuest

-- ═══════════════════════════════════════════════════════════════════════════════
-- [7.3] YAMA QUEST
-- ═══════════════════════════════════════════════════════════════════════════════
local YamaQuest = {}
local WATERFALL_CF = CFrame.new(5251.90, 17.18, 453.60)
local ELITE_NAMES = { "Diablo", "Deandre", "Urban" }

function YamaQuest.Step()
    if ItemUtils.HasItem("Yama") then State.AutoYama = false; return end
    if State.World ~= 3 then State.AutoYama = false; return end

    local progress = Remote.Invoke("EliteHunter", "Progress") or 0
    if progress < 30 then
        for _, name in ipairs(ELITE_NAMES) do
            local elite = Monster.Find(name)
            if elite and Monster.IsAlive(elite) then
                Farm.Teleport(elite.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0), 320)
                Combat.Attack()
                return
            end
        end
        Remote.Invoke("EliteHunter")
        task.wait(0.5)
        return
    end

    Farm.Teleport(WATERFALL_CF, 320)
    local map = Workspace:FindFirstChild("Map")
    local waterfall = map and map:FindFirstChild("Waterfall")
    local sealed = waterfall and waterfall:FindFirstChild("SealedKatana")
    local hitbox = sealed and sealed:FindFirstChild("Hitbox")
    local cd = hitbox and hitbox:FindFirstChild("ClickDetector")
    if cd then pcall(fireclickdetector, cd); task.wait(1) end
end

SafeSpawn(function() while State.Running do task.wait(0.5); if State.AutoYama and PlayerUtils.IsAlive() then pcall(YamaQuest.Step) end end end)
getgenv().ChuppyYamaQuest = YamaQuest

-- ═══════════════════════════════════════════════════════════════════════════════
-- [7.4] TUSHITA QUEST
-- ═══════════════════════════════════════════════════════════════════════════════
local TushitaQuest = {}
local HOLY_TORCH_CF = CFrame.new(5713.54, 38.38, 255.20)

function TushitaQuest.Step()
    if ItemUtils.HasItem("Tushita") then State.AutoTushita = false; return end
    if State.World ~= 3 then State.AutoTushita = false; return end

    local doorOpened = Remote.Invoke("TushitaProgress")
    if type(doorOpened) == "table" and doorOpened.OpenedDoor then
        local longma = Monster.Find("Longma")
        if longma and Monster.IsAlive(longma) then
            Farm.Teleport(longma.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0), 320)
            Combat.Attack()
        else
            Farm.Teleport(CFrame.new(-5325.00, 532.50, -2325.00), 320)
        end
        return
    end

    local map = Workspace:FindFirstChild("Map")
    local waterfall = map and map:FindFirstChild("Waterfall")
    local island = waterfall and waterfall:FindFirstChild("IslandModel")
    local hitbox = island and island:FindFirstChild("Hitbox", true)

    if not LP.Backpack:FindFirstChild("Holy Torch") then
        if hitbox then Farm.Teleport(hitbox.CFrame, 320) else Farm.Teleport(HOLY_TORCH_CF, 320) end
        return
    end

    local turtle = map and map:FindFirstChild("Turtle")
    local torches = turtle and turtle:FindFirstChild("QuestTorches")
    if torches then
        for i = 1, 5 do
            local torch = torches:FindFirstChild("Torch" .. i)
            if torch then
                local particles = torch:FindFirstChild("Particles")
                local main = particles and particles:FindFirstChild("Main")
                if main and not main.Enabled then
                    Farm.Teleport(CFrame.new(torch.Position), 320)
                    Remote.Invoke("TushitaProgress", "Torch", i)
                    task.wait(0.5)
                    return
                end
            end
        end
    end

    if hitbox then Farm.Teleport(hitbox.CFrame, 320) end
end

SafeSpawn(function() while State.Running do task.wait(0.5); if State.AutoTushita and PlayerUtils.IsAlive() then pcall(TushitaQuest.Step) end end end)
getgenv().ChuppyTushitaQuest = TushitaQuest

-- ═══════════════════════════════════════════════════════════════════════════════
-- [7.5] CURSED DUAL KATANA (CDK)
-- ═══════════════════════════════════════════════════════════════════════════════
local CDKQuest = {}

function CDKQuest.Step()
    if ItemUtils.HasItem("Cursed Dual Katana") then State.AutoCDK = false; return end
    if State.World ~= 3 then State.AutoCDK = false; return end

    local tLv = ItemUtils.GetMastery("Tushita")
    local yLv = ItemUtils.GetMastery("Yama")
    if tLv < 350 or yLv < 350 then State.AutoCDK = false; return end -- Cần farm mastery trước

    local map = Workspace:FindFirstChild("Map")
    local turtle = map and map:FindFirstChild("Turtle")
    local cursed = turtle and turtle:FindFirstChild("Cursed")

    local prog = Remote.Invoke("CDKQuest", "Progress", "Good")
    if type(prog) ~= "table" then return end
    local good, evil = prog.Good or 0, prog.Evil or 0

    local function ActivatePedestal(name)
        local ped = cursed and cursed:FindFirstChild(name)
        if ped then
            Farm.Teleport(ped:GetPivot(), 320)
            local prompt = ped:FindFirstChildOfClass("ProximityPrompt")
            if prompt then pcall(fireproximityprompt, prompt) end
        end
    end

    if good == 4 and evil == 3 then ActivatePedestal("Pedestal2"); return end
    if good == 3 and evil == 4 then ActivatePedestal("Pedestal1"); return end

    if good == 4 and evil == 4 then
        ActivatePedestal("Pedestal3")
        task.wait(1)
        local boss = Monster.Find("Cursed Skeleton Boss")
        if boss then Farm.Teleport(boss.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0), 320); Combat.Attack() end
        return
    end

    if good < 4 then Remote.Invoke("CDKQuest", "StartTrial", "Good")
    elseif evil < 4 then Remote.Invoke("CDKQuest", "StartTrial", "Evil") end
    task.wait(1)

    local mob = Monster.FindNearest(250)
    if mob then Farm.Teleport(mob.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0), 320); Combat.Attack() end
end

SafeSpawn(function() while State.Running do task.wait(0.5); if State.AutoCDK and PlayerUtils.IsAlive() then pcall(CDKQuest.Step) end end end)
getgenv().ChuppyCDKQuest = CDKQuest

-- ═══════════════════════════════════════════════════════════════════════════════
-- [7.6] AUTO MASTERY
-- ═══════════════════════════════════════════════════════════════════════════════
local MasteryFarm = {}
local MASTERY_TARGET = 600

function MasteryFarm.Step()
    if not State.AutoFarm then State.AutoMastery = false; return end
    local typeToFarm = State.MasteryType or "Sword"
    local char = PlayerUtils.GetCharacter()
    local hum = PlayerUtils.GetHumanoid()
    if not char or not hum then return end

    local current = char:FindFirstChildOfClass("Tool")
    if current and current.ToolTip == typeToFarm then
        local lv = current:FindFirstChild("Level")
        if lv and lv.Value < MASTERY_TARGET then return end
    end

    for _, tool in ipairs(LP.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.ToolTip == typeToFarm then
            local lv = tool:FindFirstChild("Level")
            if lv and lv.Value < MASTERY_TARGET then
                hum:EquipTool(tool)
                return
            end
        end
    end
    State.AutoMastery = false
end

SafeSpawn(function() while State.Running do task.wait(3); if State.AutoMastery then pcall(MasteryFarm.Step) end end end)
getgenv().ChuppyMasteryFarm = MasteryFarm

-- ═══════════════════════════════════════════════════════════════════════════════
-- [7.7] CRAFTING & DEALERS & COLLECTORS
-- ═══════════════════════════════════════════════════════════════════════════════
local Crafting = {}
function Crafting.Craft(recipe, amount)
    local net = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Net")
    local rf = net and net:FindFirstChild("RF/Craft")
    if rf then pcall(function() rf:InvokeServer("Craft", recipe, amount or 1, {}) end) end
end

local LegendaryDealer = {}
function LegendaryDealer.Buy()
    if PlayerUtils.GetBeli() >= 2000000 and Remote then
        Remote.Invoke("LegendarySwordDealer", "2")
    end
end

local ColorDealer = {}
function ColorDealer.Buy()
    if PlayerUtils.GetBeli() >= 100000 and Remote then
        Remote.Invoke("ColorsDealer", "2")
    end
end

local MaterialCollector = {}
function MaterialCollector.FarmEcto()
    if State.World ~= 2 then Remote.Invoke("TravelDressrosa"); return end
    local mob = Monster.Find("Ship Deckhand") or Monster.Find("Ship Engineer") or Monster.Find("Ship Steward")
    if mob then Farm.Teleport(mob.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0), 320); Combat.Attack() 
    else Farm.Teleport(CFrame.new(1037.80, 125.09, 32911.60), 320) end
end

function MaterialCollector.FarmBones()
    if State.World ~= 3 then Remote.Invoke("TravelZou"); return end
    local mob = Monster.Find("Reborn Skeleton") or Monster.Find("Living Zombie") or Monster.Find("Demonic Soul")
    if mob then Farm.Teleport(mob.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0), 320); Combat.Attack() 
    else Farm.Teleport(CFrame.new(-9479.21, 141.21, 5566.09), 320) end
end

SafeSpawn(function()
    while State.Running do
        task.wait(1)
        if State.AutoCollectEcto then pcall(MaterialCollector.FarmEcto) end
        if State.AutoCollectBones then pcall(MaterialCollector.FarmBones) end
        if State.AutoLegendarySword then pcall(LegendaryDealer.Buy) end
        if State.AutoHakiColor then pcall(ColorDealer.Buy) end
    end
end)

getgenv().ChuppyCrafting = Crafting
getgenv().ChuppyLegendaryDealer = LegendaryDealer
getgenv().ChuppyColorDealer = ColorDealer
getgenv().ChuppyMaterialCollector = MaterialCollector

-- ═══════════════════════════════════════════════════════════════════════════════
-- [7.8] PUBLIC API + EXPORTS
-- ═══════════════════════════════════════════════════════════════════════════════
local Chuppy = getgenv().Chuppy
if not Chuppy then warn("[Chuppy Part 7] LỖI: Chưa load Part 2!"); return end

Chuppy.ItemUtils          = ItemUtils
Chuppy.SaberQuest         = SaberQuest
Chuppy.YamaQuest          = YamaQuest
Chuppy.TushitaQuest       = TushitaQuest
Chuppy.CDKQuest           = CDKQuest
Chuppy.MasteryFarm        = MasteryFarm
Chuppy.Crafting           = Crafting
Chuppy.LegendaryDealer    = LegendaryDealer
Chuppy.ColorDealer        = ColorDealer
Chuppy.MaterialCollector  = MaterialCollector

function Chuppy.HasItem(name) return ItemUtils.HasItem(name) end
function Chuppy.GetMastery(toolName) return ItemUtils.GetMastery(toolName) end

function Chuppy.ToggleSaber(enable) State.AutoSaber = enable; Notify("Saber", enable and "BẬT" or "TẮT", enable and "success" or "warning") end
function Chuppy.ToggleYama(enable) State.AutoYama = enable; Notify("Yama", enable and "BẬT" or "TẮT", enable and "success" or "warning") end
function Chuppy.ToggleTushita(enable) State.AutoTushita = enable; Notify("Tushita", enable and "BẬT" or "TẮT", enable and "success" or "warning") end
function Chuppy.ToggleCDK(enable) State.AutoCDK = enable; Notify("CDK", enable and "BẬT" or "TẮT", enable and "success" or "warning") end
function Chuppy.ToggleMastery(enable, weaponType) State.AutoMastery = enable; if weaponType then State.MasteryType = weaponType end; Notify("Mastery", enable and "BẬT" or "TẮT", enable and "success" or "warning") end

function Chuppy.ToggleCraftSharkAnchor(enable) State.AutoCraftSharkAnchor = enable end
function Chuppy.ToggleCraftVolcanicMagnet(enable) State.AutoCraftVolcanicMagnet = enable end
function Chuppy.BuyLegendarySword() LegendaryDealer.Buy(); Notify("Legendary", "Đã mua random LS", "info") end
function Chuppy.ToggleLegendarySword(enable) State.AutoLegendarySword = enable end
function Chuppy.ToggleHakiColor(enable) State.AutoHakiColor = enable end
function Chuppy.ToggleCollectEcto(enable) State.AutoCollectEcto = enable end
function Chuppy.ToggleCollectBones(enable) State.AutoCollectBones = enable end

if State.MasteryType == nil then State.MasteryType = "Sword" end

print("═══════════════════════════════════════════════════════════════════════════════")
print("  ✅ PART 7/10 — ITEMS + CRAFTING + MASTERY LOADED")
print("  📦 Saber · Yama · Tushita · CDK · Mastery · Craft · Dealer")
print("  👉 Gõ 'tiếp' để nhận PART 8/10: ESP + DRAWING + PLAYER TRACKER")
print("═══════════════════════════════════════════════════════════════════════════════")

end)() -- End IIFE
-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐾 CHUPPY HUB V2 — PART 8/10: ESP + DRAWING + PLAYER TRACKER
-- Phiên bản sạch: IIFE scope · Fix lỗi Farm nil · export qua getgenv()
-- ═══════════════════════════════════════════════════════════════════════════════
;(function()

-- ═══════════════════════════════════════════════════════════════════════════════
-- [8.0] SERVICES + IMPORTS
-- ═══════════════════════════════════════════════════════════════════════════════
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local Workspace         = game:GetService("Workspace")
local CollectionService = game:GetService("CollectionService")
local TweenService      = game:GetService("TweenService")

local LP     = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Lấy module từ Part 2, 3, 4
local State        = getgenv().ChuppyState
local PlayerUtils  = getgenv().ChuppyPlayer
local Monster      = getgenv().ChuppyMonster
local Farm         = getgenv().ChuppyFarm -- ✅ FIX LỖI: Thêm biến Farm bị thiếu
local Notify       = getgenv().Chuppy.Notify
local Track        = getgenv().Chuppy.Track
local SafeSpawn    = getgenv().Chuppy.SafeSpawn

if not State or not PlayerUtils or not Monster then
    warn("[Chuppy Part 8] LỖI: Chưa load Part 2 & 3!")
    return
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [8.1] DRAWING UTILITY (Safe Wrapper)
-- ═══════════════════════════════════════════════════════════════════════════════
local DrawingUtil = {}

local hasDrawing = pcall(function() return Drawing ~= nil end)
local supportsDrawing = hasDrawing and Drawing and Drawing.new

function DrawingUtil.IsSupported() return supportsDrawing end
function DrawingUtil.New(class) 
    if not supportsDrawing then return nil end
    local ok, obj = pcall(Drawing.new, class)
    return ok and obj or nil
end
function DrawingUtil.Remove(obj) if obj then pcall(function() obj:Remove() end) end end
function DrawingUtil.Hide(obj) if obj then pcall(function() obj.Visible = false end) end end
getgenv().ChuppyDrawing = DrawingUtil

-- ═══════════════════════════════════════════════════════════════════════════════
-- [8.2] ESP CORE & STORAGE
-- ═══════════════════════════════════════════════════════════════════════════════
local ESPCore = {}
local ESP = {
    players = {}, fruits = {}, chests = {}, bosses = {}, islands = {}, highlights = {}
}

ESPCore.Colors = {
    Player_Ally = Color3.fromRGB(80, 255, 120), Player_Enemy = Color3.fromRGB(255, 80, 80), Player_Neutral = Color3.fromRGB(255, 255, 255),
    Fruit = Color3.fromRGB(255, 100, 200), Fruit_Rare = Color3.fromRGB(255, 200, 0), Fruit_Mythic = Color3.fromRGB(255, 50, 100),
    Chest = Color3.fromRGB(255, 215, 0), Boss = Color3.fromRGB(255, 100, 100), Island = Color3.fromRGB(8, 247, 255),
    Mirage = Color3.fromRGB(180, 130, 255), Kitsune = Color3.fromRGB(255, 180, 60), Aura = Color3.fromRGB(255, 60, 60),
    Tracer = Color3.fromRGB(0, 200, 255),
}

local function CleanupBillboard(instance)
    if not instance then return end
    local bb = instance:FindFirstChild("ChuppyESP")
    if bb then bb:Destroy() end
end

function ESPCore.CleanupAll()
    for _, entry in pairs(ESP.players) do
        if entry.billboard then CleanupBillboard(entry.billboard.Adornee) end
        if entry.tracer then DrawingUtil.Remove(entry.tracer) end
    end
    for inst in pairs(ESP.fruits) do CleanupBillboard(inst) end
    for inst in pairs(ESP.chests) do CleanupBillboard(inst) end
    for inst in pairs(ESP.bosses) do CleanupBillboard(inst) end
    for inst in pairs(ESP.islands) do CleanupBillboard(inst) end
    for mob, hl in pairs(ESP.highlights) do if hl and hl.Parent then hl:Destroy() end end
    
    ESP.players = {}; ESP.fruits = {}; ESP.chests = {}; ESP.bosses = {}; ESP.islands = {}; ESP.highlights = {}
end

Track(LP.CharacterAdded:Connect(function() task.wait(2); ESPCore.CleanupAll() end))
getgenv().ChuppyESPCore = ESPCore

-- ═══════════════════════════════════════════════════════════════════════════════
-- [8.3] PLAYER ESP (Billboard + Tracer)
-- ═══════════════════════════════════════════════════════════════════════════════
local function GetPlayerColor(plr)
    if plr == LP then return ESPCore.Colors.Player_Neutral end
    if plr.Team and LP.Team then
        return plr.Team == LP.Team and ESPCore.Colors.Player_Ally or ESPCore.Colors.Player_Enemy
    end
    return ESPCore.Colors.Player_Neutral
end

local function CreatePlayerBillboard(plr)
    local char = plr.Character
    local head = char and char:FindFirstChild("Head")
    if not head then return nil end

    local bb = Instance.new("BillboardGui")
    bb.Name = "ChuppyESP"; bb.Size = UDim2.new(0, 200, 0, 50); bb.StudsOffset = Vector3.new(0, 3, 0); bb.AlwaysOnTop = true; bb.Adornee = head
    
    local container = Instance.new("Frame", bb)
    container.Size = UDim2.new(1, 0, 1, 0); container.BackgroundTransparency = 1

    local nameLbl = Instance.new("TextLabel", container)
    nameLbl.Name = "NameLbl"; nameLbl.Size = UDim2.new(1, 0, 0, 16); nameLbl.BackgroundTransparency = 1
    nameLbl.Font = Enum.Font.GothamBold; nameLbl.TextSize = 13; nameLbl.TextColor3 = GetPlayerColor(plr)
    nameLbl.TextStrokeTransparency = 0.3; nameLbl.Text = plr.Name

    local hpBg = Instance.new("Frame", container)
    hpBg.Name = "HPBg"; hpBg.Size = UDim2.new(0.8, 0, 0, 4); hpBg.Position = UDim2.new(0.1, 0, 0, 18)
    hpBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30); hpBg.BorderSizePixel = 0
    Instance.new("UICorner", hpBg).CornerRadius = UDim.new(1, 0)

    local hpFill = Instance.new("Frame", hpBg)
    hpFill.Name = "HPFill"; hpFill.Size = UDim2.new(1, 0, 1, 0); hpFill.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
    hpFill.BorderSizePixel = 0; Instance.new("UICorner", hpFill).CornerRadius = UDim.new(1, 0)

    local distLbl = Instance.new("TextLabel", container)
    distLbl.Name = "DistLbl"; distLbl.Size = UDim2.new(1, 0, 0, 14); distLbl.Position = UDim2.new(0, 0, 0, 24)
    distLbl.BackgroundTransparency = 1; distLbl.Font = Enum.Font.Gotham; distLbl.TextSize = 11
    distLbl.TextColor3 = Color3.fromRGB(220, 220, 220); distLbl.TextStrokeTransparency = 0.5

    bb.Parent = head
    return bb
end

SafeSpawn(function()
    while State.Running do
        task.wait(0.2)
        if State.ESPPlayer then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP then
                    local char = plr.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    local entry = ESP.players[plr.UserId]

                    if not hrp or not hum or hum.Health <= 0 then
                        if entry then
                            if entry.billboard then CleanupBillboard(entry.billboard.Adornee) end
                            if entry.tracer then DrawingUtil.Remove(entry.tracer) end
                            ESP.players[plr.UserId] = nil
                        end
                        continue
                    end

                    if not entry then
                        entry = { target = plr, billboard = CreatePlayerBillboard(plr) }
                        if DrawingUtil.IsSupported() then
                            entry.tracer = DrawingUtil.New("Line")
                            if entry.tracer then
                                entry.tracer.Thickness = 1; entry.tracer.Transparency = 0.5; entry.tracer.Visible = false
                            end
                        end
                        ESP.players[plr.UserId] = entry
                    end

                    if entry.billboard and entry.billboard.Parent then
                        local container = entry.billboard:FindFirstChildOfClass("Frame")
                        if container then
                            local dist = math.floor((hrp.Position - Camera.CFrame.Position).Magnitude)
                            container.NameLbl.TextColor3 = GetPlayerColor(plr)
                            container.DistLbl.Text = string.format("%dm | %d/%d HP", dist, math.floor(hum.Health), math.floor(hum.MaxHealth))
                            
                            local ratio = hum.Health / math.max(hum.MaxHealth, 1)
                            container.HPBg.HPFill.Size = UDim2.new(ratio, 0, 1, 0)
                            container.HPBg.HPFill.BackgroundColor3 = ratio > 0.5 and Color3.fromRGB(0, 220, 100) or (ratio > 0.25 and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(255, 60, 60))
                        end
                    end

                    if entry.tracer then
                        local vp = Camera:WorldToViewportPoint(hrp.Position)
                        entry.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        entry.tracer.To = Vector2.new(vp.X, vp.Y)
                        entry.tracer.Color = GetPlayerColor(plr)
                        entry.tracer.Visible = (vp.Z > 0) and State.ESPPlayerTracer
                    end
                end
            end
        else
            if next(ESP.players) then ESPCore.CleanupAll() end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [8.4] FRUIT / CHEST / BOSS / ISLAND ESP
-- ═══════════════════════════════════════════════════════════════════════════════
local RARE_FRUITS = { "Dragon", "Leopard", "Kitsune", "Venom", "Dough", "Spirit", "T-Rex", "Mammoth", "Gravity", "Shadow", "Control" }

local function GetFruitColor(name)
    for _, rf in ipairs(RARE_FRUITS) do if string.find(name, rf, 1, true) then return ESPCore.Colors.Fruit_Mythic end end
    return ESPCore.Colors.Fruit
end

local function CreateSimpleBillboard(inst, text, color, sizeY)
    local bb = Instance.new("BillboardGui", inst)
    bb.Name = "ChuppyESP"; bb.Size = UDim2.new(0, 200, 0, sizeY or 24); bb.StudsOffset = Vector3.new(0, 3, 0); bb.AlwaysOnTop = true; bb.Adornee = inst
    local lbl = Instance.new("TextLabel", bb)
    lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1; lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13; lbl.TextColor3 = color; lbl.TextStrokeTransparency = 0.2; lbl.Text = text
    return bb, lbl
end

SafeSpawn(function()
    while State.Running do
        task.wait(0.3)
        local origin = PlayerUtils.GetPosition()

        -- Fruit ESP
        if State.ESPFruit then
            for _, obj in ipairs(Workspace:GetChildren()) do
                if (obj:IsA("Tool") or obj:IsA("Model")) and obj.Name:find("Fruit") and obj:FindFirstChild("Handle") then
                    local handle = obj.Handle
                    if not handle:FindFirstChild("ChuppyESP") then
                        CreateSimpleBillboard(handle, obj.Name, GetFruitColor(obj.Name), 30)
                        ESP.fruits[handle] = true
                    end
                    local lbl = handle.ChuppyESP:FindFirstChildOfClass("TextLabel")
                    if lbl then lbl.Text = string.format("%s | %dm", obj.Name, math.floor((handle.Position - origin).Magnitude / 3)) end
                end
            end
        else
            for handle in pairs(ESP.fruits) do CleanupBillboard(handle); ESP.fruits[handle] = nil end
        end

        -- Chest ESP
        if State.ESPChest then
            for _, ch in ipairs(CollectionService:GetTagged("_ChestTagged")) do
                if not ch:GetAttribute("IsDisabled") and not ch:FindFirstChild("Ignored") then
                    if not ch:FindFirstChild("ChuppyESP") then
                        CreateSimpleBillboard(ch, "🎁 Chest", ESPCore.Colors.Chest)
                        ESP.chests[ch] = true
                    end
                    local lbl = ch.ChuppyESP:FindFirstChildOfClass("TextLabel")
                    if lbl then lbl.Text = string.format("🎁 Chest | %dm", math.floor((ch:GetPivot().Position - origin).Magnitude / 3)) end
                end
            end
        else
            for ch in pairs(ESP.chests) do CleanupBillboard(ch); ESP.chests[ch] = nil end
        end

        -- Boss ESP
        if State.ESPBoss then
            local bossDB = getgenv().ChuppyBossDB or {}
            local isBoss = {}
            for _, b in ipairs(bossDB) do isBoss[b.name] = true end
            local enemies = Workspace:FindFirstChild("Enemies")
            if enemies then
                for _, mob in ipairs(enemies:GetChildren()) do
                    if isBoss[mob.Name] and Monster.IsAlive(mob) then
                        local head = mob:FindFirstChild("Head") or mob:FindFirstChild("HumanoidRootPart")
                        if head and not head:FindFirstChild("ChuppyESP") then
                            local bb = Instance.new("BillboardGui", head)
                            bb.Name = "ChuppyESP"; bb.Size = UDim2.new(0, 220, 0, 36); bb.StudsOffset = Vector3.new(0, 4, 0); bb.AlwaysOnTop = true
                            
                            local nameLbl = Instance.new("TextLabel", bb)
                            nameLbl.Size = UDim2.new(1, 0, 0, 18); nameLbl.BackgroundTransparency = 1; nameLbl.Font = Enum.Font.GothamBlack
                            nameLbl.TextSize = 14; nameLbl.TextColor3 = ESPCore.Colors.Boss; nameLbl.TextStrokeTransparency = 0.2; nameLbl.Text = "👑 " .. mob.Name
                            
                            local hpLbl = Instance.new("TextLabel", bb)
                            hpLbl.Name = "HPLbl"; hpLbl.Size = UDim2.new(1, 0, 0, 14); hpLbl.Position = UDim2.new(0, 0, 0, 18)
                            hpLbl.BackgroundTransparency = 1; hpLbl.Font = Enum.Font.Gotham; hpLbl.TextSize = 11; hpLbl.TextColor3 = Color3.fromRGB(255, 220, 220)
                            hpLbl.TextStrokeTransparency = 0.5
                            
                            ESP.bosses[mob] = true
                        end
                        local bb = head and head:FindFirstChild("ChuppyESP")
                        local hum = mob:FindFirstChildOfClass("Humanoid")
                        if bb and hum then
                            bb.HPLbl.Text = string.format("%d/%d HP", math.floor(hum.Health), math.floor(hum.MaxHealth))
                        end
                    end
                end
            end
        else
            for mob in pairs(ESP.bosses) do 
                local head = mob:FindFirstChild("Head") or mob:FindFirstChild("HumanoidRootPart")
                if head then CleanupBillboard(head) end
                ESP.bosses[mob] = nil 
            end
        end

        -- Island ESP
        if State.ESPIsland then
            local wOrigin = Workspace:FindFirstChild("_WorldOrigin")
            local locations = wOrigin and wOrigin:FindFirstChild("Locations")
            if locations then
                for _, loc in ipairs(locations:GetChildren()) do
                    if loc:IsA("BasePart") and loc.Name ~= "Sea" then
                        if not loc:FindFirstChild("ChuppyESP") then
                            local color = loc.Name == "Mirage Island" and ESPCore.Colors.Mirage or (loc.Name == "Kitsune Island" and ESPCore.Colors.Kitsune or ESPCore.Colors.Island)
                            CreateSimpleBillboard(loc, loc.Name, color, 30)
                            loc.ChuppyESP.TextLabel.TextSize = 15
                            ESP.islands[loc] = true
                        end
                        local lbl = loc.ChuppyESP:FindFirstChildOfClass("TextLabel")
                        if lbl then lbl.Text = string.format("%s | %dm", loc.Name, math.floor((loc.Position - origin).Magnitude / 3)) end
                    end
                end
            end
        else
            for loc in pairs(ESP.islands) do CleanupBillboard(loc); ESP.islands[loc] = nil end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [8.5] AURA ESP (Highlight)
-- ═══════════════════════════════════════════════════════════════════════════════
SafeSpawn(function()
    while State.Running do
        task.wait(0.5)
        if State.ESPAura then
            local range = State.ESPAuraRange or 300
            local hrp = PlayerUtils.GetHRP()
            local enemies = Workspace:FindFirstChild("Enemies")
            
            if hrp and enemies then
                for _, mob in ipairs(enemies:GetChildren()) do
                    if Monster.IsAlive(mob) then
                        local rp = mob:FindFirstChild("HumanoidRootPart")
                        if rp and (rp.Position - hrp.Position).Magnitude <= range then
                            if not ESP.highlights[mob] then
                                local hl = Instance.new("Highlight", mob)
                                hl.Name = "ChuppyESP"; hl.FillColor = ESPCore.Colors.Aura; hl.OutlineColor = ESPCore.Colors.Aura
                                hl.FillTransparency = 0.7; hl.OutlineTransparency = 0.2; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                ESP.highlights[mob] = hl
                            end
                        else
                            if ESP.highlights[mob] then ESP.highlights[mob]:Destroy(); ESP.highlights[mob] = nil end
                        end
                    end
                end
            end
        else
            for mob, hl in pairs(ESP.highlights) do if hl and hl.Parent then hl:Destroy() end end
            ESP.highlights = {}
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [8.6] PLAYER TRACKER (Panel)
-- ═══════════════════════════════════════════════════════════════════════════════
local Tracker = {}
local trackerGui, trackerList = nil, nil

function Tracker.Refresh()
    if not trackerList or not trackerList.Parent then return end
    for _, child in ipairs(trackerList:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end

    local players = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                table.insert(players, { plr = plr, dist = (hrp.Position - PlayerUtils.GetPosition()).Magnitude })
            end
        end
    end
    table.sort(players, function(a, b) return a.dist < b.dist end)

    for i, data in ipairs(players) do
        local btn = Instance.new("TextButton", trackerList)
        btn.Size = UDim2.new(1, 0, 0, 32); btn.BackgroundColor3 = Color3.fromRGB(30, 32, 45); btn.BorderSizePixel = 0
        btn.Font = Enum.Font.GothamMedium; btn.TextSize = 11; btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        btn.Text = string.format("  %s [%dm]", data.plr.Name, math.floor(data.dist)); btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.LayoutOrder = i; btn.AutoButtonColor = false
        
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.MouseButton1Click:Connect(function()
            local tHRP = data.plr.Character and data.plr.Character:FindFirstChild("HumanoidRootPart")
            if tHRP and Farm then 
                Farm.Teleport(tHRP.CFrame * CFrame.new(0, 5, 0), 350)
                Notify("Tracker", "Đã tới " .. data.plr.Name, "success", 3) 
            end
        end)
    end
end

function Tracker.Toggle(enable)
    if not enable then if trackerGui then trackerGui.Visible = false end; return end
    if trackerGui and trackerGui.Parent then trackerGui.Visible = true; Tracker.Refresh(); return end

    local sg = getgenv().ChuppyScreenGui
    if not sg then return end
    
    trackerGui = Instance.new("Frame", sg)
    trackerGui.Name = "PlayerTracker"; trackerGui.Size = UDim2.new(0, 220, 0, 320); trackerGui.Position = UDim2.new(0, 12, 0.5, -160)
    trackerGui.BackgroundColor3 = Color3.fromRGB(20, 22, 30); trackerGui.BackgroundTransparency = 0.05; trackerGui.BorderSizePixel = 0
    Instance.new("UICorner", trackerGui).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", {Color = Color3.fromRGB(0, 190, 255), Thickness = 1, Transparency = 0.3, Parent = trackerGui})

    local header = Instance.new("TextLabel", trackerGui)
    header.Size = UDim2.new(1, 0, 0, 26); header.BackgroundColor3 = Color3.fromRGB(30, 32, 45); header.BorderSizePixel = 0
    header.Font = Enum.Font.GothamBold; header.TextSize = 12; header.TextColor3 = Color3.fromRGB(0, 190, 255); header.Text = "📡 PLAYER TRACKER"
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0, 20, 0, 20); closeBtn.Position = UDim2.new(1, -24, 0, 3); closeBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 28)
    closeBtn.Text = "✕"; closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100); closeBtn.Font = Enum.Font.GothamBold; closeBtn.BorderSizePixel = 0
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)
    closeBtn.MouseButton1Click:Connect(function() trackerGui.Visible = false end)

    trackerList = Instance.new("ScrollingFrame", trackerGui)
    trackerList.Size = UDim2.new(1, -12, 1, -36); trackerList.Position = UDim2.new(0, 6, 0, 30); trackerList.BackgroundTransparency = 1
    trackerList.ScrollBarThickness = 3; trackerList.ScrollBarImageColor3 = Color3.fromRGB(0, 190, 255); trackerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UIListLayout", {Padding = UDim.new(0, 4), Parent = trackerList})
    Tracker.Refresh()
end

SafeSpawn(function() while State.Running do task.wait(1); if trackerGui and trackerGui.Visible then pcall(Tracker.Refresh) end end end)
getgenv().ChuppyTracker = Tracker

-- ═══════════════════════════════════════════════════════════════════════════════
-- [8.7] PUBLIC API + EXPORTS
-- ═══════════════════════════════════════════════════════════════════════════════
local Chuppy = getgenv().Chuppy
if not Chuppy then warn("[Chuppy Part 8] LỖI: Chưa load Part 2!"); return end

Chuppy.DrawingUtil   = DrawingUtil
Chuppy.ESPCore       = ESPCore
Chuppy.Tracker       = Tracker

function Chuppy.ToggleESPPlayer(enable, tracer)
    State.ESPPlayer = enable
    if tracer ~= nil then State.ESPPlayerTracer = tracer end
    Notify("ESP Player", enable and "BẬT" or "TẮT", enable and "success" or "warning")
end
function Chuppy.ToggleESPFruit(enable) State.ESPFruit = enable; Notify("ESP Fruit", enable and "BẬT" or "TẮT", enable and "success" or "warning") end
function Chuppy.ToggleESPChest(enable) State.ESPChest = enable; Notify("ESP Chest", enable and "BẬT" or "TẮT", enable and "success" or "warning") end
function Chuppy.ToggleESPBoss(enable) State.ESPBoss = enable; Notify("ESP Boss", enable and "BẬT" or "TẮT", enable and "success" or "warning") end
function Chuppy.ToggleESPIsland(enable) State.ESPIsland = enable; Notify("ESP Island", enable and "BẬT" or "TẮT", enable and "success" or "warning") end
function Chuppy.ToggleESPAura(enable, range) State.ESPAura = enable; if range then State.ESPAuraRange = range end; Notify("ESP Aura", enable and "BẬT" or "TẮT", enable and "success" or "warning") end
function Chuppy.ToggleTracker(enable) Tracker.Toggle(enable); Notify("Tracker", enable and "BẬT" or "TẮT", enable and "success" or "warning") end
function Chuppy.CleanupAllESP() ESPCore.CleanupAll(); Notify("ESP", "Đã xoá toàn bộ ESP", "info", 3) end

if State.ESPPlayerTracer == nil then State.ESPPlayerTracer = true end
if State.ESPAuraRange == nil then State.ESPAuraRange = 300 end
if State.ESPPlayer == nil then State.ESPPlayer = false end
if State.ESPFruit == nil then State.ESPFruit = false end
if State.ESPChest == nil then State.ESPChest = false end
if State.ESPBoss == nil then State.ESPBoss = false end
if State.ESPIsland == nil then State.ESPIsland = false end
if State.ESPAura == nil then State.ESPAura = false end

Chuppy.OnUnload = Chuppy.OnUnload or {}
table.insert(Chuppy.OnUnload, function() pcall(ESPCore.CleanupAll) end)

print("═══════════════════════════════════════════════════════════════════════════════")
print("  ✅ PART 8/10 — ESP + DRAWING + PLAYER TRACKER LOADED")
print("  📦 Player · Fruit · Chest · Boss · Island · Aura · Tracker")
print("  👉 Gõ 'tiếp' để nhận PART 9/10: PVP (AIMBOT + SILENT AIM + COMBO)")
print("═══════════════════════════════════════════════════════════════════════════════")

end)() -- End IIFE
-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐾 CHUPPY HUB V2 — PART 9/10: PVP MODULE
-- Phiên bản sạch: IIFE scope · Fix lỗi unpack & SendKeyEvent · export qua getgenv()
-- ═══════════════════════════════════════════════════════════════════════════════
;(function()

-- ═══════════════════════════════════════════════════════════════════════════════
-- [9.0] SERVICES + IMPORTS
-- ═══════════════════════════════════════════════════════════════════════════════
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local Workspace         = game:GetService("Workspace")
local UserInputService  = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser       = game:GetService("VirtualUser")
local Lighting          = game:GetService("Lighting")
local Camera            = Workspace.CurrentCamera

local LP = Players.LocalPlayer

-- Lấy module từ Part 2, 3, 4
local State        = getgenv().ChuppyState
local PlayerUtils  = getgenv().ChuppyPlayer
local Monster      = getgenv().ChuppyMonster
local Remote       = getgenv().ChuppyRemote
local Farm         = getgenv().ChuppyFarm
local Combat       = getgenv().ChuppyCombat
local Notify       = getgenv().Chuppy.Notify
local Track        = getgenv().Chuppy.Track
local SafeSpawn    = getgenv().Chuppy.SafeSpawn
local CheckCooldown= getgenv().Chuppy.CheckCooldown

if not State or not PlayerUtils or not Farm or not Combat then
    warn("[Chuppy Part 9] LỖI: Chưa load Part 2 & 3!")
    return
end

local function IsAlive() return PlayerUtils.IsAlive() end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [9.1] PVP CORE STATE
-- ═══════════════════════════════════════════════════════════════════════════════
local PVP = {}
PVP.State = {
    AimbotEnabled    = false, SilentAimEnabled = false, AutoKenEnabled = false,
    AutoDodgeEnabled = false, AutoComboEnabled = false, AutoAttackEnabled = false,
    AntiMobEnabled   = false, FOV = 100, Target = nil, TargetMode = "Nearest",
    SpecificTarget   = nil, AttackRange = 30,
    DamageDealt      = 0, HitsLanded = 0, Kills = 0,
}

local SAFE_ZONES = {
    [1] = { { pos = Vector3.new(0, 30, 0), radius = 500 } },
    [2] = { { pos = Vector3.new(-385, 73, 297), radius = 200 } },
    [3] = { { pos = Vector3.new(-12463, 374, -7523), radius = 250 } },
}

function PVP.IsInSafeZone(pos)
    pos = pos or PlayerUtils.GetPosition()
    local zones = SAFE_ZONES[State.World] or {}
    for _, zone in ipairs(zones) do
        if (pos - zone.pos).Magnitude <= zone.radius then return true end
    end
    return false
end

function PVP.EnablePvp()
    local pg = LP:FindFirstChild("PlayerGui")
    local main = pg and pg:FindFirstChild("Main")
    local hud = main and main:FindFirstChild("BottomHUDList")
    local pvpDisabled = hud and hud:FindFirstChild("PvpDisabled")
    if pvpDisabled and pvpDisabled.Visible and Remote then Remote.Invoke("EnablePvp") end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [9.2] TARGET SELECTOR
-- ═══════════════════════════════════════════════════════════════════════════════
local TargetSelector = {}

function TargetSelector.PickNearest(maxFov)
    maxFov = maxFov or PVP.State.FOV
    local best, bestDist = nil, maxFov
    local myPos = PlayerUtils.GetPosition()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local dist = (hrp.Position - myPos).Magnitude
                if dist < bestDist then bestDist = dist; best = plr end
            end
        end
    end
    return best, bestDist
end

function TargetSelector.PickCursor(maxFov)
    maxFov = maxFov or PVP.State.FOV
    local vp = Camera.ViewportSize
    local center = Vector2.new(vp.X / 2, vp.Y / 2)
    local best, bestDist = nil, maxFov
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if d < bestDist then bestDist = d; best = plr end
                end
            end
        end
    end
    return best
end

function TargetSelector.PickSpecific(name)
    if not name then return nil end
    local plr = Players:FindFirstChild(name)
    if plr and plr.Character then
        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then return plr end
    end
    return nil
end

function TargetSelector.Pick()
    if PVP.State.TargetMode == "Cursor" then return TargetSelector.PickCursor()
    elseif PVP.State.TargetMode == "Specific" then return TargetSelector.PickSpecific(PVP.State.SpecificTarget)
    else return TargetSelector.PickNearest() end
end
getgenv().ChuppyTargetSelector = TargetSelector

-- ═══════════════════════════════════════════════════════════════════════════════
-- [9.3] FOV CIRCLE
-- ═══════════════════════════════════════════════════════════════════════════════
local FOVCircle = {}
local circle, circleGui = nil, nil

function FOVCircle.Create()
    local DrawingUtil = getgenv().ChuppyDrawing
    if DrawingUtil and DrawingUtil.IsSupported() then
        if not circle then
            circle = DrawingUtil.New("Circle")
            if circle then
                circle.Thickness = 2; circle.NumSides = 60; circle.Color = Color3.fromRGB(0, 190, 255)
                circle.Filled = false; circle.Transparency = 0.7; circle.Visible = false
            end
        end
    else
        if not circleGui then
            local sg = getgenv().ChuppyScreenGui
            if sg then
                circleGui = Instance.new("Frame", sg)
                circleGui.Name = "FOVCircle"; circleGui.AnchorPoint = Vector2.new(0.5, 0.5)
                circleGui.Position = UDim2.new(0.5, 0, 0.5, 0); circleGui.BackgroundTransparency = 1; circleGui.BorderSizePixel = 0; circleGui.Visible = false
                local stroke = Instance.new("UIStroke", circleGui)
                stroke.Color = Color3.fromRGB(0, 190, 255); stroke.Thickness = 2; stroke.Transparency = 0.3
            end
        end
    end
end

function FOVCircle.Update()
    local enabled = PVP.State.AimbotEnabled or PVP.State.SilentAimEnabled
    local fov = PVP.State.FOV
    if circle then
        local vp = Camera.ViewportSize
        pcall(function()
            circle.Position = Vector2.new(vp.X / 2, vp.Y / 2); circle.Radius = fov; circle.Visible = enabled
        end)
    elseif circleGui then
        circleGui.Visible = enabled; circleGui.Size = UDim2.new(0, fov * 2, 0, fov * 2)
    end
end

function FOVCircle.Destroy()
    if circle then pcall(function() circle:Remove() end); circle = nil end
    if circleGui then circleGui:Destroy(); circleGui = nil end
end

SafeSpawn(function() FOVCircle.Create(); while State.Running do task.wait(0.1); FOVCircle.Update() end end)
getgenv().ChuppyFOVCircle = FOVCircle

-- ═══════════════════════════════════════════════════════════════════════════════
-- [9.4] SILENT AIM (Metamethod Hook)
-- ═══════════════════════════════════════════════════════════════════════════════
local SilentAim = {}
local hookInstalled = false

function SilentAim.Install()
    if hookInstalled then return end
    if not (getrawmetatable and setreadonly and newcclosure and getnamecallmethod) then
        Notify("Silent Aim", "Executor không hỗ trợ hook", "warning", 5)
        return
    end

    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    if not oldNamecall then return end

    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = { ... }

        if PVP.State.SilentAimEnabled and PVP.State.Target and (method == "FireServer" or method == "InvokeServer") then
            if typeof(self) == "Instance" and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then
                local isCombat = false
                local pName = self.Parent and self.Parent.Name or ""
                local rName = self.Name
                
                if pName == "Remotes" or pName == "Net" or pName == "Modules" then isCombat = true end
                if rName:find("Register") or rName:find("Attack") or rName:find("Hit") or rName == "CommE" then isCombat = true end

                if isCombat then
                    local target = PVP.State.Target
                    local tChar = target and target.Character
                    local tHRP = tChar and tChar:FindFirstChild("HumanoidRootPart")
                    if tHRP then
                        for i, v in pairs(args) do
                            if typeof(v) == "Vector3" then args[i] = tHRP.Position
                            elseif typeof(v) == "CFrame" then args[i] = tHRP.CFrame end
                        end
                    end
                end
            end
        end
        -- FIX LỖI: Dùng table.unpack thay vì unpack
        return oldNamecall(self, table.unpack(args))
    end)
    setreadonly(mt, true)
    hookInstalled = true
end

SafeSpawn(function()
    while State.Running do
        task.wait(0.15)
        if PVP.State.SilentAimEnabled then
            if not hookInstalled then pcall(SilentAim.Install) end
            PVP.State.Target = TargetSelector.Pick()
        end
    end
end)
getgenv().ChuppySilentAim = SilentAim

-- ═══════════════════════════════════════════════════════════════════════════════
-- [9.5] AUTO KEN
-- ═══════════════════════════════════════════════════════════════════════════════
local AutoKen = {}
local lastHealth = 100
local lastKenActivate = 0

function AutoKen.Activate()
    if tick() - lastKenActivate < 3 then return end
    local blur = Lighting:FindFirstChild("Blur")
    if blur and blur.Enabled then return end
    
    lastKenActivate = tick()
    pcall(function()
        -- FIX LỖI: Tham số thứ 4 phải là true/false thay vì game
        VirtualInputManager:SendKeyEvent(true, "E", false, true)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, "E", false, true)
    end)
end

SafeSpawn(function()
    while State.Running do
        task.wait(0.2)
        if PVP.State.AutoKenEnabled and IsAlive() then
            local hum = PlayerUtils.GetHumanoid()
            if hum then
                if hum.Health < lastHealth - 5 then AutoKen.Activate() end
                lastHealth = hum.Health
            end
        end
    end
end)
getgenv().ChuppyAutoKen = AutoKen

-- ═══════════════════════════════════════════════════════════════════════════════
-- [9.6] AUTO DODGE
-- ═══════════════════════════════════════════════════════════════════════════════
local AutoDodge = {}
local isDodging = false
local dodgeEndTime = 0

local function StartDodge(duration)
    if isDodging then return end
    isDodging = true
    dodgeEndTime = tick() + (duration or 0.5)
    local hrp = PlayerUtils.GetHRP()
    if hrp then hrp.CFrame = hrp.CFrame + Vector3.new(0, 30, 0) end
    task.delay(duration or 0.5, function() isDodging = false end)
end

-- Safe wait for Enemies folder
task.spawn(function()
    local enemies = Workspace:WaitForChild("Enemies", 10)
    if enemies then
        Track(enemies.DescendantAdded:Connect(function(child)
            if not PVP.State.AutoDodgeEnabled or isDodging or not IsAlive() then return end
            local name = child.Name
            if name == "BodyGyro" or name == "BodyPosition" or name == "KiBlastFireShort" or name == "SharkSplash" or name == "ChargeUp" then
                local parent = child.Parent
                if parent and parent.Parent and parent.Parent.Name == "Enemies" then
                    local mobHRP = parent:FindFirstChild("HumanoidRootPart")
                    if mobHRP and (mobHRP.Position - PlayerUtils.GetPosition()).Magnitude < 100 then
                        StartDodge(0.5)
                    end
                end
            end
        end))
    end
end)

task.spawn(function()
    local wOrigin = Workspace:WaitForChild("_WorldOrigin", 10)
    if wOrigin then
        Track(wOrigin.ChildAdded:Connect(function(child)
            if not PVP.State.AutoDodgeEnabled or isDodging then return end
            if child:IsA("BasePart") and (child.Name == "SharkSplash" or child.Name == "ChargeUp") then
                if (child.Position - PlayerUtils.GetPosition()).Magnitude < 30 then StartDodge(1.5) end
            end
        end))
    end
end)

Track(LP.CharacterAdded:Connect(function(char)
    task.wait(2)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        Track(hum.HealthChanged:Connect(function(newHealth)
            if PVP.State.AutoDodgeEnabled and IsAlive() then
                if newHealth < hum.Health and (hum.Health - newHealth) > 50 then StartDodge(0.4) end
            end
        end))
    end
end))

SafeSpawn(function()
    while State.Running do
        task.wait(0.1)
        if PVP.State.AutoDodgeEnabled and IsAlive() and isDodging then
            local hrp = PlayerUtils.GetHRP()
            if hrp and tick() < dodgeEndTime then hrp.CFrame = hrp.CFrame + Vector3.new(0, 2, 0) end
        end
    end
end)
getgenv().ChuppyAutoDodge = AutoDodge

-- ═══════════════════════════════════════════════════════════════════════════════
-- [9.7] AUTO COMBO & ATTACK
-- ═══════════════════════════════════════════════════════════════════════════════
local AutoCombo = {}
local COMBO_SEQUENCE = { "Z", "X", "C", "V", "F" }
local comboIndex = 0
local lastComboTime = 0
local COMBO_INTERVAL = 0.35

local function SendKey(key)
    pcall(function()
        -- FIX LỖI: Tham số thứ 4 phải là true/false thay vì game
        VirtualInputManager:SendKeyEvent(true, key, false, true)
        task.wait(0.03)
        VirtualInputManager:SendKeyEvent(false, key, false, true)
    end)
end

local function IsSkillReady(skillKey)
    local pg = LP:FindFirstChild("PlayerGui")
    local main = pg and pg:FindFirstChild("Main")
    local skills = main and main:FindFirstChild("Skills")
    local char = PlayerUtils.GetCharacter()
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not skills or not tool then return false end
    
    local toolSkills = skills:FindFirstChild(tool.Name)
    local skillFrame = toolSkills and toolSkills:FindFirstChild(skillKey)
    local cd = skillFrame and skillFrame:FindFirstChild("Cooldown")
    if not cd then return false end
    return cd.Size == UDim2.new(0, 0, 1, -1) or cd.Size == UDim2.new(1, 0, 1, -1)
end

function AutoCombo.Step()
    if not PVP.State.Target or not PVP.State.Target.Character then return end
    local tHRP = PVP.State.Target.Character:FindFirstChild("HumanoidRootPart")
    if not tHRP then return end
    if (tHRP.Position - PlayerUtils.GetPosition()).Magnitude > 50 then return end
    if tick() - lastComboTime < COMBO_INTERVAL then return end
    
    lastComboTime = tick()
    comboIndex = (comboIndex % #COMBO_SEQUENCE) + 1
    local skillKey = COMBO_SEQUENCE[comboIndex]
    if IsSkillReady(skillKey) then SendKey(skillKey) end
end

SafeSpawn(function()
    while State.Running do
        task.wait(0.1)
        if PVP.State.AutoComboEnabled and IsAlive() and PVP.State.Target then pcall(AutoCombo.Step) else comboIndex = 0 end
    end
end)
getgenv().ChuppyAutoCombo = AutoCombo

local AutoAttack = {}
function AutoAttack.Hit(target)
    if not target or not target.Character then return end
    Combat.EquipWeapon(State.CurrentWeapon or "Melee")
    if State.AutoHaki then Combat.AutoHaki() end
    Combat.Attack()
end

SafeSpawn(function()
    while State.Running do
        task.wait(0.1)
        if PVP.State.AutoAttackEnabled and IsAlive() then
            local target = PVP.State.Target or TargetSelector.Pick()
            PVP.State.Target = target
            if target and target.Character then
                local tHRP = target.Character:FindFirstChild("HumanoidRootPart")
                if tHRP then
                    local dist = (tHRP.Position - PlayerUtils.GetPosition()).Magnitude
                    if dist <= (PVP.State.AttackRange or 30) then AutoAttack.Hit(target)
                    else Farm.Teleport(tHRP.CFrame * CFrame.new(0, 5, 0), 350) end
                end
            end
        end
    end
end)
getgenv().ChuppyAutoAttack = AutoAttack

-- ═══════════════════════════════════════════════════════════════════════════════
-- [9.8] ANTI-MOB PUSH
-- ═══════════════════════════════════════════════════════════════════════════════
local AntiMob = {}
function AntiMob.Push(mob)
    if not mob or not mob.Parent then return end
    pcall(function()
        local hrp = mob:FindFirstChild("HumanoidRootPart")
        local hum = mob:FindFirstChildOfClass("Humanoid")
        if hrp then
            hrp.CFrame = hrp.CFrame + Vector3.new(0, 500, 0)
            if hum then hum.Health = 0 end
        end
    end)
end

SafeSpawn(function()
    while State.Running do
        task.wait(1)
        if PVP.State.AntiMobEnabled and IsAlive() and PVP.State.Target then
            local myPos = PlayerUtils.GetPosition()
            local enemies = Workspace:FindFirstChild("Enemies")
            if enemies then
                for _, mob in ipairs(enemies:GetChildren()) do
                    if Monster.IsAlive(mob) then
                        local rp = mob:FindFirstChild("HumanoidRootPart")
                        if rp and (rp.Position - myPos).Magnitude < 50 then AntiMob.Push(mob) end
                    end
                end
            end
        end
    end
end)
getgenv().ChuppyAntiMob = AntiMob

-- ═══════════════════════════════════════════════════════════════════════════════
-- [9.9] DAMAGE COUNTER
-- ═══════════════════════════════════════════════════════════════════════════════
local DamageCounter = {}
local dmgConn = nil

local function TrackDamageUI()
    local pg = LP:FindFirstChild("PlayerGui")
    local main = pg and pg:FindFirstChild("Main")
    local dmgCounter = main and main:FindFirstChild("DmgCounter")
    local text = dmgCounter and dmgCounter:FindFirstChild("Text")
    if not text then return end
    if dmgConn then pcall(function() dmgConn:Disconnect() end) end
    
    dmgConn = text:GetPropertyChangedSignal("Text"):Connect(function()
        local amount = tonumber(text.Text)
        if amount and amount > 0 then
            PVP.State.DamageDealt = PVP.State.DamageDealt + amount
            PVP.State.HitsLanded = PVP.State.HitsLanded + 1
        end
    end)
end

local function TrackKills()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                local conn
                conn = hum.Died:Connect(function()
                    PVP.State.Kills = PVP.State.Kills + 1
                    Notify("PVP Kill", "Đã hạ " .. plr.Name, "success", 4)
                    local Webhook = getgenv().ChuppyWebhook
                    if Webhook then Webhook.Success("PVP Kill", "Hạ gục " .. plr.Name) end
                    if conn then conn:Disconnect() end
                end)
                Track(conn)
            end
        end
    end
end

task.spawn(function() task.wait(3); pcall(TrackDamageUI); pcall(TrackKills) end)
Track(Players.PlayerAdded:Connect(function() task.wait(2); pcall(TrackKills) end))

function DamageCounter.Reset()
    PVP.State.DamageDealt = 0; PVP.State.HitsLanded = 0; PVP.State.Kills = 0
end
function DamageCounter.GetStats()
    return { damage = PVP.State.DamageDealt, hits = PVP.State.HitsLanded, kills = PVP.State.Kills }
end
getgenv().ChuppyDamageCounter = DamageCounter

-- ═══════════════════════════════════════════════════════════════════════════════
-- [9.10] PUBLIC API + EXPORTS
-- ═══════════════════════════════════════════════════════════════════════════════
local Chuppy = getgenv().Chuppy
if not Chuppy then warn("[Chuppy Part 9] LỖI: Chưa load Part 2!"); return end

Chuppy.TargetSelector = TargetSelector
Chuppy.FOVCircle      = FOVCircle
Chuppy.SilentAim      = SilentAim
Chuppy.AutoKen        = AutoKen
Chuppy.AutoDodge      = AutoDodge
Chuppy.AutoCombo      = AutoCombo
Chuppy.AutoAttack     = AutoAttack
Chuppy.AntiMob        = AntiMob
Chuppy.DamageCounter  = DamageCounter
Chuppy.PVP            = PVP

function Chuppy.ToggleAimbot(enable, fov) PVP.State.AimbotEnabled = enable; if fov then PVP.State.FOV = fov end; Notify("Aimbot", enable and "BẬT" or "TẮT", enable and "success" or "warning") end
function Chuppy.ToggleSilentAim(enable, fov) PVP.State.SilentAimEnabled = enable; if fov then PVP.State.FOV = fov end; if enable and not hookInstalled then pcall(SilentAim.Install) end; Notify("Silent Aim", enable and "BẬT" or "TẮT", enable and "success" or "warning") end
function Chuppy.SetFOV(fov) PVP.State.FOV = fov end
function Chuppy.SetTargetMode(mode) PVP.State.TargetMode = mode end
function Chuppy.SetSpecificTarget(name) PVP.State.SpecificTarget = name; PVP.State.TargetMode = "Specific" end
function Chuppy.ClearTarget() PVP.State.Target = nil end
function Chuppy.ToggleAutoKen(enable) PVP.State.AutoKenEnabled = enable; Notify("Auto Ken", enable and "BẬT" or "TẮT", enable and "success" or "warning") end
function Chuppy.ToggleAutoDodge(enable) PVP.State.AutoDodgeEnabled = enable; Notify("Auto Dodge", enable and "BẬT" or "TẮT", enable and "success" or "warning") end
function Chuppy.ToggleAutoCombo(enable) PVP.State.AutoComboEnabled = enable; Notify("Auto Combo", enable and "BẬT" or "TẮT", enable and "success" or "warning") end
function Chuppy.ToggleAutoAttack(enable, range) PVP.State.AutoAttackEnabled = enable; if range then PVP.State.AttackRange = range end; Notify("Auto Attack", enable and "BẬT" or "TẮT", enable and "success" or "warning") end
function Chuppy.ToggleAntiMob(enable) PVP.State.AntiMobEnabled = enable; Notify("Anti Mob", enable and "BẬT" or "TẮT", enable and "success" or "warning") end
function Chuppy.ResetPVPStats() DamageCounter.Reset(); Notify("PVP", "Đã reset stats", "info", 3) end

Chuppy.OnUnload = Chuppy.OnUnload or {}
table.insert(Chuppy.OnUnload, function() pcall(FOVCircle.Destroy) end)

print("═══════════════════════════════════════════════════════════════════════════════")
print("  ✅ PART 9/10 — PVP MODULE LOADED")
print("  📦 Aimbot · SilentAim · AutoKen · AutoDodge · Combo · Attack · AntiMob")
print("  👉 Gõ 'tiếp' để nhận PART 10/10: UI MENU + SETTINGS + INIT (Phần cuối)")
print("═══════════════════════════════════════════════════════════════════════════════")

end)() -- End IIFE
-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐾 CHUPPY HUB V2 — PART 10/10: UI MENU + SETTINGS + FINAL INIT
-- Phiên bản sạch: IIFE scope · không return giữa file · Unload an toàn
-- ═══════════════════════════════════════════════════════════════════════════════
;(function()

-- ═══════════════════════════════════════════════════════════════════════════════
-- [10.0] SERVICES + IMPORTS
-- ═══════════════════════════════════════════════════════════════════════════════
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local Lighting          = game:GetService("Lighting")
local LP                = Players.LocalPlayer

-- Lấy module từ Part 1 -> 9
local State        = getgenv().ChuppyState
local Theme        = getgenv().ChuppyTheme
local UILibrary    = getgenv().ChuppyUI
local Notification = getgenv().ChuppyNotification
local Modal        = getgenv().ChuppyModal
local Chuppy       = getgenv().Chuppy

if not UILibrary or not State or not Chuppy then
    warn("[Chuppy Part 10] LỖI: Chưa load đủ Part 1 & 2!")
    return
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [10.1] KHỞI TẠO MAIN WINDOW
-- ═══════════════════════════════════════════════════════════════════════════════
local Window = UILibrary:CreateWindow({
    Title = "CHUPPY HUB V2",
    SubTitle = "Blox Fruits | Premium Edition",
    Width = 300,
    Height = 320,
})
Chuppy.Window = Window
Chuppy.Tabs = {}

local function QuickSection(tab, name, collapsed)
    return tab:CreateSection({ Name = name, Collapsed = collapsed or false })
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [10.2] TAB FARM
-- ═══════════════════════════════════════════════════════════════════════════════
local TabFarm = Window:MakeTab({ Name = "Farm", Icon = "⚔" })
Chuppy.Tabs.Farm = TabFarm

local SecFarmLevel = QuickSection(TabFarm, "Auto Farm Level")
SecFarmLevel:AddToggle({ Name = "Auto Farm Level", Desc = "Tự nhận quest và đánh quái", Default = State.AutoFarm, Flag = "AutoFarm" }, function(v) if v then Chuppy.StartFarm() else Chuppy.StopFarm() end end)
SecFarmLevel:AddDropdown({ Name = "Chế độ Farm", Options = { "Quest", "Nearest" }, Default = State.CurrentFarmMode or "Quest", Flag = "FarmMode" }, function(v) Chuppy.SetFarmMode(v) end)
SecFarmLevel:AddDropdown({ Name = "Vũ khí", Options = { "Melee", "Sword", "Gun", "Blox Fruit" }, Default = State.CurrentWeapon or "Melee", Flag = "Weapon" }, function(v) Chuppy.SetWeapon(v) end)
SecFarmLevel:AddToggle({ Name = "Auto Buso Haki", Desc = "Tự bật Buso khi đánh", Default = State.AutoHaki, Flag = "AutoHaki" }, function(v) State.AutoHaki = v end)
SecFarmLevel:AddToggle({ Name = "Bring Mob", Desc = "Gom quái về một chỗ", Default = State.BringMob ~= false, Flag = "BringMob" }, function(v) State.BringMob = v end)
SecFarmLevel:AddSlider({ Name = "Độ cao đánh", Min = 5, Max = 50, Default = State.Height or 15, Suffix = " studs", Flag = "Height" }, function(v) State.Height = v end)

local SecFarmBoss = QuickSection(TabFarm, "Auto Boss")
SecFarmBoss:AddToggle({ Name = "Auto Farm Boss", Desc = "Tự tìm và đánh boss", Default = State.AutoFarmBoss, Flag = "AutoFarmBoss" }, function(v) Chuppy.ToggleBossFarm(v) end)
local bossNames = Chuppy.BossFarm and Chuppy.BossFarm.GetNames() or {}
if #bossNames > 0 then SecFarmBoss:AddDropdown({ Name = "Chọn Boss", Options = bossNames, Default = State.SelectedBoss or bossNames[1], Search = true, Flag = "SelectedBoss" }, function(v) Chuppy.SelectBoss(v) end) end
SecFarmBoss:AddToggle({ Name = "Hop Server tìm Boss", Default = State.HopBoss or false, Flag = "HopBoss" }, function(v) State.HopBoss = v end)

local SecFarmMat = QuickSection(TabFarm, "Auto Material")
SecFarmMat:AddToggle({ Name = "Auto Farm Material", Desc = "Farm nguyên liệu", Default = State.AutoFarmMaterial, Flag = "AutoFarmMaterial" }, function(v) Chuppy.ToggleMaterialFarm(v) end)
local matNames = Chuppy.MaterialFarm and Chuppy.MaterialFarm.GetNames() or {}
if #matNames > 0 then SecFarmMat:AddDropdown({ Name = "Chọn Material", Options = matNames, Default = State.SelectedMaterial or matNames[1], Search = true, Flag = "SelectedMaterial" }, function(v) Chuppy.SelectMaterial(v) end) end

local SecFarmChest = QuickSection(TabFarm, "Chest & Fruit")
SecFarmChest:AddToggle({ Name = "Auto Chest", Default = State.AutoFarmChest, Flag = "AutoFarmChest" }, function(v) Chuppy.ToggleChest(v) end)
SecFarmChest:AddToggle({ Name = "Teleport to Fruit", Default = State.TeleportToFruit, Flag = "TeleportToFruit" }, function(v) Chuppy.ToggleFruitSniper(v) end)
SecFarmChest:AddToggle({ Name = "Auto Store Fruit", Default = State.AutoStoreFruit, Flag = "AutoStoreFruit" }, function(v) Chuppy.ToggleAutoStore(v) end)
SecFarmChest:AddButton({ Name = "Cất Fruit Ngay", Color = Theme.Success }, function() Chuppy.StoreFruitsNow() end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [10.3] TAB SEA
-- ═══════════════════════════════════════════════════════════════════════════════
local TabSea = Window:MakeTab({ Name = "Sea", Icon = "🌊" })
Chuppy.Tabs.Sea = TabSea

local SecSeaBeast = QuickSection(TabSea, "Sea Beast & Pirate")
SecSeaBeast:AddToggle({ Name = "Auto Sea Beast", Default = State.AutoSeaBeast, Flag = "AutoSeaBeast" }, function(v) Chuppy.ToggleSeaBeast(v) end)
SecSeaBeast:AddToggle({ Name = "Auto Pirate Raid", Default = State.AutoPirateRaid, Flag = "AutoPirateRaid" }, function(v) Chuppy.TogglePirateRaid(v) end)

local SecRaids = QuickSection(TabSea, "Raids & Dungeon")
SecRaids:AddToggle({ Name = "Auto Law Raid", Default = State.AutoLawRaid, Flag = "AutoLawRaid" }, function(v) Chuppy.ToggleLawRaid(v) end)
SecRaids:AddToggle({ Name = "Auto Buy Chip", Default = State.AutoBuyChip ~= false, Flag = "AutoBuyChip" }, function(v) State.AutoBuyChip = v end)
SecRaids:AddToggle({ Name = "Auto Raid", Default = State.AutoRaid, Flag = "AutoRaid" }, function(v) Chuppy.ToggleAutoRaid(v) end)
SecRaids:AddDropdown({ Name = "Chọn Raid", Options = { "Flame", "Ice", "Quake", "Light", "Dark", "Spider", "Rumble", "Magma", "Buddha", "Sand", "Bird: Phoenix", "Dough" }, Default = State.SelectedRaid or "Flame", Search = true, Flag = "SelectedRaid" }, function(v) State.SelectedRaid = v end)
SecRaids:AddToggle({ Name = "Auto Dungeon", Default = State.AutoDungeon, Flag = "AutoDungeon" }, function(v) Chuppy.ToggleDungeon(v) end)

local SecEvents = QuickSection(TabSea, "Special Events")
SecEvents:AddToggle({ Name = "Auto Leviathan", Default = State.AutoLeviathan, Flag = "AutoLeviathan" }, function(v) Chuppy.ToggleLeviathan(v, v) end)
SecEvents:AddToggle({ Name = "Tìm Mirage Island", Default = State.AutoFindMirage, Flag = "AutoFindMirage" }, function(v) Chuppy.ToggleMirage(v) end)
SecEvents:AddToggle({ Name = "Hop Full Moon", Default = State.AutoHopFullMoon, Flag = "AutoHopFullMoon" }, function(v) Chuppy.ToggleFullMoonHop(v) end)
SecEvents:AddButton({ Name = "🏝️ Tới Kitsune Island", Color = Theme.Warning }, function() Chuppy.GoKitsune() end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [10.4] TAB RACE
-- ═══════════════════════════════════════════════════════════════════════════════
local TabRace = Window:MakeTab({ Name = "Race", Icon = "🧬" })
Chuppy.Tabs.Race = TabRace

local SecRaceUp = QuickSection(TabRace, "Race Upgrade")
SecRaceUp:AddToggle({ Name = "Auto Race V2", Default = State.AutoRaceV2 or false, Flag = "AutoRaceV2" }, function(v) Chuppy.ToggleRaceV2(v) end)
SecRaceUp:AddToggle({ Name = "Auto Race V3", Default = State.AutoRaceV3 or false, Flag = "AutoRaceV3" }, function(v) Chuppy.ToggleRaceV3(v) end)
SecRaceUp:AddToggle({ Name = "Auto Race V4", Default = State.AutoRaceV4 or false, Flag = "AutoRaceV4" }, function(v) Chuppy.ToggleRaceV4(v) end)
SecRaceUp:AddToggle({ Name = "Auto Draco", Default = State.AutoDraco or false, Flag = "AutoDraco" }, function(v) Chuppy.ToggleDraco(v) end)

local SecRaceQuest = QuickSection(TabRace, "Race Quests")
SecRaceQuest:AddToggle({ Name = "Auto Cyborg", Default = State.AutoCyborgQuest or false, Flag = "AutoCyborgQuest" }, function(v) Chuppy.ToggleCyborgQuest(v) end)
SecRaceQuest:AddToggle({ Name = "Auto Ghoul", Default = State.AutoGhoulQuest or false, Flag = "AutoGhoulQuest" }, function(v) Chuppy.ToggleGhoulQuest(v) end)
SecRaceQuest:AddToggle({ Name = "Auto Godhuman", Default = State.AutoGodhuman or false, Flag = "AutoGodhuman" }, function(v) Chuppy.ToggleGodhuman(v) end)

local SecStyles = QuickSection(TabRace, "Fighting Styles")
SecStyles:AddDropdown({ Name = "Chọn Style", Options = { "BlackLeg", "FishmanKarate", "Electro", "Superhuman", "DeathStep", "SharkmanKarate", "DragonTalon", "ElectricClaw", "SanguineArt", "DragonClaw", "Godhuman" }, Default = "Superhuman", Search = true, Flag = "StyleSelect" }, function(v) Chuppy.SelectedStyle = v end)
SecStyles:AddButton({ Name = "⚡ Mua Style", Color = Theme.Accent }, function() if Chuppy.SelectedStyle then Chuppy.BuyFightingStyle(Chuppy.SelectedStyle) end end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [10.5] TAB ITEMS
-- ═══════════════════════════════════════════════════════════════════════════════
local TabItems = Window:MakeTab({ Name = "Items", Icon = "🗡" })
Chuppy.Tabs.Items = TabItems

local SecLegacy = QuickSection(TabItems, "Legendary Weapons")
SecLegacy:AddToggle({ Name = "Auto Saber", Default = State.AutoSaber or false, Flag = "AutoSaber" }, function(v) Chuppy.ToggleSaber(v) end)
SecLegacy:AddToggle({ Name = "Auto Yama", Default = State.AutoYama or false, Flag = "AutoYama" }, function(v) Chuppy.ToggleYama(v) end)
SecLegacy:AddToggle({ Name = "Auto Tushita", Default = State.AutoTushita or false, Flag = "AutoTushita" }, function(v) Chuppy.ToggleTushita(v) end)
SecLegacy:AddToggle({ Name = "Auto CDK", Default = State.AutoCDK or false, Flag = "AutoCDK" }, function(v) Chuppy.ToggleCDK(v) end)

local SecAutoBuy = QuickSection(TabItems, "Auto Buy & Craft")
SecAutoBuy:AddToggle({ Name = "Auto Legendary Sword", Default = State.AutoLegendarySword or false, Flag = "AutoLegendarySword" }, function(v) Chuppy.ToggleLegendarySword(v) end)
SecAutoBuy:AddToggle({ Name = "Auto Haki Color", Default = State.AutoHakiColor or false, Flag = "AutoHakiColor" }, function(v) Chuppy.ToggleHakiColor(v) end)
SecAutoBuy:AddToggle({ Name = "Auto Farm Mastery", Default = State.AutoMastery or false, Flag = "AutoMastery" }, function(v) Chuppy.ToggleMastery(v) end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [10.6] TAB ESP
-- ═══════════════════════════════════════════════════════════════════════════════
local TabESP = Window:MakeTab({ Name = "ESP", Icon = "👁" })
Chuppy.Tabs.ESP = TabESP

local SecESPMain = QuickSection(TabESP, "ESP Chính")
SecESPMain:AddToggle({ Name = "ESP Người Chơi", Default = State.ESPPlayer, Flag = "ESPPlayer" }, function(v) Chuppy.ToggleESPPlayer(v, State.ESPPlayerTracer) end)
SecESPMain:AddToggle({ Name = "Tracer Line", Default = State.ESPPlayerTracer, Flag = "ESPPlayerTracer" }, function(v) State.ESPPlayerTracer = v end)
SecESPMain:AddToggle({ Name = "ESP Trái Ác Quỷ", Default = State.ESPFruit, Flag = "ESPFruit" }, function(v) Chuppy.ToggleESPFruit(v) end)
SecESPMain:AddToggle({ Name = "ESP Rương", Default = State.ESPChest, Flag = "ESPChest" }, function(v) Chuppy.ToggleESPChest(v) end)
SecESPMain:AddToggle({ Name = "ESP Boss", Default = State.ESPBoss, Flag = "ESPBoss" }, function(v) Chuppy.ToggleESPBoss(v) end)
SecESPMain:AddToggle({ Name = "ESP Đảo", Default = State.ESPIsland, Flag = "ESPIsland" }, function(v) Chuppy.ToggleESPIsland(v) end)

local SecESPAura = QuickSection(TabESP, "Aura & Tracker")
SecESPAura:AddToggle({ Name = "ESP Aura (Highlight)", Default = State.ESPAura, Flag = "ESPAura" }, function(v) Chuppy.ToggleESPAura(v, State.ESPAuraRange) end)
SecESPAura:AddSlider({ Name = "Phạm vi Aura", Min = 50, Max = 1000, Default = State.ESPAuraRange or 300, Flag = "ESPAuraRange" }, function(v) State.ESPAuraRange = v end)
SecESPAura:AddToggle({ Name = "Player Tracker", Default = false, Flag = "TrackerEnabled" }, function(v) Chuppy.ToggleTracker(v) end)
SecESPAura:AddButton({ Name = "🗑 Xoá toàn bộ ESP", Color = Theme.Danger }, function() Chuppy.CleanupAllESP() end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [10.7] TAB PVP
-- ═══════════════════════════════════════════════════════════════════════════════
local TabPVP = Window:MakeTab({ Name = "PVP", Icon = "⚔" })
Chuppy.Tabs.PVP = TabPVP

local SecAim = QuickSection(TabPVP, "Aimbot")
SecAim:AddToggle({ Name = "Aimbot", Default = State.AimbotEnabled or false, Flag = "AimbotEnabled" }, function(v) Chuppy.ToggleAimbot(v, State.FOV) end)
SecAim:AddToggle({ Name = "Silent Aim", Default = State.SilentAimEnabled or false, Flag = "SilentAimEnabled" }, function(v) Chuppy.ToggleSilentAim(v, State.FOV) end)
SecAim:AddSlider({ Name = "FOV", Min = 50, Max = 500, Default = State.FOV or 100, Suffix = " px", Flag = "FOV" }, function(v) Chuppy.SetFOV(v) end)
SecAim:AddDropdown({ Name = "Chế độ Target", Options = { "Nearest", "Cursor", "Specific" }, Default = State.TargetMode or "Nearest", Flag = "TargetMode" }, function(v) Chuppy.SetTargetMode(v) end)

local SecCombat = QuickSection(TabPVP, "Auto Combat")
SecCombat:AddToggle({ Name = "Auto Ken", Default = State.AutoKenEnabled or false, Flag = "AutoKenEnabled" }, function(v) Chuppy.ToggleAutoKen(v) end)
SecCombat:AddToggle({ Name = "Auto Dodge", Default = State.AutoDodgeEnabled or false, Flag = "AutoDodgeEnabled" }, function(v) Chuppy.ToggleAutoDodge(v) end)
SecCombat:AddToggle({ Name = "Auto Attack", Default = State.AutoAttackEnabled or false, Flag = "AutoAttackEnabled" }, function(v) Chuppy.ToggleAutoAttack(v, State.AttackRange) end)
SecCombat:AddSlider({ Name = "Attack Range", Min = 15, Max = 100, Default = State.AttackRange or 30, Suffix = " studs", Flag = "AttackRange" }, function(v) State.AttackRange = v end)
SecCombat:AddToggle({ Name = "Auto Combo", Default = State.AutoComboEnabled or false, Flag = "AutoComboEnabled" }, function(v) Chuppy.ToggleAutoCombo(v) end)
SecCombat:AddToggle({ Name = "Anti-Mob Push", Default = State.AntiMobEnabled or false, Flag = "AntiMobEnabled" }, function(v) Chuppy.ToggleAntiMob(v) end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [10.8] TAB SETTINGS & INFO
-- ═══════════════════════════════════════════════════════════════════════════════
local TabSet = Window:MakeTab({ Name = "Settings", Icon = "⚙" })
Chuppy.Tabs.Settings = TabSet

local SecChar = QuickSection(TabSet, "Nhân Vật")
SecChar:AddToggle({ Name = "Noclip", Default = State.NoClip or false, Flag = "NoClip" }, function(v) State.NoClip = v; if Chuppy.Combat then Chuppy.Combat.SetNoclip(v) end end)
SecChar:AddToggle({ Name = "Speed Hack", Default = State.SpeedHack or false, Flag = "SpeedHack" }, function(v) State.SpeedHack = v end)
SecChar:AddSlider({ Name = "WalkSpeed", Min = 16, Max = 500, Default = State.WalkSpeed or 50, Flag = "WalkSpeed" }, function(v) 
    State.WalkSpeed = v
    if State.SpeedHack and Chuppy.Combat then Chuppy.Combat.SetWalkSpeed(v) end 
end)
SecChar:AddSlider({ Name = "JumpPower", Min = 50, Max = 500, Default = State.JumpPower or 100, Flag = "JumpPower" }, function(v) 
    State.JumpPower = v
    if State.JumpHack and Chuppy.Combat then Chuppy.Combat.SetJumpPower(v) end 
end)

local SecVisual = QuickSection(TabSet, "Visual & Server")
SecVisual:AddToggle({ Name = "FullBright", Default = State.FullBright or false, Flag = "FullBright" }, function(v)
    State.FullBright = v
    if v then Lighting.Brightness = 2; Lighting.FogEnd = 9e9; Lighting.GlobalShadows = false
    else Lighting.Brightness = 1; Lighting.FogEnd = 1000; Lighting.GlobalShadows = true end
end)
SecVisual:AddButton({ Name = "🔄 Rejoin Server", Color = Theme.Accent }, function() Chuppy.Server.Rejoin() end)
SecVisual:AddButton({ Name = "🎯 Hop Server (ít người)", Color = Theme.Accent }, function() Chuppy.Server.Hop() end)
SecVisual:AddToggle({ Name = "Auto Rejoin khi Disconnect", Default = State.AutoRejoinDisconnect or false, Flag = "AutoRejoinDisconnect" }, function(v) State.AutoRejoinDisconnect = v end)

local SecWebhook = QuickSection(TabSet, "Discord Webhook")
SecWebhook:AddInput({ Name = "URL Webhook", Placeholder = "https://discord.com/api/webhooks/...", Default = State.WebhookURL or "", Flag = "WebhookURL" }, function(v) State.WebhookURL = v end)
SecWebhook:AddToggle({ Name = "Bật Webhook", Default = State.WebhookEnabled or false, Flag = "WebhookEnabled" }, function(v) State.WebhookEnabled = v end)
SecWebhook:AddButton({ Name = "🔔 Test Webhook", Color = Theme.Info }, function() Chuppy.Webhook.Test() end)

local SecUI = QuickSection(TabSet, "UI Config")
SecUI:AddButton({ Name = "💾 Lưu Config", Color = Theme.Success }, function() if Chuppy.Config.Save() then Notification.Success("Config", "Đã lưu!") end end)
SecUI:AddButton({ Name = "📋 Copy Config", Color = Theme.Accent }, function() if setclipboard then setclipboard(Chuppy.Config.ToJSON()); Notification.Success("Config", "Đã copy!") end end)
SecUI:AddButton({ Name = "🔄 Reset Config", Color = Theme.Warning }, function()
    Modal.Confirm({ Title = "Reset Config", Message = "Xóa toàn bộ cấu hình?", YesColor = Theme.Danger,
        OnYes = function() Chuppy.Config.Reset(); Notification.Warning("Config", "Đã reset. Rejoin để áp dụng.") end })
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [10.9] TAB INFO
-- ═══════════════════════════════════════════════════════════════════════════════
local TabInfo = Window:MakeTab({ Name = "Info", Icon = "ℹ" })
Chuppy.Tabs.Info = TabInfo
local SecAbout = QuickSection(TabInfo, "Chuppy Hub V2")
SecAbout:AddLabel({ Text = "🐾 Version: 2.0.0", Bold = true, Color = Theme.Accent })
SecAbout:AddLabel({ Text = "🔓 No Key System", Color = Theme.Success })
SecAbout:AddLabel({ Text = "Game: Blox Fruits", Color = Theme.Text })
SecAbout:AddLabel({ Text = "Sea: " .. tostring(State.World), Color = Theme.Text })
SecAbout:AddLabel({ Text = "Player: " .. LP.Name, Color = Theme.Text })
SecAbout:AddLabel({ Text = "Race: " .. (Chuppy.RaceInfo and Chuppy.RaceInfo.Format() or "Unknown"), Color = Theme.Accent })
SecAbout:AddDivider({})
SecAbout:AddLabel({ Text = "RightShift: Menu | L: Aimbot | End: Unload", Color = Theme.Warning })

-- ═══════════════════════════════════════════════════════════════════════════════
-- [10.10] FINAL INIT & UNLOAD HANDLER
-- ═══════════════════════════════════════════════════════════════════════════════
Window:SelectTab("Farm")

-- Khôi phục Config
task.spawn(function()
    task.wait(1)
    if State.CurrentWeapon and Chuppy.Combat then pcall(Chuppy.Combat.EquipWeapon, State.CurrentWeapon) end
    if State.SpeedHack and State.WalkSpeed and Chuppy.Combat then pcall(Chuppy.Combat.SetWalkSpeed, State.WalkSpeed) end
    if State.FullBright then Lighting.Brightness = 2; Lighting.FogEnd = 9e9; Lighting.GlobalShadows = false end
end)

-- Welcome Noti
task.delay(0.5, function()
    Notification.Success("Chuppy Hub V2", "Đã load thành công! RightShift để ẩn/hiện UI", 6)
    task.delay(2, function() Notification.Info("Hướng dẫn", "Bật Auto Farm để bắt đầu. Config tự lưu mỗi 30s.", 5) end)
end)

-- Unload Function
local function Unload()
    Notification.Warning("Chuppy Hub", "Đang unload...", 3)
    State.Running = false
    if Chuppy.OnUnload then for _, fn in ipairs(Chuppy.OnUnload) do pcall(fn) end end
    pcall(Chuppy.Config.Save)
    pcall(Chuppy.Stats.Save)
    if State._connections then for _, conn in ipairs(State._connections) do pcall(function() conn:Disconnect() end) end end
    if getgenv().ChuppyScreenGui then pcall(function() getgenv().ChuppyScreenGui:Destroy() end) end
    
    getgenv().Chuppy = nil
    getgenv().ChuppyLoaded = nil
    task.wait(0.5)
    print("[Chuppy Hub] Unloaded successfully")
end
Chuppy.Unload = Unload
getgenv().ChuppyUnload = Unload

-- Bind phím Unload
if UserInputService then
    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Enum.KeyCode.End then Unload() end
    end)
end

print("═══════════════════════════════════════════════════════════════════════════════")
print("  🐾 CHUPPY HUB V2 — FULL BUILD HOÀN TẤT")
print("  📦 Total: ~14,500 dòng code chia làm 10 Part an toàn.")
print("  🎮 Hotkeys:")
print("     RightShift → Ẩn/Hiện UI")
print("     L          → Toggle Aimbot")
print("     P          → Clear Aimbot Target")
print("     End        → Unload Hub (Thoát)")
print("  🚀 Chúc bạn chơi game vui vẻ!")
print("═══════════════════════════════════════════════════════════════════════════════")

getgenv().ChuppyLoaded = true

end)() -- End IIFE

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐾 CHUPPY HUB V3 — PART 11: BANANA-PARITY ADDON
-- Fast Attack · Auto Stats · Teleport · Shop · Redeem · Misc · Status
-- Chạy SAU Part 10 (cần getgenv().Chuppy + Chuppy.Window)
-- ═══════════════════════════════════════════════════════════════════════════════
;(function()

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local RunService        = game:GetService("RunService")
local Lighting          = game:GetService("Lighting")
local VirtualUser       = game:GetService("VirtualUser")
local StatsService      = game:GetService("Stats")
local LP                = Players.LocalPlayer

local Chuppy = getgenv().Chuppy
if not Chuppy or not Chuppy.Window or not Chuppy.State then
    warn("[Chuppy Part 11] LỖI: Cần load Part 1-10 trước!")
    return
end

local State     = Chuppy.State
local Remote    = Chuppy.Remote
local Notify    = Chuppy.Notify
local SafeSpawn = Chuppy.SafeSpawn
local Track     = Chuppy.Track
local Player    = Chuppy.Player
local Window    = Chuppy.Window
local Config    = Chuppy.Config
local Farm      = Chuppy.Farm
local Combat    = Chuppy.Combat
local Modal     = getgenv().ChuppyModal
local QuestDB   = getgenv().ChuppyQuestDB

-- ═══════════════════════════════════════════════════════════════════════════════
-- [11.0] DEFAULT STATE + CONFIG KEYS
-- ═══════════════════════════════════════════════════════════════════════════════
local DEFAULTS = {
    FastAttack = true, FastAttackAlways = false, FastAttackRange = 80,
    FastAttackDelay = 0.08, FastAttackMax = 8,
    AutoStats = false, StatSelect = "Melee", StatPoints = 3,
    AntiAFK = true, FPSBoost = false, WhiteScreen = false, WalkWater = false,
    RemoveNoti = false, AutoTeam = false, SelectedTeam = "Pirates",
    HopTimer = false, HopTimerMin = 30, ShowHUD = false,
    SelectedIsland = "", SelectedNPC = "", TargetPlayerName = "",
}
for k, v in pairs(DEFAULTS) do
    if State[k] == nil then State[k] = v end
end

local EXTRA_KEYS = {
    "FastAttack", "FastAttackAlways", "FastAttackRange", "FastAttackDelay", "FastAttackMax",
    "AutoStats", "StatSelect", "StatPoints", "AntiAFK", "FPSBoost", "WalkWater",
    "RemoveNoti", "AutoTeam", "SelectedTeam", "HopTimer", "HopTimerMin", "ShowHUD",
}
do
    local have = {}
    for _, k in ipairs(Config.SaveKeys) do have[k] = true end
    for _, k in ipairs(EXTRA_KEYS) do
        if not have[k] then table.insert(Config.SaveKeys, k) end
    end
end
pcall(Config.Load) -- nạp lại để các key mới nhận giá trị đã lưu

-- ═══════════════════════════════════════════════════════════════════════════════
-- [11.1] UTILS
-- ═══════════════════════════════════════════════════════════════════════════════
local function Commas(n)
    local s = tostring(math.floor(tonumber(n) or 0))
    local out = s:reverse():gsub("(%d%d%d)", "%1,"):reverse()
    if out:sub(1, 1) == "," then out = out:sub(2) end
    return out
end

local function FormatTime(sec)
    sec = math.floor(tonumber(sec) or 0)
    return string.format("%02d:%02d:%02d", math.floor(sec / 3600), math.floor(sec / 60) % 60, sec % 60)
end

local function Confirm(title, message, onYes)
    if Modal and Modal.Confirm then
        Modal.Confirm({ Title = title, Message = message, OnYes = onYes })
    else
        pcall(onYes)
    end
end

local function TeleportCF(cf)
    if not cf then return false end
    if Farm and Farm.Teleport then return Farm.Teleport(cf, 350) end
    local hrp = Player.GetHRP()
    if hrp then hrp.CFrame = cf; return true end
    return false
end

local function IsFarming()
    if State.FastAttackAlways then return true end
    return State.AutoFarm or State.AutoFarmBoss or State.AutoFarmMaterial or State.KillAura
        or State.AutoRaid or State.AutoSeaBeast or State.AutoLeviathan or State.AutoCDK
        or State.AutoRace or false
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [11.2] FAST ATTACK (Net RegisterAttack / RegisterHit + Fruit M1)
-- ═══════════════════════════════════════════════════════════════════════════════
local FastAttack = { combo = 0 }
local RegAttack, RegHit = nil, nil

SafeSpawn(function()
    local modules = ReplicatedStorage:WaitForChild("Modules", 15)
    local net = modules and modules:WaitForChild("Net", 15)
    if net then
        RegAttack = net:WaitForChild("RE/RegisterAttack", 15)
        RegHit    = net:FindFirstChild("RE/RegisterHit")
    end
    if not RegHit then
        pcall(function() RegHit = require(modules.Net):RemoteEvent("RegisterHit", true) end)
    end
    if not RegAttack or not RegHit then
        warn("[Chuppy FastAttack] Không tìm thấy Net remotes, sẽ dùng tool:Activate()")
    end
end)

local HIT_PARTS = { "Head", "UpperTorso", "HumanoidRootPart" }

local function PickPart(model)
    for _, name in ipairs(HIT_PARTS) do
        local p = model:FindFirstChild(name)
        if p and p:IsA("BasePart") then return p end
    end
    return nil
end

-- Gom mục tiêu trong tầm: trả về mảng { {model, part}, ... } hoặc nil
function FastAttack.Collect(range, maxCount)
    local hrp = Player.GetHRP()
    if not hrp then return nil end
    local folder = Workspace:FindFirstChild("Enemies")
    if not folder then return nil end
    local origin = hrp.Position
    local out, n = {}, 0
    for _, mob in ipairs(folder:GetChildren()) do
        local root = mob:FindFirstChild("HumanoidRootPart")
        local hum  = mob:FindFirstChildOfClass("Humanoid")
        if root and hum and hum.Health > 0 and (root.Position - origin).Magnitude <= range then
            local part = PickPart(mob)
            if part then
                n = n + 1
                out[n] = { mob, part }
                if n >= maxCount then break end
            end
        end
    end
    if n == 0 then return nil end
    return out
end

function FastAttack.Hit()
    local char = Player.GetCharacter()
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return false end
    local stun = char:FindFirstChild("Stun")
    if stun and stun.Value ~= 0 then return false end

    local targets = FastAttack.Collect(State.FastAttackRange or 60, State.FastAttackMax or 8)
    if not targets then return false end

    -- Blox Fruit: bắn LeftClickRemote theo hướng mục tiêu
    if tool.ToolTip == "Blox Fruit" then
        local lc = tool:FindFirstChild("LeftClickRemote")
        local hrp = Player.GetHRP()
        if not lc or not hrp then return false end
        local diff = targets[1][2].Position - hrp.Position
        local dir = diff.Magnitude > 0.1 and diff.Unit or hrp.CFrame.LookVector
        FastAttack.combo = FastAttack.combo % 5 + 1
        lc:FireServer(dir, FastAttack.combo)
        return true
    end

    if not RegAttack or not RegHit then return false end
    RegAttack:FireServer(0)
    local first = table.remove(targets, 1)
    RegHit:FireServer(first[2], targets)
    return true
end

-- Ghi đè Combat.Attack: farm modules gọi Combat.Attack() sẽ tự dùng fast attack
if Combat then
    local origAttack = Combat.Attack
    Combat.Attack = function()
        if State.FastAttack then
            local ok, hit = pcall(FastAttack.Hit)
            if ok and hit then return end
        end
        if origAttack then return origAttack() end
    end
end

-- Vòng lặp độc lập: đánh liên tục khi đang farm
SafeSpawn(function()
    while State.Running do
        task.wait(math.max(State.FastAttackDelay or 0.08, 0.03))
        if State.FastAttack and IsFarming() and Player.IsAlive() then
            local ok, err = pcall(FastAttack.Hit)
            if not ok then warn("[Chuppy FastAttack]", err) end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [11.3] AUTO STATS
-- ═══════════════════════════════════════════════════════════════════════════════
local STAT_NAMES = { "Melee", "Defense", "Sword", "Gun", "Demon Fruit" }

SafeSpawn(function()
    while State.Running do
        task.wait(2)
        if State.AutoStats then
            pcall(function()
                local data = LP:FindFirstChild("Data")
                local pts = data and data:FindFirstChild("Points")
                local avail = pts and pts.Value or 0
                if avail > 0 then
                    local amount = math.min(avail, math.max(1, State.StatPoints or 1))
                    Remote.Invoke("AddPoint", State.StatSelect or "Melee", amount)
                end
            end)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [11.4] TELEPORT DATA
-- ═══════════════════════════════════════════════════════════════════════════════
local function BuildIslandMap()
    local map, names = {}, {}
    if type(QuestDB) == "table" then
        for _, e in ipairs(QuestDB) do
            if e.world == State.World and e.island and not map[e.island] then
                map[e.island] = e.questCF
                table.insert(names, e.island)
            end
        end
    end
    if #names == 0 then names = { "(Không có dữ liệu)" } end
    return map, names
end

local function BuildNPCList()
    local names, seen = {}, {}
    local folder = Workspace:FindFirstChild("NPCs")
    if folder then
        for _, npc in ipairs(folder:GetChildren()) do
            if not seen[npc.Name] then
                seen[npc.Name] = true
                table.insert(names, npc.Name)
            end
        end
    end
    table.sort(names)
    if #names == 0 then names = { "(Không có NPC)" } end
    return names
end

local function FindPlayerByName(partial)
    partial = string.lower(partial or "")
    if partial == "" then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            if string.find(string.lower(p.Name), partial, 1, true)
               or string.find(string.lower(p.DisplayName), partial, 1, true) then
                return p
            end
        end
    end
    return nil
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [11.5] REDEEM
-- ═══════════════════════════════════════════════════════════════════════════════
local function Redeem(code)
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local rem = remotes and remotes:FindFirstChild("Redeem")
    if not rem then return false, "Không có remote Redeem" end
    local ok, res = pcall(function() return rem:InvokeServer(code) end)
    return ok, res
end

local function RedeemList(text)
    SafeSpawn(function()
        local count = 0
        for code in string.gmatch(text or "", "[^,%s]+") do
            count = count + 1
            Redeem(code)
            task.wait(0.6)
        end
        Notify("Redeem", "Đã thử " .. count .. " code", "success")
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [11.6] MISC SYSTEMS
-- ═══════════════════════════════════════════════════════════════════════════════
-- Anti-AFK
Track(LP.Idled:Connect(function()
    if not State.AntiAFK then return end
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end)
end))

-- Auto chọn team khi mới vào game
SafeSpawn(function()
    local tries = 0
    while State.Running and tries < 60 do
        task.wait(2)
        tries = tries + 1
        if LP.Team ~= nil then break end
        if State.AutoTeam then
            pcall(function() Remote.Invoke("SetTeam", State.SelectedTeam or "Pirates") end)
        end
    end
end)

-- FPS Boost (có thể khôi phục hiệu ứng ánh sáng + particle đã tắt)
local disabledEffects, disabledFx = {}, {}
local prevShadows = Lighting.GlobalShadows

local function ApplyFPSBoost()
    prevShadows = Lighting.GlobalShadows
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    Lighting.GlobalShadows = false
    for _, e in ipairs(Lighting:GetChildren()) do
        if e:IsA("PostEffect") and e.Enabled then
            e.Enabled = false
            table.insert(disabledEffects, e)
        end
    end
    pcall(function()
        local t = Workspace.Terrain
        t.WaterWaveSize = 0
        t.WaterWaveSpeed = 0
        t.WaterReflectance = 0
        t.WaterTransparency = 0
    end)
    SafeSpawn(function()
        local n = 0
        for _, d in ipairs(Workspace:GetDescendants()) do
            if not State.FPSBoost then break end
            if d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Smoke")
               or d:IsA("Fire") or d:IsA("Sparkles") then
                if d.Enabled then
                    d.Enabled = false
                    table.insert(disabledFx, d)
                end
            end
            n = n + 1
            if n % 400 == 0 then task.wait() end
        end
    end)
end

local function RestoreFPSBoost()
    Lighting.GlobalShadows = prevShadows
    for _, e in ipairs(disabledEffects) do pcall(function() e.Enabled = true end) end
    for _, d in ipairs(disabledFx) do pcall(function() d.Enabled = true end) end
    disabledEffects, disabledFx = {}, {}
end

-- Walk on water: nâng WaterBase-Plane, trả lại size gốc khi tắt
do
    local plane, origSize = nil, nil
    SafeSpawn(function()
        while State.Running do
            task.wait(1)
            pcall(function()
                local map = Workspace:FindFirstChild("Map")
                local p = map and map:FindFirstChild("WaterBase-Plane")
                if not p then return end
                if p ~= plane then plane = p; origSize = p.Size end
                if State.WalkWater then
                    if p.Size.Y < 100 then
                        p.Size = Vector3.new(p.Size.X, 112, p.Size.Z)
                    end
                elseif origSize and p.Size ~= origSize then
                    p.Size = origSize
                end
            end)
        end
    end)
end

-- Remove in-game notifications
do
    local hidden = false
    SafeSpawn(function()
        while State.Running do
            task.wait(1)
            pcall(function()
                local pg = LP:FindFirstChild("PlayerGui")
                local gui = pg and pg:FindFirstChild("Notifications")
                if gui and gui:IsA("ScreenGui") then
                    if State.RemoveNoti then
                        gui.Enabled = false
                        hidden = true
                    elseif hidden then
                        gui.Enabled = true
                        hidden = false
                    end
                end
            end)
        end
    end)
end

-- Hop server theo timer
do
    local lastHopAt = tick()
    SafeSpawn(function()
        while State.Running do
            task.wait(5)
            if State.HopTimer and (tick() - lastHopAt) >= (State.HopTimerMin or 30) * 60 then
                lastHopAt = tick()
                if Chuppy.Server and Chuppy.Server.Hop then pcall(Chuppy.Server.Hop) end
            elseif not State.HopTimer then
                lastHopAt = tick()
            end
        end
    end)
end

-- HUD FPS / Ping
do
    local hudGui, hudLabel = nil, nil
    local frames = 0

    local function CreateHUD()
        if hudGui and hudGui.Parent then return end
        hudGui = Instance.new("ScreenGui")
        hudGui.Name = "ChuppyHUD"
        hudGui.ResetOnSpawn = false
        hudGui.IgnoreGuiInset = true
        pcall(function() hudGui.Parent = game:GetService("CoreGui") end)
        if not hudGui.Parent then hudGui.Parent = LP:WaitForChild("PlayerGui") end
        hudLabel = Instance.new("TextLabel")
        hudLabel.Size = UDim2.new(0, 190, 0, 22)
        hudLabel.Position = UDim2.new(1, -200, 0, 8)
        hudLabel.BackgroundColor3 = Color3.fromRGB(12, 13, 18)
        hudLabel.BackgroundTransparency = 0.25
        hudLabel.BorderSizePixel = 0
        hudLabel.Font = Enum.Font.Code
        hudLabel.TextSize = 12
        hudLabel.TextColor3 = Color3.fromRGB(0, 190, 255)
        hudLabel.Text = "..."
        hudLabel.Parent = hudGui
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = hudLabel
    end

    local function DestroyHUD()
        if hudGui then pcall(function() hudGui:Destroy() end) end
        hudGui, hudLabel = nil, nil
    end

    Track(RunService.RenderStepped:Connect(function() frames = frames + 1 end))

    SafeSpawn(function()
        while State.Running do
            task.wait(0.5)
            local fps = frames * 2
            frames = 0
            if State.ShowHUD then
                pcall(function()
                    CreateHUD()
                    local ping = 0
                    local ok, v = pcall(function()
                        return StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()
                    end)
                    if ok and v then ping = math.floor(v) end
                    hudLabel.Text = string.format("FPS %d  |  Ping %dms  |  %s", fps, ping,
                        FormatTime(tick() - State.StartTime))
                end)
            elseif hudGui then
                DestroyHUD()
            end
        end
    end)

    Chuppy.OnUnload = Chuppy.OnUnload or {}
    table.insert(Chuppy.OnUnload, DestroyHUD)
end

Chuppy.OnUnload = Chuppy.OnUnload or {}
table.insert(Chuppy.OnUnload, function()
    pcall(function() RunService:Set3dRenderingEnabled(true) end)
    pcall(RestoreFPSBoost)
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [11.7] UI — TAB FAST (Fast Attack + Stats)
-- ═══════════════════════════════════════════════════════════════════════════════
local function Sec(tab, name, collapsed)
    return tab:CreateSection({ Name = name, Collapsed = collapsed or false })
end

local TabFast = Window:MakeTab({ Name = "Fast", Icon = "⚡" })
Chuppy.Tabs.Fast = TabFast

local SecFA = Sec(TabFast, "Fast Attack")
SecFA:AddToggle({ Name = "Fast Attack", Desc = "Đánh AOE nhanh (Net remote)", Default = State.FastAttack, Flag = "FastAttack" },
    function(v) State.FastAttack = v end)
SecFA:AddToggle({ Name = "Luôn tấn công", Desc = "Kể cả khi không bật farm", Default = State.FastAttackAlways, Flag = "FastAttackAlways" },
    function(v) State.FastAttackAlways = v end)
SecFA:AddSlider({ Name = "Tầm đánh", Min = 20, Max = 120, Default = State.FastAttackRange, Step = 5, Suffix = " st" },
    function(v) State.FastAttackRange = v end)
SecFA:AddSlider({ Name = "Delay", Min = 30, Max = 300, Default = math.floor((State.FastAttackDelay or 0.08) * 1000 + 0.5), Step = 10, Suffix = " ms" },
    function(v) State.FastAttackDelay = v / 1000 end)
SecFA:AddSlider({ Name = "Số mục tiêu / đòn", Min = 1, Max = 15, Default = State.FastAttackMax, Step = 1 },
    function(v) State.FastAttackMax = v end)

local SecStats = Sec(TabFast, "Auto Stats")
SecStats:AddToggle({ Name = "Auto Stats", Desc = "Tự cộng điểm chỉ số", Default = State.AutoStats, Flag = "AutoStats" },
    function(v) State.AutoStats = v end)
SecStats:AddDropdown({ Name = "Chỉ số", Options = STAT_NAMES, Default = State.StatSelect },
    function(v) State.StatSelect = v end)
SecStats:AddSlider({ Name = "Điểm mỗi lần", Min = 1, Max = 100, Default = State.StatPoints, Step = 1 },
    function(v) State.StatPoints = v end)
SecStats:AddButton({ Name = "Hoàn điểm chỉ số", Desc = "Tốn 2.500 Fragments" }, function()
    Confirm("Hoàn điểm", "Reset toàn bộ chỉ số? Tốn Fragments.", function()
        Remote.Invoke("BlackbeardReward", "Refund", "1")
        task.wait(0.3)
        Remote.Invoke("BlackbeardReward", "Refund", "2")
        Notify("Stats", "Đã gửi yêu cầu hoàn điểm", "success")
    end)
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [11.8] UI — TAB TELEPORT
-- ═══════════════════════════════════════════════════════════════════════════════
local TabTP = Window:MakeTab({ Name = "Teleport", Icon = "🧭" })
Chuppy.Tabs.Teleport = TabTP

local SecSea = Sec(TabTP, "Chuyển Sea")
SecSea:AddButton({ Name = "Sea 1 (Old World)" }, function()
    Confirm("Chuyển Sea", "Về Sea 1?", function() Remote.Invoke("TravelMain") end)
end)
SecSea:AddButton({ Name = "Sea 2 (New World)" }, function()
    Confirm("Chuyển Sea", "Sang Sea 2? (cần Level 700)", function() Remote.Invoke("TravelDressrosa") end)
end)
SecSea:AddButton({ Name = "Sea 3 (Third Sea)" }, function()
    Confirm("Chuyển Sea", "Sang Sea 3? (cần Level 1500)", function() Remote.Invoke("TravelZou") end)
end)

local islandMap, islandNames = BuildIslandMap()
local SecIsland = Sec(TabTP, "Đảo")
SecIsland:AddDropdown({ Name = "Chọn đảo", Options = islandNames, Default = islandNames[1] },
    function(v) State.SelectedIsland = v end)
SecIsland:AddButton({ Name = "Teleport tới đảo" }, function()
    local sel = (State.SelectedIsland ~= "" and State.SelectedIsland) or islandNames[1]
    local cf = islandMap[sel]
    if not cf then Notify("Teleport", "Chưa có dữ liệu đảo", "warning"); return end
    TeleportCF(CFrame.new(cf.Position + Vector3.new(0, 5, 0)))
    Notify("Teleport", "Đang bay tới " .. tostring(sel), "info")
end)

local npcNames = BuildNPCList()
local SecNPC = Sec(TabTP, "NPC")
SecNPC:AddDropdown({ Name = "Chọn NPC", Options = npcNames, Search = true, Default = npcNames[1] },
    function(v) State.SelectedNPC = v end)
SecNPC:AddButton({ Name = "Teleport tới NPC" }, function()
    local sel = (State.SelectedNPC ~= "" and State.SelectedNPC) or npcNames[1]
    local folder = Workspace:FindFirstChild("NPCs")
    local npc = folder and folder:FindFirstChild(sel)
    if not npc or not npc:IsA("Model") then Notify("Teleport", "Không thấy NPC", "warning"); return end
    local ok, pivot = pcall(function() return npc:GetPivot() end)
    if not ok then return end
    TeleportCF(CFrame.new(pivot.Position + Vector3.new(0, 3, 0)))
end)

local SecPl = Sec(TabTP, "Người chơi")
SecPl:AddInput({ Name = "Tên người chơi", Placeholder = "một phần tên..." },
    function(txt) State.TargetPlayerName = txt end)
SecPl:AddButton({ Name = "Teleport tới người chơi" }, function()
    local p = FindPlayerByName(State.TargetPlayerName)
    local hrp = p and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then Notify("Teleport", "Không tìm thấy người chơi", "warning"); return end
    TeleportCF(hrp.CFrame * CFrame.new(0, 3, 0))
end)
SecPl:AddButton({ Name = "Dừng Tween" }, function()
    if Farm and Farm.StopTween then Farm.StopTween() end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [11.9] UI — TAB SHOP
-- ═══════════════════════════════════════════════════════════════════════════════
local TabShop = Window:MakeTab({ Name = "Shop", Icon = "🛒" })
Chuppy.Tabs.Shop = TabShop

local SecHaki = Sec(TabShop, "Khả năng")
SecHaki:AddButton({ Name = "Mua Geppo" }, function() Remote.Invoke("BuyHaki", "Geppo") end)
SecHaki:AddButton({ Name = "Mua Buso Haki" }, function() Remote.Invoke("BuyHaki", "Buso") end)
SecHaki:AddButton({ Name = "Mua Soru" }, function() Remote.Invoke("BuyHaki", "Soru") end)
SecHaki:AddButton({ Name = "Mua Ken Haki" }, function() Remote.Invoke("KenTalk", "Buy") end)

local SWORDS = { "Cutlass", "Katana", "Iron Mace", "Duel Katana", "Triple Katana", "Pipe", "Dual-Headed Blade", "Bisento", "Soul Cane" }
local GUNS   = { "Slingshot", "Musket", "Flintlock", "Refined Slingshot", "Dual Flintlock", "Cannon", "Bazooka" }
local selSword, selGun = SWORDS[1], GUNS[1]

local SecWeap = Sec(TabShop, "Vũ khí")
SecWeap:AddDropdown({ Name = "Kiếm", Options = SWORDS, Default = selSword }, function(v) selSword = v end)
SecWeap:AddButton({ Name = "Mua kiếm đã chọn" }, function() Remote.Invoke("BuyItem", selSword) end)
SecWeap:AddDropdown({ Name = "Súng", Options = GUNS, Default = selGun }, function(v) selGun = v end)
SecWeap:AddButton({ Name = "Mua súng đã chọn" }, function() Remote.Invoke("BuyItem", selGun) end)

local SecFruit = Sec(TabShop, "Trái ác quỷ & Race")
local function RandomFruit()
    local RSv = game:GetService("ReplicatedStorage")
    local commF = RSv:FindFirstChild("Remotes") and RSv.Remotes:FindFirstChild("CommF_")
    if not commF then Notify("Random Fruit", "Không tìm thấy CommF_", "danger") return end
    local box = "DLCBoxData"
    pcall(function()
        local it = require(RSv.Controllers.BannerClient).TryGetBannerItemIfActiveAsync()
        if it and it.BoxName then box = it.BoxName end
    end)
    local ok, cur, lv, cost = pcall(function() return commF:InvokeServer("Cousin", "Check", box) end)
    if not ok then Notify("Random Fruit", "Lỗi kiểm tra: " .. tostring(cur), "danger") return end
    if (lv or 0) < 50 then Notify("Random Fruit", "Cần Level 50 trở lên", "warning") return end
    if (cur or 0) < (cost or math.huge) then Notify("Random Fruit", "Không đủ tiền/tiền tệ", "warning") return end
    local okT, t = pcall(function() return commF:InvokeServer("Cousin", "CheckTime", box) end)
    if not okT or t ~= true then Notify("Random Fruit", "Chưa tới giờ quay (cooldown)", "warning") return end
    local okB, r = pcall(function() return commF:InvokeServer("Cousin", box) end)
    if okB and r == 1 then Notify("Random Fruit", "Đã quay trái thành công!", "success")
    else Notify("Random Fruit", "Quay thất bại (server trả: " .. tostring(r) .. ")", "danger") end
end
Chuppy.RandomFruit = RandomFruit
SecFruit:AddButton({ Name = "Random Devil Fruit", Desc = "Quay trái ngẫu nhiên" }, function()
    task.spawn(RandomFruit)
end)
SecFruit:AddButton({ Name = "Reroll Race", Desc = "Tốn Fragments" }, function()
    Confirm("Reroll Race", "Đổi race ngẫu nhiên? Tốn Fragments.", function()
        Remote.Invoke("BlackbeardReward", "Reroll", "1")
        task.wait(0.3)
        Remote.Invoke("BlackbeardReward", "Reroll", "2")
    end)
end)

local SecTeam = Sec(TabShop, "Team")
SecTeam:AddDropdown({ Name = "Chọn Team", Options = { "Pirates", "Marines" }, Default = State.SelectedTeam },
    function(v) State.SelectedTeam = v end)
SecTeam:AddToggle({ Name = "Auto chọn Team", Desc = "Tự vào team khi mới join", Default = State.AutoTeam, Flag = "AutoTeam" },
    function(v) State.AutoTeam = v end)
SecTeam:AddButton({ Name = "Vào team ngay" }, function() Remote.Invoke("SetTeam", State.SelectedTeam) end)

local SecCode = Sec(TabShop, "Redeem Code")
local codeText = ""
SecCode:AddInput({ Name = "Code (cách nhau dấu phẩy)", Placeholder = "CODE1, CODE2" }, function(txt) codeText = txt end)
SecCode:AddButton({ Name = "Redeem" }, function()
    if codeText == "" then Notify("Redeem", "Chưa nhập code", "warning"); return end
    RedeemList(codeText)
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [11.10] UI — TAB MISC
-- ═══════════════════════════════════════════════════════════════════════════════
local TabMisc = Window:MakeTab({ Name = "Misc", Icon = "🧰" })
Chuppy.Tabs.Misc = TabMisc

local SecPerf = Sec(TabMisc, "Hiệu năng")
SecPerf:AddToggle({ Name = "FPS Boost", Desc = "Tắt shadow, hiệu ứng, particle", Default = State.FPSBoost, Flag = "FPSBoost" }, function(v)
    State.FPSBoost = v
    if v then ApplyFPSBoost() else RestoreFPSBoost() end
end)
SecPerf:AddToggle({ Name = "White Screen", Desc = "Tắt render 3D (siêu nhẹ khi treo)", Default = false, Flag = "WhiteScreen" }, function(v)
    State.WhiteScreen = v
    pcall(function() RunService:Set3dRenderingEnabled(not v) end)
end)
SecPerf:AddToggle({ Name = "Hiện FPS / Ping", Default = State.ShowHUD, Flag = "ShowHUD" }, function(v) State.ShowHUD = v end)
SecPerf:AddToggle({ Name = "Ẩn thông báo game", Default = State.RemoveNoti, Flag = "RemoveNoti" }, function(v) State.RemoveNoti = v end)

local SecUtil = Sec(TabMisc, "Tiện ích")
SecUtil:AddToggle({ Name = "Anti-AFK", Default = State.AntiAFK, Flag = "AntiAFK" }, function(v) State.AntiAFK = v end)
SecUtil:AddToggle({ Name = "Đi trên nước", Default = State.WalkWater, Flag = "WalkWater" }, function(v) State.WalkWater = v end)

local SecHop = Sec(TabMisc, "Hop Server theo giờ")
SecHop:AddToggle({ Name = "Hop theo timer", Default = State.HopTimer, Flag = "HopTimer" }, function(v) State.HopTimer = v end)
SecHop:AddSlider({ Name = "Phút / lần hop", Min = 5, Max = 120, Default = State.HopTimerMin, Step = 5, Suffix = " p" },
    function(v) State.HopTimerMin = v end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [11.11] UI — TAB STATUS
-- ═══════════════════════════════════════════════════════════════════════════════
local TabStatus = Window:MakeTab({ Name = "Status", Icon = "📈" })
Chuppy.Tabs.Status = TabStatus

local SecPlayer = Sec(TabStatus, "Nhân vật")
local lblPlayer = SecPlayer:AddLabel("Đang tải...")
local lblMoney  = SecPlayer:AddLabel("")
local lblWorld  = SecPlayer:AddLabel("")
local SecSession = Sec(TabStatus, "Phiên chơi")
local lblTime  = SecSession:AddLabel("")
local lblKills = SecSession:AddLabel("")
local lblMisc  = SecSession:AddLabel("")

SafeSpawn(function()
    while State.Running do
        task.wait(1)
        pcall(function()
            local pd, st = State.PlayerData, State.Stats
            lblPlayer.SetText(string.format("👤 %s  |  Lv %s  |  Race: %s", LP.Name, tostring(pd.Level), tostring(pd.Race)))
            lblMoney.SetText(string.format("💰 Beli: %s  |  Fragments: %s", Commas(pd.Beli), Commas(pd.Fragments)))
            lblWorld.SetText(string.format("🌍 Sea %s  |  Fruit: %s  |  Team: %s", tostring(State.World),
                (pd.DevilFruit ~= "" and pd.DevilFruit or "—"), tostring(pd.Team)))
            lblTime.SetText("⏱ Thời gian: " .. FormatTime(tick() - State.StartTime))
            lblKills.SetText(string.format("⚔ Quái: %s  |  Boss: %s  |  Chết: %s",
                Commas(st.MobsKilled), Commas(st.BossesKilled), Commas(st.Deaths)))
            lblMisc.SetText(string.format("📦 Rương: %s  |  Fruit cất: %s  |  Raid: %s",
                Commas(st.ChestsCollected), Commas(st.FruitsStored), Commas(st.RaidsCompleted)))
        end)
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [11.12] EXPORT + INIT
-- ═══════════════════════════════════════════════════════════════════════════════
Chuppy.FastAttack = FastAttack
Chuppy.Redeem     = Redeem
Chuppy.Teleport   = TeleportCF

if State.FPSBoost then pcall(ApplyFPSBoost) end

task.delay(1, function()
    Notify("Chuppy Hub V3", "Đã nạp Fast Attack · Stats · Teleport · Shop · Misc · Status", "success", 6)
end)

print("  ✅ PART 11 — BANANA-PARITY ADDON LOADED")

end)() -- End IIFE


-- 🐾 CHUPPY HUB V3 — PART 12: FISHING + ELITE HUNTER (học từ Banana Hub)
-- Dán NỐI TIẾP ngay sau Part 11 (trước dòng "end)() -- End IIFE"), hoặc chạy riêng sau khi Chuppy đã load.
;(function()
local RS, Players, CS = game:GetService("ReplicatedStorage"), game:GetService("Players"), game:GetService("CollectionService")
local LP = Players.LocalPlayer
local C = getgenv().Chuppy
local State, Notify, Monster = C.State, C.Notify, C.Monster
local Combat = getgenv().ChuppyCombat or C.Combat
local Window = C.Window
local Remote = RS:WaitForChild("Remotes"):WaitForChild("CommF_")
local function hrp() local c = LP.Character return c and c:FindFirstChild("HumanoidRootPart") end
local function tp(cf)
    local h = hrp()
    if not h then return end
    if C.Teleport then C.Teleport(cf) else h.CFrame = cf end
end
local function alive(m) return m and m.Parent and (Monster.IsAlive and Monster.IsAlive(m) or (m:FindFirstChild("Humanoid") and m.Humanoid.Health > 0)) end
State.AutoFishing, State.AutoElite, State.EliteHop = State.AutoFishing or false, State.AutoElite or false, State.EliteHop or false

-- ═══ [12.1] ELITE HUNTER ═══
local ELITE = { "Deandre", "Urban", "Diablo" }
local function FindElite()
    for _, p in ipairs({ RS, workspace:FindFirstChild("Enemies") }) do
        if p then for _, m in ipairs(p:GetChildren()) do
            if m:IsA("Model") and table.find(ELITE, m.Name) and alive(m) then return m end
        end end
    end
end
C.FindElite = FindElite

task.spawn(function()
    while task.wait(0.3) do
        if State.AutoElite then pcall(function()
            local e = FindElite()
            if not e then
                if State.EliteHop then C.Server.Hop() task.wait(5) else Remote:InvokeServer("EliteHunter") task.wait(2) end
                return
            end
            local q = LP.PlayerGui.Main.Quest
            if not q.Visible or not string.find(q.Container.QuestTitle.Title.Text, e.Name) then
                Remote:InvokeServer("AbandonQuest"); Remote:InvokeServer("EliteHunter"); task.wait(1)
            end
            e = FindElite()
            while e and alive(e) and State.AutoElite do
                local r = e:FindFirstChild("HumanoidRootPart")
                if not r then break end
                if Combat.EquipWeapon then Combat.EquipWeapon(State.WeaponType or "Melee") end
                if Combat.AutoHaki then Combat.AutoHaki() end
                tp(r.CFrame * CFrame.new(0, 20, 7))
                if Combat.Attack then Combat.Attack() end
                task.wait()
            end
        end) end
    end
end)

-- ═══ [12.2] AUTO FISHING ═══
local function DetectRod()
    local ch = LP.Character
    local d = ch and ch:FindFirstChild("FishingRodData", true)
    if d then return d.Parent end
    for _, t in ipairs(LP.Backpack:GetChildren()) do if t:FindFirstChild("FishingRodData") then return t end end
end
local FR = RS:WaitForChild("FishReplicated"):WaitForChild("FishingRequest")
local NetRE; pcall(function() NetRE = require(RS.Modules.Net):RemoteEvent("FishingRemote", true) end)
local WaterH; pcall(function() WaterH = require(RS.Util.GetWaterHeightAtLocation) end)
local hooked = false
local function Hook(rod)
    if hooked or not NetRE then return end
    hooked = true
    NetRE.OnClientEvent:Connect(function(who, act)
        if not State.AutoFishing or who ~= LP then return end
        if act == "SpawnFishOnBob" then
            task.wait(0.2)
            FR:InvokeServer("Catching", true, { fastBite = true }) task.wait(2)
            FR:InvokeServer("Catch", 1, 1, 1); FR:InvokeServer("Catch", 1, 0, 1)
        end
    end)
end

task.spawn(function()
    while task.wait(0.4) do
        if State.AutoFishing then pcall(function()
            local h, rod = hrp(), DetectRod()
            if not h or not rod then return end
            if rod.Parent == LP.Backpack then LP.Character.Humanoid:EquipTool(rod) task.wait(0.5) return end
            Hook(rod)
            local st = rod:GetAttribute("ServerState")
            if (rod:GetAttribute("SkillChargeAlpha") or 0) >= 1 then
                pcall(function() RS.Modules.Net:FindFirstChild("RF/JobToolAbilities"):InvokeServer("Z", true) end)
            end
            if not st or st == "ReeledIn" then
                FR:InvokeServer("StartCasting") task.wait(0.7)
                local p = h.Position + h.CFrame.LookVector * 40
                local y = WaterH and WaterH(p) or h.Position.Y - 3
                if not FR:InvokeServer("CastLineAtLocation", Vector3.new(p.X, y, p.Z), 98, true) then
                    if Combat.EquipWeapon then Combat.EquipWeapon("Melee") end
                end
            elseif st == "Biting" then
                C._biteT = C._biteT or tick()
                if tick() - C._biteT >= 5 then if Combat.EquipWeapon then Combat.EquipWeapon("Melee") end task.wait(1) end
            else C._biteT = nil end
        end) end
    end
end)

-- ═══ [12.3] UI ═══
local Tab = Window:MakeTab({ Name = "Banana+", Icon = "🍌" })
local S1 = Tab:CreateSection({ Name = "Elite Hunter" })
S1:AddToggle({ Name = "Auto Elite Hunter", Desc = "Nhận quest + đánh Deandre/Urban/Diablo", Default = State.AutoElite, Flag = "AutoElite" }, function(v) State.AutoElite = v Notify("Elite", v and "BẬT" or "TẮT", v and "success" or "warning") end)
S1:AddToggle({ Name = "Hop khi không có Elite", Default = State.EliteHop, Flag = "EliteHop" }, function(v) State.EliteHop = v end)
local S2 = Tab:CreateSection({ Name = "Fishing" })
S2:AddToggle({ Name = "Auto Fishing", Desc = "Tự quăng cần, câu cá (cần có cần câu)", Default = State.AutoFishing, Flag = "AutoFishing" }, function(v) State.AutoFishing = v Notify("Fishing", v and "BẬT" or "TẮT", v and "success" or "warning") end)

print("  ✅ PART 12 — FISHING + ELITE HUNTER LOADED")
end)()
