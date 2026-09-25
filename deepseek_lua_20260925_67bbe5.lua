-- ============================================================
-- Babis UI Library v1.3.0
-- Reusable, hub-agnostic Roblox UI framework.
-- Load:  local Library = loadstring(game:HttpGet("URL"))()
-- ============================================================

local Library = {}
Library.__index = Library
Library.Version = "1.3.0"

local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local SoundService      = game:GetService("SoundService")
local HttpService       = game:GetService("HttpService")
local LocalPlayer       = Players.LocalPlayer
local PlayerGui         = LocalPlayer:WaitForChild("PlayerGui")

-- ============================================================
-- BRAND
-- ============================================================
Library.Brand = {
    Title        = "UI Library",
    SubTitle     = "Free Edition",
    Version      = "v1.0.0",
    Discord      = "",
    AboutTitle   = "About",
    AboutBody    = "Built with Babis UI Library.",
    AboutEnabled = true,
}

Library.Config = {
    folder         = "BabisUI/configs",
    ext            = ".json",
    autoloadFile   = "BabisUI/autoload.txt",
    introDuration  = 5.5,
    notifySoundVol = 0.5,
}

-- ============================================================
-- THEME
-- ============================================================
Library.Theme = {
    colors = {
        windowBg      = Color3.fromRGB(8, 10, 14),
        headerTint    = Color3.fromRGB(8, 10, 14),
        divider       = Color3.fromRGB(65, 150, 245),
        accent        = Color3.fromRGB(90, 165, 255),
        accentSoft    = Color3.fromRGB(160, 210, 255),
        accentDark    = Color3.fromRGB(40, 90, 160),
        navBg         = Color3.fromRGB(18, 18, 19),
        navBorder     = Color3.fromRGB(90, 88, 92),
        navIcon       = Color3.fromRGB(52, 61, 69),
        navIconActive = Color3.fromRGB(160, 210, 255),
        navActiveBrd  = Color3.fromRGB(160, 210, 255),
        cardBg        = Color3.fromRGB(16, 16, 20),
        cardBorder    = Color3.fromRGB(56, 55, 62),
        toggleOff     = Color3.fromRGB(38, 38, 44),
        toggleOn      = Color3.fromRGB(90, 165, 255),
        textPrimary   = Color3.fromRGB(240, 240, 248),
        textDesc      = Color3.fromRGB(150, 148, 168),
        textMuted     = Color3.fromRGB(130, 130, 150),
        closeHover    = Color3.fromRGB(220, 70, 90),
        handIdle      = Color3.fromRGB(240, 245, 255),
        handHover     = Color3.fromRGB(255, 255, 255),
        bellBg        = Color3.fromRGB(30, 38, 48),
        sectionTitle  = Color3.fromRGB(160, 210, 255),
        cfgIcon       = Color3.fromRGB(170, 120, 255),
        cfgBtnBg      = Color3.fromRGB(24, 24, 28),
        cfgBtnBorder  = Color3.fromRGB(48, 48, 56),
    },
    sizes = {
        windowWidth   = 460,
        windowHeight  = 700,
        windowRadius  = 22,
        headerHeight  = 82,
        navHeight     = 88,
        navBtnSize    = 70,
        navBtnRadius  = 14,
        navGap        = 8,
        navPadX       = 12,
        contentPadX   = 14,
        scrollPadL    = 6,
        scrollPadR    = 8,
        iconSize      = 46,
        cardRadius    = 16,
        cardPadX      = 16,
        cardGap       = 14,
        cardHeight    = 128,
        toggleW       = 72,
        toggleH       = 38,
        toggleKnob    = 30,
        toggleRight   = 22,
        controlW      = 130,
        controlH      = 44,
        controlRight  = 22,
        handIconSize  = 82,
        handIconY     = 20,
        sectionHeaderH = 34,
        cfgHeight     = 560,
    },
    fonts = {
        appName = Enum.Font.GothamBold,
        version = Enum.Font.Gotham,
        intro   = Enum.Font.Code,
    },
    textSizes = {
        appName   = 22,
        version   = 13,
        intro     = 20,
        cardTitle = 24,
        cardDesc  = 15,
        aboutTitle = 30,
        aboutDesc  = 19,
        discordTitle = 28,
        discordSub   = 18,
        sectionTitle = 18,
        cfgTitle = 22,
        cfgLabel = 17,
        cfgBtn   = 17,
        cfgHint  = 16,
        cfgInput = 17,
    },
    anim = {
        fast   = 0.14,
        normal = 0.20,
        slow   = 0.32,
        easing = Enum.EasingStyle.Quint,
        dir    = Enum.EasingDirection.Out,
    },
}

Library.Assets = {
    handIcon    = "rbxassetid://88060480140568",
    infoIcon    = "rbxassetid://7733964719",
    discordIcon = "rbxassetid://100770414662869",
    bellIcon    = "rbxassetid://7072706001",
    notifySound = "rbxassetid://5153734608",
    introImage  = "rbxassetid://119251117614023",
    cfgIcon     = "rbxassetid://10709791036",
}

-- ============================================================
-- HELPERS
-- ============================================================
local function corner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function tween(obj, props, dur, style, dir)
    local T = Library.Theme.anim
    local info = TweenInfo.new(dur or T.normal, style or T.easing, dir or T.dir)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function popTween(obj, props, dur)
    local info = TweenInfo.new(dur or 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function resolveIcon(icon)
    if type(icon) == "number" then return "rbxassetid://" .. icon end
    if type(icon) == "string" then
        if icon:sub(1, 11) == "rbxassetid" then return icon end
        if icon:match("^%d+$") then return "rbxassetid://" .. icon end
        return icon
    end
    return ""
end

local function safeCall(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, res = pcall(fn, ...)
    if ok then return res end
    return nil
end

-- ============================================================
-- CONFIG FILE IO
-- ============================================================
function Library:_ensureCfgFolder()
    if not safeCall(isfolder, "BabisUI") then safeCall(makefolder, "BabisUI") end
    if not safeCall(isfolder, self.Config.folder) then safeCall(makefolder, self.Config.folder) end
end

function Library:SaveConfig(name, data)
    self:_ensureCfgFolder()
    if type(name) ~= "string" or name == "" then return false, "invalid name" end
    local path = self.Config.folder .. "/" .. name .. self.Config.ext
    local okEnc, resEnc = pcall(function() return HttpService:JSONEncode(data) end)
    if not okEnc then return false, "encode failed" end
    local ok = safeCall(writefile, path, resEnc)
    if ok == nil then return false, "writefile failed" end
    return true
end

function Library:LoadConfig(name)
    self:_ensureCfgFolder()
    local path = self.Config.folder .. "/" .. name .. self.Config.ext
    local content = safeCall(readfile, path)
    if type(content) ~= "string" then return nil end
    local ok, data = pcall(function() return HttpService:JSONDecode(content) end)
    if not ok then return nil end
    return data
end

function Library:ListConfigs()
    self:_ensureCfgFolder()
    local out = {}
    local files = safeCall(listfiles, self.Config.folder)
    if type(files) ~= "table" then return out end
    for _, path in ipairs(files) do
        local name = path:match("([^/\\]+)$") or path
        name = name:gsub(self.Config.ext:gsub("%.", "%%."), "")
        table.insert(out, name)
    end
    return out
end

function Library:DeleteConfig(name)
    local path = self.Config.folder .. "/" .. name .. self.Config.ext
    return safeCall(delfile, path) ~= nil
end

function Library:GetAutoload()
    local content = safeCall(readfile, self.Config.autoloadFile)
    if type(content) == "string" and content ~= "" then return content end
    return nil
end

function Library:SetAutoload(name)
    self:_ensureCfgFolder()
    if name == nil or name == "" then
        safeCall(delfile, self.Config.autoloadFile)
    else
        safeCall(writefile, self.Config.autoloadFile, name)
    end
end

-- ============================================================
-- BRAND API
-- ============================================================
function Library:SetBrand(t)
    for k, v in pairs(t or {}) do self.Brand[k] = v end
    for _, w in ipairs(self._windows or {}) do
        if w.ApplyBrand then w:ApplyBrand() end
    end
end

function Library:SetDiscord(url)
    self.Brand.Discord = url or ""
    for _, w in ipairs(self._windows or {}) do
        if w.ApplyBrand then w:ApplyBrand() end
    end
end

-- ============================================================
-- INTRO
-- ============================================================
function Library:PlayIntro(cfg, onComplete)
    if type(cfg) == "function" and onComplete == nil then
        onComplete = cfg; cfg = {}
    end
    cfg = cfg or {}
    local duration = cfg.Duration or self.Config.introDuration
    local img      = cfg.Image or self.Assets.introImage
    local imgW     = cfg.ImageWidth or 156
    local imgH     = cfg.ImageHeight or 139
    local text     = cfg.Text or "CONNECTING TO SERVER"

    local old = PlayerGui:FindFirstChild("BabisIntro")
    if old then old:Destroy() end

    local introGui = Instance.new("ScreenGui")
    introGui.Name = "BabisIntro"
    introGui.ResetOnSpawn = false
    introGui.IgnoreGuiInset = true
    introGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    introGui.DisplayOrder = 200
    introGui.Parent = PlayerGui

    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 1
    overlay.BorderSizePixel = 0
    overlay.Parent = introGui

    local center = Instance.new("Frame")
    center.Size = UDim2.new(0, 260, 0, 260)
    center.Position = UDim2.new(0.5, 0, 0.5, -30)
    center.AnchorPoint = Vector2.new(0.5, 0.5)
    center.BackgroundTransparency = 1
    center.Parent = overlay

    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(0, 220, 0, 220)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.BackgroundColor3 = self.Theme.colors.accent
    glow.BackgroundTransparency = 1
    glow.BorderSizePixel = 0
    glow.Parent = center
    corner(glow, 110)

    local glowRing = Instance.new("Frame")
    glowRing.Size = UDim2.new(0, 260, 0, 260)
    glowRing.Position = UDim2.new(0.5, 0, 0.5, 0)
    glowRing.AnchorPoint = Vector2.new(0.5, 0.5)
    glowRing.BackgroundTransparency = 1
    glowRing.Parent = center
    corner(glowRing, 130)
    local ringStroke = stroke(glowRing, self.Theme.colors.accent, 1, 1)

    local image = Instance.new("ImageLabel")
    image.Size = UDim2.new(0, imgW, 0, imgH)
    image.Position = UDim2.new(0.5, 0, 0.5, 0)
    image.AnchorPoint = Vector2.new(0.5, 0.5)
    image.BackgroundTransparency = 1
    image.Image = img
    image.ImageTransparency = 1
    image.ScaleType = Enum.ScaleType.Fit
    image.Parent = center

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 30)
    subtitle.Position = UDim2.new(0.5, 0, 0.5, 120)
    subtitle.AnchorPoint = Vector2.new(0.5, 0)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = text
    subtitle.TextColor3 = Color3.fromRGB(225, 230, 245)
    subtitle.TextTransparency = 1
    subtitle.Font = self.Theme.fonts.intro
    subtitle.TextSize = self.Theme.textSizes.intro
    subtitle.TextXAlignment = Enum.TextXAlignment.Center
    subtitle.Parent = overlay

    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 0, 0, 1)
    line.Position = UDim2.new(0.5, 0, 0.5, 158)
    line.AnchorPoint = Vector2.new(0.5, 0)
    line.BackgroundColor3 = self.Theme.colors.accent
    line.BackgroundTransparency = 1
    line.BorderSizePixel = 0
    line.Parent = overlay

    tween(overlay, { BackgroundTransparency = 0.55 }, 0.5)
    tween(image, { ImageTransparency = 0 }, 0.5)
    tween(glow, { BackgroundTransparency = 0.88 }, 0.6)
    tween(ringStroke, { Transparency = 0.6 }, 0.6)
    tween(subtitle, { TextTransparency = 0 }, 0.5)
    tween(line, { BackgroundTransparency = 0.2 }, 0.5)
    tween(line, { Size = UDim2.new(0, 190, 0, 1) }, 0.7)

    local spinning = true

    task.spawn(function()
        while spinning do
            local spin = TweenService:Create(image,
                TweenInfo.new(1.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                { Rotation = image.Rotation + 360 })
            spin:Play(); spin.Completed:Wait()
            if not spinning then break end
            task.wait(0.45)
        end
    end)

    task.spawn(function()
        local n = 0
        while spinning do
            n = (n + 1) % 4
            subtitle.Text = text .. string.rep(".", n)
            task.wait(0.35)
        end
    end)

    task.spawn(function()
        while spinning do
            tween(glow, { BackgroundTransparency = 0.95 }, 0.9)
            tween(ringStroke, { Transparency = 0.9 }, 0.9)
            task.wait(0.9)
            if not spinning then break end
            tween(glow, { BackgroundTransparency = 0.82 }, 0.9)
            tween(ringStroke, { Transparency = 0.4 }, 0.9)
            task.wait(0.9)
        end
    end)

    task.delay(duration, function()
        spinning = false
        tween(overlay, { BackgroundTransparency = 1 }, 0.55)
        tween(image, { ImageTransparency = 1 }, 0.5)
        tween(glow, { BackgroundTransparency = 1 }, 0.5)
        tween(ringStroke, { Transparency = 1 }, 0.5)
        tween(subtitle, { TextTransparency = 1 }, 0.4)
        tween(line, { BackgroundTransparency = 1 }, 0.4)
        tween(line, { Size = UDim2.new(0, 0, 0, 1) }, 0.5)
        task.wait(0.6)
        introGui:Destroy()
        if onComplete then onComplete() end
    end)
end

-- ============================================================
-- NOTIFIER
-- ============================================================
local Notifier = {}
Notifier.__index = Notifier

function Notifier.new(theme, assets, config)
    local self = setmetatable({}, Notifier)
    self.theme = theme; self.assets = assets; self.config = config
    self.order = 0

    local old = PlayerGui:FindFirstChild("BabisUILibNotif")
    if old then old:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "BabisUILibNotif"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 300
    gui.Parent = PlayerGui

    local sound = Instance.new("Sound")
    sound.SoundId = assets.notifySound
    sound.Volume = config.notifySoundVol
    sound.Parent = SoundService
    self.sound = sound

    local container = Instance.new("Frame")
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(0, 320, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.AnchorPoint = Vector2.new(1, 0)
    container.Position = UDim2.new(1, -20, 0, 20)
    container.Parent = gui

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.Parent = container

    self.gui = gui; self.container = container
    return self
end

function Notifier:dismiss(row)
    if not row or not row.Parent then return end
    if row:GetAttribute("Dismissing") then return end
    row:SetAttribute("Dismissing", true)
    local card = row:FindFirstChild("Card")
    local startSize = row.Size
    if card then
        card.AnchorPoint = Vector2.new(0, 0)
        tween(card, { Position = UDim2.new(1, 420, 0, 0), BackgroundTransparency = 0.7 }, 0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        for _, d in ipairs(card:GetDescendants()) do
            if d:IsA("TextLabel") then tween(d, { TextTransparency = 1 }, 0.28)
            elseif d:IsA("ImageLabel") then tween(d, { ImageTransparency = 1 }, 0.28)
            elseif d:IsA("Frame") then tween(d, { BackgroundTransparency = 1 }, 0.28)
            elseif d:IsA("UIStroke") then tween(d, { Transparency = 1 }, 0.28) end
        end
    end
    tween(row, { Size = UDim2.new(startSize.X.Scale, startSize.X.Offset, 0, 0) }, 0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    task.delay(0.38, function() if row and row.Parent then row:Destroy() end end)
end

function Notifier:notify(title, message, duration)
    title = title or "Notification"
    message = message or ""
    duration = duration or 2.0

    if self.sound.IsPlaying then self.sound:Stop() end
    self.sound.TimePosition = 0
    self.sound:Play()

    local ACCENT = self.theme.colors.accent
    self.order = self.order + 1

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 76)
    row.BackgroundTransparency = 1
    row.ClipsDescendants = false
    row.LayoutOrder = self.order
    row.Parent = self.container

    local card = Instance.new("Frame")
    card.Name = "Card"
    card.Size = UDim2.new(1, 0, 1, 0)
    card.Position = UDim2.new(1, 380, 0, 0)
    card.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
    card.BorderSizePixel = 0
    card.Parent = row
    corner(card, 12)
    stroke(card, self.theme.colors.cardBorder, 1.5, 0)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 5, 1, -22)
    bar.Position = UDim2.new(0, 9, 0, 11)
    bar.BackgroundColor3 = ACCENT
    bar.BorderSizePixel = 0
    bar.Parent = card
    corner(bar, 3)

    local bellBg = Instance.new("Frame")
    bellBg.Size = UDim2.new(0, 42, 0, 42)
    bellBg.Position = UDim2.new(0, 20, 0.5, -21)
    bellBg.BackgroundColor3 = self.theme.colors.bellBg
    bellBg.BorderSizePixel = 0
    bellBg.Parent = card
    corner(bellBg, 21)
    stroke(bellBg, ACCENT, 1.2, 0.4)

    local bell = Instance.new("ImageLabel")
    bell.Size = UDim2.new(0, 28, 0, 28)
    bell.Position = UDim2.new(0.5, -14, 0.5, -14)
    bell.BackgroundTransparency = 1
    bell.Image = self.assets.bellIcon
    bell.ImageColor3 = ACCENT
    bell.ScaleType = Enum.ScaleType.Fit
    bell.Parent = bellBg

    local titleLbl = Instance.new("TextLabel")
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = Color3.fromRGB(245, 248, 255)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 16
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.TextYAlignment = Enum.TextYAlignment.Top
    titleLbl.Size = UDim2.new(1, -90, 0, 22)
    titleLbl.Position = UDim2.new(0, 72, 0, 16)
    titleLbl.Parent = card

    local msgLbl = Instance.new("TextLabel")
    msgLbl.BackgroundTransparency = 1
    msgLbl.Text = message
    msgLbl.TextColor3 = Color3.fromRGB(160, 165, 185)
    msgLbl.Font = Enum.Font.Gotham
    msgLbl.TextSize = 14
    msgLbl.TextXAlignment = Enum.TextXAlignment.Left
    msgLbl.TextYAlignment = Enum.TextYAlignment.Top
    msgLbl.TextWrapped = true
    msgLbl.Size = UDim2.new(1, -90, 0, 34)
    msgLbl.Position = UDim2.new(0, 72, 0, 38)
    msgLbl.Parent = card

    tween(card, { Position = UDim2.new(0, 0, 0, 0) }, 0.35)

    task.spawn(function()
        task.wait(0.4)
        if not bell.Parent then return end
        bell.Rotation = -12
        tween(bell, { Rotation = 12 }, 0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out); task.wait(0.11)
        if not bell.Parent then return end
        tween(bell, { Rotation = -8 }, 0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out); task.wait(0.11)
        if not bell.Parent then return end
        tween(bell, { Rotation = 6 }, 0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out); task.wait(0.11)
        if not bell.Parent then return end
        tween(bell, { Rotation = 0 }, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    end)

    task.spawn(function()
        task.wait(duration)
        self:dismiss(row)
    end)

    return row
end

-- ============================================================
-- CARD BASE
-- ============================================================
local function makeCard(scroll, order, height, theme)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, height or theme.sizes.cardHeight)
    card.BackgroundColor3 = theme.colors.cardBg
    card.BorderSizePixel = 0
    card.LayoutOrder = order
    card.Parent = scroll
    corner(card, theme.sizes.cardRadius)
    local cardStroke = stroke(card, theme.colors.cardBorder, 1.5, 0)

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.TextColor3 = theme.colors.textPrimary
    title.Font = Enum.Font.GothamBold
    title.TextSize = theme.textSizes.cardTitle
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextYAlignment = Enum.TextYAlignment.Top
    title.Size = UDim2.new(1, -160, 0, 30)
    title.Position = UDim2.new(0, theme.sizes.cardPadX, 0, 24)
    title.Parent = card

    local desc = Instance.new("TextLabel")
    desc.BackgroundTransparency = 1
    desc.TextColor3 = theme.colors.textDesc
    desc.Font = Enum.Font.Gotham
    desc.TextSize = theme.textSizes.cardDesc
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextYAlignment = Enum.TextYAlignment.Top
    desc.Size = UDim2.new(1, -160, 0, 22)
    desc.Position = UDim2.new(0, theme.sizes.cardPadX, 0, 68)
    desc.Parent = card

    return card, title, desc, cardStroke
end

-- ============================================================
-- BUTTON
-- ============================================================
local Button = {}
Button.__index = Button

function Button.new(section, cfg)
    local window = section.tab.window
    local library = window.library
    local theme = library.Theme
    local scroll = section.tab.scroll
    local order = section:_nextOrder()

    local titleText = cfg.Name or "Button"
    local descText  = cfg.Description or ""
    local onClick   = cfg.Callback
    local doNotify  = cfg.Notify ~= false

    local card, title, desc, cardStroke = makeCard(scroll, order, nil, theme)
    title.Text = titleText
    desc.Text  = descText

    local iconSize = theme.sizes.handIconSize
    local iconY    = theme.sizes.handIconY
    local right    = theme.sizes.controlRight

    local hand = Instance.new("ImageLabel")
    hand.Size = UDim2.new(0, iconSize, 0, iconSize)
    hand.Position = UDim2.new(1, -(iconSize + right), 0, iconY)
    hand.BackgroundTransparency = 1
    hand.Image = library.Assets.handIcon
    hand.ImageColor3 = theme.colors.handIdle
    hand.ScaleType = Enum.ScaleType.Fit
    hand.Parent = card

    local flash = Instance.new("Frame")
    flash.Size = UDim2.new(1, 0, 1, 0)
    flash.BackgroundColor3 = theme.colors.accent
    flash.BackgroundTransparency = 1
    flash.BorderSizePixel = 0
    flash.ZIndex = 3
    flash.Parent = card
    corner(flash, theme.sizes.cardRadius)

    local hit = Instance.new("TextButton")
    hit.Size = UDim2.new(1, 0, 1, 0)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.AutoButtonColor = false
    hit.ZIndex = 5
    hit.Parent = card

    hit.MouseEnter:Connect(function()
        tween(card, { BackgroundColor3 = theme.colors.navBg }, theme.anim.fast)
        tween(cardStroke, { Color = theme.colors.accent }, theme.anim.fast)
        tween(hand, { ImageColor3 = theme.colors.handHover }, theme.anim.fast)
    end)
    hit.MouseLeave:Connect(function()
        tween(card, { BackgroundColor3 = theme.colors.cardBg }, theme.anim.fast)
        tween(cardStroke, { Color = theme.colors.cardBorder }, theme.anim.fast)
        tween(hand, { ImageColor3 = theme.colors.handIdle }, theme.anim.fast)
    end)

    local self = setmetatable({ _card = card, _playing = false }, Button)
    window:_registerComponent(self, cfg.Key or titleText)

    local function fire()
        if self._playing then return end
        self._playing = true

        local baseSize = card.Size
        local pressSize = UDim2.new(baseSize.X.Scale, baseSize.X.Offset - 6,
                                    baseSize.Y.Scale, baseSize.Y.Offset - 6)
        tween(card, { Size = pressSize }, 0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        flash.BackgroundTransparency = 0.85
        tween(flash, { BackgroundTransparency = 1 }, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        local origSize, origPos = hand.Size, hand.Position
        local pop = iconSize - 8
        tween(hand, {
            Size = UDim2.new(0, pop, 0, pop),
            Position = UDim2.new(1, -(pop + right) - 3, 0, iconY + 3),
            Rotation = 12,
        }, 0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        task.delay(0.08, function()
            popTween(hand, {
                Size = UDim2.new(0, iconSize + 6, 0, iconSize + 6),
                Position = UDim2.new(1, -(iconSize + 6 + right) + 3, 0, iconY - 3),
                Rotation = -6,
            }, 0.18)
            task.delay(0.18, function()
                tween(hand, { Size = origSize, Position = origPos, Rotation = 0 }, 0.14)
            end)
        end)

        task.delay(0.08, function()
            popTween(card, {
                Size = UDim2.new(baseSize.X.Scale, baseSize.X.Offset + 4,
                                 baseSize.Y.Scale, baseSize.Y.Offset + 4),
            }, 0.16)
            task.delay(0.16, function()
                tween(card, { Size = baseSize }, 0.14)
            end)
        end)

        if onClick then onClick() end
        if doNotify then library:Notify(titleText, "Executed") end
        task.delay(0.4, function() self._playing = false end)
    end

    self._fire = fire
    hit.Activated:Connect(fire)

    function self:Fire() fire() end
    function self:SetText(t) title.Text = t end
    function self:SetDescription(t) desc.Text = t end
    function self:Get() return nil end
    function self:Set() end
    function self:Destroy() card:Destroy() end

    return self
end

-- ============================================================
-- TOGGLE
-- ============================================================
local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(section, cfg)
    local window = section.tab.window
    local library = window.library
    local theme = library.Theme
    local scroll = section.tab.scroll
    local order = section:_nextOrder()

    local titleText = cfg.Name or "Toggle"
    local descText  = cfg.Description or ""
    local onChange  = cfg.Callback
    local doNotify  = cfg.Notify ~= false
    local state     = cfg.Default and true or false

    local card, title, desc, cardStroke = makeCard(scroll, order, nil, theme)
    title.Text = titleText
    desc.Text  = descText

    local tW, tH = theme.sizes.toggleW, theme.sizes.toggleH
    local knob = theme.sizes.toggleKnob
    local pad  = (tH - knob) / 2
    local right = theme.sizes.toggleRight

    local track2 = Instance.new("Frame")
    track2.Size = UDim2.new(0, tW, 0, tH)
    track2.Position = UDim2.new(1, -(tW + right), 0.5, -tH/2)
    track2.BackgroundColor3 = theme.colors.toggleOff
    track2.BorderSizePixel = 0
    track2.Parent = card
    corner(track2, tH / 2)
    local trackStroke = stroke(track2, theme.colors.cardBorder, 1.5, 0)

    local knobFrame = Instance.new("Frame")
    knobFrame.Size = UDim2.new(0, knob, 0, knob)
    knobFrame.Position = UDim2.new(0, pad, 0.5, -knob/2)
    knobFrame.BackgroundColor3 = theme.colors.textPrimary
    knobFrame.BorderSizePixel = 0
    knobFrame.Parent = track2
    corner(knobFrame, knob / 2)

    local hit = Instance.new("TextButton")
    hit.Size = UDim2.new(1, 0, 1, 0)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.AutoButtonColor = false
    hit.ZIndex = 10
    hit.Parent = card

    local offX, onX = pad, tW - knob - pad
    local self = setmetatable({ _state = state }, Toggle)
    window:_registerComponent(self, cfg.Key or titleText)

    local function render(animate, fire, notify)
        local dur = animate and theme.anim.normal or 0
        if self._state then
            tween(track2, { BackgroundColor3 = theme.colors.toggleOn }, dur)
            tween(trackStroke, { Color = theme.colors.toggleOn }, dur)
            tween(knobFrame, { Position = UDim2.new(0, onX, 0.5, -knob/2) }, dur)
        else
            tween(track2, { BackgroundColor3 = theme.colors.toggleOff }, dur)
            tween(trackStroke, { Color = theme.colors.cardBorder }, dur)
            tween(knobFrame, { Position = UDim2.new(0, offX, 0.5, -knob/2) }, dur)
        end
        if fire and onChange then onChange(self._state) end
        if notify and doNotify then
            library:Notify(titleText, self._state and "Enabled" or "Disabled")
        end
    end

    render(false, false, false)

    hit.Activated:Connect(function()
        self._state = not self._state
        render(true, true, true)
    end)

    function self:Set(v, fire)
        v = v and true or false
        if v == self._state then
            if fire and onChange then onChange(v) end
            return
        end
        self._state = v
        render(true, fire ~= false, false)
    end
    function self:Get() return self._state end
    function self:Toggle() self:Set(not self._state) end
    function self:Destroy() card:Destroy() end

    return self
end

-- ============================================================
-- SLIDER
-- ============================================================
local Slider = {}
Slider.__index = Slider

function Slider.new(section, cfg)
    local window = section.tab.window
    local library = window.library
    local theme = library.Theme
    local scroll = section.tab.scroll
    local order = section:_nextOrder()

    local titleText = cfg.Name or "Slider"
    local descText  = cfg.Description or ""
    local minV      = cfg.Min or 0
    local maxV      = cfg.Max or 100
    local value     = cfg.Default or minV
    local onChange  = cfg.Callback
    local doNotify  = cfg.Notify ~= false

    local card, title, desc, cardStroke = makeCard(scroll, order, 150, theme)
    title.Text = titleText
    desc.Text  = descText

    local barW, barH = 300, 10
    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(0, barW, 0, barH)
    barBg.Position = UDim2.new(0, 24, 1, -46)
    barBg.BackgroundColor3 = theme.colors.toggleOff
    barBg.BorderSizePixel = 0
    barBg.Parent = card
    corner(barBg, barH/2)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = theme.colors.accent
    fill.BorderSizePixel = 0
    fill.Parent = barBg
    corner(fill, barH/2)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 26, 0, 26)
    knob.Position = UDim2.new(0, -13, 0.5, -13)
    knob.BackgroundColor3 = theme.colors.textPrimary
    knob.BorderSizePixel = 0
    knob.ZIndex = 5
    knob.Parent = barBg
    corner(knob, 13)
    stroke(knob, theme.colors.accent, 2, 0)

    local valueLbl = Instance.new("TextLabel")
    valueLbl.BackgroundTransparency = 1
    valueLbl.Text = tostring(value)
    valueLbl.TextColor3 = theme.colors.accent
    valueLbl.Font = Enum.Font.GothamBold
    valueLbl.TextSize = 18
    valueLbl.TextXAlignment = Enum.TextXAlignment.Right
    valueLbl.TextYAlignment = Enum.TextYAlignment.Center
    valueLbl.Size = UDim2.new(0, 80, 0, 26)
    valueLbl.Position = UDim2.new(1, -104, 1, -50)
    valueLbl.Parent = card

    local self = setmetatable({ _value = value, _min = minV, _max = maxV }, Slider)
    window:_registerComponent(self, cfg.Key or titleText)
    local dragging = false

    local function setRel(rel, fire)
        rel = math.clamp(rel, 0, 1)
        local v = math.floor(self._min + (self._max - self._min) * rel + 0.5)
        self._value = v
        valueLbl.Text = tostring(v)
        tween(fill, { Size = UDim2.new(rel, 0, 1, 0) }, 0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        tween(knob, { Position = UDim2.new(rel, -13, 0.5, -13) }, 0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        if fire and onChange then onChange(v) end
    end

    local function setFromX(absX)
        local barAbs = barBg.AbsolutePosition.X
        local barSize = barBg.AbsoluteSize.X
        if barSize <= 0 then return end
        setRel((absX - barAbs) / barSize, false)
    end

    local initialRel = (value - minV) / math.max(1, (maxV - minV))
    fill.Size = UDim2.new(initialRel, 0, 1, 0)
    knob.Position = UDim2.new(initialRel, -13, 0.5, -13)

    local hit = Instance.new("TextButton")
    hit.Size = UDim2.new(1, 0, 1, 0)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.AutoButtonColor = false
    hit.ZIndex = 10
    hit.Parent = card

    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            setFromX(input.Position.X)
        end
    end)

    local connChanged = UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            setFromX(input.Position.X)
        end
    end)

    local connEnded = UserInputService.InputEnded:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            if onChange then onChange(self._value) end
            if doNotify then library:Notify(titleText, "Set to " .. tostring(self._value)) end
        end
    end)

    function self:Set(v, fire)
        v = math.clamp(v, self._min, self._max)
        local rel = (v - self._min) / math.max(1, (self._max - self._min))
        self._value = v
        valueLbl.Text = tostring(v)
        tween(fill, { Size = UDim2.new(rel, 0, 1, 0) }, 0.1)
        tween(knob, { Position = UDim2.new(rel, -13, 0.5, -13) }, 0.1)
        if fire and onChange then onChange(v) end
    end
    function self:Get() return self._value end
    function self:SetMin(v) self._min = v end
    function self:SetMax(v) self._max = v end
    function self:Destroy()
        connChanged:Disconnect(); connEnded:Disconnect()
        card:Destroy()
    end

    return self
end

-- ============================================================
-- DROPDOWN
-- ============================================================
local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(section, cfg)
    local window = section.tab.window
    local library = window.library
    local theme = library.Theme
    local scroll = section.tab.scroll
    local order = section:_nextOrder()

    local titleText = cfg.Name or "Dropdown"
    local descText  = cfg.Description or ""
    local choices   = cfg.Options or {}
    local value     = cfg.Default or choices[1]
    local onChange  = cfg.Callback
    local doNotify  = cfg.Notify ~= false

    local card, title, desc, cardStroke = makeCard(scroll, order, nil, theme)
    title.Text = titleText
    desc.Text  = descText

    local ddBtn = Instance.new("TextButton")
    ddBtn.Size = UDim2.new(0, theme.sizes.controlW, 0, theme.sizes.controlH)
    ddBtn.Position = UDim2.new(1, -(theme.sizes.controlW + theme.sizes.controlRight), 0.5, -theme.sizes.controlH/2)
    ddBtn.BackgroundColor3 = theme.colors.navBg
    ddBtn.Text = value or "---"
    ddBtn.TextColor3 = theme.colors.textPrimary
    ddBtn.Font = Enum.Font.GothamBold
    ddBtn.TextSize = 17
    ddBtn.TextXAlignment = Enum.TextXAlignment.Left
    ddBtn.AutoButtonColor = false
    ddBtn.Parent = card
    corner(ddBtn, 10)
    local ddStroke = stroke(ddBtn, theme.colors.cardBorder, 1.5, 0)
    local padL = Instance.new("UIPadding")
    padL.PaddingLeft = UDim.new(0, 12)
    padL.Parent = ddBtn

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 0, theme.sizes.controlH)
    arrow.Position = UDim2.new(1, -24, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "^"
    arrow.TextColor3 = theme.colors.accent
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 16
    arrow.Rotation = 180
    arrow.Parent = ddBtn

    local self = setmetatable({ _value = value, _options = choices }, Dropdown)
    window:_registerComponent(self, cfg.Key or titleText)
    local ddListOpen, ddBackdrop, ddList = false, nil, nil

    local function closeDd()
        if not ddListOpen then return end
        ddListOpen = false
        if ddBackdrop and ddBackdrop.Parent then ddBackdrop:Destroy() end
        if ddList and ddList.Parent then ddList:Destroy() end
        ddBackdrop, ddList = nil, nil
        tween(ddStroke, { Color = theme.colors.cardBorder }, theme.anim.fast)
        tween(arrow, { Rotation = 180 }, theme.anim.fast)
    end

    local function openDd()
        if ddListOpen then closeDd() return end
        if #self._options == 0 then return end
        ddListOpen = true

        local wrapper = window._scaleWrapper
        local uiScale = window._uiScale

        ddBackdrop = Instance.new("TextButton")
        ddBackdrop.Size = UDim2.new(1, 0, 1, 0)
        ddBackdrop.BackgroundTransparency = 1
        ddBackdrop.Text = ""
        ddBackdrop.AutoButtonColor = false
        ddBackdrop.ZIndex = 60
        ddBackdrop.Parent = wrapper
        ddBackdrop.Activated:Connect(closeDd)

        local btnAbs = ddBtn.AbsolutePosition
        local wrapAbs = wrapper.AbsolutePosition
        local s = uiScale.Scale
        local relX = (btnAbs.X - wrapAbs.X) / s
        local relW = ddBtn.AbsoluteSize.X / s
        local btnTopY = (btnAbs.Y - wrapAbs.Y) / s

        local itemH = 38
        local listH = #self._options * itemH + 8
        local relY = btnTopY - listH - 6

        ddList = Instance.new("Frame")
        ddList.Size = UDim2.new(0, relW, 0, listH)
        ddList.Position = UDim2.new(0, relX, 0, relY)
        ddList.BackgroundColor3 = theme.colors.cardBg
        ddList.BorderSizePixel = 0
        ddList.ZIndex = 61
        ddList.Parent = wrapper
        corner(ddList, 10)
        stroke(ddList, theme.colors.accent, 1.5, 0)

        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 4)
        pad.PaddingBottom = UDim.new(0, 4)
        pad.Parent = ddList

        local lay = Instance.new("UIListLayout")
        lay.FillDirection = Enum.FillDirection.Vertical
        lay.Parent = ddList

        for i, choice in ipairs(self._options) do
            local item = Instance.new("TextButton")
            item.Size = UDim2.new(1, -8, 0, itemH)
            item.Position = UDim2.new(0, 4, 0, 0)
            item.BackgroundColor3 = theme.colors.cardBg
            item.BackgroundTransparency = 1
            item.Text = tostring(choice)
            item.TextColor3 = (choice == self._value) and theme.colors.accent or theme.colors.textPrimary
            item.Font = Enum.Font.GothamBold
            item.TextSize = 16
            item.TextXAlignment = Enum.TextXAlignment.Left
            item.AutoButtonColor = false
            item.LayoutOrder = i
            item.ZIndex = 62
            item.Parent = ddList
            corner(item, 6)

            local ipad = Instance.new("UIPadding")
            ipad.PaddingLeft = UDim.new(0, 10)
            ipad.Parent = item

            item.MouseEnter:Connect(function()
                tween(item, { BackgroundTransparency = 0, BackgroundColor3 = theme.colors.navBg }, theme.anim.fast)
            end)
            item.MouseLeave:Connect(function()
                tween(item, { BackgroundTransparency = 1 }, theme.anim.fast)
            end)
            item.Activated:Connect(function()
                self._value = choice
                ddBtn.Text = tostring(choice)
                closeDd()
                if onChange then onChange(choice) end
                if doNotify then library:Notify(titleText, "Selected: " .. tostring(choice)) end
            end)
        end

        tween(ddStroke, { Color = theme.colors.accent }, theme.anim.fast)
        tween(arrow, { Rotation = 0 }, theme.anim.fast)
    end

    ddBtn.Activated:Connect(openDd)
    ddBtn.MouseEnter:Connect(function() tween(ddBtn, { BackgroundColor3 = theme.colors.navBg }, theme.anim.fast) end)
    ddBtn.MouseLeave:Connect(function() tween(ddBtn, { BackgroundColor3 = theme.colors.navBg }, theme.anim.fast) end)

    function self:Set(v, fire)
        self._value = v
        ddBtn.Text = tostring(v)
        if fire and onChange then onChange(v) end
    end
    function self:Get() return self._value end
    function self:SetOptions(opts)
        self._options = opts or {}
        if not self._value or not table.find(self._options, self._value) then
            self._value = self._options[1]
            ddBtn.Text = tostring(self._value or "---")
        end
    end
    function self:AddOption(v) table.insert(self._options, v) end
    function self:Destroy() closeDd(); card:Destroy() end

    return self
end

-- ============================================================
-- INPUT
-- ============================================================
local Input = {}
Input.__index = Input

function Input.new(section, cfg)
    local window = section.tab.window
    local library = window.library
    local theme = library.Theme
    local scroll = section.tab.scroll
    local order = section:_nextOrder()

    local titleText = cfg.Name or "Input"
    local descText  = cfg.Description or ""
    local default   = cfg.Default or ""
    local numeric   = cfg.Numeric and true or false
    local onConfirm = cfg.Callback
    local doNotify  = cfg.Notify ~= false

    local card, title, desc, cardStroke = makeCard(scroll, order, nil, theme)
    title.Text = titleText
    desc.Text  = descText

    local boxW = theme.sizes.controlW
    local boxH = theme.sizes.controlH
    local right = theme.sizes.controlRight

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, boxW, 0, boxH)
    box.Position = UDim2.new(1, -(boxW + right), 0.5, -boxH/2)
    box.BackgroundColor3 = theme.colors.navBg
    box.Text = tostring(default)
    box.PlaceholderText = cfg.Placeholder or (numeric and "0" or "...")
    box.PlaceholderColor3 = theme.colors.textMuted
    box.TextColor3 = theme.colors.textPrimary
    box.Font = Enum.Font.GothamBold
    box.TextSize = 20
    box.TextXAlignment = Enum.TextXAlignment.Center
    box.ClearTextOnFocus = false
    box.ZIndex = 10
    box.Parent = card
    corner(box, 10)
    local boxStroke = stroke(box, theme.colors.cardBorder, 1.5, 0)

    local self = setmetatable({ _value = default, _numeric = numeric }, Input)
    window:_registerComponent(self, cfg.Key or titleText)

    box:GetPropertyChangedSignal("Text"):Connect(function()
        if self._numeric then
            local filtered = box.Text:gsub("[^%-%d%.]", "")
            if filtered ~= box.Text then box.Text = filtered end
            self._value = tonumber(filtered) or 0
        else
            self._value = box.Text
        end
    end)

    box.Focused:Connect(function()
        tween(boxStroke, { Color = theme.colors.accent }, theme.anim.fast)
    end)
    box.FocusLost:Connect(function()
        tween(boxStroke, { Color = theme.colors.cardBorder }, theme.anim.fast)
        if onConfirm then onConfirm(self._value) end
        if doNotify then library:Notify(titleText, "Value set to " .. tostring(self._value)) end
    end)

    function self:Set(v, fire)
        self._value = v
        box.Text = tostring(v)
        if fire and onConfirm then onConfirm(v) end
    end
    function self:Get() return self._value end
    function self:SetPlaceholder(t) box.PlaceholderText = t end
    function self:Destroy() card:Destroy() end

    return self
end

-- ============================================================
-- KEYBIND
-- ============================================================
local Keybind = {}
Keybind.__index = Keybind

function Keybind.new(section, cfg)
    local window = section.tab.window
    local library = window.library
    local theme = library.Theme
    local scroll = section.tab.scroll
    local order = section:_nextOrder()

    local titleText = cfg.Name or "Keybind"
    local descText  = cfg.Description or ""
    local default   = cfg.Default or "None"
    local onChange  = cfg.Callback
    local doNotify  = cfg.Notify ~= false
    local mode      = cfg.Mode or "Toggle"
    local holdVal   = false

    local card, title, desc, cardStroke = makeCard(scroll, order, 110, theme)
    title.Text = titleText
    desc.Text  = descText
    title.Size = UDim2.new(1, -160, 0, 28)
    title.Position = UDim2.new(0, 16, 0, 24)
    desc.Size = UDim2.new(1, -160, 0, 22)
    desc.Position = UDim2.new(0, 16, 0, 60)

    local keyBtn = Instance.new("TextButton")
    keyBtn.Size = UDim2.new(0, 130, 0, 46)
    keyBtn.Position = UDim2.new(1, -146, 0.5, -23)
    keyBtn.BackgroundColor3 = theme.colors.navBg
    keyBtn.Text = default
    keyBtn.TextColor3 = theme.colors.textPrimary
    keyBtn.Font = Enum.Font.GothamBold
    keyBtn.TextSize = 18
    keyBtn.AutoButtonColor = false
    keyBtn.Parent = card
    corner(keyBtn, 10)
    local keyStroke = stroke(keyBtn, theme.colors.cardBorder, 1.5, 0)

    local self = setmetatable({ _key = default, _listening = false, _conn = nil }, Keybind)
    window:_registerComponent(self, cfg.Key or titleText)

    keyBtn.Activated:Connect(function()
        if self._listening then return end
        self._listening = true
        keyBtn.Text = "Press a key..."
        tween(keyStroke, { Color = theme.colors.accent }, theme.anim.fast)

        local conn
        conn = UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            self._key = input.KeyCode.Name
            keyBtn.Text = self._key
            self._listening = false
            tween(keyStroke, { Color = theme.colors.cardBorder }, theme.anim.fast)
            conn:Disconnect()
            self._conn = nil
            if onChange then onChange(self._key) end
            if doNotify then library:Notify(titleText, "Set to " .. self._key) end
        end)
        self._conn = conn
    end)

    local listenerConn = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if self._listening then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if self._key == "None" or self._key == "" then return end
        if input.KeyCode == Enum.KeyCode[self._key] then
            if mode == "Hold" then
                if not holdVal then
                    holdVal = true
                    if onChange then onChange(true) end
                end
            else
                if onChange then onChange(self._key) end
            end
        end
    end)

    local listenerEnd = UserInputService.InputEnded:Connect(function(input)
        if mode ~= "Hold" then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if self._key == "None" or self._key == "" then return end
        if input.KeyCode == Enum.KeyCode[self._key] then
            if holdVal then
                holdVal = false
                if onChange then onChange(false) end
            end
        end
    end)

    function self:Set(key, fire)
        self._key = key
        keyBtn.Text = tostring(key)
        if fire and onChange then onChange(key) end
    end
    function self:Get() return self._key end
    function self:Destroy()
        listenerConn:Disconnect(); listenerEnd:Disconnect()
        if self._conn then self._conn:Disconnect() end
        card:Destroy()
    end

    return self
end

-- ============================================================
-- PARAGRAPH
-- ============================================================
local Paragraph = {}
Paragraph.__index = Paragraph

function Paragraph.new(section, cfg)
    local window = section.tab.window
    local theme = window.library.Theme
    local scroll = section.tab.scroll
    local order = section:_nextOrder()

    local titleText = cfg.Name or "Paragraph"
    local bodyText  = cfg.Content or cfg.Description or ""

    local card, title, desc = makeCard(scroll, order, 128, theme)
    title.Text = titleText
    title.Size = UDim2.new(1, -32, 0, 28)
    title.Position = UDim2.new(0, 16, 0, 18)

    desc.Text = bodyText
    desc.TextWrapped = true
    desc.Size = UDim2.new(1, -32, 1, -70)
    desc.Position = UDim2.new(0, 16, 0, 52)

    local self = setmetatable({}, Paragraph)
    function self:SetText(t) desc.Text = t end
    function self:SetTitle(t) title.Text = t end
    function self:Get() return nil end
    function self:Set() end
    function self:Destroy() card:Destroy() end
    return self
end

-- ============================================================
-- SECTION
-- ============================================================
local Section = {}
Section.__index = Section

function Section.new(tab, cfg)
    local self = setmetatable({ tab = tab, _order = 0, _label = nil }, Section)

    if cfg and cfg.Name and cfg.Name ~= "" then
        local theme = tab.window.library.Theme
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, theme.sizes.sectionHeaderH)
        label.BackgroundTransparency = 1
        label.Text = string.upper(cfg.Name)
        label.TextColor3 = theme.colors.sectionTitle
        label.Font = Enum.Font.GothamBold
        label.TextSize = theme.textSizes.sectionTitle
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.LayoutOrder = tab:_nextOrder()
        label.Parent = tab.scroll
        self._label = label
    end

    return self
end

function Section:_nextOrder()
    self._order = self._order + 1
    return self.tab:_nextOrder()
end

function Section:CreateButton(cfg)    return Button.new(self, cfg or {}) end
function Section:CreateToggle(cfg)    return Toggle.new(self, cfg or {}) end
function Section:CreateSlider(cfg)    return Slider.new(self, cfg or {}) end
function Section:CreateDropdown(cfg)  return Dropdown.new(self, cfg or {}) end
function Section:CreateInput(cfg)     return Input.new(self, cfg or {}) end
function Section:CreateKeybind(cfg)   return Keybind.new(self, cfg or {}) end
function Section:CreateParagraph(cfg) return Paragraph.new(self, cfg or {}) end

function Section:Destroy()
    if self._label and self._label.Parent then self._label:Destroy() end
end

-- ============================================================
-- TAB
-- ============================================================
local Tab = {}
Tab.__index = Tab

function Tab.new(window, cfg)
    local theme = window.library.Theme
    local self = setmetatable({
        window = window, _order = 0, _sections = {}, cfg = cfg or {}, _entry = nil,
    }, Tab)

    local iconId   = resolveIcon(cfg.Icon or cfg.IconId)
    local boost    = cfg.IconBoost or 0
    local baseSize = theme.sizes.iconSize + boost

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, theme.sizes.navBtnSize, 0, theme.sizes.navBtnSize)
    btn.BackgroundColor3 = theme.colors.navBg
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ClipsDescendants = false
    btn.LayoutOrder = window:_nextTabOrder()
    btn.Parent = window._navBar
    corner(btn, theme.sizes.navBtnRadius)
    local btnStroke = stroke(btn, theme.colors.navBorder, 2, 0)

    local iconGlow = Instance.new("ImageLabel")
    iconGlow.Size = UDim2.new(0, baseSize + 8, 0, baseSize + 8)
    iconGlow.Position = UDim2.new(0.5, -(baseSize+8)/2, 0.5, -(baseSize+8)/2)
    iconGlow.BackgroundTransparency = 1
    iconGlow.Image = iconId
    iconGlow.ImageColor3 = theme.colors.navIcon
    iconGlow.ImageTransparency = 0.85
    iconGlow.ScaleType = Enum.ScaleType.Fit
    iconGlow.ZIndex = 2
    iconGlow.Parent = btn

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, baseSize, 0, baseSize)
    icon.Position = UDim2.new(0.5, -baseSize/2, 0.5, -baseSize/2)
    icon.BackgroundTransparency = 1
    icon.Image = iconId
    icon.ImageColor3 = theme.colors.navIcon
    icon.ScaleType = Enum.ScaleType.Fit
    icon.ZIndex = 2
    icon.Parent = btn

    local hit = Instance.new("TextButton")
    hit.Size = UDim2.new(1, 0, 1, 1)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.AutoButtonColor = false
    hit.ZIndex = 3
    hit.Parent = btn

    self._entry = {
        button = btn, stroke = btnStroke, icon = icon, iconGlow = iconGlow,
        hit = hit, baseSize = baseSize,
    }
    self._tabId = cfg.Name or ("tab_" .. tostring(#window._tabs + 1))

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = theme.colors.accent
    scroll.ScrollBarImageTransparency = 0.3
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ClipsDescendants = true
    scroll.Visible = false
    scroll.Parent = window._contentContainer

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.Padding = UDim.new(0, theme.sizes.cardGap)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = scroll

    local padding = Instance.new("UIPadding")
    padding.PaddingTop    = UDim.new(0, 6)
    padding.PaddingBottom = UDim.new(0, 16)
    padding.PaddingLeft   = UDim.new(0, theme.sizes.scrollPadL)
    padding.PaddingRight  = UDim.new(0, theme.sizes.scrollPadR)
    padding.Parent = scroll

    self.scroll = scroll

    hit.Activated:Connect(function()
        if window._activeTab == self then return end
        window:SelectTab(self)
    end)

    return self
end

function Tab:_nextOrder()
    self._order = self._order + 1
    return self._order
end

function Tab:CreateSection(cfg)
    local sec = Section.new(self, cfg or {})
    table.insert(self._sections, sec)
    return sec
end

function Tab:Destroy()
    if self._entry.button and self._entry.button.Parent then self._entry.button:Destroy() end
    if self.scroll and self.scroll.Parent then self.scroll:Destroy() end
end

-- ============================================================
-- WINDOW
-- ============================================================
local Window = {}
Window.__index = Window

function Window.new(library, cfg)
    cfg = cfg or {}
    local theme = library.Theme
    local self = setmetatable({
        library = library, _tabs = {}, _activeTab = nil, _tabOrder = 0,
        _connections = {}, _components = {}, _destroyed = false,
        isOpen = false, isMinimized = false, _infoOpen = false, _dragging = false,
        _justRestored = false, _minimizedPos = nil, cfg = cfg,
    }, Window)

    self.title    = cfg.Title or library.Brand.Title
    self.subtitle = cfg.SubTitle or cfg.Subtitle or library.Brand.SubTitle
    self.version  = cfg.Version or library.Brand.Version
    self.about    = cfg.About or {
        Title = library.Brand.AboutTitle, Body = library.Brand.AboutBody,
        Discord = library.Brand.Discord, Enabled = library.Brand.AboutEnabled,
    }

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = cfg.Name or "BabisUILib"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 100
    screenGui.Parent = PlayerGui
    self.screenGui = screenGui

    local scaleWrapper = Instance.new("Frame")
    scaleWrapper.BackgroundTransparency = 1
    scaleWrapper.Size = UDim2.new(0, theme.sizes.windowWidth, 0, 0)
    scaleWrapper.Position = UDim2.new(0.5, 0, 0.5, 0)
    scaleWrapper.AnchorPoint = Vector2.new(0.5, 0.5)
    scaleWrapper.ClipsDescendants = true
    scaleWrapper.Parent = screenGui
    self._scaleWrapper = scaleWrapper

    local uiScale = Instance.new("UIScale")
    uiScale.Parent = scaleWrapper
    self._uiScale = uiScale

    local mainWindow = Instance.new("Frame")
    mainWindow.Size = UDim2.new(1, 0, 1, 0)
    mainWindow.BackgroundColor3 = theme.colors.windowBg
    mainWindow.BorderSizePixel = 0
    mainWindow.ClipsDescendants = true
    mainWindow.BackgroundTransparency = 1
    mainWindow.Parent = scaleWrapper
    corner(mainWindow, theme.sizes.windowRadius)
    self._mainWindow = mainWindow

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, theme.sizes.headerHeight)
    header.BackgroundColor3 = theme.colors.headerTint
    header.BackgroundTransparency = 1
    header.BorderSizePixel = 0
    header.Parent = mainWindow
    corner(header, theme.sizes.windowRadius)
    self._header = header

    local headerFlat = Instance.new("Frame")
    headerFlat.Size = UDim2.new(1, 0, 0, 16)
    headerFlat.Position = UDim2.new(0, 0, 1, -16)
    headerFlat.BackgroundColor3 = theme.colors.headerTint
    headerFlat.BackgroundTransparency = 1
    headerFlat.BorderSizePixel = 0
    headerFlat.Parent = header
    self._headerFlat = headerFlat

    local appLabel = Instance.new("TextLabel")
    appLabel.BackgroundTransparency = 1
    appLabel.Text = self.title
    appLabel.TextColor3 = theme.colors.accent
    appLabel.Font = theme.fonts.appName
    appLabel.TextSize = theme.textSizes.appName
    appLabel.TextXAlignment = Enum.TextXAlignment.Left
    appLabel.TextYAlignment = Enum.TextYAlignment.Center
    appLabel.Size = UDim2.new(0, 380, 0, 34)
    appLabel.Position = UDim2.new(0, 22, 0, 8)
    appLabel.Parent = header
    self._appLabel = appLabel

    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Text = self.subtitle
    subtitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    subtitleLabel.Font = Enum.Font.GothamBold
    subtitleLabel.TextSize = 14
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    subtitleLabel.TextYAlignment = Enum.TextYAlignment.Center
    subtitleLabel.Size = UDim2.new(0, 220, 0, 18)
    subtitleLabel.Position = UDim2.new(0, 24, 0, 42)
    subtitleLabel.Parent = header
    self._subtitleLabel = subtitleLabel

    local versionLabel = Instance.new("TextLabel")
    versionLabel.BackgroundTransparency = 1
    versionLabel.Text = self.version
    versionLabel.TextColor3 = theme.colors.textMuted
    versionLabel.Font = theme.fonts.version
    versionLabel.TextSize = theme.textSizes.version
    versionLabel.TextXAlignment = Enum.TextXAlignment.Left
    versionLabel.TextYAlignment = Enum.TextYAlignment.Center
    versionLabel.Size = UDim2.new(0, 200, 0, 16)
    versionLabel.Position = UDim2.new(0, 24, 0, 60)
    versionLabel.Parent = header
    self._versionLabel = versionLabel

    local infoBtn = Instance.new("TextButton")
    infoBtn.Size = UDim2.new(0, 60, 0, 60)
    infoBtn.Position = UDim2.new(1, -182, 0, 12)
    infoBtn.BackgroundTransparency = 1
    infoBtn.Text = ""
    infoBtn.AutoButtonColor = false
    infoBtn.Parent = header

    local infoIcon = Instance.new("ImageLabel")
    infoIcon.Size = UDim2.new(0, 30, 0, 30)
    infoIcon.Position = UDim2.new(0.5, -15, 0.5, -15)
    infoIcon.BackgroundTransparency = 1
    infoIcon.Image = library.Assets.infoIcon
    infoIcon.ImageColor3 = theme.colors.navIcon
    infoIcon.ScaleType = Enum.ScaleType.Fit
    infoIcon.Parent = infoBtn
    self._infoIcon = infoIcon

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 60, 0, 60)
    minBtn.Position = UDim2.new(1, -122, 0, 12)
    minBtn.BackgroundTransparency = 1
    minBtn.Text = ""
    minBtn.AutoButtonColor = false
    minBtn.Parent = header

    local minGlyph = Instance.new("Frame")
    minGlyph.Size = UDim2.new(0, 22, 0, 3)
    minGlyph.Position = UDim2.new(0.5, -11, 0.5, -1)
    minGlyph.BackgroundColor3 = theme.colors.textPrimary
    minGlyph.BorderSizePixel = 0
    minGlyph.Parent = minBtn
    corner(minGlyph, 2)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 60, 0, 60)
    closeBtn.Position = UDim2.new(1, -62, 0, 12)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = ""
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = header

    local xLen, xThk = 26, 3
    local xBar1 = Instance.new("Frame")
    xBar1.Size = UDim2.new(0, xLen, 0, xThk)
    xBar1.Position = UDim2.new(0.5, -xLen/2, 0.5, -xThk/2)
    xBar1.BackgroundColor3 = theme.colors.textPrimary
    xBar1.BorderSizePixel = 0
    xBar1.Rotation = 45
    xBar1.Parent = closeBtn
    corner(xBar1, 2)

    local xBar2 = Instance.new("Frame")
    xBar2.Size = UDim2.new(0, xLen, 0, xThk)
    xBar2.Position = UDim2.new(0.5, -xLen/2, 0.5, -xThk/2)
    xBar2.BackgroundColor3 = theme.colors.textPrimary
    xBar2.BorderSizePixel = 0
    xBar2.Rotation = -45
    xBar2.Parent = closeBtn
    corner(xBar2, 2)

    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, 0, 0, 2)
    divider.Position = UDim2.new(0, 0, 0, theme.sizes.headerHeight)
    divider.BackgroundColor3 = theme.colors.divider
    divider.BorderSizePixel = 0
    divider.ZIndex = 2
    divider.Parent = mainWindow

    local divGrad = Instance.new("UIGradient")
    divGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.85),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 0.85),
    })
    divGrad.Parent = divider

    local navBar = Instance.new("Frame")
    navBar.Size = UDim2.new(1, -theme.sizes.navPadX*2, 0, theme.sizes.navHeight)
    navBar.Position = UDim2.new(0, theme.sizes.navPadX, 0, theme.sizes.headerHeight + 12)
    navBar.BackgroundTransparency = 1
    navBar.Parent = mainWindow
    self._navBar = navBar

    local navLayout = Instance.new("UIListLayout")
    navLayout.FillDirection = Enum.FillDirection.Horizontal
    navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    navLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    navLayout.Padding = UDim.new(0, theme.sizes.navGap)
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navLayout.Parent = navBar

    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(1, -theme.sizes.contentPadX*2, 1,
        -(theme.sizes.headerHeight + theme.sizes.navHeight + 30))
    contentContainer.Position = UDim2.new(0, theme.sizes.contentPadX, 0,
        theme.sizes.headerHeight + theme.sizes.navHeight + 20)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = mainWindow
    self._contentContainer = contentContainer

    local infoFrame = Instance.new("Frame")
    infoFrame.Size = UDim2.new(1, -theme.sizes.contentPadX*2, 1, -(theme.sizes.headerHeight + 20))
    infoFrame.Position = UDim2.new(0, theme.sizes.contentPadX, 0, theme.sizes.headerHeight + 10)
    infoFrame.BackgroundColor3 = theme.colors.cardBg
    infoFrame.BorderSizePixel = 0
    infoFrame.Visible = false
    infoFrame.BackgroundTransparency = 1
    infoFrame.Parent = mainWindow
    corner(infoFrame, theme.sizes.cardRadius)
    local infoStroke = stroke(infoFrame, theme.colors.cardBorder, 1.5, 1)
    self._infoFrame = infoFrame
    self._infoStroke = infoStroke

    local aboutTitle = Instance.new("TextLabel")
    aboutTitle.BackgroundTransparency = 1
    aboutTitle.Text = self.about.Title or "About"
    aboutTitle.TextColor3 = theme.colors.accent
    aboutTitle.Font = Enum.Font.GothamBold
    aboutTitle.TextSize = theme.textSizes.aboutTitle
    aboutTitle.TextXAlignment = Enum.TextXAlignment.Left
    aboutTitle.TextYAlignment = Enum.TextYAlignment.Center
    aboutTitle.Size = UDim2.new(1, -32, 0, 40)
    aboutTitle.Position = UDim2.new(0, 18, 0, 20)
    aboutTitle.TextTransparency = 1
    aboutTitle.Parent = infoFrame
    self._aboutTitle = aboutTitle

    local aboutDesc = Instance.new("TextLabel")
    aboutDesc.BackgroundTransparency = 1
    aboutDesc.Text = self.about.Body or ""
    aboutDesc.TextColor3 = theme.colors.textPrimary
    aboutDesc.Font = Enum.Font.Gotham
    aboutDesc.TextSize = theme.textSizes.aboutDesc
    aboutDesc.TextXAlignment = Enum.TextXAlignment.Left
    aboutDesc.TextYAlignment = Enum.TextYAlignment.Top
    aboutDesc.TextWrapped = true
    aboutDesc.LineHeight = 1.2
    aboutDesc.Size = UDim2.new(1, -36, 1, -190)
    aboutDesc.Position = UDim2.new(0, 18, 0, 70)
    aboutDesc.TextTransparency = 1
    aboutDesc.Parent = infoFrame
    self._aboutDesc = aboutDesc

    local discordBtn = Instance.new("TextButton")
    discordBtn.Size = UDim2.new(1, -36, 0, 108)
    discordBtn.Position = UDim2.new(0, 18, 1, -128)
    discordBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    discordBtn.Text = ""
    discordBtn.AutoButtonColor = false
    discordBtn.BackgroundTransparency = 1
    discordBtn.Parent = infoFrame
    corner(discordBtn, 14)

    local dBtnGrad = Instance.new("Frame")
    dBtnGrad.Size = UDim2.new(1, 0, 1, 0)
    dBtnGrad.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dBtnGrad.BorderSizePixel = 0
    dBtnGrad.ZIndex = 1
    dBtnGrad.Parent = discordBtn
    corner(dBtnGrad, 14)

    local dBtnGradFill = Instance.new("UIGradient")
    dBtnGradFill.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(88, 101, 242)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 24, 45)),
    })
    dBtnGradFill.Parent = dBtnGrad

    local dBtnStroke = stroke(discordBtn, Color3.fromRGB(88, 101, 242), 1.5, 0.2)

    local dIcon = Instance.new("ImageLabel")
    dIcon.Size = UDim2.new(0, 76, 0, 76)
    dIcon.Position = UDim2.new(0, 16, 0.5, -38)
    dIcon.BackgroundTransparency = 1
    dIcon.Image = library.Assets.discordIcon
    dIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    dIcon.ScaleType = Enum.ScaleType.Fit
    dIcon.ZIndex = 2
    dIcon.Parent = discordBtn

    local dTitle = Instance.new("TextLabel")
    dTitle.BackgroundTransparency = 1
    dTitle.Text = "Discord"
    dTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    dTitle.Font = Enum.Font.GothamBold
    dTitle.TextSize = theme.textSizes.discordTitle
    dTitle.TextXAlignment = Enum.TextXAlignment.Left
    dTitle.TextYAlignment = Enum.TextYAlignment.Center
    dTitle.Size = UDim2.new(1, -130, 0, 32)
    dTitle.Position = UDim2.new(0, 108, 0, 22)
    dTitle.ZIndex = 2
    dTitle.Parent = discordBtn

    local dSub = Instance.new("TextLabel")
    dSub.BackgroundTransparency = 1
    dSub.Text = "Tap to copy the invite"
    dSub.TextColor3 = Color3.fromRGB(220, 225, 245)
    dSub.Font = Enum.Font.Gotham
    dSub.TextSize = theme.textSizes.discordSub
    dSub.TextXAlignment = Enum.TextXAlignment.Left
    dSub.TextYAlignment = Enum.TextYAlignment.Center
    dSub.Size = UDim2.new(1, -130, 0, 26)
    dSub.Position = UDim2.new(0, 108, 0, 58)
    dSub.ZIndex = 2
    dSub.Parent = discordBtn

    self._discordBtn = discordBtn
    self._dBtnGrad = dBtnGrad
    self._dBtnStroke = dBtnStroke
    self._dIcon = dIcon
    self._dTitle = dTitle
    self._dSub = dSub

    discordBtn.MouseEnter:Connect(function()
        tween(dBtnGradFill, { Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(105, 118, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 34, 60)),
        }) }, theme.anim.fast)
    end)
    discordBtn.MouseLeave:Connect(function()
        tween(dBtnGradFill, { Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(88, 101, 242)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 24, 45)),
        }) }, theme.anim.fast)
    end)
    discordBtn.Activated:Connect(function()
        local invite = self.about.Discord or library.Brand.Discord or ""
        if invite ~= "" then
            pcall(function() setclipboard(invite) end)
            library:Notify("Discord", "Invite copied: " .. invite)
        end
    end)

    local function closeInfo()
        if not self._infoOpen then return end
        self._infoOpen = false
        tween(aboutTitle, { TextTransparency = 1 }, 0.18)
        tween(aboutDesc,  { TextTransparency = 1 }, 0.18)
        tween(dTitle,     { TextTransparency = 1 }, 0.18)
        tween(dSub,       { TextTransparency = 1 }, 0.18)
        tween(dIcon,      { ImageTransparency = 1 }, 0.18)
        tween(dBtnGrad,   { BackgroundTransparency = 1 }, 0.18)
        tween(discordBtn, { BackgroundTransparency = 1 }, 0.18)
        tween(dBtnStroke, { Transparency = 1 }, 0.18)
        tween(infoFrame,  { BackgroundTransparency = 1 }, 0.22)
        tween(infoStroke, { Transparency = 1 }, 0.22)
        task.delay(0.24, function()
            infoFrame.Visible = false
            if self.isMinimized then
                navBar.Visible = false; contentContainer.Visible = false
            else
                navBar.Visible = true; contentContainer.Visible = true
                if self._activeTab then self._activeTab.scroll.Visible = true end
            end
            tween(infoIcon, { ImageColor3 = theme.colors.navIcon }, theme.anim.fast)
        end)
    end

    local function openInfo()
        if not self.about.Enabled then return end
        if self._infoOpen then closeInfo() return end
        if self.isMinimized then self:Restore() end

        self._infoOpen = true
        infoFrame.Visible = true
        infoFrame.BackgroundTransparency = 1
        infoStroke.Transparency = 1
        aboutTitle.TextTransparency = 1
        aboutDesc.TextTransparency = 1
        dTitle.TextTransparency = 1
        dSub.TextTransparency = 1
        dIcon.ImageTransparency = 1
        dBtnGrad.BackgroundTransparency = 1
        discordBtn.BackgroundTransparency = 1
        dBtnStroke.Transparency = 1

        navBar.Visible = false
        contentContainer.Visible = false
        for _, t in ipairs(self._tabs) do t.scroll.Visible = false end

        tween(infoFrame,  { BackgroundTransparency = 0 }, 0.28)
        tween(infoStroke, { Transparency = 0 }, 0.28)
        tween(aboutTitle, { TextTransparency = 0 }, 0.30)
        tween(aboutDesc,  { TextTransparency = 0 }, 0.36)
        task.delay(0.10, function()
            tween(dBtnGrad,   { BackgroundTransparency = 0 }, 0.28)
            tween(discordBtn, { BackgroundTransparency = 0 }, 0.28)
            tween(dBtnStroke, { Transparency = 0.2 }, 0.28)
            tween(dIcon,      { ImageTransparency = 0 }, 0.30)
            tween(dTitle,     { TextTransparency = 0 }, 0.30)
            tween(dSub,       { TextTransparency = 0 }, 0.32)
        end)
        tween(infoIcon, { ImageColor3 = theme.colors.navIconActive }, theme.anim.fast)
    end

    infoBtn.Activated:Connect(openInfo)
    infoBtn.MouseEnter:Connect(function()
        if not self._infoOpen then tween(infoIcon, { ImageColor3 = theme.colors.accentSoft }, theme.anim.fast) end
    end)
    infoBtn.MouseLeave:Connect(function()
        if not self._infoOpen then tween(infoIcon, { ImageColor3 = theme.colors.navIcon }, theme.anim.fast) end
    end)

    local function clampToViewport(px, py, overrideH)
        local cam = workspace.CurrentCamera
        if not cam then return px, py end
        local vp = cam.ViewportSize
        local s = uiScale.Scale or 1
        local w = scaleWrapper.Size.X.Offset * s
        local h = (overrideH or scaleWrapper.Size.Y.Offset) * s
        local halfW, halfH = w / 2, h / 2
        local minX, maxX = halfW, vp.X - halfW
        local minY, maxY = halfH, vp.Y - halfH
        if maxX < minX then px = vp.X / 2 else px = math.clamp(px, minX, maxX) end
        if maxY < minY then py = vp.Y / 2 else py = math.clamp(py, minY, maxY) end
        return px, py
    end
    self._clampToViewport = clampToViewport

    minBtn.Activated:Connect(function()
        if self.isMinimized then self:Restore() else self:Minimize() end
    end)

    closeBtn.Activated:Connect(function()
        self:Close()
        task.delay(theme.anim.normal + 0.05, function() screenGui:Destroy() end)
    end)

    minBtn.MouseEnter:Connect(function() tween(minGlyph, { BackgroundColor3 = theme.colors.accent }, theme.anim.fast) end)
    minBtn.MouseLeave:Connect(function() tween(minGlyph, { BackgroundColor3 = theme.colors.textPrimary }, theme.anim.fast) end)
    closeBtn.MouseEnter:Connect(function()
        tween(xBar1, { BackgroundColor3 = theme.colors.closeHover }, theme.anim.fast)
        tween(xBar2, { BackgroundColor3 = theme.colors.closeHover }, theme.anim.fast)
    end)
    closeBtn.MouseLeave:Connect(function()
        tween(xBar1, { BackgroundColor3 = theme.colors.textPrimary }, theme.anim.fast)
        tween(xBar2, { BackgroundColor3 = theme.colors.textPrimary }, theme.anim.fast)
    end)

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self._dragging = true
            self._dragStart = input.Position
            self._startPos = scaleWrapper.Position
        end
    end)

    self:_track(UserInputService.InputChanged:Connect(function(input)
        if not self._dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local cam = workspace.CurrentCamera
            if not cam then return end
            local vp = cam.ViewportSize
            local delta = input.Position - self._dragStart
            local baseX = self._startPos.X.Scale * vp.X + self._startPos.X.Offset
            local baseY = self._startPos.Y.Scale * vp.Y + self._startPos.Y.Offset
            local curH = self.isMinimized and (theme.sizes.headerHeight + 2) or theme.sizes.windowHeight
            local cx, cy = clampToViewport(baseX + delta.X, baseY + delta.Y, curH)
            scaleWrapper.Position = UDim2.new(0, cx, 0, cy)
            if self.isMinimized then self._minimizedPos = scaleWrapper.Position end
        end
    end))

    self:_track(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self._dragging = false
        end
    end))

    local function updateScale()
        local cam = workspace.CurrentCamera
        if not cam then return end
        local vp = cam.ViewportSize
        local sx = (vp.X - 16) / theme.sizes.windowWidth
        local sy = (vp.Y - 32) / theme.sizes.windowHeight
        local s = math.min(1.25, math.min(sx, sy))
        s = math.max(s, 0.55)
        uiScale.Scale = s
        local cur = scaleWrapper.Position
        local px = cur.X.Scale * vp.X + cur.X.Offset
        local py = cur.Y.Scale * vp.Y + cur.Y.Offset
        local h = self.isMinimized and (theme.sizes.headerHeight + 2) or theme.sizes.windowHeight
        local cx, cy = clampToViewport(px, py, h)
        scaleWrapper.Position = UDim2.new(0, cx, 0, cy)
        if self.isMinimized then self._minimizedPos = scaleWrapper.Position end
    end
    updateScale()
    if workspace.CurrentCamera then
        self:_track(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale))
    end

    return self
end

function Window:_track(conn)
    table.insert(self._connections, conn)
    return conn
end

function Window:_nextTabOrder()
    self._tabOrder = self._tabOrder + 1
    return self._tabOrder
end

function Window:_registerComponent(comp, key)
    comp._configKey = key or ("comp_" .. tostring(#self._components + 1))
    table.insert(self._components, comp)
end

function Window:CollectValues()
    local data = {}
    for _, comp in ipairs(self._components) do
        if comp._configKey and comp.Get then
            data[comp._configKey] = comp:Get()
        end
    end
    return data
end

function Window:ApplyValues(data)
    for _, comp in ipairs(self._components) do
        if comp._configKey and data[comp._configKey] ~= nil and comp.Set then
            pcall(function() comp:Set(data[comp._configKey], false) end)
        end
    end
end

function Window:ApplyBrand()
    local b = self.library.Brand
    if self._appLabel then self._appLabel.Text = self.cfg.Title or b.Title end
    if self._subtitleLabel then self._subtitleLabel.Text = self.cfg.SubTitle or b.SubTitle end
    if self._versionLabel then self._versionLabel.Text = self.cfg.Version or b.Version end
    if self._aboutTitle then self._aboutTitle.Text = b.AboutTitle end
    if self._aboutDesc then self._aboutDesc.Text = b.AboutBody end
    self.about.Discord = (self.cfg.About and self.cfg.About.Discord) or b.Discord
end

function Window:SetTitle(t) self._appLabel.Text = t end
function Window:SetSubtitle(t) self._subtitleLabel.Text = t end
function Window:SetVersion(t) self._versionLabel.Text = t end
function Window:SetDiscord(url) self.about.Discord = url end

function Window:CreateTab(cfg)
    local tab = Tab.new(self, cfg or {})
    table.insert(self._tabs, tab)
    if not self._activeTab then self:SelectTab(tab, false) end
    return tab
end

function Window:SelectTab(tab, doPop)
    if not tab then return end
    local theme = self.library.Theme

    for _, t in ipairs(self._tabs) do t.scroll.Visible = false end
    tab.scroll.Visible = true
    self._activeTab = tab

    for _, t in ipairs(self._tabs) do
        local e = t._entry
        local baseSize = e.baseSize
        if t == tab then
            e.icon.Size = UDim2.new(0, baseSize, 0, baseSize)
            tween(e.button, { BackgroundColor3 = theme.colors.navBg }, theme.anim.fast)
            tween(e.icon,   { ImageColor3 = theme.colors.navIconActive }, theme.anim.fast)
            tween(e.stroke, { Color = theme.colors.navActiveBrd, Transparency = 0, Thickness = 3.6 }, 0.18)
            task.delay(0.18, function() tween(e.stroke, { Thickness = 2.4 }, 0.22) end)
            tween(e.iconGlow, { ImageColor3 = theme.colors.navIconActive, ImageTransparency = 0.35 }, theme.anim.fast)

            if doPop then
                e.icon.Size = UDim2.new(0, baseSize * 0.75, 0, baseSize * 0.75)
                e.icon.Position = UDim2.new(0.5, -(baseSize * 0.75)/2, 0.5, -(baseSize * 0.75)/2)
                popTween(e.icon, {
                    Size = UDim2.new(0, baseSize * 1.18, 0, baseSize * 1.18),
                    Position = UDim2.new(0.5, -(baseSize * 1.18)/2, 0.5, -(baseSize * 1.18)/2),
                }, 0.22)
                task.delay(0.22, function()
                    tween(e.icon, {
                        Size = UDim2.new(0, baseSize, 0, baseSize),
                        Position = UDim2.new(0.5, -baseSize/2, 0.5, -baseSize/2),
                    }, 0.16)
                end)
            end
        else
            tween(e.button, { BackgroundColor3 = theme.colors.navBg }, theme.anim.fast)
            tween(e.stroke, { Color = theme.colors.navBorder, Transparency = 0, Thickness = 2 }, theme.anim.fast)
            tween(e.icon, { ImageColor3 = theme.colors.navIcon }, theme.anim.fast)
            tween(e.iconGlow, { ImageColor3 = theme.colors.navIcon, ImageTransparency = 0.85 }, theme.anim.fast)
            e.icon.Size = UDim2.new(0, baseSize, 0, baseSize)
            e.icon.Position = UDim2.new(0.5, -baseSize/2, 0.5, -baseSize/2)
        end
    end
end

function Window:Notify(title, message, duration)
    return self.library:Notify(title, message, duration)
end

-- ============================================================
-- MINIMIZE / RESTORE
-- ============================================================
function Window:Minimize()
    if self.isMinimized then return end
    self.isMinimized = true

    local theme = self.library.Theme
    local wrapper = self._scaleWrapper
    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
    local minH = theme.sizes.headerHeight + 2

    local targetPos
    if self._justRestored and self._minimizedPos then
        targetPos = self._minimizedPos
    else
        local px = wrapper.Position.X.Scale * vp.X + wrapper.Position.X.Offset
        local py = wrapper.Position.Y.Scale * vp.Y + wrapper.Position.Y.Offset
        targetPos = UDim2.new(0, px, 0, py)
    end
    self._justRestored = false

    local cx, cy = self._clampToViewport(targetPos.X.Offset, targetPos.Y.Offset, minH)
    self._minimizedPos = UDim2.new(0, cx, 0, cy)

    self._navBar.Visible = false
    self._contentContainer.Visible = false
    for _, t in ipairs(self._tabs) do t.scroll.Visible = false end
    if self._infoOpen then self._infoFrame.Visible = false end

    tween(wrapper, {
        Size = UDim2.new(0, theme.sizes.windowWidth, 0, minH),
        Position = self._minimizedPos,
    }, theme.anim.slow)
end

function Window:Restore()
    if not self.isMinimized then return end
    self.isMinimized = false
    self._justRestored = true

    local theme = self.library.Theme
    local wrapper = self._scaleWrapper
    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)

    local cx = vp.X / 2
    local cy = vp.Y / 2
    cx, cy = self._clampToViewport(cx, cy, theme.sizes.windowHeight)

    tween(wrapper, {
        Size = UDim2.new(0, theme.sizes.windowWidth, 0, theme.sizes.windowHeight),
        Position = UDim2.new(0, cx, 0, cy),
    }, theme.anim.slow)

    if self._infoOpen then
        self._infoFrame.Visible = true
        self._navBar.Visible = false
        self._contentContainer.Visible = false
        for _, t in ipairs(self._tabs) do t.scroll.Visible = false end
    else
        self._navBar.Visible = true
        self._contentContainer.Visible = true
        if self._activeTab then self._activeTab.scroll.Visible = true end
    end
end

function Window:Close()
    if not self.isOpen then return end
    self.isOpen = false
    local theme = self.library.Theme
    self._navBar.Visible = false
    self._contentContainer.Visible = false
    for _, t in ipairs(self._tabs) do t.scroll.Visible = false end
    if self._infoOpen then self._infoFrame.Visible = false end
    tween(self._scaleWrapper, { Size = UDim2.new(0, theme.sizes.windowWidth, 0, 0) }, theme.anim.normal)
end

function Window:Open(playEntrance)
    if self._destroyed or self.isOpen then return end
    self.isOpen = true

    local theme = self.library.Theme
    local wrapper = self._scaleWrapper
    local cam = workspace.CurrentCamera
    local px, py = 0, 0
    if cam then
        px = wrapper.Position.X.Scale * cam.ViewportSize.X + wrapper.Position.X.Offset
        py = wrapper.Position.Y.Scale * cam.ViewportSize.Y + wrapper.Position.Y.Offset
    end
    local cx, cy = self._clampToViewport(px, py, theme.sizes.windowHeight)
    wrapper.Position = UDim2.new(0, cx, 0, cy)

    if playEntrance ~= false then
        wrapper.Size = UDim2.new(0, theme.sizes.windowWidth, 0, 0)
        self._mainWindow.BackgroundTransparency = 1
        self._header.BackgroundTransparency = 1
        self._headerFlat.BackgroundTransparency = 1
        self._navBar.Visible = false
        self._contentContainer.Visible = false

        popTween(wrapper, {
            Size = UDim2.new(0, theme.sizes.windowWidth, 0, theme.sizes.windowHeight),
        }, 0.55)
        tween(self._mainWindow, { BackgroundTransparency = 0 }, 0.45)
        tween(self._header, { BackgroundTransparency = 0 }, 0.45)
        tween(self._headerFlat, { BackgroundTransparency = 0 }, 0.45)

        task.delay(0.35, function()
            self._navBar.Visible = true
            self._contentContainer.Visible = true
            if self._activeTab then self._activeTab.scroll.Visible = true end
            local scroll = self._activeTab and self._activeTab.scroll
            if scroll then
                for _, c in ipairs(scroll:GetChildren()) do
                    if c:IsA("Frame") then
                        c.BackgroundTransparency = 1
                        tween(c, { BackgroundTransparency = 0 }, 0.35)
                    elseif c:IsA("TextLabel") then
                        local orig = c.TextTransparency
                        c.TextTransparency = 1
                        tween(c, { TextTransparency = orig }, 0.35)
                    end
                end
            end
        end)
    else
        wrapper.Size = UDim2.new(0, theme.sizes.windowWidth, 0, theme.sizes.windowHeight)
        self._mainWindow.BackgroundTransparency = 0
        self._header.BackgroundTransparency = 0
        self._headerFlat.BackgroundTransparency = 0
        self._navBar.Visible = true
        self._contentContainer.Visible = true
        if self._activeTab then self._activeTab.scroll.Visible = true end
    end
end

-- ============================================================
-- SETTINGS PANEL (idêntico ao original: keybind + config card)
-- ============================================================
function Window:BuildSettingsPanel(section, opts)
    opts = opts or {}
    local library = self.library
    local theme = library.Theme
    local scroll = section.tab.scroll

    -- ── KEYBIND CARD ──
    local keybindCard = Instance.new("Frame")
    keybindCard.Size = UDim2.new(1, 0, 0, 110)
    keybindCard.BackgroundColor3 = theme.colors.cardBg
    keybindCard.BorderSizePixel = 0
    keybindCard.LayoutOrder = section:_nextOrder()
    keybindCard.Parent = scroll
    corner(keybindCard, theme.sizes.cardRadius)
    stroke(keybindCard, theme.colors.cardBorder, 1.5, 0)

    local kbTitle = Instance.new("TextLabel")
    kbTitle.BackgroundTransparency = 1
    kbTitle.Text = "Toggle Keybind"
    kbTitle.TextColor3 = theme.colors.textPrimary
    kbTitle.Font = Enum.Font.GothamBold
    kbTitle.TextSize = 24
    kbTitle.TextXAlignment = Enum.TextXAlignment.Left
    kbTitle.TextYAlignment = Enum.TextYAlignment.Top
    kbTitle.Size = UDim2.new(1, -160, 0, 28)
    kbTitle.Position = UDim2.new(0, 16, 0, 24)
    kbTitle.Parent = keybindCard

    local kbDesc = Instance.new("TextLabel")
    kbDesc.BackgroundTransparency = 1
    kbDesc.Text = "Key to open/close the interface"
    kbDesc.TextColor3 = theme.colors.textDesc
    kbDesc.Font = Enum.Font.Gotham
    kbDesc.TextSize = 15
    kbDesc.TextXAlignment = Enum.TextXAlignment.Left
    kbDesc.TextYAlignment = Enum.TextYAlignment.Top
    kbDesc.Size = UDim2.new(1, -160, 0, 22)
    kbDesc.Position = UDim2.new(0, 16, 0, 60)
    kbDesc.Parent = keybindCard

    local keyBtn = Instance.new("TextButton")
    keyBtn.Size = UDim2.new(0, 130, 0, 46)
    keyBtn.Position = UDim2.new(1, -146, 0.5, -23)
    keyBtn.BackgroundColor3 = theme.colors.navBg
    keyBtn.Text = opts.DefaultKeybind or "K"
    keyBtn.TextColor3 = theme.colors.textPrimary
    keyBtn.Font = Enum.Font.GothamBold
    keyBtn.TextSize = 18
    keyBtn.AutoButtonColor = false
    keyBtn.Parent = keybindCard
    corner(keyBtn, 10)
    local keyStroke = stroke(keyBtn, theme.colors.cardBorder, 1.5, 0)

    local listening = false
    local listenConn = nil
    local savedKey = opts.DefaultKeybind or "K"

    local function stopListening()
        listening = false
        if listenConn then pcall(function() listenConn:Disconnect() end) end
        listenConn = nil
        keyBtn.Text = savedKey
        tween(keyBtn, { BackgroundColor3 = theme.colors.navBg }, theme.anim.fast)
        tween(keyStroke, { Color = theme.colors.cardBorder }, theme.anim.fast)
    end

    keyBtn.MouseEnter:Connect(function()
        if not listening then
            tween(keyBtn, { BackgroundColor3 = theme.colors.navBg }, theme.anim.fast)
            tween(keyStroke, { Color = theme.colors.accent }, theme.anim.fast)
        end
    end)
    keyBtn.MouseLeave:Connect(function()
        if not listening then
            tween(keyStroke, { Color = theme.colors.cardBorder }, theme.anim.fast)
        end
    end)

    keyBtn.Activated:Connect(function()
        if listening then return end
        listening = true
        keyBtn.Text = "Press a key..."
        tween(keyStroke, { Color = theme.colors.accent }, theme.anim.fast)

        listenConn = UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            local key = input.KeyCode
            if key == Enum.KeyCode.Unknown then return end

            savedKey = key.Name
            stopListening()
            library:Notify("Keybind", "Set to " .. key.Name)
        end)
    end)

    -- global key listener for toggle
    self:_track(UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if listening then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if not savedKey or savedKey == "None" or savedKey == "" then return end
        if input.KeyCode == Enum.KeyCode[savedKey] then
            if self.isOpen then self:Close() else self:Open() end
        end
    end))

    -- ── CONFIG CARD ──
    local cfgCard = Instance.new("Frame")
    cfgCard.Size = UDim2.new(1, 0, 0, theme.sizes.cfgHeight)
    cfgCard.BackgroundColor3 = theme.colors.cardBg
    cfgCard.BorderSizePixel = 0
    cfgCard.LayoutOrder = section:_nextOrder()
    cfgCard.Parent = scroll
    corner(cfgCard, theme.sizes.cardRadius)
    stroke(cfgCard, theme.colors.cardBorder, 1.5, 0)

    local cfgIcon = Instance.new("ImageLabel")
    cfgIcon.Size = UDim2.new(0, 26, 0, 26)
    cfgIcon.Position = UDim2.new(0, 14, 0, 14)
    cfgIcon.BackgroundTransparency = 1
    cfgIcon.Image = library.Assets.cfgIcon
    cfgIcon.ImageColor3 = theme.colors.cfgIcon
    cfgIcon.ScaleType = Enum.ScaleType.Fit
    cfgIcon.Parent = cfgCard

    local cfgHeader = Instance.new("TextLabel")
    cfgHeader.Size = UDim2.new(1, -60, 0, 26)
    cfgHeader.Position = UDim2.new(0, 48, 0, 16)
    cfgHeader.BackgroundTransparency = 1
    cfgHeader.Text = "Configuration"
    cfgHeader.TextColor3 = theme.colors.textPrimary
    cfgHeader.Font = Enum.Font.GothamBold
    cfgHeader.TextSize = theme.textSizes.cfgTitle
    cfgHeader.TextXAlignment = Enum.TextXAlignment.Left
    cfgHeader.Parent = cfgCard

    local function smallLabel(y, text)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -28, 0, 22)
        lbl.Position = UDim2.new(0, 14, 0, y)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = theme.colors.textPrimary
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = theme.textSizes.cfgLabel
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = cfgCard
        return lbl
    end

    smallLabel(54, "Config name")

    local nameBox = Instance.new("TextBox")
    nameBox.Size = UDim2.new(1, -28, 0, 38)
    nameBox.Position = UDim2.new(0, 14, 0, 78)
    nameBox.BackgroundColor3 = theme.colors.cfgBtnBg
    nameBox.Text = ""
    nameBox.PlaceholderText = "type a name..."
    nameBox.PlaceholderColor3 = theme.colors.textMuted
    nameBox.TextColor3 = theme.colors.textPrimary
    nameBox.Font = Enum.Font.GothamBold
    nameBox.TextSize = theme.textSizes.cfgInput
    nameBox.TextXAlignment = Enum.TextXAlignment.Left
    nameBox.ClearTextOnFocus = false
    nameBox.Parent = cfgCard
    corner(nameBox, 8)
    local nameStroke = stroke(nameBox, theme.colors.cfgBtnBorder, 1.2, 0)
    local namePad = Instance.new("UIPadding")
    namePad.PaddingLeft = UDim.new(0, 12)
    namePad.Parent = nameBox

    nameBox.Focused:Connect(function() tween(nameStroke, { Color = theme.colors.accent }, theme.anim.fast) end)
    nameBox.FocusLost:Connect(function() tween(nameStroke, { Color = theme.colors.cfgBtnBorder }, theme.anim.fast) end)

    -- small button helper
    local function smallButton(y, text, onClick)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -28, 0, 34)
        btn.Position = UDim2.new(0, 14, 0, y)
        btn.BackgroundColor3 = theme.colors.cfgBtnBg
        btn.Text = text
        btn.TextColor3 = theme.colors.textPrimary
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = theme.textSizes.cfgBtn
        btn.AutoButtonColor = false
        btn.Parent = cfgCard
        corner(btn, 8)
        local s = stroke(btn, theme.colors.cfgBtnBorder, 1.2, 0)

        btn.MouseEnter:Connect(function()
            tween(btn, { BackgroundColor3 = theme.colors.navBg }, theme.anim.fast)
            tween(s, { Color = theme.colors.accent }, theme.anim.fast)
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, { BackgroundColor3 = theme.colors.cfgBtnBg }, theme.anim.fast)
            tween(s, { Color = theme.colors.cfgBtnBorder }, theme.anim.fast)
        end)
        btn.Activated:Connect(function()
            local osz, opos = btn.Size, btn.Position
            btn.Size = UDim2.new(1, -32, 0, 32)
            btn.Position = UDim2.new(0, 16, 0, y + 1)
            task.delay(0.07, function()
                btn.Size = osz; btn.Position = opos
            end)
            if onClick then onClick() end
        end)
        return btn
    end

    smallButton(126, "Create config", function()
        local name = nameBox.Text
        if name == "" then library:Notify("Config", "Enter a name first") return end
        local ok, err = library:SaveConfig(name, self:CollectValues())
        if ok then
            library:Notify("Config", "\"" .. name .. "\" created")
            nameBox.Text = ""
            if refreshCfgList then refreshCfgList() end
        else
            library:Notify("Config", "Failed: " .. tostring(err))
        end
    end)

    smallLabel(176, "Config list")

    local ddBtn = Instance.new("TextButton")
    ddBtn.Size = UDim2.new(1, -28, 0, 38)
    ddBtn.Position = UDim2.new(0, 14, 0, 200)
    ddBtn.BackgroundColor3 = theme.colors.cfgBtnBg
    ddBtn.Text = "---"
    ddBtn.TextColor3 = theme.colors.textPrimary
    ddBtn.Font = Enum.Font.GothamBold
    ddBtn.TextSize = theme.textSizes.cfgInput
    ddBtn.TextXAlignment = Enum.TextXAlignment.Left
    ddBtn.AutoButtonColor = false
    ddBtn.Parent = cfgCard
    corner(ddBtn, 8)
    local ddStroke = stroke(ddBtn, theme.colors.cfgBtnBorder, 1.2, 0)
    local ddPad = Instance.new("UIPadding")
    ddPad.PaddingLeft = UDim.new(0, 12)
    ddPad.Parent = ddBtn

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 24, 0, 38)
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "^"
    arrow.TextColor3 = theme.colors.textDesc
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 16
    arrow.Parent = ddBtn

    local selectedName = nil
    local ddListOpen, ddBackdrop, ddList = false, nil, nil

    local function closeDd()
        if not ddListOpen then return end
        ddListOpen = false
        if ddBackdrop and ddBackdrop.Parent then ddBackdrop:Destroy() end
        if ddList and ddList.Parent then ddList:Destroy() end
        ddBackdrop, ddList = nil, nil
        tween(ddStroke, { Color = theme.colors.cfgBtnBorder }, theme.anim.fast)
    end

    local function openDd()
        if ddListOpen then closeDd() return end
        ddListOpen = true

        ddBackdrop = Instance.new("TextButton")
        ddBackdrop.Size = UDim2.new(1, 0, 1, 0)
        ddBackdrop.BackgroundTransparency = 1
        ddBackdrop.Text = ""
        ddBackdrop.AutoButtonColor = false
        ddBackdrop.ZIndex = 60
        ddBackdrop.Parent = self._scaleWrapper
        ddBackdrop.Activated:Connect(closeDd)

        local list = library:ListConfigs()
        if #list == 0 then
            tween(ddStroke, { Color = theme.colors.accent }, theme.anim.fast)
            library:Notify("Config", "No configs found")
            closeDd()
            return
        end

        local btnAbs = ddBtn.AbsolutePosition
        local wrapAbs = self._scaleWrapper.AbsolutePosition
        local s = self._uiScale.Scale
        local relX = (btnAbs.X - wrapAbs.X) / s
        local relW = ddBtn.AbsoluteSize.X / s
        local btnTopY = (btnAbs.Y - wrapAbs.Y) / s

        local itemH = 34
        local listH = #list * itemH + 8
        local relY = btnTopY - listH - 6

        ddList = Instance.new("Frame")
        ddList.Size = UDim2.new(0, relW, 0, listH)
        ddList.Position = UDim2.new(0, relX, 0, relY)
        ddList.BackgroundColor3 = theme.colors.cardBg
        ddList.BorderSizePixel = 0
        ddList.ZIndex = 61
        ddList.Parent = self._scaleWrapper
        corner(ddList, 10)
        stroke(ddList, theme.colors.accent, 1.5, 0)

        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 4)
        pad.PaddingBottom = UDim.new(0, 4)
        pad.Parent = ddList

        local lay = Instance.new("UIListLayout")
        lay.FillDirection = Enum.FillDirection.Vertical
        lay.Parent = ddList

        for i, name in ipairs(list) do
            local item = Instance.new("TextButton")
            item.Size = UDim2.new(1, -8, 0, itemH)
            item.Position = UDim2.new(0, 4, 0, 0)
            item.BackgroundColor3 = theme.colors.cardBg
            item.BackgroundTransparency = 1
            item.Text = name
            item.TextColor3 = (name == selectedName) and theme.colors.accent or theme.colors.textPrimary
            item.Font = Enum.Font.GothamBold
            item.TextSize = 16
            item.TextXAlignment = Enum.TextXAlignment.Left
            item.AutoButtonColor = false
            item.LayoutOrder = i
            item.ZIndex = 62
            item.Parent = ddList
            corner(item, 6)

            local ipad = Instance.new("UIPadding")
            ipad.PaddingLeft = UDim.new(0, 10)
            ipad.Parent = item

            item.MouseEnter:Connect(function() tween(item, { BackgroundTransparency = 0, BackgroundColor3 = theme.colors.navBg }, theme.anim.fast) end)
            item.MouseLeave:Connect(function() tween(item, { BackgroundTransparency = 1 }, theme.anim.fast) end)
            item.Activated:Connect(function()
                selectedName = name
                ddBtn.Text = name
                closeDd()
            end)
        end

        tween(ddStroke, { Color = theme.colors.accent }, theme.anim.fast)
    end

    local function refreshCfgList()
        ddBtn.Text = selectedName or "---"
    end

    ddBtn.Activated:Connect(openDd)
    ddBtn.MouseEnter:Connect(function() tween(ddBtn, { BackgroundColor3 = theme.colors.navBg }, theme.anim.fast) end)
    ddBtn.MouseLeave:Connect(function() tween(ddBtn, { BackgroundColor3 = theme.colors.cfgBtnBg }, theme.anim.fast) end)

    smallButton(250, "Load config", function()
        if not selectedName then library:Notify("Config", "Select a config first") return end
        local data = library:LoadConfig(selectedName)
        if not data then library:Notify("Config", "Failed to load") return end
        self:ApplyValues(data)
        library:Notify("Config", "\"" .. selectedName .. "\" loaded")
    end)

    smallButton(288, "Overwrite config", function()
        if not selectedName then library:Notify("Config", "Select a config first") return end
        local ok, err = library:SaveConfig(selectedName, self:CollectValues())
        if ok then library:Notify("Config", "\"" .. selectedName .. "\" overwritten")
        else library:Notify("Config", "Failed: " .. tostring(err)) end
    end)

    smallButton(326, "Delete config", function()
        if not selectedName then library:Notify("Config", "Select a config first") return end
        library:DeleteConfig(selectedName)
        library:Notify("Config", "\"" .. selectedName .. "\" deleted")
        selectedName = nil
        ddBtn.Text = "---"
    end)

    smallButton(364, "Refresh list", function()
        library:Notify("Config", "List refreshed")
        if refreshCfgList then refreshCfgList() end
    end)

    smallButton(402, "Set as autoload", function()
        if not selectedName then library:Notify("Config", "Select a config first") return end
        library:SetAutoload(selectedName)
        if updateAutoloadText then updateAutoloadText() end
        library:Notify("Config", "\"" .. selectedName .. "\" set as autoload")
    end)

    smallButton(440, "Reset autoload", function()
        library:SetAutoload(nil)
        if updateAutoloadText then updateAutoloadText() end
        library:Notify("Config", "Autoload cleared")
    end)

    local autoloadText = Instance.new("TextLabel")
    autoloadText.Size = UDim2.new(1, -28, 0, 22)
    autoloadText.Position = UDim2.new(0, 14, 0, 482)
    autoloadText.BackgroundTransparency = 1
    autoloadText.Text = "Current autoload config: " .. (library:GetAutoload() or "none")
    autoloadText.TextColor3 = theme.colors.textDesc
    autoloadText.Font = Enum.Font.GothamBold
    autoloadText.TextSize = theme.textSizes.cfgHint
    autoloadText.TextXAlignment = Enum.TextXAlignment.Left
    autoloadText.Parent = cfgCard

    local function updateAutoloadText()
        autoloadText.Text = "Current autoload config: " .. (library:GetAutoload() or "none")
    end

    return {
        Refresh = refreshCfgList,
        UpdateAutoload = updateAutoloadText,
    }
end

function Window:Destroy()
    self._destroyed = true
    for _, c in ipairs(self._connections) do
        if c and c.Disconnect then c:Disconnect() end
    end
    self._connections = {}
    if self.screenGui and self.screenGui.Parent then self.screenGui:Destroy() end
end

-- ============================================================
-- LIBRARY
-- ============================================================
Library._windows = {}

function Library:CreateWindow(cfg)
    self._notifier = self._notifier or Notifier.new(self.Theme, self.Assets, self.Config)
    local w = Window.new(self, cfg or {})
    table.insert(self._windows, w)
    return w
end

function Library:Notify(title, message, duration)
    if not self._notifier then
        self._notifier = Notifier.new(self.Theme, self.Assets, self.Config)
    end
    return self._notifier:notify(title, message, duration)
end

function Library:SetTheme(overrides)
    local function merge(dst, src)
        for k, v in pairs(src) do
            if type(v) == "table" and type(dst[k]) == "table" then merge(dst[k], v)
            else dst[k] = v end
        end
    end
    merge(self.Theme, overrides or {})
end

return Library
