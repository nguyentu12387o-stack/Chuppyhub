-- CHUPPY HUB BLOX V25 — menu animation Pro Max + nền Miku · sửa farm Quest (Monster.Find) · giữ core + gethui
-- chống chạy 2 lần (loader / queue_on_teleport): gỡ bản cũ trước
pcall(function() local g = getgenv and getgenv(); if g and g.ChuppyUnload then g.ChuppyUnload(); task.wait(0.6) end end);
-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐾 CHUPPY HUB V2 — PART 1/10: UI LIBRARY
-- Phiên bản sạch: IIFE scope · không return giữa file · export qua getgenv()
-- ═══════════════════════════════════════════════════════════════════════════════
-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐾 CHUPPY UI V4 — kiểu redz V5 (sidebar · ô tick · section có đường kẻ) · Theme presets · Floating button · Mobile friendly
-- API tương thích: CreateWindow / MakeTab / SelectTab / CreateSection / Add*
-- ═══════════════════════════════════════════════════════════════════════════════
(function()
-- ═══ MENU MỚI (lấy từ Chuppy Egg) · cầu nối API redz: CreateWindow / MakeTab / CreateSection / Add* ═══
local okNew, errNew = pcall(function()
local Players, LP = game:GetService("Players"), game:GetService("Players").LocalPlayer
local genv = (getgenv and getgenv()) or _G
genv.ChuppyErrors = genv.ChuppyErrors or {}
pcall(function() if genv.ChuppyErrConn then genv.ChuppyErrConn:Disconnect() end end)
pcall(function()
    genv.ChuppyErrConn = game:GetService("LogService").MessageOut:Connect(function(msg, mt)
        if mt == Enum.MessageType.MessageError or (mt == Enum.MessageType.MessageWarning and string.find(msg, "Chuppy", 1, true)) then
            local b = genv.ChuppyErrors
            b[#b + 1] = os.date("%H:%M:%S ") .. tostring(msg)
            if #b > 40 then table.remove(b, 1) end
        end
    end)
end)

local Theme = {
    Accent = Color3.fromRGB(225, 45, 65), Accent2 = Color3.fromRGB(170, 28, 48),
    Background = Color3.fromRGB(18, 18, 21), Surface = Color3.fromRGB(24, 24, 28),
    Surface2 = Color3.fromRGB(31, 31, 36), Surface3 = Color3.fromRGB(44, 44, 50),
    Text = Color3.fromRGB(236, 236, 242), TextDim = Color3.fromRGB(138, 138, 150),
    Border = Color3.fromRGB(46, 46, 54),
    Success = Color3.fromRGB(70, 210, 120), Warning = Color3.fromRGB(250, 185, 45),
    Danger = Color3.fromRGB(240, 70, 85), Info = Color3.fromRGB(90, 165, 250),
    FontRegular = Enum.Font.Gotham, FontBold = Enum.Font.GothamBold, FontBlack = Enum.Font.GothamBlack,
}
genv.ChuppyTheme = Theme
local function P(name, r, g, b)
    return { name = name, c1 = Color3.fromRGB(r, g, b), c2 = Color3.fromRGB(math.floor(r * 0.74), math.floor(g * 0.74), math.floor(b * 0.74)) }
end
local Presets = {
    P("Redz Red", 225, 45, 65), P("Banana Yellow", 250, 204, 21), P("Quantum Violet", 139, 92, 246),
    P("Cyber Cyan", 0, 200, 235), P("Neon Green", 70, 220, 120), P("Sunset", 255, 140, 40),
    P("Ice Blue", 100, 180, 255), P("Pink Kawaii", 255, 130, 190), P("Mint", 120, 235, 190), P("Toxic", 170, 240, 20),
}
-- bỏ emoji / ký hiệu hình trong chữ hiển thị
local function clean(s)
    s = tostring(s == nil and "" or s)
    local ok, out = pcall(function()
        local t = {}
        for _, cp in utf8.codes(s) do
            local drop = cp >= 0x1F000 or (cp >= 0x2600 and cp <= 0x27BF) or (cp >= 0x2B00 and cp <= 0x2BFF)
                or (cp >= 0x2300 and cp <= 0x23FF) or cp == 0xFE0F or cp == 0x200D or cp == 0x20E3 or cp == 0x2139
            if not drop then t[#t + 1] = utf8.char(cp) end
        end
        return table.concat(t)
    end)
    if not ok then out = s end
    out = string.gsub(out, "^%s+", "")
    out = string.gsub(out, "%s+$", "")
    return out
end

local Core = (function()
-- ChuppyUI: menu tối giản (sidebar trái, topbar, splash, pill thu nhỏ). Tương thích API ChuppyLibrary.
local Players, UIS, TS, HS = game:GetService("Players"), game:GetService("UserInputService"), game:GetService("TweenService"), game:GetService("HttpService")
local CoreGui, LP = game:GetService("CoreGui"), Players.LocalPlayer
local Lib = { Version = "Beta", Discord = "https://discord.gg/F2Yn4csrR", Title = "Chuppy Hub", Subtitle = "Steal an Egg" }
local function upper(k) return type(k) == "string" and string.match(k, "^%u") ~= nil end
local Stub
Stub = setmetatable({}, { __index = function() return Stub end, __call = function() return Stub end, __newindex = function() end })
local function C3(r, g, b) return Color3.fromRGB(r, g, b) end
local Theme = { Bg = C3(13, 13, 15), Surface = C3(23, 23, 27), Surface2 = C3(36, 36, 42), Stroke = C3(44, 44, 52), Text = C3(240, 240, 245), Sub = C3(138, 138, 150), Accent = C3(240, 240, 245) }
local Presets = {
    Dark = { Bg = C3(13, 13, 15), Surface = C3(23, 23, 27), Surface2 = C3(36, 36, 42), Stroke = C3(44, 44, 52), Text = C3(240, 240, 245), Sub = C3(138, 138, 150), Accent = C3(240, 240, 245) },
    AMOLED = { Bg = C3(0, 0, 0), Surface = C3(14, 14, 14), Surface2 = C3(28, 28, 28), Stroke = C3(38, 38, 38), Text = C3(255, 255, 255), Sub = C3(130, 130, 130), Accent = C3(255, 255, 255) },
    Midnight = { Bg = C3(10, 12, 22), Surface = C3(18, 22, 38), Surface2 = C3(30, 36, 60), Stroke = C3(42, 50, 82), Text = C3(230, 236, 255), Sub = C3(130, 140, 175), Accent = C3(110, 150, 255) },
    Rose = { Bg = C3(20, 11, 15), Surface = C3(32, 18, 24), Surface2 = C3(50, 28, 38), Stroke = C3(70, 40, 52), Text = C3(255, 236, 242), Sub = C3(170, 130, 145), Accent = C3(255, 100, 140) },
    Forest = { Bg = C3(10, 17, 13), Surface = C3(17, 28, 21), Surface2 = C3(28, 46, 34), Stroke = C3(40, 64, 48), Text = C3(230, 255, 238), Sub = C3(125, 165, 138), Accent = C3(90, 220, 130) },
}
local binds, restylers = {}, {}
local function B(inst, prop, key) inst[prop] = Theme[key]; binds[#binds + 1] = { inst, prop, key } end
local function applyTheme()
    for i = #binds, 1, -1 do
        local b = binds[i]
        if b[1].Parent then b[1][b[2]] = Theme[b[3]] else table.remove(binds, i) end
    end
    for _, f in ipairs(restylers) do pcall(f) end
end
local function new(class, props, parent)
    local i = Instance.new(class)
    for k, v in pairs(props or {}) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end
local function corner(i, r) new("UICorner", { CornerRadius = UDim.new(0, r or 6) }, i) end
local function strokeOf(i) local s = new("UIStroke", { Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, i); B(s, "Color", "Stroke"); return s end
local function label(parent, text, size, key, font, align)
    local l = new("TextLabel", { BackgroundTransparency = 1, Text = text or "", TextSize = size or 12, Font = font or Enum.Font.GothamMedium, TextXAlignment = align or Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd }, parent)
    B(l, "TextColor3", key or "Text")
    return l
end
local function tween(i, t, p) pcall(function() TS:Create(i, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p):Play() end) end
-- ===== Hiệu ứng (animation) =====
local ESt = Enum.EasingStyle
local function tweenE(i, t, p, style, dir) pcall(function() TS:Create(i, TweenInfo.new(t, style or ESt.Quad, dir or Enum.EasingDirection.Out), p):Play() end) end
local function roundFull(i) new("UICorner", { CornerRadius = UDim.new(1, 0) }, i) end
local function scaleOf(inst)
    local s = inst:FindFirstChild("_pop")
    if not s then s = Instance.new("UIScale"); s.Name = "_pop"; s.Scale = 1; s.Parent = inst end
    return s
end
-- nhấn: ép nhỏ rồi bật lại kiểu lò xo
local function press(inst, depth)
    local sc = scaleOf(inst)
    tweenE(sc, 0.07, { Scale = depth or 0.965 }, ESt.Quad)
    task.delay(0.07, function() if sc.Parent then tweenE(sc, 0.42, { Scale = 1 }, ESt.Back) end end)
end
-- gợn sóng từ điểm bấm (host cần ClipsDescendants)
local function ripple(host, color)
    pcall(function()
        local ap, as = host.AbsolutePosition, host.AbsoluteSize
        local mp = UIS:GetMouseLocation()
        local rx, ry = mp.X - ap.X, mp.Y - ap.Y
        if rx < 0 or ry < 0 or rx > as.X or ry > as.Y then rx, ry = as.X / 2, as.Y / 2 end
        local d = math.max(as.X, as.Y) * 2.3
        local c = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(rx, ry), Size = UDim2.fromOffset(0, 0),
            BackgroundColor3 = color or Theme.Accent, BackgroundTransparency = 0.72, BorderSizePixel = 0, ZIndex = 6 }, host)
        roundFull(c)
        tweenE(c, 0.6, { Size = UDim2.fromOffset(d, d), BackgroundTransparency = 1 }, ESt.Quint)
        task.delay(0.65, function() if c.Parent then c:Destroy() end end)
    end)
end
-- các hàng nảy lên lần lượt (dùng khi đổi tab / mở section)
local function popIn(container, maxN)
    local n = 0
    for _, d in ipairs(container:GetDescendants()) do
        if d.Name == "_pop" and d:IsA("UIScale") and d.Parent and d.Parent:IsA("GuiObject") and d.Parent.Visible then
            n = n + 1
            if n > (maxN or 16) then break end
            d.Scale = 0.88
            local i = n
            task.delay(0.025 * i, function() if d.Parent then tweenE(d, 0.45, { Scale = 1 }, ESt.Back) end end)
        end
    end
end
local function guiParent()
    local ok, h = pcall(function() return gethui and gethui() end)
    if ok and typeof(h) == "Instance" then return h end
    local ok2 = pcall(function() return CoreGui.Name end)
    if ok2 then return CoreGui end
    return LP:WaitForChild("PlayerGui")
end
local function truthy(v) return v ~= nil and v ~= false and v ~= "" end
local function drag(handle, target)
    local dragging, start, pos
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging, start, pos = true, i.Position, target.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - start
            target.Position = UDim2.new(pos.X.Scale, pos.X.Offset + d.X, pos.Y.Scale, pos.Y.Offset + d.Y)
        end
    end)
end

-- ===== Ảnh (logo + hình nền) =====
-- Nhận: link ảnh trực tiếp, ID Roblox, rbxassetid://ID, hoặc link create.roblox.com/store/asset/ID
-- ID trên Creator Store thường là DECAL; ImageLabel cần ID ẢNH (Image). Script tự đổi decal -> ảnh khi chạy:
--   1) game:GetObjects("rbxassetid://<decal>") rồi đọc Decal.Texture   2) tải ảnh thumbnail về máy   3) dùng thẳng ID
Lib.ImageUrl = "6722334274"   -- ảnh mặc định (Miku Nakano trên Creator Store)
local UIFILE = "ChuppyHub/blox_ui.json"
Lib.Pref = { img = "", bgOn = true, bgAlpha = 0.6, map = {} }
pcall(function()
    if type(isfile) == "function" and isfile(UIFILE) then
        local d = HS:JSONDecode(readfile(UIFILE))
        if type(d) == "table" then
            if type(d.img) == "string" then Lib.Pref.img = d.img end
            if type(d.bgOn) == "boolean" then Lib.Pref.bgOn = d.bgOn end
            if type(d.bgAlpha) == "number" then Lib.Pref.bgAlpha = d.bgAlpha end
            if type(d.map) == "table" then Lib.Pref.map = d.map end
        end
    end
end)
local function savePref()
    pcall(function()
        if type(writefile) ~= "function" then return end
        if type(makefolder) == "function" and type(isfolder) == "function" and not isfolder("ChuppyHub") then makefolder("ChuppyHub") end
        writefile(UIFILE, HS:JSONEncode(Lib.Pref))
    end)
end
Lib.SavePref = savePref
local function ensureFolder()
    pcall(function() if type(makefolder) == "function" and type(isfolder) == "function" and not isfolder("ChuppyHub") then makefolder("ChuppyHub") end end)
end
local function hashOf(str) local h = 5381; for i = 1, #str do h = (h * 33 + string.byte(str, i)) % 4294967296 end return tostring(h) end
local function trim(x) x = string.gsub(tostring(x or ""), "^%s+", ""); return (string.gsub(x, "%s+$", "")) end
local function parseId(str)
    return string.match(str, "/store/asset/(%d+)") or string.match(str, "/catalog/(%d+)") or string.match(str, "/library/(%d+)")
        or string.match(str, "[?&][iI][dD]=(%d+)") or string.match(str, "^rbxassetid://(%d+)") or string.match(str, "^(%d+)$")
end
local function texId(t)
    t = tostring(t or "")
    return string.match(t, "[?&][iI][dD]=(%d+)") or string.match(t, "rbxassetid://(%d+)") or string.match(t, "^(%d+)$")
end
-- kiểm tra ảnh có tải được không
local CP = game:GetService("ContentProvider")
local function assetLoads(asset)
    local ok, res = pcall(function()
        local probe = Instance.new("ImageLabel")
        probe.Image = asset
        local good = false
        CP:PreloadAsync({ probe }, function(_, status) good = (status == Enum.AssetFetchStatus.Success) end)
        probe:Destroy()
        return good
    end)
    if not ok then return true end   -- không kiểm tra được thì coi như dùng được
    return res == true
end
-- DECAL -> ảnh: đọc thuộc tính Texture của Decal (không gắn vào game, huỷ ngay)
local function decalToImage(id)
    local okObj, objs = pcall(function() return game:GetObjects("rbxassetid://" .. id) end)
    if not okObj or type(objs) ~= "table" then return nil end
    local found
    for _, o in ipairs(objs) do
        pcall(function()
            if o:IsA("Decal") or o:IsA("Texture") then found = found or o.Texture
            else
                local d = o:FindFirstChildWhichIsA("Decal", true) or o:FindFirstChildWhichIsA("Texture", true)
                if d then found = found or d.Texture end
            end
        end)
        pcall(function() o:Destroy() end)
    end
    local n = texId(found)
    return n and ("rbxassetid://" .. n) or nil
end
local function saveDownload(path, data)
    if type(getcustomasset) ~= "function" or type(writefile) ~= "function" then return nil end
    if type(data) ~= "string" or #data < 200 then return nil end
    ensureFolder()
    writefile(path, data)
    return getcustomasset(path)
end
-- thumbnail của asset (ảnh thật của decal) tải về máy
local function thumbToFile(id)
    local asset
    pcall(function()
        if type(getcustomasset) ~= "function" or type(writefile) ~= "function" then return end
        local path = "ChuppyHub/img_" .. id .. ".png"
        if type(isfile) == "function" and isfile(path) then asset = getcustomasset(path); return end
        local raw = game:HttpGet("https://thumbnails.roblox.com/v1/assets?assetIds=" .. id .. "&returnPolicy=PlaceHolder&size=420x420&format=Png&isCircular=false")
        local d = HS:JSONDecode(raw)
        local e = d and d.data and d.data[1]
        if not e or e.state ~= "Completed" or type(e.imageUrl) ~= "string" or e.imageUrl == "" then return end
        asset = saveDownload(path, game:HttpGet(e.imageUrl))
    end)
    return asset
end
local function downloadUrl(url)
    local asset
    pcall(function()
        if type(getcustomasset) ~= "function" or type(writefile) ~= "function" then return end
        local path = "ChuppyHub/img_" .. hashOf(url) .. ".png"
        if type(isfile) == "function" and isfile(path) then asset = getcustomasset(path); return end
        asset = saveDownload(path, game:HttpGet(url))
    end)
    return asset
end
local imgCache = {}
local function resolveImage(url)
    url = trim(url)
    if url == "" then return nil end
    local cached = imgCache[url]
    if cached == "pending" then   -- luồng khác đang tải cùng ảnh: chờ kết quả (logo + nền gọi cùng lúc)
        local t0 = os.clock()
        while imgCache[url] == "pending" and os.clock() - t0 < 90 do task.wait(0.1) end
        cached = imgCache[url]
        if cached == "pending" then return nil end
        return cached or nil
    elseif cached ~= nil then
        return cached or nil
    end
    imgCache[url] = "pending"
    local id = parseId(url)
    local cands = {}
    if id then
        local mapped = Lib.Pref.map[id]
        if type(mapped) == "string" then cands[#cands + 1] = mapped
        else
            local conv = decalToImage(id)
            if conv then cands[#cands + 1] = conv end
        end
        cands[#cands + 1] = "thumb:" .. id
        cands[#cands + 1] = "rbxassetid://" .. id
    else
        cands[#cands + 1] = "url:" .. url
    end
    local chosen, first
    for _, c in ipairs(cands) do
        local asset = c
        if string.sub(c, 1, 6) == "thumb:" then asset = thumbToFile(string.sub(c, 7))
        elseif string.sub(c, 1, 4) == "url:" then asset = downloadUrl(string.sub(c, 5)) end
        if asset then
            first = first or asset
            if assetLoads(asset) then chosen = asset; break end
        end
    end
    chosen = chosen or first
    if id then
        local mapped = Lib.Pref.map[id]
        if chosen and string.sub(chosen, 1, 13) == "rbxassetid://" and chosen ~= ("rbxassetid://" .. id) then
            if mapped ~= chosen then Lib.Pref.map[id] = chosen; savePref() end
        elseif mapped then Lib.Pref.map[id] = nil; savePref() end
    end
    imgCache[url] = chosen or nil   -- lỗi thì không nhớ, lần sau còn thử lại được
    return chosen
end
local function currentSource() return (Lib.Pref.img ~= "" and Lib.Pref.img) or Lib.ImageUrl end

Lib._logos, Lib._bgImgs = {}, {}
-- độ trong của các hàng: có hình nền thì hàng trong hơn để thấy ảnh
local allRows = setmetatable({}, { __mode = "k" })
Lib.RowAlpha = 0.1
local function bgActive()
    for _, rec in ipairs(Lib._bgImgs) do if rec.img.Parent and rec.img.Visible then return true end end
    return false
end
local function refreshRows()
    local a = bgActive() and 0.42 or 0.1
    Lib.RowAlpha = a
    for r in pairs(allRows) do if r.Parent then tween(r, 0.3, { BackgroundTransparency = a }) end end
end
local function paintLogo(rec, asset)
    if not rec.frame.Parent then return end
    if asset then
        rec.label.Visible = false
        if not rec.img or not rec.img.Parent then
            rec.img = new("ImageLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Crop, ZIndex = 53 }, rec.frame)
            corner(rec.img, rec.radius or 10)
        end
        rec.img.Image = asset
    else
        rec.label.Visible = true
        if rec.img then rec.img:Destroy(); rec.img = nil end
    end
end
local function paintBg(rec, asset)
    if not rec.img.Parent then return end
    if asset then rec.img.Image = asset; rec.img.Visible = Lib.Pref.bgOn else rec.img.Visible = false end
    rec.shade.Visible = rec.img.Visible
    refreshRows()
end
function Lib.ApplyLogo(frame, textLabel, radius)
    local rec = { frame = frame, label = textLabel, radius = radius }
    Lib._logos[#Lib._logos + 1] = rec
    task.spawn(function() paintLogo(rec, resolveImage(currentSource())) end)
end
function Lib.RegisterBg(img, shade)
    local rec = { img = img, shade = shade }
    Lib._bgImgs[#Lib._bgImgs + 1] = rec
    img.ImageTransparency = Lib.Pref.bgAlpha
    img.Visible = false; shade.Visible = false
    task.spawn(function() paintBg(rec, resolveImage(currentSource())) end)
end
-- đổi ảnh khi đang chạy (từ ô nhập ở tab UI)
function Lib.SetImage(url)
    Lib.Pref.img = trim(url)
    savePref()
    task.spawn(function()
        local a = resolveImage(currentSource())
        for _, rec in ipairs(Lib._logos) do paintLogo(rec, a) end
        for _, rec in ipairs(Lib._bgImgs) do paintBg(rec, a) end
        if not a then Lib.Notify(Lib, "Chuppy Hub", "Không tải được ảnh, kiểm tra link/ID") end
    end)
end
function Lib.SetBgOn(v)
    Lib.Pref.bgOn = v and true or false; savePref()
    for _, rec in ipairs(Lib._bgImgs) do
        if rec.img.Parent then rec.img.Visible = Lib.Pref.bgOn and rec.img.Image ~= ""; rec.shade.Visible = rec.img.Visible end
    end
    refreshRows()
end
function Lib.SetBgAlpha(a)
    Lib.Pref.bgAlpha = a; savePref()
    for _, rec in ipairs(Lib._bgImgs) do if rec.img.Parent then tweenE(rec.img, 0.2, { ImageTransparency = a }) end end
end

-- ===== Handle chung =====
local HandleMT = {}
HandleMT.__index = function(t, k)
    local m = rawget(HandleMT, k)
    if m ~= nil then return m end
    if upper(k) then return Stub end
    return nil
end
function HandleMT.Get(self) return self.Value end
function HandleMT.GetValue(self) return self.Value end
function HandleMT.Subscribe(self, fn)
    self._subs[#self._subs + 1] = fn
    return { Disconnect = function() for i, f in ipairs(self._subs) do if f == fn then table.remove(self._subs, i) break end end end }
end
function HandleMT.SetValue(self, ...) return self:Set(...) end
function HandleMT.JoinExclusiveGroup(self, g) if type(g) == "table" and g._members then g._members[#g._members + 1] = self; self._group = g end end
function HandleMT.SetVisible(self, v) local r = rawget(self, "Row"); if r then r.Visible = v end end
function HandleMT.Destroy(self) local r = rawget(self, "Row"); if r then r:Destroy() end end
local Registry, cfg = {}, { AutoSave = true, AutoLoad = true, Notifs = true, loading = false }
local saveQueued = false
local function queueSave()
    if cfg.loading or not cfg.AutoSave or saveQueued or not Lib._saver then return end
    saveQueued = true
    task.delay(2, function() saveQueued = false; pcall(Lib._saver) end)
end
local function newHandle(kind, name, value)
    return setmetatable({ Kind = kind, Name = name, Value = value, _subs = {} }, HandleMT)
end
local function emit(h, o, v)
    if o and type(o.Callback) == "function" then pcall(o.Callback, v) end
    for _, f in ipairs(h._subs) do pcall(f, v) end
    queueSave()
end

-- ===== Toast =====
local ToastHolder
function Lib.Notify(a, b, c)
    if not cfg.Notifs or not ToastHolder then return end
    local t, x = "Chuppy Hub", ""
    local args = { a, b, c }
    if a == Lib then args = { b, c } end
    local first = args[1]
    if type(first) == "table" then t = tostring(first.Title or first.Name or t); x = tostring(first.Content or first.Text or first.Description or "")
    else t = tostring(first or t); x = tostring(args[2] or "") end
    local f = new("Frame", { Size = UDim2.fromOffset(200, 30), BackgroundTransparency = 1 }, ToastHolder)
    B(f, "BackgroundColor3", "Bg"); corner(f, 8)
    local st = strokeOf(f); st.Transparency = 1
    local l = label(f, t .. (x ~= "" and ("  ·  " .. x) or ""), 11, "Text")
    l.Size = UDim2.new(1, -16, 1, 0); l.Position = UDim2.fromOffset(8, 0); l.TextTransparency = 1
    local acc = new("Frame", { Size = UDim2.new(0, 3, 1, -10), Position = UDim2.fromOffset(0, 5), BorderSizePixel = 0, BackgroundTransparency = 1 }, f)
    B(acc, "BackgroundColor3", "Accent"); roundFull(acc)
    local sc = scaleOf(f); sc.Scale = 0.7
    tweenE(sc, 0.5, { Scale = 1 }, ESt.Back)
    tweenE(f, 0.25, { BackgroundTransparency = 0.05 }); tweenE(st, 0.25, { Transparency = 0 }); tweenE(l, 0.25, { TextTransparency = 0 }); tweenE(acc, 0.25, { BackgroundTransparency = 0 })
    task.delay(3.3, function()
        if not f.Parent then return end
        tweenE(sc, 0.3, { Scale = 0.85 }); tweenE(f, 0.3, { BackgroundTransparency = 1 }); tweenE(st, 0.3, { Transparency = 1 })
        tweenE(l, 0.3, { TextTransparency = 1 }); tweenE(acc, 0.3, { BackgroundTransparency = 1 })
        task.delay(0.35, function() if f.Parent then f:Destroy() end end)
    end)
end

-- ===== Controls =====
local Common = {}
function Common.CreateState(self, o)
    o = o or {}
    local win = self._win or self
    local nm = tostring(o.Name or ("State" .. tostring(os.clock())))
    if win.States[nm] then return win.States[nm] end
    local s = newHandle("State", nm, (o.Default ~= nil) and o.Default or false)
    function s.Set(me, v) me.Value = v; for _, f in ipairs(me._subs) do pcall(f, v) end; queueSave() end
    win.States[nm] = s
    Registry[#Registry + 1] = { key = "state/" .. nm, h = s }
    return s
end
function Common.CreateExclusiveGroup(self, o) return { Name = (o or {}).Name, Max = (o or {}).MaxActive or 1, _members = {} } end
function Common.Notify(self, ...) return Lib.Notify(Lib, ...) end

local Section = {}
Section.__index = function(t, k) return rawget(Section, k) or Common[k] or (upper(k) and Stub or nil) end
local Search = { q = "" }
local rowInfos = setmetatable({}, { __mode = "k" })

local function makeRow(sec, o, h, rightW)
    sec._n = sec._n + 1
    local row = new("Frame", { Size = UDim2.new(1, 0, 0, h), LayoutOrder = sec._n, ClipsDescendants = true, BackgroundTransparency = Lib.RowAlpha or 0.1 }, sec.Body)
    allRows[row] = true
    B(row, "BackgroundColor3", "Surface"); corner(row, 6); strokeOf(row)
    scaleOf(row)
    row.MouseEnter:Connect(function() tweenE(row, 0.18, { BackgroundColor3 = Theme.Surface2 }) end)
    row.MouseLeave:Connect(function() tweenE(row, 0.25, { BackgroundColor3 = Theme.Surface }) end)
    local hasNote = type(o.Note) == "string" and o.Note ~= ""
    local title = label(row, tostring(o.Name or ""), 12, "Text", Enum.Font.GothamMedium)
    title.Position = UDim2.fromOffset(10, hasNote and 4 or 0)
    title.Size = UDim2.new(1, -(rightW or 0) - 18, 0, hasNote and 16 or h)
    if hasNote then
        local n = label(row, o.Note, 10, "Sub", Enum.Font.Gotham)
        n.Position = UDim2.fromOffset(10, 20); n.Size = UDim2.new(1, -(rightW or 0) - 18, 0, 13)
    end
    local info = { name = string.lower(tostring(o.Name or "")) }
    rowInfos[row] = info
    local parent = o.SubOf or o.ShowWhen
    local function cond()
        if parent == nil then return true end
        if type(parent) == "function" then local ok, v = pcall(parent); return ok and truthy(v) end
        if type(parent) == "table" then
            local g = parent.Get
            if type(g) == "function" then local ok, v = pcall(g, parent); if ok then return truthy(v) end end
        end
        return true
    end
    info.refresh = function() row.Visible = cond() end
    info.refresh()
    if o.SubOf then row.Size = UDim2.new(1, -14, 0, h) end
    if type(parent) == "table" and type(parent.Subscribe) == "function" then pcall(parent.Subscribe, parent, function() info.refresh() end) end
    return row, info
end
local function register(sec, name, h)
    local key = sec._path .. "/" .. tostring(name)
    local n = 1
    for _, r in ipairs(Registry) do if r.base == key then n = n + 1 end end
    Registry[#Registry + 1] = { key = n > 1 and (key .. "#" .. n) or key, base = key, h = h }
end
local function finish(h, o, row, v)
    h.Row = row
    if Lib.FireDefaults ~= false then task.defer(function() emit(h, o, v) end) end
    return h
end

function Section.CreateToggle(self, o)
    o = o or {}
    local row = makeRow(self, o, (type(o.Note) == "string" and o.Note ~= "") and 38 or 34, 44)
    local sw = new("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(34, 18) }, row)
    corner(sw, 9)
    local glow = new("UIStroke", { Thickness = 1.5, Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, sw)
    B(glow, "Color", "Accent")
    local knob = new("Frame", { Size = UDim2.fromOffset(14, 14), Position = UDim2.fromOffset(2, 2) }, sw)
    corner(knob, 7)
    local btn = new("TextButton", { BackgroundTransparency = 1, Text = "", Size = UDim2.fromScale(1, 1) }, row)
    local init = o.Default == true
    if o.State then local ok, sv = pcall(function() return o.State:Get() end); if ok and type(sv) == "boolean" then init = sv end end
    local h = newHandle("Toggle", o.Name, init)
    local function style(v)
        tweenE(sw, 0.22, { BackgroundColor3 = v and Theme.Accent or Theme.Surface2 })
        tweenE(glow, 0.25, { Transparency = v and 0.35 or 1 })
        -- lò xo: kéo giãn knob rồi bật về đúng chỗ
        tweenE(knob, 0.1, { Size = UDim2.fromOffset(20, 14) })
        task.delay(0.1, function()
            if knob.Parent then tweenE(knob, 0.45, { Size = UDim2.fromOffset(14, 14), Position = v and UDim2.fromOffset(18, 2) or UDim2.fromOffset(2, 2), BackgroundColor3 = v and Theme.Bg or Theme.Sub }, ESt.Back) end
        end)
    end
    sw.BackgroundColor3 = init and Theme.Accent or Theme.Surface2
    knob.Position = init and UDim2.fromOffset(18, 2) or UDim2.fromOffset(2, 2)
    knob.BackgroundColor3 = init and Theme.Bg or Theme.Sub
    restylers[#restylers + 1] = function() if sw.Parent then style(h.Value) end end
    function h.Set(me, v, silent)
        v = v == true
        me.Value = v; style(v)
        if o.State then pcall(function() o.State:Set(v) end) end
        if v and me._group and me._group.Max then
            local act = {}
            for _, m in ipairs(me._group._members) do if m ~= me and m.Value then act[#act + 1] = m end end
            while #act >= me._group.Max do local m = table.remove(act, 1); m:Set(false) end
        end
        if not silent then emit(me, o, v) else for _, f in ipairs(me._subs) do pcall(f, v) end end
    end
    btn.MouseButton1Click:Connect(function() press(row, 0.97); ripple(row); h:Set(not h.Value) end)
    register(self, o.Name, h)
    return finish(h, o, row, init)
end

function Section.CreateButton(self, o)
    o = o or {}
    local hasBtn = type(o.ButtonText) == "string"
    local row = makeRow(self, hasBtn and o or { SubOf = o.SubOf, ShowWhen = o.ShowWhen, Name = "" }, (hasBtn and type(o.Note) == "string" and o.Note ~= "") and 38 or 34, hasBtn and 70 or 0)
    local h = newHandle("Button", o.Name, nil)
    local b = new("TextButton", { BackgroundTransparency = hasBtn and 0 or 1, Font = Enum.Font.GothamMedium, TextSize = 12, AutoButtonColor = false }, row)
    if hasBtn then
        b.AnchorPoint = Vector2.new(1, 0.5); b.Position = UDim2.new(1, -8, 0.5, 0); b.Size = UDim2.fromOffset(60, 22); b.Text = o.ButtonText
        B(b, "BackgroundColor3", "Surface2"); corner(b, 5)
    else
        b.Size = UDim2.fromScale(1, 1); b.Text = tostring(o.Name or "Button"); b.TextXAlignment = Enum.TextXAlignment.Left
        new("UIPadding", { PaddingLeft = UDim.new(0, 10) }, b)
    end
    B(b, "TextColor3", "Text")
    if not hasBtn then
        local chev = label(row, ">", 13, "Sub", Enum.Font.GothamBold, Enum.TextXAlignment.Right)
        chev.Size = UDim2.new(1, -12, 1, 0)
        row.MouseEnter:Connect(function() tweenE(chev, 0.25, { Position = UDim2.fromOffset(-4, 0) }, ESt.Back) end)
        row.MouseLeave:Connect(function() tweenE(chev, 0.25, { Position = UDim2.fromOffset(0, 0) }) end)
    end
    b.MouseButton1Click:Connect(function()
        press(hasBtn and b or row, hasBtn and 0.9 or 0.97); ripple(row)
        if type(o.Callback) == "function" then pcall(o.Callback) end
        if hasBtn and o.ConfirmText then
            local old = o.ButtonText; b.Text = o.ConfirmText
            task.delay(1.2, function() if b.Parent then b.Text = old end end)
        end
    end)
    h.Row = row
    function h.Set(me, t) if hasBtn and type(t) == "string" then b.Text = t end end
    return h
end

local function fmtNum(v) local s = string.format("%.2f", v); s = s:gsub("0+$", ""):gsub("%.$", ""); return s end
function Section.CreateSlider(self, o)
    o = o or {}
    local min, max = tonumber(o.Min) or 0, tonumber(o.Max) or 100
    local inc = tonumber(o.Increment) or 1
    local row = makeRow(self, o, 46, 90)
    local title = row:FindFirstChildWhichIsA("TextLabel")
    local val = label(row, "", 11, "Sub", Enum.Font.GothamMedium, Enum.TextXAlignment.Right)
    val.AnchorPoint = Vector2.new(1, 0); val.Position = UDim2.new(1, -10, 0, 6); val.Size = UDim2.fromOffset(100, 14)
    if title then title.Size = UDim2.new(1, -120, 0, 14); title.Position = UDim2.fromOffset(10, 6) end
    local bar = new("Frame", { Position = UDim2.new(0, 10, 1, -14), Size = UDim2.new(1, -20, 0, 4) }, row)
    B(bar, "BackgroundColor3", "Surface2"); corner(bar, 2)
    local fill = new("Frame", { Size = UDim2.fromScale(0, 1) }, bar)
    B(fill, "BackgroundColor3", "Accent"); corner(fill, 2)
    local sknob = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(10, 10), Position = UDim2.fromScale(0, 0.5), BorderSizePixel = 0, ZIndex = 3 }, bar)
    B(sknob, "BackgroundColor3", "Text"); roundFull(sknob)
    local hit = new("TextButton", { BackgroundTransparency = 1, Text = "", Position = UDim2.new(0, 0, 1, -24), Size = UDim2.new(1, 0, 0, 24) }, row)
    local h = newHandle("Slider", o.Name, tonumber(o.Default) or min)
    local function show(v)
        local txt
        if type(o.ValueFormat) == "function" then local ok, r = pcall(o.ValueFormat, v); txt = ok and tostring(r) or fmtNum(v) else txt = fmtNum(v) end
        val.Text = txt .. (o.Unit and (" " .. tostring(o.Unit)) or "")
        local r = max > min and math.clamp((v - min) / (max - min), 0, 1) or 0
        tweenE(fill, 0.14, { Size = UDim2.fromScale(r, 1) }, ESt.Quint)
        tweenE(sknob, 0.14, { Position = UDim2.fromScale(r, 0.5) }, ESt.Quint)
    end
    function h.Set(me, v, silent)
        v = tonumber(v) or min
        v = math.clamp(v, min, max)
        if inc > 0 then v = math.floor((v - min) / inc + 0.5) * inc + min end
        if o.AllowDecimals ~= true and inc >= 1 then v = math.floor(v + 0.5) end
        v = math.clamp(v, min, max)
        me.Value = v; show(v)
        if not silent then emit(me, o, v) else for _, f in ipairs(me._subs) do pcall(f, v) end end
    end
    local dragging = false
    local function fromX(x) local r = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1); h:Set(min + r * (max - min)) end
    hit.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; fromX(i.Position.X)
            tweenE(sknob, 0.3, { Size = UDim2.fromOffset(15, 15) }, ESt.Back)
            tweenE(val, 0.2, { TextSize = 13 })
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then fromX(i.Position.X) end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            if dragging then tweenE(sknob, 0.35, { Size = UDim2.fromOffset(10, 10) }, ESt.Back); tweenE(val, 0.25, { TextSize = 11 }) end
            dragging = false
        end
    end)
    show(h.Value)
    register(self, o.Name, h)
    return finish(h, o, row, h.Value)
end

local function normOptions(opts)
    local out = {}
    for _, e in ipairs(type(opts) == "table" and opts or {}) do
        if type(e) == "table" then
            local l = e.Name or e.Label or e.Text or e[1]
            out[#out + 1] = { label = tostring(l), value = e.Value ~= nil and e.Value or tostring(l) }
        else out[#out + 1] = { label = tostring(e), value = e } end
    end
    return out
end
local function dropdown(self, o, multi)
    o = o or {}
    local sec = self
    sec._n = sec._n + 1
    local row, info = makeRow(sec, o, 36, 120)
    row.AutomaticSize = Enum.AutomaticSize.Y
    row.Size = UDim2.new(row.Size.X.Scale, row.Size.X.Offset, 0, 36)
    local header = new("TextButton", { BackgroundTransparency = 1, Text = "", Size = UDim2.new(1, 0, 0, 36) }, row)
    local cur = label(header, "", 11, "Sub", Enum.Font.GothamMedium, Enum.TextXAlignment.Right)
    cur.AnchorPoint = Vector2.new(1, 0); cur.Position = UDim2.new(1, -24, 0, 0); cur.Size = UDim2.new(0, 110, 0, 36)
    local arrow = label(header, "▾", 12, "Sub", Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    arrow.Rotation = 0
    arrow.AnchorPoint = Vector2.new(1, 0); arrow.Position = UDim2.new(1, -6, 0, 0); arrow.Size = UDim2.fromOffset(16, 36)
    local list = new("Frame", { BackgroundTransparency = 1, Position = UDim2.fromOffset(0, 38), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Visible = false }, row)
    new("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, list)
    new("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6) }, list)
    local search = new("TextBox", { Size = UDim2.new(1, 0, 0, 24), PlaceholderText = "Search...", Text = "", ClearTextOnFocus = false, Font = Enum.Font.Gotham, TextSize = 11, LayoutOrder = 0, Visible = false }, list)
    B(search, "BackgroundColor3", "Surface2"); B(search, "TextColor3", "Text"); B(search, "PlaceholderColor3", "Sub"); corner(search, 5)
    local scroll = new("ScrollingFrame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.None, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 2, BorderSizePixel = 0, LayoutOrder = 1 }, list)
    new("UIListLayout", { Padding = UDim.new(0, 2) }, scroll)
    local options = normOptions(o.Options)
    local sel = {}
    local h = newHandle(multi and "MultiDropdown" or "Dropdown", o.Name, nil)
    local rows = {}
    local function summary()
        if multi then
            local t = {}
            for _, op in ipairs(options) do if sel[op.label] then t[#t + 1] = op.label end end
            if #t == 0 then return "None" end
            if #t > 2 then return #t .. " selected" end
            return table.concat(t, ", ")
        end
        return h._cur or "Select"
    end
    local function value()
        if multi then local s = {}; for k, v in pairs(sel) do if v then s[k] = true end end; return s end
        return h._val
    end
    local function paint()
        for lab, r in pairs(rows) do
            local on = multi and sel[lab] or (not multi and h._cur == lab)
            r.mark.Text = on and "✓" or ""
            r.btn.TextColor3 = on and Theme.Text or Theme.Sub
        end
        cur.Text = summary()
        h.Value = value()
    end
    local function rebuild()
        for _, r in pairs(rows) do r.btn:Destroy() end
        rows = {}
        search.Visible = #options > 8
        for i, op in ipairs(options) do
            local b = new("TextButton", { Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Text = op.label, Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, LayoutOrder = i }, scroll)
            new("UIPadding", { PaddingLeft = UDim.new(0, 6) }, b)
            local mark = label(b, "", 12, "Text", Enum.Font.GothamBold, Enum.TextXAlignment.Right)
            mark.Size = UDim2.new(1, -6, 1, 0)
            rows[op.label] = { btn = b, mark = mark }
            b.MouseButton1Click:Connect(function()
                if multi then sel[op.label] = not sel[op.label]; paint(); emit(h, o, value())
                else h._cur = op.label; h._val = op.value; paint(); list.Visible = false; tweenE(arrow, 0.3, { Rotation = 0 }, ESt.Back); emit(h, o, op.value) end
            end)
        end
        local n = math.min(#options, 6)
        scroll.Size = UDim2.new(1, 0, 0, n * 26)
        paint()
    end
    search:GetPropertyChangedSignal("Text"):Connect(function()
        local q = string.lower(search.Text)
        for lab, r in pairs(rows) do r.btn.Visible = q == "" or string.find(string.lower(lab), q, 1, true) ~= nil end
    end)
    header.MouseButton1Click:Connect(function()
        press(row, 0.98); ripple(row)
        list.Visible = not list.Visible
        tweenE(arrow, 0.35, { Rotation = list.Visible and 180 or 0 }, ESt.Back)
        if list.Visible then
            local i = 0
            for _, r in pairs(rows) do
                i = i + 1
                r.btn.TextTransparency = 1
                task.delay(0.02 * math.min(i, 10), function() if r.btn.Parent then tweenE(r.btn, 0.25, { TextTransparency = 0 }) end end)
            end
        end
    end)
    local function applyDefault(d)
        sel = {}; h._cur, h._val = nil, nil
        if multi then
            if type(d) == "table" then for k, v in pairs(d) do if v == true and type(k) == "string" then sel[k] = true elseif type(v) == "string" then sel[v] = true end end end
        else
            if type(d) == "number" and options[d] then d = options[d].label end
            for _, op in ipairs(options) do if d ~= nil and (op.label == tostring(d) or op.value == d) then h._cur, h._val = op.label, op.value end end
        end
    end
    function h.Set(me, d, silent)
        applyDefault(d); paint()
        if not silent then emit(me, o, value()) else for _, f in ipairs(me._subs) do pcall(f, value()) end end
    end
    function h.SetOptions(me, opts, d, silent)
        options = normOptions(opts)
        if d ~= nil then applyDefault(d) else
            local keep = {}
            for _, op in ipairs(options) do if sel[op.label] or h._cur == op.label then keep[#keep + 1] = op.label end end
            if multi then sel = {}; for _, k in ipairs(keep) do sel[k] = true end elseif #keep == 0 then h._cur, h._val = nil, nil end
        end
        rebuild()
    end
    function h.GetList(me) local t = {}; for k, v in pairs(sel) do if v then t[#t + 1] = k end end; return t end
    applyDefault(o.Default)
    rebuild()
    register(sec, o.Name, h)
    return finish(h, o, row, value())
end
function Section.CreateDropdown(self, o) return dropdown(self, o, false) end
function Section.CreateMultiDropdown(self, o) return dropdown(self, o, true) end
Section.CreateActionDropdown = Section.CreateDropdown
Section.CreateActionMultiDropdown = Section.CreateMultiDropdown

function Section.CreateInput(self, o)
    o = o or {}
    local row = makeRow(self, o, 36, 150)
    local tb = new("TextBox", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), Size = UDim2.fromOffset(140, 22), Text = tostring(o.Default or ""), PlaceholderText = o.Placeholder or "", ClearTextOnFocus = false, Font = Enum.Font.Gotham, TextSize = 11 }, row)
    B(tb, "BackgroundColor3", "Surface2"); B(tb, "TextColor3", "Text"); B(tb, "PlaceholderColor3", "Sub"); corner(tb, 5)
    local h = newHandle("Input", o.Name, tb.Text)
    function h.Set(me, t, silent)
        t = tostring(t or ""); if o.MaxLength then t = string.sub(t, 1, o.MaxLength) end
        tb.Text = t; me.Value = t
        if not silent then emit(me, o, t) end
    end
    tb.FocusLost:Connect(function() h:Set(tb.Text) end)
    register(self, o.Name, h)
    h.Row = row
    if tb.Text ~= "" and Lib.FireDefaults ~= false then task.defer(function() emit(h, o, tb.Text) end) end
    return h
end

function Section.CreateText(self, o)
    o = o or {}
    local row = makeRow(self, { Name = o.Name, SubOf = o.SubOf, ShowWhen = o.ShowWhen }, 30, 160)
    local v = label(row, tostring(o.Text or ""), 11, "Sub", Enum.Font.Gotham, Enum.TextXAlignment.Right)
    v.AnchorPoint = Vector2.new(1, 0); v.Position = UDim2.new(1, -10, 0, 0); v.Size = UDim2.new(0, 190, 1, 0)
    local h = newHandle("Text", o.Name, o.Text)
    function h.Set(me, t) t = tostring(t or ""); me.Value = t; v.Text = t end
    h.SetText = h.Set
    h.Row = row
    return h
end
function Section.CreateLabel(self, o)
    if type(o) == "string" then o = { Name = o, Text = "" } end
    o = o or {}
    return Section.CreateText(self, { Name = o.Name or o.Text or "", Text = o.Name and o.Text or "" })
end
function Section.CreateCanvas() return Stub, Stub end

-- ===== Tab / Window =====
local Tab = {}
Tab.__index = function(t, k) return rawget(Tab, k) or Common[k] or (upper(k) and Stub or nil) end
function Tab.CreateSection(self, o)
    o = o or {}
    local win = self._win
    local frame = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = self._sn }, self.Page)
    self._sn = self._sn + 1
    new("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }, frame)
    local expanded = o.Expanded ~= false
    local head = new("TextButton", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), Text = "", LayoutOrder = 0, AutoButtonColor = false }, frame)
    local hl = label(head, string.upper(tostring(o.Name or "")), 10, "Sub", Enum.Font.GothamBold)
    hl.Position = UDim2.fromOffset(4, 0); hl.Size = UDim2.new(1, -24, 1, 0)
    local ar = label(head, "▾", 11, "Sub", Enum.Font.GothamBold, Enum.TextXAlignment.Right)
    ar.Size = UDim2.new(1, -8, 1, 0)
    ar.AnchorPoint = Vector2.new(0, 0)
    ar.Rotation = expanded and 0 or -90
    local body = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 1, Visible = expanded }, frame)
    new("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Right }, body)
    head.MouseButton1Click:Connect(function()
        body.Visible = not body.Visible
        tweenE(ar, 0.35, { Rotation = body.Visible and 0 or -90 }, ESt.Back)
        tweenE(hl, 0.2, { TextTransparency = 0.5 }); task.delay(0.2, function() tweenE(hl, 0.3, { TextTransparency = 0 }) end)
        if body.Visible then popIn(body, 12) end
    end)
    return setmetatable({ _n = 0, Body = body, _win = win, _path = self.Name .. "/" .. tostring(o.Name or "") }, Section)
end
for _, k in ipairs({ "CreateToggle", "CreateButton", "CreateSlider", "CreateDropdown", "CreateMultiDropdown", "CreateActionDropdown", "CreateActionMultiDropdown", "CreateInput", "CreateText", "CreateLabel", "CreateCanvas" }) do
    Tab[k] = function(self, o, ...)
        if not self._def then self._def = Tab.CreateSection(self, { Name = "General" }) end
        return Section[k](self._def, o, ...)
    end
end

local Window = {}
Window.__index = function(t, k) return rawget(Window, k) or Common[k] or (upper(k) and Stub or nil) end
function Window.CreateTab(self, o)
    o = type(o) == "string" and { Name = o } or o or {}
    local nm = tostring(o.Name or "Tab")
    if self._tabByName[nm] then return self._tabByName[nm] end
    local order = (o.Side == "Right" and 1000 or 0) + #self.Tabs
    local btn = new("TextButton", { Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, Text = tostring(o.DisplayName or nm), Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, LayoutOrder = order }, self._side)
    corner(btn, 6); new("UIPadding", { PaddingLeft = UDim.new(0, 10) }, btn)
    local bar = new("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, -8, 0.5, 0), Size = UDim2.fromOffset(3, 0), BorderSizePixel = 0 }, btn)
    B(bar, "BackgroundColor3", "Accent"); roundFull(bar)
    btn.MouseEnter:Connect(function() if self.SelectedTab and self.SelectedTab.Button ~= btn then tweenE(btn, 0.15, { BackgroundTransparency = 0.6 }); btn.BackgroundColor3 = Theme.Surface2 end end)
    btn.MouseLeave:Connect(function() if self.SelectedTab and self.SelectedTab.Button ~= btn then tweenE(btn, 0.2, { BackgroundTransparency = 1 }) end end)
    local page = new("ScrollingFrame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 2, BorderSizePixel = 0, Visible = false }, self._content)
    new("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder }, page)
    new("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 10) }, page)
    local t = setmetatable({ Name = nm, Button = btn, Page = page, Bar = bar, _win = self, _sn = 0 }, Tab)
    btn.MouseButton1Click:Connect(function() press(btn, 0.94); self:SelectTab(t) end)
    self.Tabs[#self.Tabs + 1] = t
    self._tabByName[nm] = t
    return t
end
function Window.GetDefaultTab(self) return self.DefaultTab end
function Window.SelectTab(self, t)
    if type(t) == "string" then t = self._tabByName[t] end
    if not t then return end
    local prev = self.SelectedTab
    self.SelectedTab = t
    for _, x in ipairs(self.Tabs) do
        local on = x == t
        x.Button.BackgroundColor3 = Theme.Surface2
        tweenE(x.Button, 0.25, { BackgroundTransparency = on and 0.15 or 1, TextColor3 = on and Theme.Text or Theme.Sub })
        if x.Bar then tweenE(x.Bar, 0.4, { Size = UDim2.fromOffset(3, on and 14 or 0) }, ESt.Back) end
        if on then
            if prev ~= t then
                x.Page.Position = UDim2.fromOffset(22, 0)
                x.Page.Visible = true
                tweenE(x.Page, 0.4, { Position = UDim2.fromOffset(0, 0) }, ESt.Quint)
                popIn(x.Page, 14)
            else
                x.Page.Visible = true
            end
        else
            x.Page.Visible = false
        end
    end
end
function Window.Toggle(self, v)
    if v == nil then v = not self.Main.Visible end
    self.Main.Visible = v
end
function Window.Destroy(self) pcall(function() self._gui:Destroy() end) end

function Lib.CreateWindow(self, o)
    o = o or {}
    pcall(function() for _, p in ipairs({ guiParent(), CoreGui }) do local old = p:FindFirstChild("ChuppyUI"); if old then old:Destroy() end end end)
    local gui = new("ScreenGui", { Name = "ChuppyUI", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling }, nil)
    pcall(function() gui:SetAttribute("ChuppyLibraryOwned", true) end)
    local okp = pcall(function() gui.Parent = guiParent() end)
    if not okp then gui.Parent = LP:WaitForChild("PlayerGui") end
    pcall(function() ((getgenv and getgenv()) or _G).ChuppyScreenGui = gui end)
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
    local W, H = math.min(470, vp.X - 24), math.min(300, vp.Y - 48)
    local main = new("Frame", { Name = "MainWindow", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(W, H), Visible = false, ClipsDescendants = true }, gui)
    B(main, "BackgroundColor3", "Bg"); corner(main, 12); strokeOf(main)
    local scale = new("UIScale", { Scale = 1 }, main)
    local bgImg = new("ImageLabel", { Name = "MikuBg", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ScaleType = Enum.ScaleType.Crop, ZIndex = -2, Visible = false, Image = "" }, main)
    corner(bgImg, 12)
    local bgShade = new("Frame", { Name = "MikuShade", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.5, BorderSizePixel = 0, ZIndex = -1, Visible = false }, main)
    corner(bgShade, 12)
    Lib.RegisterBg(bgImg, bgShade)
    local top = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 38) }, main)
    local logo = new("Frame", { Position = UDim2.fromOffset(10, 8), Size = UDim2.fromOffset(22, 22) }, top)
    B(logo, "BackgroundColor3", "Surface2"); corner(logo, 11)
    local lt = label(logo, "C", 12, "Text", Enum.Font.GothamBold, Enum.TextXAlignment.Center); lt.Size = UDim2.fromScale(1, 1)
    Lib.ApplyLogo(logo, lt, 11)
    local ttl = label(top, tostring(o.Name or Lib.Title), 12, "Text", Enum.Font.GothamBold)
    ttl.Position = UDim2.fromOffset(38, 5); ttl.Size = UDim2.fromOffset(120, 15)
    local sub = label(top, Lib.Subtitle, 9, "Sub", Enum.Font.Gotham)
    sub.Position = UDim2.fromOffset(38, 20); sub.Size = UDim2.fromOffset(120, 11)
    local ver = new("TextLabel", { Position = UDim2.fromOffset(112, 7), Size = UDim2.fromOffset(34, 14), Text = Lib.Version, Font = Enum.Font.GothamBold, TextSize = 9 }, top)
    B(ver, "BackgroundColor3", "Surface2"); B(ver, "TextColor3", "Sub"); corner(ver, 7)
    ttl.Size = UDim2.fromOffset(72, 15)
    local function iconBtn(txt, xoff)
        local b = new("TextButton", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, xoff, 0.5, 0), Size = UDim2.fromOffset(26, 26), BackgroundTransparency = 1, Text = txt, Font = Enum.Font.GothamBold, TextSize = 14, AutoButtonColor = false }, top)
        B(b, "TextColor3", "Sub")
        b.MouseEnter:Connect(function() tweenE(b, 0.15, { TextColor3 = Theme.Text }); tweenE(scaleOf(b), 0.25, { Scale = 1.25 }, ESt.Back) end)
        b.MouseLeave:Connect(function() tweenE(b, 0.2, { TextColor3 = Theme.Sub }); tweenE(scaleOf(b), 0.25, { Scale = 1 }, ESt.Back) end)
        b.MouseButton1Click:Connect(function() press(b, 0.8) end)
        return b
    end
    local bClose, bMin, bSet, bSearch = iconBtn("×", -8), iconBtn("–", -34), iconBtn("⚙", -60), iconBtn("⌕", -86)
    local sbox = new("TextBox", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -116, 0.5, 0), Size = UDim2.fromOffset(110, 22), Text = "", PlaceholderText = "Search...", ClearTextOnFocus = false, Font = Enum.Font.Gotham, TextSize = 11, Visible = false }, top)
    B(sbox, "BackgroundColor3", "Surface"); B(sbox, "TextColor3", "Text"); B(sbox, "PlaceholderColor3", "Sub"); corner(sbox, 6)
    local line = new("Frame", { Position = UDim2.fromOffset(0, 38), Size = UDim2.new(1, 0, 0, 1), BorderSizePixel = 0 }, main); B(line, "BackgroundColor3", "Stroke")
    local side = new("Frame", { Position = UDim2.fromOffset(0, 39), Size = UDim2.new(0, 92, 1, -39), BackgroundTransparency = 1 }, main)
    local list = new("ScrollingFrame", { BackgroundTransparency = 1, Position = UDim2.fromOffset(6, 6), Size = UDim2.new(1, -12, 1, -50), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 0, BorderSizePixel = 0 }, side)
    new("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, list)
    local ucard = new("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 6, 1, -6), Size = UDim2.new(1, -12, 0, 32), BackgroundTransparency = 1 }, side)
    local av = new("Frame", { Position = UDim2.fromOffset(0, 5), Size = UDim2.fromOffset(22, 22) }, ucard); B(av, "BackgroundColor3", "Surface2"); corner(av, 11)
    local avi = new("ImageLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }, av); corner(avi, 11)
    task.spawn(function() pcall(function() avi.Image = Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48) end) end)
    local un = label(ucard, LP.Name, 10, "Sub", Enum.Font.Gotham); un.Position = UDim2.fromOffset(28, 0); un.Size = UDim2.new(1, -28, 1, 0)
    local vline = new("Frame", { Position = UDim2.fromOffset(92, 39), Size = UDim2.new(0, 1, 1, -39), BorderSizePixel = 0 }, main); B(vline, "BackgroundColor3", "Stroke")
    local content = new("Frame", { Position = UDim2.fromOffset(93, 39), Size = UDim2.new(1, -93, 1, -39), BackgroundTransparency = 1 }, main)
    ToastHolder = new("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 10, 1, -70), Size = UDim2.fromOffset(210, 200), BackgroundTransparency = 1 }, gui)
    new("UIListLayout", { Padding = UDim.new(0, 4), VerticalAlignment = Enum.VerticalAlignment.Bottom }, ToastHolder)
    -- pill thu nhỏ
    local pill = new("TextButton", { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 8), Size = UDim2.fromOffset(150, 30), Text = "", AutoButtonColor = false }, gui)
    B(pill, "BackgroundColor3", "Bg"); corner(pill, 15); strokeOf(pill)
    local pl = label(pill, "", 10, "Text", Enum.Font.GothamBold); pl.Position = UDim2.fromOffset(34, 3); pl.Size = UDim2.new(1, -40, 0, 13); pl.Text = tostring(o.Name or Lib.Title)
    local ps = label(pill, "Tap to show", 9, "Sub", Enum.Font.Gotham); ps.Position = UDim2.fromOffset(34, 16); ps.Size = UDim2.new(1, -40, 0, 11)
    local pc = new("Frame", { Position = UDim2.fromOffset(8, 5), Size = UDim2.fromOffset(20, 20) }, pill); B(pc, "BackgroundColor3", "Surface2"); corner(pc, 10)
    local pcl = label(pc, "C", 11, "Text", Enum.Font.GothamBold, Enum.TextXAlignment.Center); pcl.Size = UDim2.fromScale(1, 1)
    Lib.ApplyLogo(pc, pcl, 10)
    local win = setmetatable({ Name = tostring(o.Name or Lib.Title), SelectedTab = false, DefaultTab = false, Tabs = {}, _tabByName = {}, States = {}, _gui = gui, Main = main, _side = list, _content = content, _scale = scale, ExclusiveGroups = {} }, Window)
    win._win = win
    local shownToken = 0
    local function setShown(v)
        shownToken = shownToken + 1
        local tk = shownToken
        ps.Text = v and "Tap to hide" or "Tap to show"
        if v then
            main.Size = UDim2.fromOffset(W * 0.88, H * 0.88)
            main.Visible = true
            tweenE(main, 0.5, { Size = UDim2.fromOffset(W, H) }, ESt.Back)
            popIn((win.SelectedTab and win.SelectedTab.Page) or content, 12)
        else
            tweenE(main, 0.2, { Size = UDim2.fromOffset(W * 0.9, H * 0.9) }, ESt.Quad, Enum.EasingDirection.In)
            task.delay(0.2, function() if tk == shownToken then main.Visible = false; main.Size = UDim2.fromOffset(W, H) end end)
        end
        press(pill, 0.9)
    end
    win.Show = setShown
    local moved = false
    pill.MouseEnter:Connect(function() tweenE(scaleOf(pill), 0.25, { Scale = 1.06 }, ESt.Back) end)
    pill.MouseLeave:Connect(function() tweenE(scaleOf(pill), 0.25, { Scale = 1 }, ESt.Back) end)
    pill.MouseButton1Click:Connect(function() if not moved then setShown(not main.Visible) end end)
    do
        local d, st, ps0 = false, nil, nil
        pill.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                d, moved, st, ps0 = true, false, i.Position, pill.Position
                i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then d = false end end)
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local dl = i.Position - st
                if dl.Magnitude > 6 then moved = true end
                if moved then pill.Position = UDim2.new(ps0.X.Scale, ps0.X.Offset + dl.X, ps0.Y.Scale, ps0.Y.Offset + dl.Y) end
            end
        end)
    end
    bClose.MouseButton1Click:Connect(function() setShown(false) end)
    bMin.MouseButton1Click:Connect(function() setShown(false) end)
    bSet.MouseButton1Click:Connect(function() win:SelectTab(win._settingsName or "Settings") end)
    bSearch.MouseButton1Click:Connect(function() sbox.Visible = not sbox.Visible; if sbox.Visible then sbox:CaptureFocus() else sbox.Text = "" end end)
    sbox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = string.lower(sbox.Text)
        local t = win.SelectedTab
        if not t then return end
        for _, d in ipairs(t.Page:GetDescendants()) do
            local info = rowInfos[d]
            if info then if q == "" then info.refresh() else d.Visible = string.find(info.name, q, 1, true) ~= nil end end
        end
    end)
    drag(top, main)
    UIS.InputBegan:Connect(function(i, gp) if not gp and i.KeyCode == Enum.KeyCode.RightControl then setShown(not main.Visible) end end)
    if o.DefaultTab ~= false then win.DefaultTab = win:CreateTab({ Name = tostring(o.DefaultTab or "Main") }) end
    Lib.Window = win
    return win
end

-- ===== Finalize: Settings + Config + Splash =====
local function hexOf(c) return string.format("#%02X%02X%02X", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5)) end
function Lib.Finalize(self, o)
    if self ~= Lib and o == nil then o = self end
    o = o or {}
    local win = o.Window or Lib.Window
    local fs = type(isfile) == "function" and type(writefile) == "function" and type(readfile) == "function"
    local path = "ChuppyHub/SAE_config.json"
    local function save()
        if not fs then return end
        local data = { _theme = {} }
        for k, v in pairs(Theme) do data._theme[k] = hexOf(v) end
        for _, r in ipairs(Registry) do
            local v = r.h.Value
            if r.h.Kind == "MultiDropdown" then v = r.h:GetList() end
            if r.h.Kind ~= "Button" and (type(v) == "boolean" or type(v) == "number" or type(v) == "string" or type(v) == "table") then data[r.key] = v end
        end
        pcall(function() if type(makefolder) == "function" and type(isfolder) == "function" and not isfolder("ChuppyHub") then makefolder("ChuppyHub") end end)
        writefile(path, HS:JSONEncode(data))
    end
    Lib._saver = save
    local function load()
        if not fs or not isfile(path) then return false end
        local ok, data = pcall(function() return HS:JSONDecode(readfile(path)) end)
        if not ok or type(data) ~= "table" then return false end
        cfg.loading = true
        if type(data._theme) == "table" then
            for k, v in pairs(data._theme) do if Theme[k] and type(v) == "string" then pcall(function() Theme[k] = Color3.fromHex(v) end) end end
            applyTheme()
        end
        for _, r in ipairs(Registry) do
            local v = data[r.key]
            if v ~= nil and r.h.Kind ~= "Button" then pcall(function() r.h:Set(v) end) end
        end
        task.delay(1.5, function() cfg.loading = false end)
        return true
    end
    -- Settings
    if o.NoConfig then cfg.AutoSave = false; cfg.AutoLoad = false end
    win._settingsName = o.SettingsName or "Settings"
    local st = win:CreateTab({ Name = win._settingsName, Side = "Right" })
    local s1 = st:CreateSection({ Name = "Interface" })
    s1:CreateToggle({ Name = "Notifications", Note = "Show toast notifications", Default = true, Callback = function(v) cfg.Notifs = v end })
    local openOnLaunch = s1:CreateToggle({ Name = "Open On Launch", Note = "Open the menu automatically", Default = true })
    s1:CreateSlider({ Name = "UI Scale", Min = 0.7, Max = 1.3, Increment = 0.05, Default = 1, AllowDecimals = true, Callback = function(v) win._scale.Scale = v end })
    s1:CreateSlider({ Name = "Transparency", Min = 0, Max = 0.6, Increment = 0.05, Default = 0, AllowDecimals = true, Callback = function(v) win.Main.BackgroundTransparency = v end })
    local sb = st:CreateSection({ Name = "Background" })
    sb:CreateInput({ Name = "Image URL", Placeholder = "ID hoặc link ảnh", Default = (Lib.Pref.img ~= "" and Lib.Pref.img) or Lib.ImageUrl, Callback = function(t) if t ~= Lib.Pref.img then Lib.SetImage(t) end end })
    sb:CreateToggle({ Name = "Show Background", Note = "Hình nền Miku phía sau menu", Default = Lib.Pref.bgOn, Callback = function(v) Lib.SetBgOn(v) end })
    sb:CreateSlider({ Name = "Background Dim", Min = 0.3, Max = 0.97, Increment = 0.01, Default = Lib.Pref.bgAlpha, AllowDecimals = true, Callback = function(v) Lib.SetBgAlpha(v) end })
    local s2 = st:CreateSection({ Name = "Colors" })
    local names = {}
    for k in pairs(Presets) do names[#names + 1] = k end
    table.sort(names)
    local hexInputs = {}
    s2:CreateDropdown({ Name = "Theme Preset", Options = names, Default = "Dark", Callback = function(v)
        local p = Presets[v]
        if p then for k, c in pairs(p) do Theme[k] = c end; applyTheme(); for k, i in pairs(hexInputs) do i:Set(hexOf(Theme[k]), true) end end
    end })
    for _, k in ipairs({ "Accent", "Bg", "Surface", "Text" }) do
        hexInputs[k] = s2:CreateInput({ Name = k == "Bg" and "Background" or k, Placeholder = "#RRGGBB", Default = hexOf(Theme[k]), MaxLength = 7, Callback = function(t)
            local ok, c = pcall(Color3.fromHex, t)
            if ok and c then Theme[k] = c; if k == "Surface" then Theme.Surface2 = Color3.new(math.min(c.R + 0.05, 1), math.min(c.G + 0.05, 1), math.min(c.B + 0.05, 1)) end; applyTheme() end
        end })
    end
    local s3 = st:CreateSection({ Name = "Config" })
    s3:CreateToggle({ Name = "Auto Save Config", Default = true, Callback = function(v) cfg.AutoSave = v end })
    s3:CreateToggle({ Name = "Auto Load Config", Default = true, Callback = function(v) cfg.AutoLoad = v end })
    s3:CreateButton({ Name = "Save Config", ButtonText = "Save", ConfirmText = "Saved", Callback = function() pcall(save) end })
    s3:CreateButton({ Name = "Load Config", ButtonText = "Load", ConfirmText = "Loaded", Callback = function() load() end })
    s3:CreateButton({ Name = "Destroy UI", ButtonText = "Close", Callback = function() win:Destroy() end })
    restylers[#restylers + 1] = function() if win.SelectedTab then win:SelectTab(win.SelectedTab) end end
    if o.NoConfig then pcall(function() s3.Body.Parent:Destroy() end) end
    win:SelectTab(o.MainTab or win.SelectedTab or win.DefaultTab or win.Tabs[1])
    task.delay(0.6, function() if cfg.AutoLoad then load() end end)
    -- Splash
    local overlay = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.5, ZIndex = 50 }, win._gui)
    local card = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(280, 206), ZIndex = 51 }, overlay)
    B(card, "BackgroundColor3", "Bg"); corner(card, 14); strokeOf(card)
    local wp = new("Frame", { Position = UDim2.fromOffset(12, 10), Size = UDim2.new(1, -24, 0, 22), ZIndex = 52 }, card); B(wp, "BackgroundColor3", "Surface"); corner(wp, 11)
    local wl = label(wp, "Welcome back, " .. LP.Name, 10, "Sub", Enum.Font.Gotham); wl.Position = UDim2.fromOffset(10, 0); wl.Size = UDim2.new(1, -16, 1, 0); wl.ZIndex = 53
    local lg = new("Frame", { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 42), Size = UDim2.fromOffset(46, 46), ZIndex = 52 }, card); B(lg, "BackgroundColor3", "Surface"); corner(lg, 23); strokeOf(lg)
    local lgl = label(lg, "C", 20, "Text", Enum.Font.GothamBold, Enum.TextXAlignment.Center); lgl.Size = UDim2.fromScale(1, 1); lgl.ZIndex = 53
    Lib.ApplyLogo(lg, lgl, 23)
    local nm = label(card, tostring(win.Name), 16, "Text", Enum.Font.GothamBold, Enum.TextXAlignment.Center); nm.Position = UDim2.fromOffset(0, 94); nm.Size = UDim2.new(1, 0, 0, 20); nm.ZIndex = 52
    local sb = label(card, string.upper(Lib.Subtitle), 9, "Sub", Enum.Font.Gotham, Enum.TextXAlignment.Center); sb.Position = UDim2.fromOffset(0, 114); sb.Size = UDim2.new(1, 0, 0, 12); sb.ZIndex = 52
    local pt = label(card, "Loading...", 10, "Sub", Enum.Font.Gotham); pt.Position = UDim2.fromOffset(14, 138); pt.Size = UDim2.new(1, -70, 0, 12); pt.ZIndex = 52
    local pp = label(card, "0%", 10, "Sub", Enum.Font.Gotham, Enum.TextXAlignment.Right); pp.Position = UDim2.new(1, -54, 0, 138); pp.Size = UDim2.fromOffset(40, 12); pp.ZIndex = 52
    local pb = new("Frame", { Position = UDim2.fromOffset(14, 154), Size = UDim2.new(1, -28, 0, 3), ZIndex = 52 }, card); B(pb, "BackgroundColor3", "Surface2"); corner(pb, 2)
    local pf = new("Frame", { Size = UDim2.fromScale(0, 1), ZIndex = 53 }, pb); B(pf, "BackgroundColor3", "Accent"); corner(pf, 2)
    local cont = new("TextButton", { Position = UDim2.fromOffset(14, 172), Size = UDim2.fromOffset(80, 24), BackgroundTransparency = 1, Text = "Continue →", Font = Enum.Font.Gotham, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 52 }, card); B(cont, "TextColor3", "Sub")
    local jd = new("TextButton", { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 0, 170), Size = UDim2.fromOffset(120, 26), BackgroundColor3 = Color3.new(1, 1, 1), Text = "Join Discord ↗", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Color3.new(0, 0, 0), AutoButtonColor = true, ZIndex = 52 }, card); corner(jd, 7)
    jd.MouseButton1Click:Connect(function()
        pcall(function() (setclipboard or toclipboard)(Lib.Discord) end)
        jd.Text = "Link copied!"; task.delay(1.5, function() if jd.Parent then jd.Text = "Join Discord ↗" end end)
    end)
    local done = false
    local function finishSplash()
        if done then return end
        done = true
        overlay:Destroy()
        local show = true
        pcall(function() show = openOnLaunch.Value ~= false end)
        win.Show(show)
    end
    cont.MouseButton1Click:Connect(finishSplash)
    task.spawn(function()
        local total = 4
        for s = total, 1, -1 do
            if done then return end
            pt.Text = "Ready — opening in " .. s .. "s"
            local pct = (total - s + 1) / total
            tween(pf, 0.9, { Size = UDim2.fromScale(pct, 1) }); pp.Text = math.floor(pct * 100) .. "%"
            task.wait(1)
        end
        finishSplash()
    end)
    return win
end

Lib.Theme = Theme
Lib.ApplyTheme = applyTheme
return Lib
end)()
Core.FireDefaults = false

local function wrap(h)
    if type(h) ~= "table" then return h end
    local out = {}
    local function bindm(name)
        return function(a, ...)
            if a == out or a == h then return h[name](h, ...) end
            return h[name](h, a, ...)
        end
    end
    setmetatable(out, { __index = function(_, k)
        if k == "Instance" then return h.Row end
        if k == "Handle" then return h end
        local v = h[k]
        if type(v) == "function" then return bindm(k) end
        return v
    end })
    out.SetText = bindm("Set")
    out.GetText = bindm("Get")
    return out
end
local function cb2(cfg, cb) return cb or (type(cfg) == "table" and cfg.Callback) or nil end

local SecA = {}
SecA.__index = SecA
function SecA:AddToggle(cfg, cb)
    cfg = cfg or {}
    local d = clean(cfg.Desc or "")
    return wrap(self._s:CreateToggle({ Name = clean(cfg.Name or "Toggle"), Note = d ~= "" and d or nil, Default = cfg.Default and true or false, Callback = cb2(cfg, cb) }))
end
function SecA:AddButton(cfg, cb)
    cfg = cfg or {}
    local d = clean(cfg.Desc or "")
    local fn = cb2(cfg, cb)
    return wrap(self._s:CreateButton({ Name = clean(cfg.Name or "Button"), Note = d ~= "" and d or nil, ButtonText = d ~= "" and (cfg.ButtonText or "Run") or cfg.ButtonText, Callback = function() if fn then fn() end end }))
end
function SecA:AddSlider(cfg, cb)
    cfg = cfg or {}
    local step = cfg.Step or 1
    local unit = string.gsub(tostring(cfg.Suffix or ""), "^%s+", "")
    return wrap(self._s:CreateSlider({ Name = clean(cfg.Name or "Slider"), Min = cfg.Min or 0, Max = cfg.Max or 100, Default = cfg.Default, Increment = step, AllowDecimals = step < 1, Unit = unit ~= "" and unit or nil, Callback = cb2(cfg, cb) }))
end
function SecA:AddDropdown(cfg, cb)
    cfg = cfg or {}
    local d = clean(cfg.Desc or "")
    return wrap(self._s:CreateDropdown({ Name = clean(cfg.Name or "Dropdown"), Note = d ~= "" and d or nil, Options = cfg.Options or cfg.List or {}, Default = cfg.Default, Callback = cb2(cfg, cb) }))
end
function SecA:AddInput(cfg, cb)
    cfg = cfg or {}
    return wrap(self._s:CreateInput({ Name = clean(cfg.Name or "Input"), Placeholder = cfg.Placeholder or "", Default = cfg.Default, Callback = cb2(cfg, cb) }))
end
function SecA:AddLabel(cfg)
    if type(cfg) == "string" then cfg = { Text = cfg } end
    cfg = cfg or {}
    local sec = self._s
    sec._n = sec._n + 1
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 0)
    l.AutomaticSize = Enum.AutomaticSize.Y
    l.BackgroundTransparency = 1
    l.Text = clean(cfg.Text or cfg.Title or "")
    l.Font = cfg.Bold and Enum.Font.GothamBold or Enum.Font.Gotham
    l.TextSize = cfg.Size or 11
    l.TextColor3 = cfg.Color or Core.Theme.Sub
    l.TextWrapped = true
    l.TextXAlignment = cfg.Center and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
    l.LayoutOrder = sec._n
    local pd = Instance.new("UIPadding"); pd.PaddingLeft = UDim.new(0, 6); pd.PaddingRight = UDim.new(0, 6); pd.PaddingTop = UDim.new(0, 2); pd.PaddingBottom = UDim.new(0, 2); pd.Parent = l
    l.Parent = sec.Body
    return { SetText = function(a, b) local t = (a == nil or type(a) == "table") and b or a; l.Text = clean(t) end, GetText = function() return l.Text end, Instance = l }
end
function SecA:AddDivider()
    local sec = self._s
    sec._n = sec._n + 1
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 1); f.BorderSizePixel = 0; f.BackgroundColor3 = Core.Theme.Stroke; f.LayoutOrder = sec._n
    f.Parent = sec.Body
end

local TabA = {}
TabA.__index = TabA
function TabA:CreateSection(cfg)
    cfg = type(cfg) == "string" and { Name = cfg } or cfg or {}
    return setmetatable({ _s = self._t:CreateSection({ Name = clean(cfg.Name or ""), Expanded = not cfg.Collapsed }) }, SecA)
end
for _, k in ipairs({ "AddToggle", "AddButton", "AddSlider", "AddDropdown", "AddInput", "AddLabel", "AddDivider" }) do
    TabA[k] = function(self, ...)
        if not self._def then self._def = self:CreateSection({ Name = "General" }) end
        return self._def[k](self._def, ...)
    end
end

local UILibrary = {}
UILibrary.__index = UILibrary
function UILibrary.GetPresets() local t = {} for _, p in ipairs(Presets) do t[#t + 1] = p.name end return t end
function UILibrary.SetTheme(name)
    for _, p in ipairs(Presets) do
        if p.name == name then
            Theme.Accent, Theme.Accent2 = p.c1, p.c2
            Core.Theme.Accent = p.c1
            pcall(Core.ApplyTheme)
            return true
        end
    end
    return false
end
function UILibrary:CreateWindow(cfg)
    cfg = cfg or {}
    Core.Title = clean(cfg.Title or "Chuppy Hub")
    Core.Subtitle = clean(cfg.SubTitle or "Blox Fruits")
    local win = Core:CreateWindow({ Name = Core.Title, DefaultTab = false })
    local W = setmetatable({ _w = win, tabs = {} }, UILibrary)
    task.delay(2, function()
        pcall(function() Core:Finalize({ Window = win, NoConfig = true, SettingsName = "UI" }) end)
    end)
    return W
end
function UILibrary:MakeTab(cfg)
    local name = clean(type(cfg) == "table" and cfg.Name or cfg or "Tab")
    local t = self._w:CreateTab({ Name = name })
    local tab = setmetatable({ _t = t }, TabA)
    self.tabs[name] = tab
    return tab
end
function UILibrary:SelectTab(name) self._w:SelectTab(clean(name)) end
function UILibrary:Show(v) self._w.Show(v) end

genv.ChuppyUI = UILibrary
print("  CHUPPY UI (menu Egg) LOADED")
end)

if not okNew then
    warn("[Chuppy Hub] Menu moi loi, dung menu cu: " .. tostring(errNew))
    pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Chuppy Hub: menu moi loi", Text = string.sub(tostring(errNew), 1, 180), Duration = 12 }) end)
    ;(function()


local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local RunService   = game:GetService("RunService")
local CoreGui      = game:GetService("CoreGui")
local LP           = Players.LocalPlayer

-- ═══ THEME ═══
local Theme = {
    Accent = Color3.fromRGB(225, 45, 65), Accent2 = Color3.fromRGB(170, 28, 48),
    Background = Color3.fromRGB(18, 18, 21), Surface = Color3.fromRGB(24, 24, 28),
    Surface2 = Color3.fromRGB(31, 31, 36), Surface3 = Color3.fromRGB(44, 44, 50),
    Text = Color3.fromRGB(236, 236, 242), TextDim = Color3.fromRGB(138, 138, 150),
    Border = Color3.fromRGB(46, 46, 54),
    Success = Color3.fromRGB(70, 210, 120), Warning = Color3.fromRGB(250, 185, 45),
    Danger = Color3.fromRGB(240, 70, 85), Info = Color3.fromRGB(90, 165, 250),
    FontRegular = Enum.Font.Gotham, FontBold = Enum.Font.GothamBold, FontBlack = Enum.Font.GothamBlack,
}
local function P(name, r, g, b)
    return { name = name, c1 = Color3.fromRGB(r, g, b), c2 = Color3.fromRGB(math.floor(r * 0.74), math.floor(g * 0.74), math.floor(b * 0.74)) }
end
local Presets = {
    P("Redz Red", 225, 45, 65), P("Banana Yellow", 250, 204, 21), P("Quantum Violet", 139, 92, 246),
    P("Cyber Cyan", 0, 200, 235), P("Neon Green", 70, 220, 120), P("Sunset", 255, 140, 40),
    P("Ice Blue", 100, 180, 255), P("Pink Kawaii", 255, 130, 190), P("Mint", 120, 235, 190), P("Toxic", 170, 240, 20),
}
getgenv().ChuppyTheme = Theme

-- bỏ emoji / ký hiệu hình trong mọi chữ hiển thị
local function clean(s)
    s = tostring(s == nil and "" or s)
    local ok, out = pcall(function()
        local t = {}
        for _, cp in utf8.codes(s) do
            local drop = cp >= 0x1F000 or (cp >= 0x2600 and cp <= 0x27BF) or (cp >= 0x2B00 and cp <= 0x2BFF)
                or (cp >= 0x2300 and cp <= 0x23FF) or cp == 0xFE0F or cp == 0x200D or cp == 0x20E3 or cp == 0x2139
            if not drop then t[#t + 1] = utf8.char(cp) end
        end
        return table.concat(t)
    end)
    if not ok then out = s end
    out = string.gsub(out, "^%s+", "")
    out = string.gsub(out, "%s+$", "")
    return out
end

local refreshers = {}
local function reg(fn) pcall(fn); refreshers[#refreshers + 1] = fn end

local function mk(cls, props, parent)
    local i = Instance.new(cls)
    for k, v in pairs(props or {}) do pcall(function() i[k] = v end) end
    if parent then i.Parent = parent end
    return i
end
local function corner(p, r) return mk("UICorner", { CornerRadius = UDim.new(0, r or 5) }, p) end
local function round(p) return mk("UICorner", { CornerRadius = UDim.new(1, 0) }, p) end
local function stroke(p, col, th, tr) return mk("UIStroke", { Color = col or Theme.Border, Thickness = th or 1, Transparency = tr or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, p) end
local function pad(p, t, l, r, b) return mk("UIPadding", { PaddingTop = UDim.new(0, t or 0), PaddingLeft = UDim.new(0, l or 0), PaddingRight = UDim.new(0, r or 0), PaddingBottom = UDim.new(0, b or 0) }, p) end
local function list(p, gap) return mk("UIListLayout", { Padding = UDim.new(0, gap or 4), SortOrder = Enum.SortOrder.LayoutOrder }, p) end
local function tw(o, t, props) pcall(function() TweenService:Create(o, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play() end) end

local UILibrary = {}
UILibrary.__index = UILibrary
function UILibrary.GetPresets() local t = {} for _, p in ipairs(Presets) do t[#t + 1] = p.name end return t end
function UILibrary.SetTheme(name)
    for _, p in ipairs(Presets) do
        if p.name == name then
            Theme.Accent, Theme.Accent2 = p.c1, p.c2
            for _, f in ipairs(refreshers) do pcall(f) end
            return true
        end
    end
    return false
end

-- ═══ KẾT NỐI DỌN DẸP ═══
local allConns = {}
local function conn(c) allConns[#allConns + 1] = c; return c end

local function newGui(name, order)
    local gui = mk("ScreenGui", { Name = name .. tostring(math.random(10000, 99999)), ResetOnSpawn = false, IgnoreGuiInset = true,
        DisplayOrder = order or 999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling })
    local ok = pcall(function() gui.Parent = (gethui and gethui()) or CoreGui end)
    if not ok or not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end
    return gui
end

local function drag(handle, target, onClick)
    local dragging, start, startPos, moved = false, nil, nil, false
    conn(handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging, start, startPos, moved = true, i.Position, target.Position, false
            local c; c = i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if not moved and onClick then pcall(onClick) end
                    c:Disconnect()
                end
            end)
        end
    end))
    conn(UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - start
            if d.Magnitude > 6 then moved = true end
            if moved or not onClick then
                target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end
    end))
end

-- ═══ NOTIFICATION ═══
local Notification = {}
local notiGui, notiHolder
local function holder()
    if notiHolder and notiHolder.Parent then return notiHolder end
    local parent = getgenv().ChuppyScreenGui
    if not parent or not parent.Parent then notiGui = newGui("ChuppyNoti_", 1000); parent = notiGui end
    notiHolder = mk("Frame", { Name = "Notis", AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 12),
        Size = UDim2.new(0, 220, 1, -24), BackgroundTransparency = 1, ZIndex = 100 }, parent)
    mk("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Right }, notiHolder)
    return notiHolder
end
local NCOL = { info = "Info", success = "Success", warning = "Warning", danger = "Danger" }
function Notification.Show(cfg)
    cfg = cfg or {}
    local col = Theme[NCOL[string.lower(tostring(cfg.Type or "info"))] or "Info"]
    local dur = cfg.Duration or 3
    local card = mk("Frame", { Size = UDim2.new(0, 220, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Theme.Surface,
        BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 101 }, holder())
    corner(card, 5)
    local st = stroke(card, Theme.Border, 1, 1)
    local bar = mk("Frame", { Size = UDim2.new(0, 2, 1, -8), Position = UDim2.new(0, 4, 0, 4), BackgroundColor3 = col, BorderSizePixel = 0, ZIndex = 102 }, card)
    round(bar)
    local body = mk("Frame", { Size = UDim2.new(1, -16, 0, 0), Position = UDim2.new(0, 12, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 102 }, card)
    list(body, 1); pad(body, 6, 0, 4, 8)
    local t1 = mk("TextLabel", { Size = UDim2.new(1, 0, 0, 13), BackgroundTransparency = 1, Text = clean(cfg.Title), Font = Theme.FontBold,
        TextSize = 11, TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1, ZIndex = 103 }, body)
    local t2 = mk("TextLabel", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
        Text = clean(cfg.Desc), Font = Theme.FontRegular, TextSize = 10, TextColor3 = Theme.TextDim, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1, ZIndex = 103 }, body)
    local prog = mk("Frame", { Size = UDim2.new(1, -10, 0, 1), Position = UDim2.new(0, 5, 1, -2), BackgroundColor3 = col, BorderSizePixel = 0, ZIndex = 103 }, card)
    tw(card, 0.2, { BackgroundTransparency = 0.04 }); tw(st, 0.2, { Transparency = 0.2 })
    tw(t1, 0.2, { TextTransparency = 0 }); tw(t2, 0.2, { TextTransparency = 0 })
    tw(prog, dur, { Size = UDim2.new(0, 0, 0, 1) })
    task.delay(dur, function()
        if not card.Parent then return end
        tw(card, 0.25, { BackgroundTransparency = 1 }); tw(t1, 0.25, { TextTransparency = 1 }); tw(t2, 0.25, { TextTransparency = 1 })
        tw(st, 0.25, { Transparency = 1 }); tw(bar, 0.25, { BackgroundTransparency = 1 }); tw(prog, 0.25, { BackgroundTransparency = 1 })
        task.delay(0.3, function() pcall(function() card:Destroy() end) end)
    end)
end
function Notification.Info(t, d, dur)    return Notification.Show({ Type = "info", Title = t, Desc = d, Duration = dur }) end
function Notification.Success(t, d, dur) return Notification.Show({ Type = "success", Title = t, Desc = d, Duration = dur }) end
function Notification.Warning(t, d, dur) return Notification.Show({ Type = "warning", Title = t, Desc = d, Duration = dur }) end
function Notification.Danger(t, d, dur)  return Notification.Show({ Type = "danger", Title = t, Desc = d, Duration = dur }) end
getgenv().ChuppyNotification = Notification

-- ═══ MODAL ═══
local Modal = {}
local function modalBase(cfg, contentFn)
    local parent = getgenv().ChuppyScreenGui
    if not parent then return end
    local ov = mk("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 200 }, parent)
    tw(ov, 0.2, { BackgroundTransparency = 0.5 })
    local card = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 250, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Theme.Background, BorderSizePixel = 0, ZIndex = 201 }, ov)
    corner(card, 6); stroke(card, Theme.Border, 1, 0)
    local body = mk("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 202 }, card)
    list(body, 8); pad(body, 12, 14, 14, 12)
    mk("TextLabel", { Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, Text = clean(cfg.Title), Font = Theme.FontBold,
        TextSize = 13, TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 203 }, body)
    mk("TextLabel", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Text = clean(cfg.Message),
        Font = Theme.FontRegular, TextSize = 11, TextColor3 = Theme.TextDim, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 203 }, body)
    local close = function() pcall(function() ov:Destroy() end) end
    contentFn(body, close)
    return ov
end
local function mbtn(parent, text, col, order, cb)
    local b = mk("TextButton", { Size = UDim2.new(0.5, -4, 0, 26), BackgroundColor3 = col, Text = clean(text), Font = Theme.FontBold, TextSize = 11,
        TextColor3 = Color3.new(1, 1, 1), AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = order, ZIndex = 204 }, parent)
    corner(b, 5)
    b.MouseButton1Click:Connect(cb)
    return b
end
function Modal.Confirm(cfg)
    cfg = cfg or {}
    modalBase(cfg, function(body, close)
        local row = mk("Frame", { Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, ZIndex = 203 }, body)
        mk("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, row)
        mbtn(row, cfg.YesText or "Đồng ý", cfg.YesColor or Theme.Accent, 1, function() close(); if cfg.OnYes then pcall(cfg.OnYes) end end)
        mbtn(row, cfg.NoText or "Huỷ", Theme.Surface3, 2, function() close(); if cfg.OnNo then pcall(cfg.OnNo) end end)
    end)
end
function Modal.Prompt(cfg)
    cfg = cfg or {}
    modalBase(cfg, function(body, close)
        local box = mk("TextBox", { Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = Theme.Surface2, Text = tostring(cfg.Default or ""),
            PlaceholderText = cfg.Placeholder or "", PlaceholderColor3 = Theme.TextDim, Font = Theme.FontRegular, TextSize = 11, TextColor3 = Theme.Text,
            ClearTextOnFocus = false, BorderSizePixel = 0, ZIndex = 204 }, body)
        corner(box, 5); stroke(box, Theme.Border, 1, 0)
        local row = mk("Frame", { Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, ZIndex = 203 }, body)
        mk("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, row)
        mbtn(row, "OK", Theme.Accent, 1, function() close(); local cb = cfg.OnSubmit or cfg.OnYes; if cb then pcall(cb, box.Text) end end)
        mbtn(row, "Huỷ", Theme.Surface3, 2, close)
    end)
end
getgenv().ChuppyModal = Modal

-- ═══ SECTION + ELEMENTS (kiểu redz) ═══
local Section = {}
Section.__index = Section

local function row(self, h)
    self._n = (self._n or 0) + 1
    local f = mk("Frame", { Size = UDim2.new(1, 0, 0, h), BackgroundColor3 = Theme.Surface2, BorderSizePixel = 0, LayoutOrder = self._n, ZIndex = 12 }, self._body)
    corner(f, 5)
    return f
end
local function txt(parent, text, size, font, color, x, w, y, h)
    return mk("TextLabel", { BackgroundTransparency = 1, Text = clean(text), TextSize = size, Font = font, TextColor3 = color,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Position = UDim2.new(0, x or 10, 0, y or 0),
        Size = w or UDim2.new(1, -20, h and 0 or 1, h or 0), ZIndex = 14 }, parent)
end
local function nameDesc(r, cfg, defName, rightPad)
    local d = clean(cfg.Desc or "")
    local w = UDim2.new(1, -(rightPad or 20), 0, 16)
    if d ~= "" then
        txt(r, cfg.Name or defName, 11, Theme.FontBold, Theme.Text, 10, w, 5, 16)
        txt(r, d, 9, Theme.FontRegular, Theme.TextDim, 10, UDim2.new(1, -(rightPad or 20), 0, 13), 21, 13)
        return true
    end
    txt(r, cfg.Name or defName, 11, Theme.FontBold, Theme.Text, 10, UDim2.new(1, -(rightPad or 20), 1, 0))
    return false
end

function Section:AddToggle(cfg, cb)
    cfg = cfg or {}
    local state = cfg.Default and true or false
    local hasDesc = clean(cfg.Desc or "") ~= ""
    local r = row(self, hasDesc and 40 or 32)
    nameDesc(r, cfg, "Toggle", 62)
    local pill = mk("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.new(0, 34, 0, 16),
        BackgroundColor3 = Theme.Surface3, BorderSizePixel = 0, ZIndex = 14 }, r)
    round(pill)
    local knob = mk("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 2, 0.5, 0), Size = UDim2.new(0, 12, 0, 12),
        BackgroundColor3 = Theme.Text, BorderSizePixel = 0, ZIndex = 15 }, pill)
    round(knob)
    local function apply(anim)
        local t = anim and 0.14 or 0
        tw(pill, t, { BackgroundColor3 = state and Theme.Accent or Theme.Surface3 })
        tw(knob, t, { Position = state and UDim2.new(0, 20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0) })
    end
    apply(false)
    reg(function() apply(false) end)
    local btn = mk("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 16 }, r)
    btn.MouseButton1Click:Connect(function()
        state = not state; apply(true)
        if cb then pcall(cb, state) end
    end)
    return {
        Set = function(v) v = v and true or false; if v ~= state then state = v; apply(true); if cb then pcall(cb, state) end end end,
        Get = function() return state end,
    }
end

function Section:AddButton(cfg, cb)
    cfg = cfg or {}
    local hasDesc = clean(cfg.Desc or "") ~= ""
    local r = row(self, hasDesc and 40 or 32)
    local nameLbl
    if hasDesc then
        nameLbl = txt(r, cfg.Name or "Button", 11, Theme.FontBold, Theme.Text, 10, UDim2.new(1, -34, 0, 16), 5, 16)
        txt(r, cfg.Desc, 9, Theme.FontRegular, Theme.TextDim, 10, UDim2.new(1, -34, 0, 13), 21, 13)
    else
        nameLbl = txt(r, cfg.Name or "Button", 11, Theme.FontBold, Theme.Text, 10, UDim2.new(1, -34, 1, 0))
    end
    if cfg.Color then
        local tag = mk("Frame", { Size = UDim2.new(0, 2, 1, -10), Position = UDim2.new(0, 0, 0, 5), BackgroundColor3 = cfg.Color, BorderSizePixel = 0, ZIndex = 15 }, r)
        round(tag)
    end
    local arrow = mk("TextLabel", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.new(0, 14, 0, 14),
        Text = ">", Font = Theme.FontBold, TextSize = 12, TextColor3 = Theme.TextDim, ZIndex = 14 }, r)
    local b = mk("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 16 }, r)
    b.MouseEnter:Connect(function() tw(r, 0.1, { BackgroundColor3 = Theme.Surface3 }) end)
    b.MouseLeave:Connect(function() tw(r, 0.1, { BackgroundColor3 = Theme.Surface2 }) end)
    b.MouseButton1Click:Connect(function()
        arrow.TextColor3 = Theme.Accent
        task.delay(0.25, function() pcall(function() arrow.TextColor3 = Theme.TextDim end) end)
        if cb then pcall(cb) end
    end)
    return { SetText = function(t) nameLbl.Text = clean(t) end }
end

function Section:AddSlider(cfg, cb)
    cfg = cfg or {}
    local min, max, step = cfg.Min or 0, cfg.Max or 100, cfg.Step or 1
    local val = math.clamp(cfg.Default or min, min, max)
    local suffix = cfg.Suffix or ""
    local r = row(self, 40)
    txt(r, cfg.Name or "Slider", 11, Theme.FontBold, Theme.Text, 10, UDim2.new(1, -90, 0, 16), 4, 16)
    local vl = mk("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(0, 76, 0, 16), Position = UDim2.new(1, -86, 0, 4), Font = Theme.FontBold,
        TextSize = 10, TextXAlignment = Enum.TextXAlignment.Right, TextColor3 = Theme.Accent, ZIndex = 14 }, r)
    reg(function() vl.TextColor3 = Theme.Accent end)
    local track = mk("Frame", { Position = UDim2.new(0, 10, 0, 28), Size = UDim2.new(1, -20, 0, 4), BackgroundColor3 = Theme.Surface3, BorderSizePixel = 0, ZIndex = 14 }, r)
    round(track)
    local fill = mk("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, ZIndex = 15 }, track)
    round(fill)
    reg(function() fill.BackgroundColor3 = Theme.Accent end)
    local knob = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = Theme.Text, BorderSizePixel = 0, ZIndex = 16 }, track)
    round(knob)
    local function fmt(v) if step < 1 then return string.format("%.2f", v) end return tostring(math.floor(v + 0.5)) end
    local function show()
        local a = (val - min) / math.max(max - min, 1e-9)
        fill.Size = UDim2.new(a, 0, 1, 0); knob.Position = UDim2.new(a, 0, 0.5, 0)
        vl.Text = fmt(val) .. suffix
    end
    show()
    local function setFromX(x)
        local a = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
        local v = min + (max - min) * a
        v = math.clamp(math.floor(v / step + 0.5) * step, min, max)
        if v ~= val then val = v; show(); if cb then pcall(cb, val) end end
    end
    local sliding = false
    local hit = mk("TextButton", { Size = UDim2.new(1, 0, 0, 22), Position = UDim2.new(0, 0, 0, 18), BackgroundTransparency = 1, Text = "", ZIndex = 17 }, r)
    hit.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            sliding = true; setFromX(i.Position.X)
            local c; c = i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then sliding = false; c:Disconnect() end end)
        end
    end)
    conn(UIS.InputChanged:Connect(function(i)
        if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then setFromX(i.Position.X) end
    end))
    return {
        Set = function(v) v = math.clamp(v, min, max); if v ~= val then val = v; show(); if cb then pcall(cb, val) end end end,
        Get = function() return val end,
    }
end

function Section:AddDropdown(cfg, cb)
    cfg = cfg or {}
    local opts = cfg.Options or cfg.List or {}
    local val = cfg.Default or opts[1]
    local searchable = cfg.Search or #opts > 10
    self._n = (self._n or 0) + 1
    local r = mk("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Theme.Surface2,
        BorderSizePixel = 0, LayoutOrder = self._n, ZIndex = 12 }, self._body)
    corner(r, 5)
    mk("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }, r)
    local head = mk("TextButton", { Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, Text = "", LayoutOrder = 1, ZIndex = 14 }, r)
    txt(head, cfg.Name or "Dropdown", 11, Theme.FontBold, Theme.Text, 10, UDim2.new(0.5, -10, 1, 0))
    local vlabel = mk("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(0.5, -28, 1, 0), Position = UDim2.new(0.5, 0, 0, 0), Font = Theme.FontBold,
        TextSize = 10, TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd, TextColor3 = Theme.Accent, Text = clean(val or "-"), ZIndex = 14 }, head)
    reg(function() vlabel.TextColor3 = Theme.Accent end)
    local arrow = mk("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(0, 16, 1, 0), Position = UDim2.new(1, -20, 0, 0), Text = "▾",
        Font = Theme.FontBold, TextSize = 11, TextColor3 = Theme.TextDim, ZIndex = 14 }, head)
    local panel = mk("Frame", { Size = UDim2.new(1, -12, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Visible = false, LayoutOrder = 2, ZIndex = 14 }, r)
    list(panel, 3); pad(panel, 0, 6, 0, 6)
    local search
    if searchable then
        search = mk("TextBox", { Size = UDim2.new(1, 0, 0, 22), BackgroundColor3 = Theme.Surface, Text = "", PlaceholderText = "Tìm...", Font = Theme.FontRegular,
            TextSize = 10, TextColor3 = Theme.Text, PlaceholderColor3 = Theme.TextDim, ClearTextOnFocus = false, BorderSizePixel = 0, LayoutOrder = 0, ZIndex = 15 }, panel)
        corner(search, 4)
    end
    local sc = mk("ScrollingFrame", { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
        CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, LayoutOrder = 1, ZIndex = 15 }, panel)
    sc.ScrollBarImageColor3 = Theme.Accent
    local scl = list(sc, 2)
    local open = false
    local items = {}
    local function resize() sc.Size = UDim2.new(1, 0, 0, math.min(scl.AbsoluteContentSize.Y, 120)) end
    local function build(filter)
        for _, it in ipairs(items) do it:Destroy() end
        items = {}
        local f = filter and string.lower(filter) or ""
        for i, o in ipairs(opts) do
            if f == "" or string.find(string.lower(tostring(o)), f, 1, true) then
                local b = mk("TextButton", { Size = UDim2.new(1, -4, 0, 22), BackgroundColor3 = Theme.Surface3, BackgroundTransparency = (o == val) and 0.2 or 0.75,
                    Text = clean(o), Font = Theme.FontRegular, TextSize = 10, TextColor3 = (o == val) and Theme.Accent or Theme.Text, AutoButtonColor = false,
                    BorderSizePixel = 0, LayoutOrder = i, ZIndex = 16 }, sc)
                corner(b, 4)
                items[#items + 1] = b
                b.MouseButton1Click:Connect(function()
                    val = o; vlabel.Text = clean(o); open = false; panel.Visible = false; arrow.Text = "▾"
                    if cb then pcall(cb, val) end
                end)
            end
        end
        task.defer(resize)
    end
    scl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(resize)
    if search then search:GetPropertyChangedSignal("Text"):Connect(function() build(search.Text) end) end
    head.MouseButton1Click:Connect(function()
        open = not open
        panel.Visible = open; arrow.Text = open and "▴" or "▾"
        if open then build(search and search.Text or nil) end
    end)
    return {
        Set = function(v) val = v; vlabel.Text = clean(v); if cb then pcall(cb, v) end end,
        Get = function() return val end,
        SetOptions = function(o, keep) opts = o or {}; if not keep then val = opts[1]; vlabel.Text = clean(val or "-") end; if open then build() end end,
    }
end

function Section:AddInput(cfg, cb)
    cfg = cfg or {}
    local r = row(self, 32)
    txt(r, cfg.Name or "Input", 11, Theme.FontBold, Theme.Text, 10, UDim2.new(0.4, -10, 1, 0))
    local box = mk("TextBox", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), Size = UDim2.new(0.6, -14, 0, 22),
        BackgroundColor3 = Theme.Surface, Text = tostring(cfg.Default or ""), PlaceholderText = cfg.Placeholder or "", PlaceholderColor3 = Theme.TextDim,
        Font = Theme.FontRegular, TextSize = 10, TextColor3 = Theme.Text, ClearTextOnFocus = false, TextTruncate = Enum.TextTruncate.AtEnd, BorderSizePixel = 0, ZIndex = 15 }, r)
    corner(box, 4)
    local s = stroke(box, Theme.Border, 1, 0)
    box.Focused:Connect(function() s.Color = Theme.Accent end)
    box.FocusLost:Connect(function() s.Color = Theme.Border; if cb then pcall(cb, box.Text) end end)
    return { Set = function(t) box.Text = tostring(t) end, Get = function() return box.Text end }
end

function Section:AddLabel(cfg)
    if type(cfg) == "string" then cfg = { Text = cfg } end
    cfg = cfg or {}
    self._n = (self._n or 0) + 1
    local l = mk("TextLabel", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Text = clean(cfg.Text or cfg.Title or ""),
        Font = cfg.Bold and Theme.FontBold or Theme.FontRegular, TextSize = cfg.Size or 10, TextColor3 = cfg.Color or Theme.TextDim, TextWrapped = true,
        TextXAlignment = cfg.Center and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left, LayoutOrder = self._n, ZIndex = 14 }, self._body)
    pad(l, 2, 6, 6, 2)
    return { SetText = function(t) l.Text = clean(t) end, GetText = function() return l.Text end, Instance = l }
end

function Section:AddDivider()
    self._n = (self._n or 0) + 1
    mk("Frame", { Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Theme.Border, BorderSizePixel = 0, LayoutOrder = self._n, ZIndex = 13 }, self._body)
end

-- ═══ TAB ═══
local Tab = {}
Tab.__index = Tab
function Tab:CreateSection(cfg)
    cfg = cfg or {}
    local sec = setmetatable({ _n = 0 }, Section)
    self._n = (self._n or 0) + 1
    local card = mk("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
        BorderSizePixel = 0, LayoutOrder = self._n, ZIndex = 11 }, self._page)
    mk("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4) }, card)
    local head = mk("TextButton", { Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Text = "", LayoutOrder = 1, ZIndex = 12 }, card)
    mk("TextLabel", { BackgroundTransparency = 1, Position = UDim2.new(0, 2, 0, 0), Size = UDim2.new(1, -24, 1, 0), Text = clean(cfg.Name or "Section"),
        Font = Theme.FontBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = Theme.Text, ZIndex = 13 }, head)
    local chev = mk("TextLabel", { BackgroundTransparency = 1, Position = UDim2.new(1, -18, 0, 0), Size = UDim2.new(0, 16, 1, 0), Text = cfg.Collapsed and "▸" or "▾",
        Font = Theme.FontBold, TextSize = 11, TextColor3 = Theme.TextDim, ZIndex = 13 }, head)
    mk("Frame", { Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Theme.Border, BorderSizePixel = 0, LayoutOrder = 2, ZIndex = 12 }, card)
    local body = mk("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Visible = not cfg.Collapsed, LayoutOrder = 3, ZIndex = 12 }, card)
    list(body, 4); pad(body, 2, 0, 0, 6)
    head.MouseButton1Click:Connect(function() body.Visible = not body.Visible; chev.Text = body.Visible and "▾" or "▸" end)
    sec._body = body
    return sec
end

-- ═══ WINDOW ═══
function UILibrary:CreateWindow(cfg)
    cfg = cfg or {}
    local vp = Vector2.new(800, 400)
    pcall(function() vp = workspace.CurrentCamera.ViewportSize end)
    local W = math.floor(math.clamp(cfg.Width or 460, 340, math.max(340, math.min(vp.X - 20, vp.X * 0.62))))
    local H = math.floor(math.clamp(cfg.Height or 280, 210, math.max(210, math.min(vp.Y - 30, vp.Y * 0.74))))
    local sideW = W < 400 and 88 or 108

    local self = setmetatable({ tabs = {}, order = {}, flags = {}, current = nil }, UILibrary)
    local gui = newGui("ChuppyUI_", 999)
    getgenv().ChuppyScreenGui = gui
    self.screenGui = gui
    if notiHolder then pcall(function() notiHolder:Destroy() end); notiHolder = nil end

    local main = mk("Frame", { Name = "MainWindow", Size = UDim2.new(0, W, 0, H), Position = UDim2.new(0.5, -W / 2, 0.5, -H / 2),
        BackgroundColor3 = Theme.Background, BackgroundTransparency = 0.03, BorderSizePixel = 0, ClipsDescendants = true, Active = true, ZIndex = 10 }, gui)
    corner(main, 6); stroke(main, Theme.Border, 1, 0)
    self.mainFrame = main

    -- thanh tiêu đề
    local bar = mk("Frame", { Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = Theme.Surface, BorderSizePixel = 0, ZIndex = 11 }, main)
    mk("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Theme.Border, BorderSizePixel = 0, ZIndex = 12 }, bar)
    local tbox = mk("Frame", { BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -110, 1, 0), ZIndex = 12 }, bar)
    mk("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, tbox)
    mk("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Text = clean(cfg.Title or "CHUPPY HUB"),
        Font = Theme.FontBold, TextSize = 12, TextColor3 = Theme.Text, LayoutOrder = 1, ZIndex = 12 }, tbox)
    mk("TextLabel", { BackgroundTransparency = 1, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Text = clean(cfg.SubTitle or ""),
        Font = Theme.FontRegular, TextSize = 9, TextColor3 = Theme.TextDim, LayoutOrder = 2, ZIndex = 12 }, tbox)
    local fps = mk("TextLabel", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -56, 0, 0), Size = UDim2.new(0, 46, 1, 0), Text = "",
        Font = Theme.FontRegular, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Right, TextColor3 = Theme.TextDim, ZIndex = 12 }, bar)
    local frames, lastT = 0, os.clock()
    conn(RunService.RenderStepped:Connect(function()
        frames = frames + 1
        if os.clock() - lastT >= 1 then fps.Text = frames .. " FPS"; frames = 0; lastT = os.clock() end
    end))

    local function winBtn(text, xoff)
        local b = mk("TextButton", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, xoff, 0.5, 0), Size = UDim2.new(0, 22, 0, 22), BackgroundTransparency = 1,
            Text = text, Font = Theme.FontBold, TextSize = 16, TextColor3 = Theme.TextDim, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 13 }, bar)
        b.MouseEnter:Connect(function() b.TextColor3 = Theme.Text end)
        b.MouseLeave:Connect(function() b.TextColor3 = Theme.TextDim end)
        return b
    end
    local minBtn = winBtn("−", -28)
    local closeBtn = winBtn("×", -4)

    -- nút nổi tròn (như logo redz)
    local float = mk("TextButton", { Name = "Float", Size = UDim2.new(0, 38, 0, 38), Position = UDim2.new(0, 14, 0.5, -19), BackgroundColor3 = Theme.Surface,
        Text = "C", TextSize = 16, Font = Theme.FontBold, TextColor3 = Theme.Text, AutoButtonColor = false, Visible = false, BorderSizePixel = 0, ZIndex = 50 }, gui)
    round(float)
    local fs = stroke(float, Theme.Accent, 1.5, 0)
    reg(function() fs.Color = Theme.Accent end)
    conn(main:GetPropertyChangedSignal("Visible"):Connect(function() float.Visible = not main.Visible end))
    drag(float, float, function() main.Visible = true end)
    minBtn.MouseButton1Click:Connect(function() main.Visible = false end)
    closeBtn.MouseButton1Click:Connect(function()
        Modal.Confirm({ Title = "Thoát Chuppy Hub?", Message = "Hub sẽ được tắt hoàn toàn.", YesText = "Thoát", YesColor = Theme.Danger,
            OnYes = function() if getgenv().ChuppyUnload then getgenv().ChuppyUnload() else gui:Destroy() end end })
    end)
    drag(bar, main)

    local side = mk("ScrollingFrame", { Position = UDim2.new(0, 0, 0, 29), Size = UDim2.new(0, sideW, 1, -29), BackgroundColor3 = Theme.Surface, BackgroundTransparency = 0,
        BorderSizePixel = 0, ScrollBarThickness = 0, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 11 }, main)
    list(side, 2); pad(side, 5, 4, 4, 5)
    mk("Frame", { Position = UDim2.new(0, sideW, 0, 29), Size = UDim2.new(0, 1, 1, -29), BackgroundColor3 = Theme.Border, BorderSizePixel = 0, ZIndex = 12 }, main)
    local content = mk("Frame", { Position = UDim2.new(0, sideW + 5, 0, 33), Size = UDim2.new(1, -sideW - 9, 1, -37), BackgroundTransparency = 1, ZIndex = 11, ClipsDescendants = true }, main)

    self._side, self._content, self._n = side, content, 0
    conn(gui.Destroying:Connect(function()
        for _, c in ipairs(allConns) do pcall(function() c:Disconnect() end) end
        allConns = {}
        refreshers = {}
    end))
    return self
end

function UILibrary:MakeTab(cfg)
    cfg = cfg or {}
    self._n = self._n + 1
    local name = clean(cfg.Name or cfg.Title or ("Tab" .. self._n))
    local btn = mk("TextButton", { Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = Theme.Surface3, BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
        BorderSizePixel = 0, LayoutOrder = self._n, ZIndex = 12 }, self._side)
    corner(btn, 5)
    local pill = mk("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(0, 2, 0, 0), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, ZIndex = 14 }, btn)
    round(pill)
    reg(function() pill.BackgroundColor3 = Theme.Accent end)
    local lb = mk("TextLabel", { BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -12, 1, 0), Text = name, TextSize = 10,
        Font = Theme.FontBold, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, TextColor3 = Theme.TextDim, ZIndex = 13 }, btn)

    local page = mk("ScrollingFrame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2, Visible = false,
        CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 11 }, self._content)
    page.ScrollBarImageColor3 = Theme.Accent
    reg(function() page.ScrollBarImageColor3 = Theme.Accent end)
    list(page, 8); pad(page, 0, 0, 6, 8)

    local tab = setmetatable({ _page = page, _n = 0, name = name, _btn = btn, _pill = pill, _lb = lb }, Tab)
    self.tabs[name] = tab
    self.order[#self.order + 1] = name
    btn.MouseButton1Click:Connect(function() self:SelectTab(name) end)
    if not self.current then self:SelectTab(name) end
    return tab
end

function UILibrary:SelectTab(name)
    name = clean(name)
    local target = self.tabs[name]
    if not target then return end
    self.current = name
    for n, t in pairs(self.tabs) do
        local on = (n == name)
        t._page.Visible = on
        tw(t._pill, 0.15, { Size = UDim2.new(0, 2, 0, on and 14 or 0) })
        tw(t._btn, 0.15, { BackgroundTransparency = on and 0.4 or 1 })
        t._lb.TextColor3 = on and Theme.Text or Theme.TextDim
    end
end

getgenv().ChuppyUI = UILibrary
print("  CHUPPY UI V5 (redz) LOADED")


    end)()
end
end)()

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

local function SafeLoop(fn)
    local thread = task.spawn(function()
        local fails = 0
        while getgenv().Chuppy and State.Running and fails < 200 do
            local ok, err = pcall(fn)
            if ok then return end
            fails = fails + 1
            warn("[Chuppy] Loop error (tự chạy lại):", err)
            task.wait(1)
        end
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
    "BringMob", "BringCount", "MobWait", "Height",
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
    -- (đã bỏ: trả về mẫu quái nằm trong ReplicatedStorage khiến farm tưởng đã thấy quái nên không bay tới spawn)
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
    if not main then return end
    local ch = getgenv().Chuppy
    local w = ch and ch.Window
    if w and w.Show then pcall(function() w:Show(not main.Visible) end) else main.Visible = not main.Visible end
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
Chuppy.SafeLoop     = SafeLoop
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
local SafeLoop     = getgenv().Chuppy.SafeLoop
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

local _liveLbl, _liveT = nil, 0
local function _shown(o)
    local x = o
    while x and x ~= game do
        if x:IsA("GuiObject") and not x.Visible then return false end
        if x:IsA("ScreenGui") then return x.Enabled end
        x = x.Parent
    end
    return true
end
-- tìm nhãn quest THẬT đang hiện bất kỳ đâu trong PlayerGui (khung Main.Quest có thể là bản mẫu cũ)
local function ScanQuestText(_)
    local pg = LP:FindFirstChild("PlayerGui")
    if not pg then return nil end
    if _liveLbl and _liveLbl.Parent and _shown(_liveLbl) then
        local t = string.gsub(_liveLbl.Text or "", "<[^>]->", "")
        local c, n = string.match(t, "%((%d+)%s*/%s*(%d+)%)")
        if c then return t, tonumber(c), tonumber(n) end
    end
    if os.clock() - _liveT < 0.4 then return nil end
    _liveT = os.clock()
    _liveLbl = nil
    for _, d in ipairs(pg:GetDescendants()) do
        if d:IsA("TextLabel") and d.Text ~= "" and string.find(d.Text, "%(%d+%s*/%s*%d+%)") and _shown(d) then
            local t = string.gsub(d.Text, "<[^>]->", "")
            local c, n = string.match(t, "%((%d+)%s*/%s*(%d+)%)")
            if c then _liveLbl = d; getgenv().ChuppyLiveQuestPath = d:GetFullName(); return t, tonumber(c), tonumber(n) end
        end
    end
    return nil
end
getgenv().ChuppyScanQuest = ScanQuestText

local function GetInfoUI()
    local pg = LP:FindFirstChild("PlayerGui")
    local main = pg and pg:FindFirstChild("Main")
    local questUI = main and main:FindFirstChild("Quest")
    
    local fbT, fbC, fbN = ScanQuestText(questUI)
    -- UI.Visible có thể không phản ánh đúng: coi là đang có quest nếu text "(c/n)" còn dở dang
    if not questUI or (not questUI.Visible and not (fbT and fbC < fbN)) then
        return { hasQuest = false, title = "", mob = "" }
    end

    local title, mob = "", ""
    pcall(function()
        local container = questUI:FindFirstChild("Container")
        local qTitle = container and container:FindFirstChild("QuestTitle")
        local tLbl = qTitle and qTitle:FindFirstChild("Title")
        if tLbl then title = tLbl.Text or "" end
        if title == "" or not string.find(title, "%d+%s*/%s*%d+") then
            for _, d in ipairs(questUI:GetDescendants()) do
                if d:IsA("TextLabel") and d.Text and string.find(d.Text, "%d+%s*/%s*%d+") then title = d.Text break end
            end
        end
    end)
    if not questUI.Visible and fbT then title = fbT end
    title = string.gsub(title, "<[^>]->", "")

    if title ~= "" then
        pcall(function()
            local m = string.match(title, "[Dd][Ee][Ff][Ee][Aa][Tt]%s+%d+%s+(.-)%s*%(%d+%s*/%s*%d+%)") or string.match(title, "[Dd][Ee][Ff][Ee][Aa][Tt]%s+%d+%s+(.+)")
            if m then mob = m end
        end)
    end

    return { hasQuest = true, title = title, mob = mob }
end

-- Đọc quest từ GuideModule.Data.QuestData (giống Banana), không phụ thuộc UI Visible
local _guideMod
local function GetGuide()
    if _guideMod == nil then
        local ok, m = pcall(function()
            return require(game:GetService("ReplicatedStorage"):WaitForChild("GuideModule", 5))
        end)
        _guideMod = (ok and m) or false
    end
    return _guideMod or nil
end

function QuestStatus.GetInfo()
    do
        local pg = LP:FindFirstChild("PlayerGui")
        local m = pg and pg:FindFirstChild("Main")
        if m and m:FindFirstChild("Quest") then return GetInfoUI() end
    end
    local g = GetGuide()
    if g and type(g.Data) == "table" then
        local qd = g.Data.QuestData
        if type(qd) == "table" then
            local names = {}
            if type(qd.Task) == "table" then
                for name in pairs(qd.Task) do table.insert(names, tostring(name)) end
            end
            if #names > 0 then
                return { hasQuest = true, title = table.concat(names, " "), mob = names[1] or "" }
            end
        end
    end
    return GetInfoUI()
end

-- tiến độ quest đang làm: trả (đã đánh, cần đánh) hoặc nil nếu không đọc được
function QuestStatus.GetProgress()
    local pg = LP:FindFirstChild("PlayerGui")
    local main = pg and pg:FindFirstChild("Main")
    local qu = main and main:FindFirstChild("Quest")
    if not qu then return nil end
    if not qu.Visible then
        local t, c0, n0 = ScanQuestText(qu)
        if t and c0 < n0 then return c0, n0 end
        return nil
    end
    local txt
    pcall(function() txt = qu.Container.QuestTitle.Title.Text end)
    if type(txt) ~= "string" or not string.find(txt, "%d+%s*/%s*%d+") then
        txt = nil
        for _, d in ipairs(qu:GetDescendants()) do
            if d:IsA("TextLabel") and d.Text and string.find(d.Text, "%d+%s*/%s*%d+") then txt = d.Text break end
        end
    end
    if type(txt) ~= "string" then return nil end
    txt = string.gsub(txt, "<[^>]->", "")
    local c, n = string.match(txt, "(%d+)%s*/%s*(%d+)")
    if c then return tonumber(c), tonumber(n) end
    return nil
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

    -- đang có quest chưa xong: KHÔNG đổi/huỷ; đánh đủ rồi quest tự hoàn thành mới nhận quest mới
    if not info.hasQuest then needSwitch = true end

    if not needSwitch then return false end
    if info.hasQuest then QuestAction.Abandon(); task.wait(0.3) end

    if QuestAction.failUntil and tick() < QuestAction.failUntil then return false end

    local Farm = getgenv().ChuppyFarm
    local qpos = targetQuest.questCF.Position
    local function goNear()
        local h = PlayerUtils.GetHRP()
        if h and (h.Position - qpos).Magnitude <= 8 then return true end
        if Farm and Farm.Teleport then
            local goFn = Farm.TeleportWait or Farm.Teleport
            pcall(goFn, targetQuest.questCF * CFrame.new(0, 4, 2))
        end
        h = PlayerUtils.GetHRP()
        if h and (h.Position - qpos).Magnitude > 12 then
            h.CFrame = targetQuest.questCF * CFrame.new(0, 3, 2)
        end
        task.wait(0.15)
        h = PlayerUtils.GetHRP()
        return h and (h.Position - qpos).Magnitude <= 15
    end

    pcall(function() game:GetService("Players").LocalPlayer:RequestStreamAroundAsync(qpos) end)
    local lastRes
    for i = 1, 6 do
        local near = goNear()
        task.wait(0.3) -- cho server cap nhat vi tri roi moi nhan (nhu Banana)
        lastRes = QuestAction.Start(targetQuest.quest, targetQuest.qlv)
        print("[Chuppy Farm] StartQuest lan " .. i .. ": " .. tostring(targetQuest.quest) .. " #" .. tostring(targetQuest.qlv) .. " | gan NPC=" .. tostring(near) .. " | ket qua=" .. tostring(lastRes))
        task.wait(0.3)
        if QuestStatus.GetInfo().hasQuest then
            QuestAction.lastKey = tostring(targetQuest.quest) .. ":" .. tostring(targetQuest.qlv)
            return true
        end
    end
    warn("[Chuppy Farm] StartQuest that bai: " .. tostring(targetQuest.quest) .. " " .. tostring(targetQuest.qlv) .. " " .. tostring(lastRes) .. " -> tam bo qua quest 20s, danh quai truoc")
    QuestAction.failUntil = tick() + 20
    return false
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
    local EXCL = { "BartiloQuest", "Trainees", "MarineQuest", "CitizenQuest" }
    local origFind, spawnCache = Quest.Find, {}
    local function StripLv(n) return (n:gsub(" %p?Lv%.? %d+%p?", "")) end
    local function MatchSpawn(p, mob, loose)
        if not p:IsA("BasePart") or p:FindFirstChild("Ignored") then return false end
        if p.Name == mob or StripLv(p.Name) == mob then return true end
        return loose and string.find(string.lower(p.Name), string.lower(mob), 1, true) ~= nil
    end
    local missAt = {}
    -- chọn điểm spawn GẦN NPC quest nhất (và <=1500 studs): tránh bay sang đảo/biển khác
    local function SpawnFor(mob, npcPos)
        local c = spawnCache[mob]
        if c and c.Parent then return c end
        if missAt[mob] and tick() - missAt[mob] < 5 then return nil end
        local wo = workspace:FindFirstChild("_WorldOrigin")
        local folder = wo and wo:FindFirstChild("EnemySpawns")
        local nilList
        if getnilinstances then
            local ok, list = pcall(getnilinstances)
            if ok and type(list) == "table" then nilList = list end
        end
        for _, loose in ipairs({ false, true }) do
            local best, bd = nil, math.huge
            local function scan(container)
                for _, p in ipairs(container) do
                    if MatchSpawn(p, mob, loose) then
                        local d = npcPos and (p.Position - npcPos).Magnitude or 0
                        if d < bd then best, bd = p, d end
                    end
                end
            end
            if folder then scan(folder:GetChildren()) end
            if nilList then scan(nilList) end
            if best and (not npcPos or bd <= 1500) then spawnCache[mob] = best; return best end
        end
        missAt[mob] = tick()
        return nil
    end
    local function FindDynamic(level, world)
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
                local sp = SpawnFor(best.mob, best.questCF.Position)
                if sp then
                    best.mobCF = sp.CFrame
                else
                    local e = Quest.FindByMob(best.mob)
                    best.mobCF = (e and e.mobCF) or best.questCF
                end
                return best
            end
        end
        return origFind(level, world)
    end
    -- tất cả điểm spawn của 1 loại quái (để xoay vòng khi điểm đầu không có quái)
    function Quest.SpawnList(mob, npcPos)
        local wo = workspace:FindFirstChild("_WorldOrigin")
        local folder = wo and wo:FindFirstChild("EnemySpawns")
        for _, loose in ipairs({ false, true }) do
            local found = {}
            local function scan(container)
                for _, p in ipairs(container) do
                    if MatchSpawn(p, mob, loose) and (not npcPos or (p.Position - npcPos).Magnitude <= 1500) then found[#found + 1] = p end
                end
            end
            if folder then scan(folder:GetChildren()) end
            if getnilinstances then
                local ok, nl = pcall(getnilinstances)
                if ok and type(nl) == "table" then scan(nl) end
            end
            if #found > 0 then
                if npcPos then table.sort(found, function(x, y) return (x.Position - npcPos).Magnitude < (y.Position - npcPos).Magnitude end) end
                local list = {}
                for _, p in ipairs(found) do list[#list + 1] = p.CFrame end
                return list
            end
        end
        return {}
    end
    local memo
    function Quest.Find(level, world)
        local now = tick()
        if memo and memo.level == level and now - memo.t < 2 then return memo.v end
        local v = FindDynamic(level, world)
        memo = { level = level, t = now, v = v }
        return v
    end
end

local Farm = {}
local currentTween = nil

local FarmRS = game:GetService("RunService")
Farm._target, Farm._speed, Farm._nc = nil, 350, 0
local farmConn = FarmRS.Heartbeat:Connect(function(dt)
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

Track(farmConn)

-- ── v18: SimulationRadius (cả Banana/redz/NaNaONTOP/Night_slayer đều làm) để quái gom được
do
    local simRS = game:GetService("RunService")
    Track(simRS.Heartbeat:Connect(function()
        if State.SimRadius == false then return end
        if type(sethiddenproperty) == "function" then
            pcall(sethiddenproperty, LP, "SimulationRadius", math.huge)
        elseif type(setsimulationradius) == "function" then
            pcall(setsimulationradius, 1e9, 1e9)
        end
    end))
end

-- ── v18: helper quái kiểu Banana (DetectMob / BringMob / Ignored)
do
    local ignore = setmetatable({}, { __mode = "k" })
    local moved  = setmetatable({}, { __mode = "k" })

    function Monster.Ignore(m, secs) if m then ignore[m] = os.clock() + (secs or 20) end end
    function Monster.ClearIgnore() for k in pairs(ignore) do ignore[k] = nil end end
    function Monster.IsIgnored(m) local t = ignore[m]; return t ~= nil and t > os.clock() end

    -- quái sống GẦN NHẤT theo tên (khớp đúng tên trước, rồi mới khớp một phần)
    local function baseName(n) return (string.gsub(n, "%s*%[?%s*Lv%.?%s*%d+%s*%]?", "")) end
    function Monster.NameIs(n, name) return n == name or baseName(n) == name end
    function Monster.FindNearestByName(name)
        local folder = workspace:FindFirstChild("Enemies")
        if not folder or not name then return nil end
        local hrp = PlayerUtils.GetHRP()
        local origin = hrp and hrp.Position or Vector3.zero
        local best, bd = nil, math.huge
        for _, m in ipairs(folder:GetChildren()) do
            local r, h = m:FindFirstChild("HumanoidRootPart"), m:FindFirstChildOfClass("Humanoid")
            if r and h and h.Health > 0 and not Monster.IsIgnored(m) and Monster.NameIs(m.Name, name) then
                local d = (r.Position - origin).Magnitude
                if d < bd then best, bd = m, d end
            end
        end
        return best
    end

    local function Owns(part)
        if type(isnetworkowner) == "function" then
            local ok, r = pcall(isnetworkowner, part)
            if ok then return r end
        end
        local chars = workspace:FindFirstChild("Characters")  -- heuristic của Banana
        if chars then
            for _, o in ipairs(chars:GetChildren()) do
                if o.Name ~= LP.Name then
                    local rr = o:FindFirstChild("HumanoidRootPart")
                    if rr and (rr.Position - part.Position).Magnitude <= 300 then return false end
                end
            end
        end
        return true
    end

    -- Gom quái cùng tên về chỗ con đang đánh. Chỉ gom khi đứng gần (<=60) và quái do mình sở hữu;
    -- quái nào bị server kéo ngược lại (không sở hữu) sẽ bị bỏ qua 10s.
    -- Gom quái cùng tên về MỘT điểm cố định (centerCF, như "Locked/PosMon" của redz) để đứng yên trên đống quái và đánh cả đống.
    -- Chỉ gom quái do mình sở hữu; quái bị server kéo ngược lại sẽ bị bỏ qua 10s.
    function Monster.BringGroup(target, maxCount, centerCF)
        if not target or not target.Parent then return 0 end
        local tr, hrp = target:FindFirstChild("HumanoidRootPart"), PlayerUtils.GetHRP()
        local folder = workspace:FindFirstChild("Enemies")
        if not tr or not hrp or not folder then return 0 end
        if (hrp.Position - tr.Position).Magnitude > 300 then return 0 end
        maxCount = maxCount or State.BringCount or 8
        local radius = maxCount > 2 and 450 or 200
        local center, now, n = centerCF or tr.CFrame, os.clock(), 0
        for _, o in ipairs(folder:GetChildren()) do
            if n >= maxCount then break end
            if (o ~= target or centerCF) and o.Name == target.Name and not Monster.IsIgnored(o) then
                local oh, orr = o:FindFirstChildOfClass("Humanoid"), o:FindFirstChild("HumanoidRootPart")
                if oh and orr and oh.Health > 0 then
                    local mv = moved[o]
                    if mv and now - mv.t > 0.4 and (orr.Position - mv.pos).Magnitude > 15 then
                        moved[o] = nil
                        Monster.Ignore(o, 10)   -- bị kéo ngược: không sở hữu
                    elseif (orr.Position - center.Position).Magnitude <= radius and Owns(orr) then
                        orr.CFrame = CFrame.new(center.Position + Vector3.new(math.random(-2, 2), 0, math.random(-2, 2)))
                        orr.CanCollide = false
                        oh.WalkSpeed = 0; oh.JumpPower = 0
                        if not mv or now - mv.t > 0.4 then moved[o] = { t = now, pos = center.Position } end
                        n = n + 1
                    end
                end
            end
        end
        return n
    end
end

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
    Farm._speed = State.FarmSpeed or speed or 350
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

local lastTrace, lastTraceT = "", 0
local function Trace(msg)
    Farm.Status = msg
    if msg ~= lastTrace or tick() - lastTraceT > 8 then
        lastTrace, lastTraceT = msg, tick()
        print("[Chuppy Farm] " .. msg)
    end
end

local function FarmStep()
    if State.SafeHold then Trace("Safe Mode: chờ hồi máu"); task.wait(0.3); return end
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
    if not quest then Trace("KHÔNG tìm thấy quest cho Lv " .. tostring(level) .. " Sea " .. tostring(world)); task.wait(1); return end
    State.CurrentQuest = quest
    Trace("Quest " .. tostring(quest.quest) .. " #" .. tostring(quest.qlv) .. " | quái: " .. tostring(quest.mob))

    if State.CurrentFarmMode == "Quest" then
        Trace("Kiểm tra/nhận quest...")
        local skipQuest = false
        local qKey = tostring(quest.quest) .. ":" .. tostring(quest.qlv)
        local qi = QuestStatus.GetInfo()
        if qi.hasQuest then
            QuestAction.hadQuest = true
            QuestAction.clearedAt = nil
        elseif QuestAction.hadQuest then
            -- Đọc được "mất quest" lần đầu: UI quest có thể chớp tắt trong tích tắc đúng lúc
            -- hạ gục con cuối (hoặc đang đánh con 7/8) -> không tin ngay, xác nhận lại trong ~1.2s
            QuestAction.clearedAt = QuestAction.clearedAt or tick()
            if tick() - QuestAction.clearedAt < 1.2 then
                task.wait(0.15)
                return -- thử lại ở vòng FarmStep kế tiếp, chưa kết luận vội
            end
            Trace("Xác nhận mất quest sau 1.2s, nhận quest mới")
            QuestAction.hadQuest, QuestAction.clearedAt = false, nil
        end
        if not skipQuest and (qi.hasQuest or not QuestAction.hadQuest) and QuestAction.AutoStart(quest) then return end

        -- đang có quest chưa xong -> luôn đánh đúng quái của quest đó (kể cả khi vừa lên level)
        if qi.hasQuest and qi.mob and qi.mob ~= "" and qi.mob ~= quest.mob then
            local hp0 = PlayerUtils.GetHRP()
            local cf = Quest.SpawnList(qi.mob, hp0 and hp0.Position)[1]
            if not cf then local e = Quest.FindByMob(qi.mob); cf = e and e.mobCF end
            if cf then quest = setmetatable({ mob = qi.mob, mobCF = cf }, { __index = quest }) end
        end

        -- Học từ Banana: đánh DỨT ĐIỂM từng con, bay cạnh quái (7,20,0), gom quái, chưa thấy quái thì bay tới spawn
        Farm._spawnOverride = Farm._spawnOverride or {}
        local ovr = Farm._spawnOverride[quest.mob]
        if ovr then quest.mobCF = ovr end
        local mob = Monster.FindNearestByName(quest.mob)
        if not mob then
            local sp = quest.mobCF
            Trace("Chưa thấy quái, bay tới spawn: " .. tostring(quest.mob))
            local near = false
            repeat
                task.wait()
                Farm.Teleport(sp * CFrame.new(0, 60, 0), 350)
                local h = PlayerUtils.GetHRP()
                -- yêu cầu server tải khu vực quanh spawn từ xa (StreamingEnabled) -> thấy quái mà không cần tới sát
                if os.clock() - (Farm._lastStream or 0) > 1.5 then
                    Farm._lastStream = os.clock()
                    task.spawn(function() pcall(function() game:GetService("Players").LocalPlayer:RequestStreamAroundAsync(sp.Position) end) end)
                end
                near = h and (h.Position - sp.Position).Magnitude <= 120
            until near or Monster.FindNearestByName(quest.mob) or not State.AutoFarm or not PlayerUtils.IsAlive()
            if not Monster.FindNearestByName(quest.mob) then
                -- chưa có quái ở điểm này: chờ tối đa 80s cho quái hồi, hết thì đổi sang điểm spawn khác của cùng loại quái
                local t0 = tick()
                local maxWait = State.MobWait or 80
                local ang = 0
                while tick() - t0 < maxWait and State.AutoFarm and PlayerUtils.IsAlive() and not Monster.FindNearestByName(quest.mob) do
                    Trace("Chờ quái hồi sinh ở điểm spawn: " .. math.ceil(maxWait - (tick() - t0)) .. "s")
                    -- bay vòng quanh điểm spawn/đống quái cũ (như redz) để tải quái và thấy quái hồi sinh
                    ang = ang + 0.2
                    local bp = ((Farm._pile and Farm._pileMob == quest.mob) and Farm._pile or sp).Position
                    Farm.Teleport(CFrame.new(bp + Vector3.new(math.cos(ang) * 50, 35, math.sin(ang) * 50)), 120)
                    task.wait(0.2)
                end
                if not Monster.FindNearestByName(quest.mob) then
                    local list = Quest.SpawnList(quest.mob, quest.questCF and quest.questCF.Position)
                    if #list > 1 then
                        Farm._spawnIdx = ((Farm._spawnIdx or 0) % #list) + 1
                        Farm._spawnOverride[quest.mob] = list[Farm._spawnIdx]
                        Trace("Điểm này chưa có quái, đổi sang điểm spawn " .. Farm._spawnIdx .. "/" .. #list)
                    else
                        warn("[Chuppy Farm] Đã tới spawn nhưng chưa thấy quái: " .. tostring(quest.mob))
                    end
                end
            end
            task.wait(0.2)
            return
        end

        State.CurrentTarget = mob
        do local c2, n2 = QuestStatus.GetProgress(); Trace("Đang đánh: " .. mob.Name .. (c2 and (" | quest " .. c2 .. "/" .. n2) or "")) end
        local h0 = mob:FindFirstChildOfClass("Humanoid")
        local lastHp, tDrop = h0 and h0.Health or 0, os.clock()
        local slowT = 0
        -- điểm khoá (đống quái): giữ nguyên giữa các con để đứng yên, không đuổi theo quái -> hết giật
        local lock = Farm._pile
        do
            local r0 = mob:FindFirstChild("HumanoidRootPart")
            if r0 and not (lock and Farm._pileMob == quest.mob and (r0.Position - lock.Position).Magnitude <= 120) then lock = r0.CFrame end
            Farm._pile, Farm._pileMob = lock, quest.mob
        end
        repeat
            task.wait()
            local root = mob:FindFirstChild("HumanoidRootPart")
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local hrp = PlayerUtils.GetHRP()
            if not root or not hum or hum.Health <= 0 or not hrp then break end

            -- chống kẹt (như "Ignored" của Banana): 15s không mất máu khi đã đứng gần -> bỏ con này
            if hum.Health < lastHp - 0.01 or (hrp.Position - root.Position).Magnitude > 60 then tDrop = os.clock() end
            lastHp = hum.Health
            if os.clock() - tDrop > 15 then
                Monster.Ignore(mob, 20)
                Trace("Con " .. mob.Name .. " không mất máu 15s -> bỏ qua, đổi con khác")
                break
            end

            -- việc nặng (va chạm, equip, haki) chỉ làm 4 lần/giây; gom quái + đánh làm mỗi frame
            local nowc = os.clock()
            if nowc - slowT > 0.25 then
                slowT = nowc
                if (hrp.Position - root.Position).Magnitude <= 50 then
                    for _, p in ipairs(mob:GetDescendants()) do
                        if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
                    end
                end
                Combat.EquipWeapon(State.CurrentWeapon or "Melee")
                if State.AutoHaki then Combat.AutoHaki() end
            end
            if lock and (root.Position - lock.Position).Magnitude > 45 then lock = root.CFrame; Farm._pile = lock end -- quái bị kéo đi xa: đổi điểm khoá
            if State.BringMob ~= false then Monster.BringGroup(mob, nil, lock) end
            Combat.Attack(mob)
            Farm.Teleport(CFrame.new((lock or root.CFrame).Position + Vector3.new(0, State.Height or 25, 0)), 350)
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

SafeLoop(function()
    while State.Running do
        task.wait(0.03)
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
Chuppy.OnUnload = Chuppy.OnUnload or {}
table.insert(Chuppy.OnUnload, function() Farm.StopTween() end)

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
local SafeLoop     = getgenv().Chuppy.SafeLoop
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

SafeLoop(function()
    while State.Running do
        task.wait(0.15)
        if State.AutoFarmBoss and PlayerUtils.IsAlive() then
            local bossName = State.SelectedBoss
            if type(bossName) ~= "string" then bossName = nil end
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

SafeLoop(function()
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

SafeLoop(function()
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

SafeLoop(function()
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

SafeLoop(function()
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

SafeLoop(function()
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
local SafeLoop     = getgenv().Chuppy.SafeLoop
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

SafeLoop(function()
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

SafeLoop(function()
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

SafeLoop(function()
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
            local n = tonumber((loc.Name:gsub("Island ", "")))
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

SafeLoop(function()
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
                    local _h = PlayerUtils.GetHRP(); if _h then Monster.Bring(mob, _h.CFrame * CFrame.new(0, 0, -5)) end
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
    local okF, v = pcall(function() return data.Parent.Parent:GetAttribute("CurrentExploredLevel") end)
    return okF and v or nil
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

SafeLoop(function()
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

SafeLoop(function()
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

SafeLoop(function()
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

SafeLoop(function()
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

SafeLoop(function()
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

SafeLoop(function()
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
local SafeLoop     = getgenv().Chuppy.SafeLoop

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

SafeLoop(function()
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

SafeLoop(function()
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

SafeLoop(function()
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

SafeLoop(function()
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

SafeLoop(function()
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
SafeLoop(function() while State.Running do task.wait(0.5); if State.AutoCyborgQuest and PlayerUtils.IsAlive() then pcall(CyborgQuest.Step) end end end)
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
SafeLoop(function() while State.Running do task.wait(0.5); if State.AutoGhoulQuest and PlayerUtils.IsAlive() then pcall(GhoulQuest.Step) end end end)
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
        local _h = PlayerUtils.GetHRP(); if not _h then return end
        local dist = (_h.Position - npc.HumanoidRootPart.Position).Magnitude
        if dist > 10 then Farm.Teleport(npc.HumanoidRootPart.CFrame * CFrame.new(0, 4, 4), 320)
        else
            if Remote.Invoke("Buy" .. styleName) then Notify("Style", "Đã mua " .. styleName, "success", 5); State.AutoFightingStyle = nil end
        end
    end
end
SafeLoop(function() while State.Running do task.wait(0.5); if State.AutoFightingStyle and PlayerUtils.IsAlive() then pcall(FightingStyles.Step) end end end)
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
        if type(res) == "table" and type(res.Amount) == "number" and res.Amount < 10 then
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
SafeLoop(function() while State.Running do task.wait(0.5); if State.AutoGodhuman and PlayerUtils.IsAlive() then pcall(Godhuman.Step) end end end)
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
local SafeLoop     = getgenv().Chuppy.SafeLoop

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

SafeLoop(function() while State.Running do task.wait(0.5); if State.AutoSaber and PlayerUtils.IsAlive() then pcall(SaberQuest.Step) end end end)
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

SafeLoop(function() while State.Running do task.wait(0.5); if State.AutoYama and PlayerUtils.IsAlive() then pcall(YamaQuest.Step) end end end)
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

SafeLoop(function() while State.Running do task.wait(0.5); if State.AutoTushita and PlayerUtils.IsAlive() then pcall(TushitaQuest.Step) end end end)
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

SafeLoop(function() while State.Running do task.wait(0.5); if State.AutoCDK and PlayerUtils.IsAlive() then pcall(CDKQuest.Step) end end end)
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

SafeLoop(function() while State.Running do task.wait(3); if State.AutoMastery then pcall(MasteryFarm.Step) end end end)
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

SafeLoop(function()
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
local SafeLoop     = getgenv().Chuppy.SafeLoop

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

SafeLoop(function()
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

SafeLoop(function()
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
SafeLoop(function()
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

SafeLoop(function() while State.Running do task.wait(1); if trackerGui and trackerGui.Visible then pcall(Tracker.Refresh) end end end)
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
local SafeLoop     = getgenv().Chuppy.SafeLoop
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
            if hrp and hum and hum.Health > 0 and (not getgenv().ChuppyPVPValid or getgenv().ChuppyPVPValid(plr)) then
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
            if hrp and hum and hum.Health > 0 and (not getgenv().ChuppyPVPValid or getgenv().ChuppyPVPValid(plr)) then
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

SafeLoop(function()
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

SafeLoop(function()
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
        local lastHP = hum.Health
        Track(hum.HealthChanged:Connect(function(newHealth)
            local drop = lastHP - newHealth
            lastHP = newHealth
            if PVP.State.AutoDodgeEnabled and IsAlive() and drop > 50 then StartDodge(0.4) end
        end))
    end
end))

SafeLoop(function()
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

SafeLoop(function()
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

SafeLoop(function()
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

SafeLoop(function()
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
    Title = "CHUPPY HUB",
    SubTitle = "Blox Fruits | Premium",
    Width = 500,
    Height = 300,
})
Chuppy.Window = Window
Chuppy.Tabs = {}

-- ═════════════════════════════════════════════════════════════════════
-- [10.1b] TAB SETTING (đầu menu): tốc độ bay + gom quái + Fast Attack (Part 11 gộp vào đây)
-- ═════════════════════════════════════════════════════════════════════
local TabSet = Window:MakeTab({ Name = "Setting", Icon = "⚙" })
Chuppy.Tabs.Setting = TabSet
if State.FarmSpeed == nil then State.FarmSpeed = 250 end
if State.BringCount == nil then State.BringCount = 8 end
if State.MobWait == nil then State.MobWait = 80 end
local SecFly = TabSet:CreateSection({ Name = "Tốc độ bay (Fly)" })
SecFly:AddSlider({ Name = "Tốc độ bay", Desc = "Bị giật thì kéo xuống (150-250 mượt); muốn nhanh thì kéo lên", Min = 50, Max = 500, Default = math.clamp(State.FarmSpeed, 50, 500), Step = 10, Suffix = " st/s" },
    function(v) State.FarmSpeed = v end)
local SecFarmSet = TabSet:CreateSection({ Name = "Gom quái & chờ quái" })
SecFarmSet:AddSlider({ Name = "Gom quái tối đa", Desc = "Số quái kéo về một chỗ để đánh cùng lúc", Min = 1, Max = 12, Default = math.clamp(State.BringCount, 1, 12), Step = 1 },
    function(v) State.BringCount = v end)
SecFarmSet:AddSlider({ Name = "Chờ quái hồi tối đa", Desc = "Hết quái ở điểm spawn thì đứng chờ, quá giờ mới đổi điểm", Min = 5, Max = 120, Default = math.clamp(State.MobWait, 5, 120), Step = 5, Suffix = " giây" },
    function(v) State.MobWait = v end)

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
SecChar:AddToggle({ Name = "Jump Hack", Default = State.JumpHack or false, Flag = "JumpHack" }, function(v) State.JumpHack = v; if v and Chuppy.Combat then Chuppy.Combat.SetJumpPower(State.JumpPower or 100) end end)
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
SecUI:AddDropdown({ Name = "🎨 Màu giao diện", Options = UILibrary.GetPresets(), Default = "Redz Red", Flag = "ThemeColor" }, function(v) UILibrary.SetTheme(v) end)
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
SecAbout:AddLabel({ Text = "RightShift: Menu | L: Aimbot | End: Dừng farm | Delete: Unload", Color = Theme.Warning })

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
        if not gp and input.KeyCode == Enum.KeyCode.Delete then Unload() end
    end)
end

print("═══════════════════════════════════════════════════════════════════════════════")
print("  🐾 CHUPPY HUB V2 — FULL BUILD HOÀN TẤT")
print("  📦 Total: ~14,500 dòng code chia làm 10 Part an toàn.")
print("  🎮 Hotkeys:")
print("     RightShift → Ẩn/Hiện UI")
print("     L          → Toggle Aimbot")
print("     P          → Clear Aimbot Target")
print("     End        → Dừng tất cả farm | Delete → Unload Hub")
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
local SafeLoop  = Chuppy.SafeLoop
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
    FastAttack = true, FastAttackAlways = false, FastAttackRange = 60, FastAttackMode = "auto",
    FastAttackDelay = 0.08, FastAttackMax = 10,
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
    "ScanRange", "FastAttack", "FastAttackAlways", "FastAttackRange", "FastAttackDelay", "FastAttackMax", "FastAttackMode",
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
local FastAttack = { combo = 0, Why = "-", Good = nil, Using = (getgenv and getgenv().ChuppyGoodMode) or nil }
local RegAttack, RegHit
local NetMod, IdRemote, IdValue
local CombatUtil, FlagsMod
local hitFn, hitFnTry = nil, 0
local lastFire = 0
local animBad, animIdx = false, 0
local hpSeen = setmetatable({}, { __mode = "k" })
local W = { t = 0, last = 0, kills = 0 }

SafeSpawn(function()
    local modules = ReplicatedStorage:WaitForChild("Modules", 15)
    local net = modules and modules:WaitForChild("Net", 15)
    NetMod = net
    if net then
        RegAttack = net:WaitForChild("RE/RegisterAttack", 15)
        RegHit    = net:FindFirstChild("RE/RegisterHit")
        if not RegHit then pcall(function() RegHit = require(net):RemoteEvent("RegisterHit", true) end) end
    end
    if modules then
        pcall(function() CombatUtil = require(modules:WaitForChild("CombatUtil", 5)) end)
        pcall(function() FlagsMod = require(modules:WaitForChild("Flags", 5)) end)
    end
    if not RegAttack or not RegHit then
        warn("[Chuppy FastAttack] Không tìm thấy Net remotes (RegisterAttack/RegisterHit)")
    end
end)

-- Giao thức "Id" như redz: Net.seed + RemoteEvent có attribute "Id"
SafeSpawn(function()
    for _, name in ipairs({ "Util", "Common", "Remotes", "Assets", "FX" }) do
        local f = ReplicatedStorage:FindFirstChild(name)
        if f then
            local function scan(child)
                if child:IsA("RemoteEvent") and child:GetAttribute("Id") then
                    IdRemote, IdValue = child, child:GetAttribute("Id")
                end
            end
            for _, c in ipairs(f:GetChildren()) do scan(c) end
            Track(f.ChildAdded:Connect(scan))
        end
    end
end)

local function ExtraHit(head, list)
    if not (IdRemote and IdValue and NetMod) then return end
    local seedRF = NetMod:FindFirstChild("seed")
    if not seedRF then return end
    local ok, seed = pcall(function() return seedRF:InvokeServer() end)
    if not ok or type(seed) ~= "number" then return end
    local key = math.floor(Workspace:GetServerTimeNow() / 10 % 10) + 1
    local enc = string.gsub("RE/RegisterHit", ".", function(c) return string.char(bit32.bxor(string.byte(c), key)) end)
    local finalId = bit32.bxor(IdValue + 909090, seed * 2)
    pcall(function() IdRemote:FireServer(enc, finalId, head, list) end)
end

-- Hàm gốc của game (như Night_slayer): _G.SendHitsToServer, dùng khi cờ COMBAT_REMOTE_THREAD bật
local function FlagOn() return (FlagsMod and FlagsMod.COMBAT_REMOTE_THREAD) and true or false end
local function GetHitFn()
    if hitFn then return hitFn end
    if os.clock() - hitFnTry < 3 then return nil end
    hitFnTry = os.clock()
    pcall(function()
        local f
        if getsenv then
            local ps = LP:FindFirstChild("PlayerScripts")
            local ls = ps and ps:FindFirstChildOfClass("LocalScript")
            if ls then
                local ok, env = pcall(getsenv, ls)
                local g = ok and env and env._G
                f = g and g.SendHitsToServer
            end
        end
        if not f and getrenv then
            local g = getrenv()._G
            f = g and g.SendHitsToServer
        end
        if type(f) == "function" then hitFn = f end
    end)
    return hitFn
end

local MODES = { "official", "redz", "anim", "plain", "click", "activate" }
local function Avail(m)
    if m == "official" then return RegAttack ~= nil and FlagOn() and GetHitFn() ~= nil end
    if m == "anim" then return RegAttack ~= nil and RegHit ~= nil and CombatUtil ~= nil and not animBad end
    if m == "redz" or m == "plain" then return RegAttack ~= nil and RegHit ~= nil end
    return true
end
local function NextMode(cur)
    local start = (cur and table.find(MODES, cur)) or 0
    for i = 1, #MODES do
        local m = MODES[(start + i - 1) % #MODES + 1]
        if Avail(m) then return m end
    end
    return "click"
end

local HIT_PARTS = { "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart" }
local function PickPart(model)
    for _, name in ipairs(HIT_PARTS) do
        local p = model:FindFirstChild(name)
        if p and p:IsA("BasePart") then return p end
    end
    return nil
end

-- Mục tiêu trong tầm, GẦN NHẤT trước: { {model, part}, ... } hoặc nil
function FastAttack.Collect(range, maxCount, prefer)
    local hrp = Player.GetHRP()
    local folder = Workspace:FindFirstChild("Enemies")
    if not hrp or not folder then return nil end
    local origin, found = hrp.Position, {}
    for _, mob in ipairs(folder:GetChildren()) do
        local root, hum = mob:FindFirstChild("HumanoidRootPart"), mob:FindFirstChildOfClass("Humanoid")
        if root and hum and hum.Health > 0 and not mob:GetAttribute("IsBoat") then
            local d = (root.Position - origin).Magnitude
            if d <= range then
                local okV = true
                if CombatUtil and CombatUtil.IsVulnerable then
                    local ok, v = pcall(CombatUtil.IsVulnerable, CombatUtil, mob)
                    if ok and v == false then okV = false end
                end
                local part = okV and PickPart(mob)
                if part then found[#found + 1] = { mob, part, mob == prefer and -1 or d } end
            end
        end
    end
    if State.FastAttackPlayers then
        local vf = getgenv().ChuppyPVPValid
        for _, plr in ipairs(Players:GetPlayers()) do
            local ch = plr ~= LP and plr.Character
            local root = ch and ch:FindFirstChild("HumanoidRootPart")
            if root and (not vf or vf(plr)) then
                local d = (root.Position - origin).Magnitude
                if d <= range then
                    local part = PickPart(ch)
                    if part then found[#found + 1] = { ch, part, d } end
                end
            end
        end
    end
    if #found == 0 then return nil end
    table.sort(found, function(a, b) return a[3] < b[3] end)
    local out = {}
    for i = 1, math.min(#found, maxCount) do out[i] = { found[i][1], found[i][2] } end
    return out
end

-- M1 trái cây (như Banana UseFruitM1)
local function FruitM1(tool, target)
    local hrp = Player.GetHRP()
    local tr = target and target:FindFirstChild("HumanoidRootPart")
    if not hrp or not tr then return false end
    local tpos = tr.Position
    local diff = tpos - hrp.Position
    local dir = diff.Magnitude > 0.1 and diff.Unit or hrp.CFrame.LookVector
    local lc = tool:FindFirstChild("LeftClickRemote")
    local rf, re = tool:FindFirstChild("RemoteFunction"), tool:FindFirstChild("RemoteEvent")
    if not lc and rf then
        if re then re:FireServer(tpos) end
        task.spawn(function() pcall(function() rf:InvokeServer("TAP") end) end)
        return true
    end
    if lc and tool.Name == "Mammoth-Mammoth" then lc:FireServer(tpos); return true end
    if lc then
        FastAttack.combo = FastAttack.combo % 5 + 1
        lc:FireServer(dir, FastAttack.combo)
        return true
    end
    return false
end

local function Fire(mode, main, list, tool)
    if mode == "official" then
        RegAttack:FireServer(0)
        GetHitFn()(main, list)
        return true
    elseif mode == "anim" then
        local ok, res = pcall(function()
            local char = Player.GetCharacter()
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local cache = hum and CombatUtil:GetMovesetAnimCache(hum)
            if not cache then return false end
            local wname = CombatUtil:GetWeaponName(tool)
            local wdata = CombatUtil:GetWeaponData(wname)
            if not CombatUtil:CanAttack(char, wdata.WeaponType) then return "cd" end
            animIdx = animIdx + 1
            if animIdx > #wdata.Moveset.Basic then animIdx = 1 end
            local track = cache[CombatUtil:GetPureWeaponName(wname) .. "-basic" .. animIdx]
            if not track then return false end
            local sp = track:GetAttribute("SpeedMult") or 1
            RegAttack:FireServer(track.Length / sp)
            local rest = {}
            for i = 2, #list do rest[#rest + 1] = list[i] end
            RegHit:FireServer(list[1][2], rest)
            track:Play(0.1, 1, sp)
            return true
        end)
        if not ok then animBad = true; warn("[Chuppy FastAttack] anim lỗi, tắt cách này:", res); return false end
        return res == true or res == "cd"
    elseif mode == "redz" then
        RegAttack:FireServer(0)
        RegHit:FireServer(main, list, {})
        ExtraHit(main, list)
        return true
    elseif mode == "plain" then
        RegAttack:FireServer(0)
        RegHit:FireServer(main, list)
        return true
    elseif mode == "click" then
        pcall(function() VirtualUser:CaptureController(); VirtualUser:Button1Down(Vector2.new(1280, 672)) end)
        return true
    elseif mode == "activate" then
        pcall(function() tool:Activate() end)
        return true
    end
    return false
end

-- quái có mất máu (hoặc chết) kể từ lần trước không?
local function SawDamage(list)
    local drop = false
    for _, e in ipairs(list) do
        local h = e[1]:FindFirstChildOfClass("Humanoid")
        if h then
            local prev = hpSeen[e[1]]
            if prev and h.Health < prev - 0.01 then drop = true end
            hpSeen[e[1]] = h.Health
        end
    end
    for m, prev in pairs(hpSeen) do
        local h = m.Parent and m:FindFirstChildOfClass("Humanoid")
        if prev > 0 and (not h or h.Health <= 0) then drop = true; hpSeen[m] = nil end
    end
    if State.Stats and State.Stats.MobsKilled ~= W.kills then W.kills = State.Stats.MobsKilled; drop = true end
    return drop
end

function FastAttack.Hit(prefer)
    local char = Player.GetCharacter()
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then FastAttack.Why = "chưa cầm vũ khí (" .. tostring(State.CurrentWeapon) .. ")"; return false end
    local stun = char:FindFirstChild("Stun")
    if stun and stun.Value ~= 0 then FastAttack.Why = "đang bị stun"; return false end

    local range = math.min(State.FastAttackRange or 55, 60)
    local list = FastAttack.Collect(range, State.FastAttackMax or 8, prefer)
    if not list then FastAttack.Why = "không có quái trong tầm"; return false end

    local now = os.clock()
    if now - lastFire < math.max(State.FastAttackDelay or 0.08, 0.05) then return true end
    lastFire = now

    if tool.ToolTip == "Blox Fruit" then
        FastAttack.Why = "Fruit M1"
        return FruitM1(tool, list[1][1])
    end

    local sel = State.FastAttackMode or "auto"
    local mode = FastAttack.Using
    if sel ~= "auto" then
        mode = sel
        if not Avail(mode) then FastAttack.Why = "cách '" .. mode .. "' không khả dụng"; return false end
    elseif not mode or not Avail(mode) then
        mode = NextMode(mode)
    end
    FastAttack.Using = mode

    local ok, res = pcall(Fire, mode, list[1][2], list, tool)
    if not ok then FastAttack.Why = mode .. " lỗi: " .. tostring(res); return false end

    if now - W.last > 1 then W.t = now end
    W.last = now
    if SawDamage(list) then
        W.t = now
        FastAttack.Good = mode
        pcall(function() getgenv().ChuppyGoodMode = mode end)
    elseif sel == "auto" and now - W.t > (FastAttack.Good == mode and 6 or 1.2) then
        local nm = NextMode(mode)
        if nm ~= mode then print("[Chuppy FastAttack] '" .. mode .. "' không làm quái mất máu → thử '" .. nm .. "'") end
        FastAttack.Using = nm
        if FastAttack.Good == mode then FastAttack.Good = nil end
        W.t = now
    end
    FastAttack.Why = mode .. (FastAttack.Good == mode and " ✔" or " …")
    return res and true or false
end

-- Combat.Attack(prefer): farm gọi mỗi frame; KHÔNG còn tool:Activate() khi chưa có quái trong tầm
if Combat then
    local origAttack = Combat.Attack
    Combat.Attack = function(prefer)
        if State.FastAttack then
            local ok, err = pcall(FastAttack.Hit, prefer)
            if not ok then FastAttack.Why = "lỗi: " .. tostring(err) end
            return
        end
        if origAttack then return origAttack() end
    end
end

-- Vòng lặp độc lập: đánh liên tục khi đang farm
SafeLoop(function()
    while State.Running do
        task.wait(math.max(State.FastAttackDelay or 0.08, 0.05))
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

SafeLoop(function()
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
    SafeLoop(function()
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
    SafeLoop(function()
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
    SafeLoop(function()
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

    SafeLoop(function()
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

local SecFA = Sec(Chuppy.Tabs.Setting or TabFast, "Fast Attack")
SecFA:AddToggle({ Name = "Fast Attack", Desc = "Đánh AOE nhanh (Net remote)", Default = State.FastAttack, Flag = "FastAttack" },
    function(v) State.FastAttack = v end)
SecFA:AddToggle({ Name = "Luôn tấn công", Desc = "Kể cả khi không bật farm", Default = State.FastAttackAlways, Flag = "FastAttackAlways" },
    function(v) State.FastAttackAlways = v end)
do
    local LBL = { ["Tự động"] = "auto", ["Hàm gốc game"] = "official", ["Redz (Id)"] = "redz", ["Banana (anim)"] = "anim", ["Plain"] = "plain", ["Click"] = "click", ["Activate"] = "activate" }
    local order, cur = { "Tự động", "Hàm gốc game", "Redz (Id)", "Banana (anim)", "Plain", "Click", "Activate" }, "Tự động"
    for k, v in pairs(LBL) do if v == State.FastAttackMode then cur = k end end
    SecFA:AddDropdown({ Name = "Cách đánh", Desc = "Tự động = tự đổi nếu quái không mất máu", Options = order, Default = cur },
        function(v) State.FastAttackMode = LBL[v] or "auto" end)
end
SecFA:AddSlider({ Name = "Tầm quét quái", Desc = "Đẹp nhất 1000-1500: tải quái từ xa, dừng bay khi còn cách spawn bấy nhiêu", Min = 300, Max = 1500, Default = State.ScanRange or 1000, Step = 50, Suffix = " studs" },
    function(v) State.ScanRange = v end)
SecFA:AddSlider({ Name = "Tầm đánh", Min = 20, Max = 60, Default = math.min(State.FastAttackRange or 55, 60), Step = 5, Suffix = " st" },
    function(v) State.FastAttackRange = v end)
SecFA:AddSlider({ Name = "Delay", Min = 50, Max = 300, Default = math.clamp(math.floor((State.FastAttackDelay or 0.08) * 1000 + 0.5), 50, 300), Step = 10, Suffix = " ms" },
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
    -- Khóa tọa độ NPC Cousin (lấy từ ReplicatedStorage.NPCs dù chưa được tải), bay tới + tải khu vực rồi mới quay
    do
        local npcRS = RSv:FindFirstChild("NPCs")
        local wsNpcs = workspace:FindFirstChild("NPCs")
        local npc = (wsNpcs and wsNpcs:FindFirstChild("Barista Cousin")) or (npcRS and npcRS:FindFirstChild("Barista Cousin"))
        local root = npc and npc:FindFirstChild("HumanoidRootPart")
        local hrp = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root and hrp and (hrp.Position - root.Position).Magnitude > 25 then
            Notify("Random Fruit", "Đang bay tới Cousin...", "info")
            task.spawn(function() pcall(function() game:GetService("Players").LocalPlayer:RequestStreamAroundAsync(root.Position) end) end)
            local farm = getgenv().ChuppyFarm
            if farm and farm.TeleportWait then farm.TeleportWait(root.CFrame * CFrame.new(0, 0, 4), 350, 20) else hrp.CFrame = root.CFrame * CFrame.new(0, 0, 4) end
            task.wait(1)
        end
    end
    local box = "DLCBoxData"
    pcall(function()
        local it = require(RSv.Controllers.BannerClient).TryGetBannerItemIfActiveAsync()
        if it and it.BoxName then box = it.BoxName end
    end)
    local ok, cur, lv, cost = pcall(function() return commF:InvokeServer("Cousin", "Check", box) end)
    if not ok then Notify("Random Fruit", "Lỗi kiểm tra: " .. tostring(cur), "danger") return end
    -- Dùng level thật của người chơi, không tin giá trị thứ 2 mà server trả về
    if type(lv) == "number" and lv < 50 then Notify("Random Fruit", "Cần Level 50 trở lên (hiện " .. tostring(lv) .. ")", "warning") return end
    if type(cur) == "number" and type(cost) == "number" and cur < cost then
        Notify("Random Fruit", "Không đủ tiền/tiền tệ", "warning") return
    end
    local okT, t = pcall(function() return commF:InvokeServer("Cousin", "CheckTime", box) end)
    if not okT or t ~= true then Notify("Random Fruit", "Chưa đủ thời gian: đang cooldown, thử lại sau", "warning") return end
    local okB, r = pcall(function() return commF:InvokeServer("Cousin", box) end)
    if okB and r == 1 then
        Notify("Random Fruit", "Đã quay trái thành công!", "success")
        task.spawn(function()
            local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
            for _ = 1, 40 do
                task.wait(0.2)
                local ok2, vis = pcall(function() return pg.SpinnerWindow.Enabled and pg.SpinnerWindow.AboveSpinner.Navigation.CloseButton.Visible end)
                if ok2 and vis then pcall(function() require(RSv.Controllers.UI.Spinner):Close() end) break end
            end
        end)
    else Notify("Random Fruit", "Quay thất bại (server trả: " .. tostring(r) .. " | Check: " .. tostring(cur) .. ", " .. tostring(lv) .. ", " .. tostring(cost) .. ")", "danger") end
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
local lblFarm  = SecSession:AddLabel("")

SafeLoop(function()
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
            lblFarm.SetText("🧭 Farm: " .. tostring(Farm and Farm.Status or "-") .. "  |  Đánh: " .. tostring(FastAttack.Why or "-"))
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
local Combat = getgenv().ChuppyCombat or C.Combat or {}
local Window = C.Window
if not Window or not State or not Monster then warn("[Chuppy Part 12] thiếu module, bỏ qua"); return end
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
    while task.wait(0.3) and State.Running ~= false do
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
local FRf = RS:WaitForChild("FishReplicated", 5)
local FR = FRf and FRf:WaitForChild("FishingRequest", 5)
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
    while task.wait(0.4) and State.Running ~= false do
        if State.AutoFishing and FR then pcall(function()
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

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐾 PART 13: EXTRA — Bones · Cake Prince · Safe Mode · Auto Skills · Utilities
-- ═══════════════════════════════════════════════════════════════════════════════
;(function()
local Players, RS, RunService = game:GetService("Players"), game:GetService("ReplicatedStorage"), game:GetService("RunService")
local VIM, TeleportService = game:GetService("VirtualInputManager"), game:GetService("TeleportService")
local LP = Players.LocalPlayer
local C = getgenv().Chuppy
if not C or not C.Window or not C.State then warn("[Chuppy Part 13] thiếu core"); return end
local State, Notify, Window = C.State, C.Notify, C.Window
local Remote, Monster, PlayerU = C.Remote, C.Monster, C.Player
local Farm = getgenv().ChuppyFarm or C.Farm
local Combat = getgenv().ChuppyCombat or C.Combat
local QS = getgenv().ChuppyQuestStatus or C.QuestStatus
local SafeLoop = C.SafeLoop

local X = {
    AutoBones = false, AutoCake = false, SafeMode = false, SafeHP = 30, SafeResume = 80,
    AutoSkills = false, SkillDelay = 0.6, SkillOnlyNear = true, SkZ = true, SkX = true, SkC = true, SkV = false, SkF = false,
    NoDmgText = false, DashNoCD = false, JobId = "",
}
getgenv().ChuppyExtra = X

local function HRP() local c = LP.Character; return c and c:FindFirstChild("HumanoidRootPart") end
local function Hum() local c = LP.Character; return c and c:FindFirstChildOfClass("Humanoid") end
local function Alive() local h = Hum(); return h and h.Health > 0 end

-- ═══ [13.1] SAFE MODE (theo % máu) ═══
SafeLoop(function()
    while State.Running do
        task.wait(0.2)
        local h = Hum()
        if X.SafeMode and h and h.MaxHealth > 0 then
            local pct = h.Health / h.MaxHealth * 100
            if not State.SafeHold and pct < X.SafeHP and h.Health > 0 then
                State.SafeHold = true
                Notify("Safe Mode", "Máu thấp - bay lên cao chờ hồi", "warning")
            end
            if State.SafeHold then
                local r = HRP()
                if r and Farm then Farm.Teleport(CFrame.new(r.Position.X, math.max(r.Position.Y, 300), r.Position.Z), 350) end
                if pct >= X.SafeResume or h.Health <= 0 then
                    State.SafeHold = false
                    if Farm then Farm.StopTween() end
                end
            end
        elseif State.SafeHold then
            State.SafeHold = false
        end
    end
end)

-- ═══ [13.2] GRIND CHUNG: BONES + CAKE PRINCE ═══
local function FindAny(names, skip)
    local f = workspace:FindFirstChild("Enemies")
    if not f then return nil end
    for _, m in ipairs(f:GetChildren()) do
        if table.find(names, m.Name) and Monster.IsAlive(m) and m:FindFirstChild("HumanoidRootPart") and m ~= skip then return m end
    end
end

local function Attack(mob, flag)
    local count = 0
    repeat
        task.wait()
        count = count + 1
        if State.SafeHold then return end
        local root, hum, hrp = mob:FindFirstChild("HumanoidRootPart"), mob:FindFirstChildOfClass("Humanoid"), HRP()
        if not root or not hum or hum.Health <= 0 or not hrp then break end
        if (hrp.Position - root.Position).Magnitude <= 50 then
            for _, p in ipairs(mob:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end end
        end
        if State.BringMob ~= false then Monster.BringGroup(mob) end
        Combat.EquipWeapon(State.CurrentWeapon or "Melee")
        if State.AutoHaki then Combat.AutoHaki() end
        Combat.Attack(mob)
        local side = (State.CurrentWeapon == "Blox Fruit") and -7 or 7
        Farm.Teleport(root.CFrame * CFrame.new(side, State.Height or 20, 0), 350)
    until not X[flag] or not Alive() or not Monster.IsAlive(mob)
    if not Monster.IsAlive(mob) then State.Stats.MobsKilled = State.Stats.MobsKilled + 1 end
end

local function Grind(cfg)
    if State.World ~= 3 then X[cfg.flag] = false; Notify(cfg.title, "Chỉ dùng ở Sea 3", "warning"); return end
    local boss = cfg.boss and FindAny({ cfg.boss })
    if boss then State.CurrentTarget = boss; Attack(boss, cfg.flag); return end
    local info = QS and QS.GetInfo and QS.GetInfo() or { hasQuest = true }
    local mob = FindAny(cfg.mobs)
    if mob and info.hasQuest then
        State.CurrentTarget = mob
        Attack(mob, cfg.flag)
        return
    end
    if not info.hasQuest then
        Farm.TeleportWait(cfg.questCF * CFrame.new(0, 4, 2))
        task.wait(1.5)
        local q = cfg.quests[math.random(#cfg.quests)]
        Remote.Invoke("StartQuest", q[1], q[2])
        task.wait(0.8)
        return
    end
    Farm.Teleport(cfg.idleCF, 350)
    task.spawn(function() pcall(function() LP:RequestStreamAroundAsync(cfg.idleCF.Position) end) end)
    task.wait(0.4)
end

local BONES = { flag = "AutoBones", title = "Auto Bones",
    mobs = { "Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy" },
    questCF = CFrame.new(-9516.99316, 172.017181, 6078.46533), idleCF = CFrame.new(-9495.68, 453.59, 5977.35),
    quests = { { "HauntedQuest1", 1 }, { "HauntedQuest1", 2 }, { "HauntedQuest2", 1 }, { "HauntedQuest2", 2 } } }
local CAKE = { flag = "AutoCake", title = "Auto Cake Prince", boss = "Cake Prince",
    mobs = { "Cookie Crafter", "Cake Guard", "Baking Staff", "Head Baker" },
    questCF = CFrame.new(-1927.92, 37.8, -12842.54), idleCF = CFrame.new(-2077, 252, -12373),
    quests = { { "CakeQuest1", 1 }, { "CakeQuest1", 2 }, { "CakeQuest2", 1 }, { "CakeQuest2", 2 } } }

SafeLoop(function()
    while State.Running do
        task.wait(0.2)
        if State.SafeHold or not Alive() then
            task.wait(0.3)
        elseif X.AutoBones then
            local ok, e = pcall(Grind, BONES); if not ok then warn("[Chuppy Bones]", e); task.wait(1) end
        elseif X.AutoCake then
            local ok, e = pcall(Grind, CAKE); if not ok then warn("[Chuppy Cake]", e); task.wait(1) end
        end
    end
end)

-- ═══ [13.3] AUTO SKILLS (Z X C V F) ═══
local KEYS = { { "SkZ", Enum.KeyCode.Z }, { "SkX", Enum.KeyCode.X }, { "SkC", Enum.KeyCode.C }, { "SkV", Enum.KeyCode.V }, { "SkF", Enum.KeyCode.F } }
local function Farming()
    return State.AutoFarm or State.AutoFarmBoss or State.AutoFarmMaterial or X.AutoBones or X.AutoCake or X.AutoBerry or X.AutoDojo or X.AutoDragonHunter
        or State.AutoRaid or State.AutoSeaBeast or State.AutoCDK or State.AutoMastery
end
local function MobNear()
    local r, f = HRP(), workspace:FindFirstChild("Enemies")
    if not r or not f then return false end
    for _, m in ipairs(f:GetChildren()) do
        local mr = m:FindFirstChild("HumanoidRootPart")
        if mr and Monster.IsAlive(m) and (mr.Position - r.Position).Magnitude <= 60 then return true end
    end
    return false
end
SafeLoop(function()
    while State.Running do
        task.wait(math.max(X.SkillDelay, 0.2))
        if X.AutoSkills and Alive() and not State.SafeHold and Farming() and (not X.SkillOnlyNear or MobNear()) then
            for _, k in ipairs(KEYS) do
                if X[k[1]] then
                    pcall(function()
                        VIM:SendKeyEvent(true, k[2], false, game)
                        task.wait(0.06)
                        VIM:SendKeyEvent(false, k[2], false, game)
                    end)
                    task.wait(0.12)
                end
            end
        end
    end
end)

-- ═══ [13.4] TIỆN ÍCH ═══
local function ApplyDmgText(on)
    pcall(function() RS.Assets.GUI.DamageCounter.Enabled = not on end)
end
local function ApplyDash()
    pcall(function()
        if not (getgc and getfenv and getupvalues and setupvalue) then return end
        local dodge = LP.Character and LP.Character:FindFirstChild("Dodge")
        if not dodge then return end
        for _, fn in next, getgc() do
            if typeof(fn) == "function" and getfenv(fn).script == dodge then
                for i, up in next, getupvalues(fn) do
                    if tostring(up) == "0.4" then setupvalue(fn, i, 0) end
                end
            end
        end
    end)
end
C.Track(LP.CharacterAdded:Connect(function()
    task.wait(2)
    if X.DashNoCD then ApplyDash() end
end))

local function JoinJob()
    if X.JobId == "" then Notify("Join Server", "Chưa nhập Job ID", "warning"); return end
    pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, X.JobId, LP) end)
end

-- ═══ [13.4b] AUTO COLLECT BERRY (học từ Banana) ═══
X.AutoBerry, X.BerryHop = false, false
local CollectionSvc = game:GetService("CollectionService")
local function FindBerryBush()
    for _, b in ipairs(CollectionSvc:GetTagged("BerryBush")) do
        for _, v in pairs(b:GetAttributes()) do if v then return b end end
    end
end
SafeLoop(function()
    while getgenv().Chuppy and State.Running do
        task.wait(0.15)
        if X.AutoBerry then pcall(function()
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local bush = FindBerryBush()
            if not bush then
                Notify("Berry", "Chờ Berry xuất hiện...", "info")
                if X.BerryHop and C.Server and C.Server.Hop then C.Server.Hop(); task.wait(5) else task.wait(5) end
                return
            end
            local berry = bush:GetChildren()[1]
            if not berry then
                local pv = bush.Parent and bush.Parent:IsA("Model") and bush.Parent:GetPivot()
                if pv and Farm then Farm.Teleport(pv, 350) end
                return
            end
            local cf = berry:IsA("Model") and berry:GetPivot() or (berry:IsA("BasePart") and berry.CFrame)
            if not cf or not Farm then return end
            Farm.Teleport(cf, 350)
            local pr = berry:FindFirstChildWhichIsA("ProximityPrompt", true)
            if pr and (hrp.Position - cf.Position).Magnitude < 12 and fireproximityprompt then fireproximityprompt(pr) end
        end) end
    end
end)

-- ═══ [13.4c] DOJO TRAINER + DRAGON HUNTER (học từ NhoiiiX) ═══
X.AutoDojo, X.AutoDragonHunter = false, false
local DOJO_TRAINER_CF, DOJO_HOUSE_CF = CFrame.new(5865.02, 1208.32, 871.15), CFrame.new(5813, 1208, 884)
local function NetRF(n)
    local m = RS:FindFirstChild("Modules")
    local nf = m and m:FindFirstChild("Net")
    return nf and nf:FindFirstChild(n)
end
local function InvokeRF(rf, ...)
    if not rf then return nil end
    local a = { ... }
    local ok, r = pcall(function() return rf:InvokeServer(table.unpack(a)) end)
    if ok then return r end
    return nil
end
local function PressKey(k) VIM:SendKeyEvent(true, k, false, game); task.wait(0.05); VIM:SendKeyEvent(false, k, false, game) end

local dojoOwn = { sea = false, elite = false }
local function DojoRelease()
    if dojoOwn.sea then dojoOwn.sea = false; pcall(function() C.ToggleSeaBeast(false) end) end
    if dojoOwn.elite then dojoOwn.elite = false; State.AutoElite = false end
end
local function DojoStep()
    local rf = NetRF("RF/InteractDragonQuest")
    if not rf then X.AutoDojo = false; Notify("Dojo Trainer", "Không thấy remote Dojo (chỉ có ở Sea 3)", "warning"); return end
    local q = InvokeRF(rf, { NPC = "Dojo Trainer", Command = "RequestQuest" })
    local belt = type(q) == "table" and type(q.Quest) == "table" and q.Quest.BeltName or nil
    if not belt then
        DojoRelease()
        Farm.TeleportWait(DOJO_TRAINER_CF); task.wait(1)
        InvokeRF(rf, { NPC = "Dojo Trainer", Command = "ClaimQuest" })
        task.wait(1.5)
        return
    end
    if belt == "White" then
        DojoRelease()
        local m = FindAny({ "Skull Slayer" })
        if m then State.CurrentTarget = m; Attack(m, "AutoDojo") else Farm.Teleport(CFrame.new(-16759.59, 71.28, 1595.34), 350) end
    elseif belt == "Yellow" or belt == "Green" or belt == "Red" then
        if State.AutoElite and dojoOwn.elite then State.AutoElite = false; dojoOwn.elite = false end
        if not State.AutoSeaBeast then dojoOwn.sea = true; pcall(function() C.ToggleSeaBeast(true) end) end
        task.wait(1)
    elseif belt == "Purple" then
        if dojoOwn.sea then dojoOwn.sea = false; pcall(function() C.ToggleSeaBeast(false) end) end
        if not State.AutoElite then dojoOwn.elite = true; State.AutoElite = true end
        task.wait(1)
    else
        DojoRelease()
        Notify("Dojo Trainer", "Đai " .. tostring(belt) .. " chưa hỗ trợ tự động", "warning")
        task.wait(5)
    end
end

local function DragonStep()
    local rf = NetRF("RF/DragonHunter")
    if not rf then X.AutoDragonHunter = false; Notify("Dragon Hunter", "Không thấy remote (chỉ có ở Sea 3)", "warning"); return end
    local d = InvokeRF(rf, { Context = "Check" })
    local text = type(d) == "table" and d.Text and tostring(d.Text) or nil
    if not text then
        local npcs = workspace:FindFirstChild("NPCs")
        local npc = npcs and npcs:FindFirstChild("Dragon Hunter")
        local root = npc and npc:FindFirstChild("HumanoidRootPart")
        Farm.TeleportWait(root and root.CFrame * CFrame.new(0, 0, 4) or DOJO_HOUSE_CF)
        task.wait(1)
        InvokeRF(rf, { Context = "RequestQuest" })
        task.wait(1.5)
        return
    end
    if string.find(text, "Defeat", 1, true) then
        local target
        for _, t in ipairs({ "Hydra Enforcer", "Venomous Assailant" }) do if string.find(text, t, 1, true) then target = t break end end
        if target then
            local m = FindAny({ target })
            if m then State.CurrentTarget = m; Attack(m, "AutoDragonHunter") else Farm.Teleport(CFrame.new(4620.62, 1002.3, 399.09), 350) end
        end
    elseif string.find(text, "Destroy", 1, true) then
        local map = workspace:FindFirstChild("Map")
        local wf = map and map:FindFirstChild("Waterfall")
        local im = wf and wf:FindFirstChild("IslandModel")
        local bamboo = im and im:FindFirstChild("Meshes/bambootree", true)
        if bamboo then
            local bcf = bamboo:IsA("BasePart") and bamboo.CFrame or bamboo:GetPivot()
            Farm.Teleport(bcf * CFrame.new(4, 0, 0), 350)
            local hrp = HRP()
            if hrp and (bcf.Position - hrp.Position).Magnitude <= 200 then
                for _, wt in ipairs({ "Melee", "Sword", "Blox Fruit", "Gun" }) do
                    pcall(Combat.EquipWeapon, wt)
                    task.wait(0.15)
                    PressKey(Enum.KeyCode.Z); PressKey(Enum.KeyCode.X); PressKey(Enum.KeyCode.C)
                    task.wait(0.3)
                end
            end
        else
            Farm.Teleport(DOJO_HOUSE_CF, 350)
        end
    end
end

SafeLoop(function()
    while State.Running do
        task.wait(0.2)
        if State.SafeHold or not Alive() then
            task.wait(0.3)
        elseif X.AutoDojo then
            local ok, e = pcall(DojoStep); if not ok then warn("[Chuppy Dojo]", e); task.wait(1) end
        elseif X.AutoDragonHunter then
            local ok, e = pcall(DragonStep); if not ok then warn("[Chuppy DragonHunter]", e); task.wait(1) end
        end
    end
end)
SafeLoop(function()
    while State.Running do
        task.wait(0.1)
        if X.AutoDragonHunter then pcall(function()
            local et = workspace:FindFirstChild("EmberTemplate")
            local part = et and et:FindFirstChild("Part")
            local hrp = HRP()
            if part and hrp then hrp.CFrame = part.CFrame end
        end) end
    end
end)

-- ═══ [13.5] UI ═══
local Tab = Window:MakeTab({ Name = "Extra", Icon = "✨" })
C.Tabs.Extra = Tab
local function Sec(n, col) return Tab:CreateSection({ Name = n, Collapsed = col or false }) end

local E1 = Sec("Farm Bones / Cake (Sea 3)")
E1:AddToggle({ Name = "Auto Farm Bones", Desc = "Haunted Castle: nhận quest + đánh xương", Default = false, Flag = "AutoBones" },
    function(v) X.AutoBones = v; if v then X.AutoCake = false end; if not v and Farm then Farm.StopTween() end end)
E1:AddToggle({ Name = "Auto Farm Cake Prince", Desc = "Cake Land: farm quái, tự đánh Cake Prince khi xuất hiện", Default = false, Flag = "AutoCake" },
    function(v) X.AutoCake = v; if v then X.AutoBones = false end; if not v and Farm then Farm.StopTween() end end)
E1:AddSlider({ Name = "Số quái gom", Min = 1, Max = 10, Default = State.BringCount or 3, Flag = "BringCount" }, function(v) State.BringCount = v end)

local E1b = Sec("Berry")
E1b:AddToggle({ Name = "Auto Collect Berry", Desc = "Tự bay tới bụi Berry và nhặt", Default = false, Flag = "AutoBerry" },
    function(v) X.AutoBerry = v; if not v and Farm then Farm.StopTween() end end)
E1b:AddToggle({ Name = "Hop khi không có Berry", Default = false, Flag = "BerryHop" }, function(v) X.BerryHop = v end)

local E1c = Sec("Dragon Dojo (Sea 3)")
E1c:AddButton({ Name = "Bay tới Dragon Dojo" }, function()
    Remote.Invoke("requestEntrance", Vector3.new(5661.5322265625, 1013.0907592773, -334.965))
    task.wait(0.5)
    if Farm then Farm.TeleportWait(DOJO_HOUSE_CF) end
end)
E1c:AddToggle({ Name = "Auto Dojo Trainer", Desc = "Làm quest đai: Trắng đánh Skull Slayer, Vàng/Xanh/Đỏ Sea Beast, Tím Elite", Default = false, Flag = "AutoDojo" },
    function(v) X.AutoDojo = v; if v then X.AutoDragonHunter = false else DojoRelease(); if Farm then Farm.StopTween() end end end)
E1c:AddToggle({ Name = "Auto Dragon Hunter", Desc = "Nhận quest, đánh quái/phá tre, nhặt Ember", Default = false, Flag = "AutoDragonHunter" },
    function(v) X.AutoDragonHunter = v; if v then X.AutoDojo = false; DojoRelease() elseif Farm then Farm.StopTween() end end)

local E2 = Sec("Safe Mode")
E2:AddToggle({ Name = "Auto Safe Mode", Desc = "Máu thấp tự bay lên cao, hồi xong tiếp tục farm", Default = false, Flag = "SafeMode" }, function(v) X.SafeMode = v end)
E2:AddSlider({ Name = "Bay lên khi máu dưới", Min = 10, Max = 70, Default = X.SafeHP, Suffix = " %", Flag = "SafeHP" }, function(v) X.SafeHP = v end)
E2:AddSlider({ Name = "Quay lại khi máu trên", Min = 50, Max = 100, Default = X.SafeResume, Suffix = " %", Flag = "SafeResume" }, function(v) X.SafeResume = v end)

local E3 = Sec("Auto Skills")
E3:AddToggle({ Name = "Auto Skills", Desc = "Tự bấm kỹ năng khi đang farm", Default = false, Flag = "AutoSkills" }, function(v) X.AutoSkills = v end)
E3:AddToggle({ Name = "Chỉ khi có quái trong tầm", Default = true, Flag = "SkillOnlyNear" }, function(v) X.SkillOnlyNear = v end)
E3:AddSlider({ Name = "Delay giữa các vòng", Min = 2, Max = 30, Default = 6, Suffix = " ds", Flag = "SkillDelay" }, function(v) X.SkillDelay = v / 10 end)
E3:AddToggle({ Name = "Skill Z", Default = true, Flag = "SkZ" }, function(v) X.SkZ = v end)
E3:AddToggle({ Name = "Skill X", Default = true, Flag = "SkX" }, function(v) X.SkX = v end)
E3:AddToggle({ Name = "Skill C", Default = true, Flag = "SkC" }, function(v) X.SkC = v end)
E3:AddToggle({ Name = "Skill V", Default = false, Flag = "SkV" }, function(v) X.SkV = v end)
E3:AddToggle({ Name = "Skill F", Default = false, Flag = "SkF" }, function(v) X.SkF = v end)

local E4 = Sec("Tiện ích")
E4:AddToggle({ Name = "Ẩn số sát thương", Default = false, Flag = "NoDmgText" }, function(v) X.NoDmgText = v; ApplyDmgText(v) end)
E4:AddToggle({ Name = "Dash không hồi chiêu", Desc = "Cần executor có getgc", Default = false, Flag = "DashNoCD" }, function(v) X.DashNoCD = v; if v then ApplyDash() end end)
E4:AddInput({ Name = "Job ID", Placeholder = "dán Job ID server", Default = "", Flag = "JobId" }, function(v) X.JobId = v or "" end)
E4:AddButton({ Name = "Vào server theo Job ID", Color = C.Theme and C.Theme.Accent or nil }, JoinJob)
E4:AddButton({ Name = "Copy Job ID hiện tại" }, function()
    if setclipboard then setclipboard(game.JobId); Notify("Job ID", "Đã copy", "success") end
end)

print("  ✅ PART 13 — EXTRA LOADED")
end)()

-- ═══ PART 14 — VIP ═══
;(function()
local C = getgenv().Chuppy
if not C or not C.Window or not C.State then return end
local Window, State, Notify = C.Window, C.State, C.Notify
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local V = { AutoRandom = false, RandomGap = 30, Guard = false, GuardRange = 150, GuardSecs = 8 }
getgenv().ChuppyVIP = V

local Tab = Window:MakeTab({ Name = "VIP" })
local function Sec(n) return Tab:CreateSection({ Name = n }) end

local S1 = Sec("Trái ác quỷ")
S1:AddToggle({ Name = "Auto Random Fruit", Desc = "Tự quay trái khi đủ điều kiện, tự đóng bảng quay", Default = false },
    function(v) V.AutoRandom = v end)
S1:AddSlider({ Name = "Thử lại mỗi", Min = 10, Max = 300, Default = 30, Step = 5, Suffix = " giây" }, function(v) V.RandomGap = v end)
S1:AddButton({ Name = "Random Fruit ngay" }, function() if C.RandomFruit then task.spawn(C.RandomFruit) end end)

local S2 = Sec("An toàn")
S2:AddToggle({ Name = "Player Guard", Desc = "Có người lạ ở gần lâu thì tự đổi server", Default = false }, function(v) V.Guard = v end)
S2:AddSlider({ Name = "Khoảng cách", Min = 50, Max = 400, Default = 150, Step = 10, Suffix = " studs" }, function(v) V.GuardRange = v end)
S2:AddSlider({ Name = "Thời gian chờ", Min = 3, Max = 30, Default = 8, Suffix = " giây" }, function(v) V.GuardSecs = v end)

C.SafeLoop(function()
    local lastTry, near = 0, 0
    while getgenv().Chuppy and State.Running do
        task.wait(1)
        if V.AutoRandom and os.clock() - lastTry >= V.RandomGap then
            lastTry = os.clock()
            if C.RandomFruit then pcall(C.RandomFruit) end
        end
        if V.Guard then
            local me = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            local found = false
            if me then
                for _, p in ipairs(Players:GetPlayers()) do
                    local hrp = p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and (hrp.Position - me.Position).Magnitude <= V.GuardRange then found = true break end
                end
            end
            near = found and (near + 1) or 0
            if near >= V.GuardSecs then
                near = 0
                Notify("Player Guard", "Có người ở gần, đang đổi server", "warning")
                if C.Server and C.Server.Hop then pcall(C.Server.Hop) end
            end
        else
            near = 0
        end
    end
end)
end)()

-- ═══ PART 15 — PVP PLUS (học từ Spooky Hub): lọc mục tiêu · CamLock · bám mục tiêu · Awakening V4 · Instant Soru ═══
;(function()
local C = getgenv().Chuppy
if not C or not C.Window or not C.State then return end
local State, Notify = C.State, C.Notify
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

local P = {
    SafeZoneCheck = true, TeamCheck = false, IgnoreLow = false, LowLevel = 2000,
    CamLock = false, CamSmooth = "Smooth", CamPart = "HumanoidRootPart", CamPredict = 0.04,
    Stick = false, StickDist = 3.5,
}
getgenv().ChuppyPVPPlus = P

local function myHRP() local c = LP.Character; return c and c:FindFirstChild("HumanoidRootPart") end

-- ── Lọc mục tiêu: bỏ người trong safe zone / tắt PvP / đồng đội / level thấp
local function inSafeZone(plr)
    local ch = plr.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local hum = ch:FindFirstChildOfClass("Humanoid")
    if hum and hum.Sit then return true end
    if ch:FindFirstChildOfClass("ForceField") then return true end
    if ch:GetAttribute("SafeZone") == true or plr:GetAttribute("SafeZone") == true then return true end
    local wo = workspace:FindFirstChild("_WorldOrigin")
    local zones = wo and wo:FindFirstChild("SafeZones")
    if zones then
        for _, z in ipairs(zones:GetChildren()) do
            if z:IsA("BasePart") then
                local r = math.min(z.Size.X, z.Size.Z) / 2
                local mesh = z:FindFirstChild("Mesh")
                if mesh and mesh:IsA("SpecialMesh") then r = (z.Size.X * mesh.Scale.X) / 2 end
                if r > 500 or r <= 0 then r = 350 end
                if (z.Position - hrp.Position).Magnitude <= r then return true end
            end
        end
    end
    return false
end
local function pvpOff(plr)
    if plr:GetAttribute("PvpDisabled") == true then return true end
    local ch = plr.Character
    return ch ~= nil and (ch:FindFirstChildOfClass("ForceField") ~= nil or ch:GetAttribute("PvpDisabled") == true)
end
local function isEnemy(plr)
    local mt, tt = LP.Team, plr.Team
    if mt and tt and mt.Name == "Marines" and tt.Name == "Marines" then return false end
    return true
end
local function levelOf(plr)
    local d = plr:FindFirstChild("Data")
    local l = d and d:FindFirstChild("Level")
    return l and tonumber(l.Value) or 0
end
function P.Valid(plr, maxDist)
    if not plr or plr == LP then return false end
    local ch = plr.Character
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not (hum and hrp) or hum.Health <= 0 or hrp.Position.Y <= -500 then return false end
    if P.SafeZoneCheck and (inSafeZone(plr) or pvpOff(plr)) then return false end
    if P.TeamCheck and not isEnemy(plr) then return false end
    if P.IgnoreLow then
        local lv = levelOf(plr)
        if lv > 0 and lv < P.LowLevel then return false end
    end
    if maxDist then
        local me = myHRP()
        if not me or (hrp.Position - me.Position).Magnitude > maxDist then return false end
    end
    return true
end
-- Aimbot / Silent Aim / Fast Attack của Chuppy gọi hàm này để bỏ qua mục tiêu không hợp lệ
getgenv().ChuppyPVPValid = function(plr) return P.Valid(plr) end

-- gần tâm màn hình nhất
local function bestTarget(maxDist, exclude)
    local cam = workspace.CurrentCamera
    if not cam then return nil end
    local center = cam.ViewportSize / 2
    local best, bs = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= exclude and P.Valid(plr, maxDist) then
            local hrp = plr.Character.HumanoidRootPart
            local v, on = cam:WorldToViewportPoint(hrp.Position)
            local sc = on and (Vector2.new(v.X, v.Y) - center).Magnitude or (1e5 + (hrp.Position - cam.CFrame.Position).Magnitude)
            if sc < bs then best, bs = plr, sc end
        end
    end
    return best
end

-- ── CamLock: camera khoá vào người chơi, có dự đoán chuyển động
local camTarget, camBound, nextScan = nil, false, 0
local SM = { ["Instant"] = 1, ["Smooth"] = 0.32, ["Very Smooth"] = 0.18 }
local function camStep(dt)
    if not P.CamLock then return end
    local cam = workspace.CurrentCamera
    if not cam then return end
    if not (camTarget and P.Valid(camTarget, 750)) then
        camTarget = nil
        if os.clock() < nextScan then return end
        nextScan = os.clock() + 0.25
        camTarget = bestTarget(750)
        if not camTarget then return end
    end
    local ch = camTarget.Character
    local part = ch and (ch:FindFirstChild(P.CamPart) or ch:FindFirstChild("HumanoidRootPart"))
    if not part then camTarget = nil; return end
    local aim = part.Position + Vector3.new(0, P.CamPart == "Head" and 0.2 or 0.5, 0)
    local vel = part.AssemblyLinearVelocity
    if vel.Magnitude > 2 and vel.Magnitude < 450 then aim = aim + vel * math.clamp(P.CamPredict, 0, 0.15) end
    local pos = cam.CFrame.Position
    if (aim - pos).Magnitude > 1 then
        local sm = SM[P.CamSmooth] or 0.32
        local alpha = 1 - (1 - sm) ^ (math.clamp(dt, 0, 0.1) * 60)
        cam.CFrame = cam.CFrame:Lerp(CFrame.lookAt(pos, aim), alpha)
    end
end
local function setCamLock(v)
    P.CamLock = v and true or false
    camTarget = nil
    if P.CamLock and not camBound then
        camBound = true
        RunService:BindToRenderStep("ChuppyCamLock", Enum.RenderPriority.Camera.Value + 1, function(dt) pcall(camStep, dt) end)
    elseif not P.CamLock and camBound then
        camBound = false
        pcall(function() RunService:UnbindFromRenderStep("ChuppyCamLock") end)
    end
end

-- ── Bám mục tiêu: dịch chuyển ra sau lưng đối thủ và chạy theo
local stickT, stickConn
local function setStick(v)
    P.Stick = v and true or false
    stickT = nil
    if stickConn then stickConn:Disconnect(); stickConn = nil end
    if P.Stick then
        stickConn = RunService.Heartbeat:Connect(function()
            local me = myHRP()
            if not me then return end
            if not (stickT and P.Valid(stickT, 700)) then
                stickT = bestTarget(700)
                if not stickT then return end
            end
            local th = stickT.Character and stickT.Character:FindFirstChild("HumanoidRootPart")
            if not th then return end
            me.CFrame = th.CFrame * CFrame.new(0, 0, P.StickDist)
            me.AssemblyLinearVelocity = th.AssemblyLinearVelocity
        end)
    end
end

-- ── Awakening V4 (Race)
local function awakeningV4(on)
    pcall(function()
        local rem = RS:FindFirstChild("Remotes")
        local commE = rem and rem:FindFirstChild("CommE")
        if commE then commE:FireServer("ActivateAwakening", on ~= false) end
    end)
end

-- ── Instant Soru: lao tới mục tiêu gần nhất (hoặc 110 studs phía trước)
local function instantSoru()
    pcall(function()
        local ch = LP.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local pos
        local t = bestTarget(350)
        local th = t and t.Character and t.Character:FindFirstChild("HumanoidRootPart")
        if th then pos = th.Position end
        if not pos then
            local cam = workspace.CurrentCamera
            pos = hrp.Position + ((cam and cam.CFrame.LookVector or hrp.CFrame.LookVector) * 110)
        end
        pcall(function()
            local rem = RS:FindFirstChild("Remotes")
            local commF = rem and rem:FindFirstChild("CommF_")
            if commF then commF:InvokeServer("Blink", pos) end
        end)
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 1.5, 0))
        hrp.AssemblyLinearVelocity = Vector3.zero
    end)
end

-- ── UI (thêm vào tab PVP có sẵn)
local Tab = C.Tabs and C.Tabs.PVP or C.Window:MakeTab({ Name = "PVP" })
local function Sec(n) return Tab:CreateSection({ Name = n }) end

local S1 = Sec("Lọc mục tiêu (Aimbot / Fast Attack)")
S1:AddToggle({ Name = "Bỏ qua Safe Zone / tắt PvP", Desc = "Không nhắm người đang trong vùng an toàn hoặc có khiên", Default = true }, function(v) P.SafeZoneCheck = v end)
S1:AddToggle({ Name = "Bỏ qua đồng đội (Marines)", Default = false }, function(v) P.TeamCheck = v end)
S1:AddToggle({ Name = "Bỏ qua người level thấp", Default = false }, function(v) P.IgnoreLow = v end)
S1:AddSlider({ Name = "Level tối thiểu", Min = 100, Max = 2850, Default = 2000, Step = 50 }, function(v) P.LowLevel = v end)
S1:AddToggle({ Name = "Fast Attack cả người chơi", Desc = "Đòn đánh nhanh trúng cả người trong tầm (đã lọc theo trên)", Default = State.FastAttackPlayers or false }, function(v) State.FastAttackPlayers = v end)

local S2 = Sec("CamLock")
S2:AddToggle({ Name = "CamLock", Desc = "Camera tự khoá vào người gần tâm màn hình nhất", Default = false }, function(v) setCamLock(v) end)
S2:AddDropdown({ Name = "Độ mượt", Options = { "Instant", "Smooth", "Very Smooth" }, Default = "Smooth" }, function(v) P.CamSmooth = v end)
S2:AddDropdown({ Name = "Bộ phận ngắm", Options = { "HumanoidRootPart", "Head" }, Default = "HumanoidRootPart" }, function(v) P.CamPart = v end)
S2:AddSlider({ Name = "Dự đoán di chuyển", Min = 0, Max = 15, Default = 4, Step = 1, Suffix = " %" }, function(v) P.CamPredict = v / 100 end)
S2:AddButton({ Name = "Đổi mục tiêu CamLock" }, function() camTarget = bestTarget(750, camTarget); nextScan = 0 end)

local S3 = Sec("Bám mục tiêu & kỹ năng")
S3:AddToggle({ Name = "Bám sau lưng mục tiêu", Desc = "Tự chạy theo người gần nhất", Default = false }, function(v) setStick(v) end)
S3:AddSlider({ Name = "Khoảng cách bám", Min = 2, Max = 12, Default = 4, Step = 1, Suffix = " st" }, function(v) P.StickDist = v end)
S3:AddButton({ Name = "Bật Awakening V4" }, function() awakeningV4(true) end)
S3:AddButton({ Name = "Tắt Awakening V4" }, function() awakeningV4(false) end)
S3:AddButton({ Name = "Instant Soru" }, function() instantSoru() end)

if C.OnUnload then
    table.insert(C.OnUnload, function()
        setCamLock(false); setStick(false); getgenv().ChuppyPVPValid = nil
    end)
end
print("  ✅ PART 15 — PVP PLUS LOADED")
end)()

-- ═══ PART 16 — TIẾN TRÌNH (học từ Maru/redz): Auto Sea 2 · Sea 3 · Ăn trái · Awakener ═══
;(function()
local C = getgenv().Chuppy
if not C or not C.Window or not C.State or not C.Tabs or not C.Tabs.Misc then return end
local State, Notify, Farm, Combat = C.State, C.Notify, C.Farm, C.Combat
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local P16 = { Sea2 = false, Sea3 = false, Eat = false, Awaken = false, Fruit = "" }
getgenv().ChuppyProg = P16

local function CommF() local r = RS:FindFirstChild("Remotes"); return r and r:FindFirstChild("CommF_") end
local function inv(...)
    local f = CommF(); if not f then return nil end
    local a = { ... }
    local ok, res = pcall(function() return f:InvokeServer((table.unpack or unpack)(a)) end)
    return ok and res or nil
end
local function level() local d = LP:FindFirstChild("Data"); local l = d and d:FindFirstChild("Level"); return l and l.Value or 0 end
local function sea() return game.PlaceId == 2753915549 and 1 or game.PlaceId == 4442272183 and 2 or game.PlaceId == 7449423635 and 3 or 0 end
local function hrp() local c = LP.Character; return c and c:FindFirstChild("HumanoidRootPart") end
local function go(pos) if Farm and Farm.TeleportWait then pcall(Farm.TeleportWait, CFrame.new(pos), State.FarmSpeed or 250, 60) end end
local function alive() return getgenv().Chuppy and State.Running end

-- đánh boss theo tên (kéo tới gần + đánh), thoát khi boss chết / hết thời gian
local function kill(name, wait)
    local t0 = tick()
    while alive() and tick() - t0 < (wait or 90) do
        local en = workspace:FindFirstChild("Enemies")
        local m = en and en:FindFirstChild(name)
        local h = m and m:FindFirstChildOfClass("Humanoid")
        local mh = m and m:FindFirstChild("HumanoidRootPart")
        if m and h and mh and h.Health > 0 then
            local me = hrp()
            if me then
                pcall(function() if Combat.EquipWeapon then Combat.EquipWeapon(State.WeaponType or "Melee") end end)
                me.CFrame = mh.CFrame * CFrame.new(0, 12, 0)
                pcall(function() if Combat.Attack then Combat.Attack() end end)
            end
        elseif m then
            return true
        elseif tick() - t0 > 3 then
            return false
        end
        task.wait(0.1)
    end
    return false
end

local function doSea2()
    if sea() ~= 1 or level() < 700 then return end
    local door = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ice") and workspace.Map.Ice:FindFirstChild("Door")
    if door and (door.CanCollide or door.Transparency ~= 1) then
        go(Vector3.new(4849.3, 5.65, 719.6))
        inv("DressrosaQuestProgress", "Detective")
        pcall(function()
            local bp, ch = LP.Backpack, LP.Character
            local k = bp:FindFirstChild("Key"); if k and ch and ch:FindFirstChildOfClass("Humanoid") then ch.Humanoid:EquipTool(k) end
        end)
        task.wait(0.5)
        go(Vector3.new(1347.7, 37.4, -1325.6))
        kill("Ice Admiral", 90)
    else
        inv("TravelDressrosa")
    end
end

local function doSea3()
    if sea() ~= 2 or level() < 1500 then return end
    if inv("ZQuestProgress", "General") == 0 then
        go(Vector3.new(-1926.3, 12.8, 1738.3))
        inv("ZQuestProgress", "Begin")
    end
    local en = workspace:FindFirstChild("Enemies")
    if en and en:FindFirstChild("rip_indra") then
        kill("rip_indra", 120)
    else
        go(Vector3.new(-26880.9, 22.8, 473.2))
    end
    inv("TravelZou")
end

local function eatFruit()
    local ch = LP.Character; if not ch then return end
    local bp = LP.Backpack
    local tool
    for _, src in ipairs({ ch, bp }) do
        for _, t in ipairs(src:GetChildren()) do
            if t:IsA("Tool") and t:FindFirstChild("EatRemote") and (P16.Fruit == "" or t.Name:lower():find(P16.Fruit:lower(), 1, true)) then tool = t break end
        end
        if tool then break end
    end
    if not tool then return end
    if tool.Parent ~= ch then pcall(function() ch.Humanoid:EquipTool(tool) end) task.wait(0.2) end
    pcall(function() tool.EatRemote:InvokeServer() end)
end

local function loop(flag, fn, delay)
    task.spawn(function()
        while alive() and P16[flag] do pcall(fn); task.wait(delay) end
    end)
end

local Tab = C.Tabs.Misc
local S = Tab:CreateSection({ Name = "Tiến trình (Auto Sea / Trái / Awakener)" })
S:AddToggle({ Name = "Auto Sea 2", Desc = "Level ≥700, đang ở Sea 1: làm Detective + Ice Admiral rồi sang Sea 2", Default = false }, function(v) P16.Sea2 = v; if v then loop("Sea2", doSea2, 1) end end)
S:AddToggle({ Name = "Auto Sea 3", Desc = "Level ≥1500, đang ở Sea 2: quest General + rip_indra rồi sang Sea 3", Default = false }, function(v) P16.Sea3 = v; if v then loop("Sea3", doSea3, 1) end end)
S:AddInput({ Name = "Tên trái cần ăn (để trống = bất kỳ)", Default = "" }, function(v) P16.Fruit = tostring(v or "") end)
S:AddToggle({ Name = "Auto ăn trái", Default = false }, function(v) P16.Eat = v; if v then loop("Eat", eatFruit, 0.5) end end)
S:AddToggle({ Name = "Auto Awakener", Desc = "Kiểm tra và thức tỉnh trái ở Lab", Default = false }, function(v)
    P16.Awaken = v
    if v then loop("Awaken", function() if inv("Awakener", "Check") then inv("Awakener", "Awaken") end end, 3) end
end)
pcall(function() Notify("Chuppy", "Part 16 sẵn sàng (tab Misc)", 3) end)
end)()

-- ═══ PART 17 — AUTO FARM LEVEL KIỂU MARU (động cơ thay thế, đơn giản, ít lỗi) ═══
;(function()
local C = getgenv().Chuppy
if not C or not C.State or not C.Tabs or not C.Tabs.Farm or not C.Farm or not C.Quest then return end
local State, Farm, Quest, Monster, Combat = C.State, C.Farm, C.Quest, C.Monster, C.Combat
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local M = { On = false, idx = 1 }
getgenv().ChuppyMaruFarm = M

local function hrp() local c = LP.Character; local h = c and c:FindFirstChild("HumanoidRootPart"); local hu = c and c:FindFirstChildOfClass("Humanoid"); return (h and hu and hu.Health > 0) and h or nil end
local function questUI() local g = LP:FindFirstChild("PlayerGui"); local m = g and g:FindFirstChild("Main"); return m and m:FindFirstChild("Quest") end
local function questTitle()
    local q = questUI(); if not q then return "" end
    local ok, t = pcall(function() return q.Container.QuestTitle.Title.Text end)
    return ok and t or ""
end
local function level() local d = LP:FindFirstChild("Data"); local l = d and d:FindFirstChild("Level"); return l and l.Value or 1 end
local function commF() local r = RS:FindFirstChild("Remotes"); return r and r:FindFirstChild("CommF_") end
local function fly(cf) return Farm.Teleport(cf, State.FarmSpeed or 250) end
local function near(cf, d) local h = hrp(); return h and (h.Position - cf.Position).Magnitude <= d end

local function step()
    local h = hrp(); if not h then return end
    local q = Quest.Find(level(), State.World)
    if not q or not q.questCF then task.wait(1) return end
    local ui = questUI()
    local visible = ui and ui.Visible
    -- chưa có quest: bay tới NPC rồi nhận
    if not visible then
        fly(q.questCF)
        if near(q.questCF, 8) then
            task.wait(0.2)
            local f = commF(); if f then pcall(function() f:InvokeServer("StartQuest", q.quest, q.qlv) end) end
            task.wait(0.3)
        end
        return
    end
    -- quest sai quái -> bỏ, nhận lại
    local title = questTitle()
    if q.mob and title ~= "" and not string.find(title, q.mob, 1, true) then
        local f = commF(); if f then pcall(function() f:InvokeServer("AbandonQuest") end) end
        task.wait(0.5)
        return
    end
    -- tìm quái đúng tên (khớp tuyệt đối) còn sống
    local en = workspace:FindFirstChild("Enemies")
    local target
    if en then
        for _, m in ipairs(en:GetChildren()) do
            local hu, r = m:FindFirstChildOfClass("Humanoid"), m:FindFirstChild("HumanoidRootPart")
            if m.Name == q.mob and hu and r and hu.Health > 0 then target = m break end
        end
    end
    if not target then
        -- chưa có quái: xoay vòng các điểm spawn (như Maru), không đứng chờ
        local list = Quest.SpawnList and Quest.SpawnList(q.mob, q.questCF.Position) or {}
        local cf = list[M.idx] or q.mobCF
        if cf then
            fly(cf * CFrame.new(0, 25, 0))
            if near(cf, 60) then M.idx = (M.idx % math.max(#list, 1)) + 1; task.wait(0.5) end
        end
        return
    end
    -- đánh: đứng trên đầu, đóng băng quái, gom nhóm
    M.idx = 1
    local root = target:FindFirstChild("HumanoidRootPart")
    local t0 = os.clock()
    while M.On and State.Running and target.Parent and hrp() do
        local hu, r = target:FindFirstChildOfClass("Humanoid"), target:FindFirstChild("HumanoidRootPart")
        if not hu or not r or hu.Health <= 0 then break end
        local u = questUI(); if not (u and u.Visible) then break end
        pcall(function()
            hu.WalkSpeed = 0; r.CanCollide = false
            local hd = target:FindFirstChild("Head"); if hd then hd.CanCollide = false end
            Combat.EquipWeapon(State.CurrentWeapon or "Melee")
            if State.AutoHaki then Combat.AutoHaki() end
            if Monster.BringGroup then Monster.BringGroup(target, nil, r.CFrame) end
            Combat.Attack(target)
        end)
        Farm.Teleport(r.CFrame * CFrame.new(0, State.Height or 25, 0), 350)
        if os.clock() - t0 > 25 then break end
        task.wait()
    end
end

local function start()
    task.spawn(function()
        while M.On and getgenv().Chuppy and State.Running do
            local ok, e = pcall(step)
            if not ok then warn("[Chuppy Maru Farm]", e); task.wait(1) end
            task.wait()
        end
    end)
end

local Tab = C.Tabs.Farm
local S = Tab:CreateSection({ Name = "Auto Farm Level (kiểu Maru)" })
S:AddToggle({ Name = "Auto Farm Level — Maru", Desc = "Động cơ đơn giản: nhận quest, đứng trên quái, đánh. Tự tắt farm thường để khỏi đụng nhau", Default = false }, function(v)
    M.On = v
    if v then State.AutoFarm = false; start() end
end)
end)()

-- ═══ PART 18 — Thông báo hoàn thành quest trên màn hình ═══
;(function()
local C = getgenv().Chuppy
if not C or not C.Notify or not C.State then return end
local QS = getgenv().ChuppyQuestStatus
if not QS then return end
local had, lastC, lastN = false, nil, nil
task.spawn(function()
    while getgenv().Chuppy and C.State.Running do
        pcall(function()
            local c, n = QS.GetProgress()
            if c then
                had, lastC, lastN = true, c, n
                C.State.QuestProgress = c .. "/" .. n
                if c >= n then C.Notify("Quest", "Hoàn thành " .. c .. "/" .. n .. " ✔", "success"); had = false; lastC = nil; task.wait(2) end
            elseif had then
                had = false
                C.Notify("Quest", "Hoàn thành nhiệm vụ ✔", "success")
            end
        end)
        task.wait(0.3)
    end
end)
end)()

-- ═══ PART 19 — CHẨN ĐOÁN FARM (tự báo lý do khi kẹt) + tự gỡ kẹt ═══
;(function()
local C = getgenv().Chuppy
if not C or not C.State or not C.Monster then return end
local State, Monster = C.State, C.Monster
local LP = game:GetService("Players").LocalPlayer
local lastSeen, lastDiag = os.clock(), 0
local function hrp() local c = LP.Character; return c and c:FindFirstChild("HumanoidRootPart") end
task.spawn(function()
    while getgenv().Chuppy and State.Running do
        task.wait(1)
        pcall(function()
            local q = State.CurrentQuest
            local on = (State.AutoFarm or (getgenv().ChuppyMaruFarm and getgenv().ChuppyMaruFarm.On)) and q
            if not on then lastSeen = os.clock(); return end
            if Monster.FindNearestByName(q.mob) then lastSeen = os.clock(); return end
            local idle = os.clock() - lastSeen
            if idle < 8 or os.clock() - lastDiag < 10 then return end
            lastDiag = os.clock()
            if Monster.ClearIgnore then Monster.ClearIgnore() end
            local en = workspace:FindFirstChild("Enemies")
            local me = hrp()
            local lines = { "[Chuppy DIAG] kẹt " .. math.floor(idle) .. "s | quái cần: " .. tostring(q.mob) }
            local qs = getgenv().ChuppyQuestStatus
            if qs then local c, n = qs.GetProgress(); lines[#lines + 1] = "quest: " .. tostring(c) .. "/" .. tostring(n) end
            if en then
                local kids = en:GetChildren()
                lines[#lines + 1] = "Enemies: " .. #kids .. " con"
                for i = 1, math.min(#kids, 8) do
                    local m = kids[i]
                    local h, r = m:FindFirstChildOfClass("Humanoid"), m:FindFirstChild("HumanoidRootPart")
                    lines[#lines + 1] = ("  %s | hp=%s | cách=%s"):format(m.Name, h and math.floor(h.Health) or "?", (me and r) and math.floor((me.Position - r.Position).Magnitude) or "?")
                end
            else lines[#lines + 1] = "KHÔNG có Workspace.Enemies" end
            do
                local pg = LP:FindFirstChild("PlayerGui")
                local mn = pg and pg:FindFirstChild("Main")
                local qu = mn and mn:FindFirstChild("Quest")
                if qu then
                    lines[#lines + 1] = "QuestUI Visible=" .. tostring(qu.Visible)
                    local k = 0
                    for _, d in ipairs(qu:GetDescendants()) do
                        if d:IsA("TextLabel") and d.Text ~= "" and k < 4 then k = k + 1; lines[#lines + 1] = "  [" .. d.Name .. "] " .. string.sub(d.Text, 1, 50) end
                    end
                else lines[#lines + 1] = "KHÔNG có Main.Quest" end
            end
            lines[#lines + 1] = "nhãn quest thật: " .. tostring(getgenv().ChuppyLiveQuestPath)
            pcall(function()
                local g = require(game:GetService("ReplicatedStorage"):WaitForChild("GuideModule", 2))
                local qd = g and g.Data and g.Data.QuestData
                if type(qd) == "table" then
                    local parts = {}
                    for k, v in pairs(qd) do
                        if type(v) == "table" then for a, b in pairs(v) do table.insert(parts, tostring(k) .. "." .. tostring(a) .. "=" .. tostring(b)) end
                        else table.insert(parts, tostring(k) .. "=" .. tostring(v)) end
                    end
                    lines[#lines + 1] = "GuideModule.QuestData: " .. table.concat(parts, " ; ")
                else lines[#lines + 1] = "GuideModule.QuestData=" .. tostring(qd) end
            end)
            local function norm(x) return string.lower((string.gsub(x or "", "%s*%[?%s*Lv%.?%s*%d+%s*%]?", ""))) end
            local n = 0
            local wo = workspace:FindFirstChild("_WorldOrigin")
            local sp = wo and wo:FindFirstChild("EnemySpawns")
            if sp then for _, v in ipairs(sp:GetChildren()) do if string.find(norm(v.Name), norm(q.mob), 1, true) then n = n + 1 end end end
            lines[#lines + 1] = "spawn point khớp tên: " .. n
            warn(table.concat(lines, "\n"))
            -- gỡ kẹt: bay thẳng xuống mặt đất ngay điểm spawn (ép server tải + hồi quái)
            local done = false
            if sp and me then
                for _, v in ipairs(sp:GetChildren()) do
                    if v:IsA("BasePart") and string.find(norm(v.Name), norm(q.mob), 1, true) then me.CFrame = v.CFrame * CFrame.new(0, 6, 0); done = true break end
                end
            end
            -- không có spawn khớp tên: về đống quái cũ (nơi vừa đánh) hoặc điểm spawn của quest
            if not done and me then
                local F = C.Farm
                local cf = (F and F._pile and F._pileMob == q.mob and F._pile) or q.mobCF
                if cf then me.CFrame = cf * CFrame.new(0, 6, 0) end
            end
        end)
    end
end)
end)()
