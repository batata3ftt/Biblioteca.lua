-- ============================================================
-- Babis | UI Kit v1.0.0
-- Standalone interface. Config system + notifications included.
-- ============================================================

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local SoundService      = game:GetService("SoundService")
local HttpService       = game:GetService("HttpService")
local LocalPlayer       = Players.LocalPlayer
local PlayerGui         = LocalPlayer:WaitForChild("PlayerGui")

-- cleanup
for _, n in ipairs({"BabisUIKit", "BabisUIKitNotif", "BabisIntro"}) do
    local old = PlayerGui:FindFirstChild(n)
    if old then old:Destroy() end
end

-- ============================================================
-- CONFIG
-- ============================================================
local CONFIG = {
    appName = "Babis | UI Kit",
    version = "v1.0.0",
    edition = "Interface Only",
    discordInvite = "hunter.exe7133",

    colors = {
        windowBg=Color3.fromRGB(8,10,14), headerTint=Color3.fromRGB(8,10,14), divider=Color3.fromRGB(65,150,245),
        accent=Color3.fromRGB(90,165,255), accentSoft=Color3.fromRGB(160,210,255), accentDark=Color3.fromRGB(40,90,160),
        navBg=Color3.fromRGB(18,18,19), navBorder=Color3.fromRGB(90,88,92), navIcon=Color3.fromRGB(52,61,69),
        navIconActive=Color3.fromRGB(160,210,255), navActiveBrd=Color3.fromRGB(160,210,255),
        cardBg=Color3.fromRGB(16,16,20), cardBorder=Color3.fromRGB(56,55,62),
        toggleOff=Color3.fromRGB(38,38,44), toggleOn=Color3.fromRGB(90,165,255),
        textPrimary=Color3.fromRGB(240,240,248), textDesc=Color3.fromRGB(150,148,168), textMuted=Color3.fromRGB(130,130,150),
        closeHover=Color3.fromRGB(220,70,90), handIdle=Color3.fromRGB(240,245,255), handHover=Color3.fromRGB(255,255,255),
        cfgIcon=Color3.fromRGB(170,120,255), cfgBtnBg=Color3.fromRGB(24,24,28), cfgBtnBorder=Color3.fromRGB(48,48,56),
        bellBg=Color3.fromRGB(30,38,48),
    },
    sizes = {
        windowWidth=460, windowHeight=700, windowRadius=22, headerHeight=82,
        navHeight=88, navBtnSize=70, navBtnRadius=14, navGap=8, navPadX=12,
        contentPadX=14, scrollPadL=6, scrollPadR=8, iconSize=46,
        cardRadius=16, cardPadX=16, cardGap=14,
        toggleW=72, toggleH=38, toggleKnob=30, toggleRight=22,
        controlW=130, controlH=44, controlRight=22, handIconSize=82, handIconY=20,
        cfgHeight=516,
    },
    fonts = { appName=Enum.Font.GothamBold, version=Enum.Font.Gotham, intro=Enum.Font.Code },
    textSizes = {
        appName=22, version=15, intro=20, cardTitle=24, cardDesc=15,
        cfgTitle=22, cfgLabel=17, cfgBtn=17, cfgHint=16, cfgInput=17,
        aboutTitle=30, aboutDesc=19, discordTitle=28, discordSub=18,
    },
    anim = { fast=0.14, normal=0.20, slow=0.32, easing=Enum.EasingStyle.Quint, dir=Enum.EasingDirection.Out },

    tabs = {
        { id="main",     name="Main",     iconId=7733960981,     boost=6 },
        { id="visual",   name="Visuals",  iconId=7733774602,     boost=0 },
        { id="player",   name="Player",   iconId=92187976272467, boost=46 },
        { id="misc",     name="Misc",     iconId=10723387563,    boost=0 },
        { id="settings", name="Settings", iconId=7734053495,     boost=0 },
    },
    defaultTab = "main",

    handIconId="rbxassetid://88060480140568", cfgIconId="rbxassetid://10709791036",
    infoIconId="rbxassetid://7733964719", discordIconId="rbxassetid://100770414662869",
    bellIconId="rbxassetid://7072706001", notifySoundId="rbxassetid://5153734608",
    notifySoundVol=0.5, introImageId="rbxassetid://119251117614023",
    introDuration=5.5, introImgW=156, introImgH=139,

    cfgFolder="Babis/configs", cfgExt=".json", autoloadFile="Babis/autoload.txt",
}

-- ============================================================
-- HELPERS
-- ============================================================
local function corner(parent, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r); c.Parent = parent; return c
end
local function stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color=color; s.Thickness=thickness or 1; s.Transparency=transparency or 0
    s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; s.Parent=parent; return s
end
local function tween(obj, props, dur, style, dir)
    local info = TweenInfo.new(dur or CONFIG.anim.normal, style or CONFIG.anim.easing, dir or CONFIG.anim.dir)
    local t = TweenService:Create(obj, info, props); t:Play(); return t
end
local function popTween(obj, props, dur)
    local info = TweenInfo.new(dur or 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props); t:Play(); return t
end
local function safeCall(fn, ...)
    if type(fn) ~= "function" then return false end
    local ok, res = pcall(fn, ...); if ok then return res end; return nil
end

-- ============================================================
-- INTRO
-- ============================================================
local function showIntro(onComplete)
    local introGui = Instance.new("ScreenGui")
    introGui.Name="BabisIntro"; introGui.ResetOnSpawn=false; introGui.IgnoreGuiInset=true
    introGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; introGui.DisplayOrder=200
    introGui.Parent=PlayerGui

    local overlay = Instance.new("Frame")
    overlay.Size=UDim2.new(1,0,1,0); overlay.BackgroundColor3=Color3.fromRGB(0,0,0)
    overlay.BackgroundTransparency=1; overlay.BorderSizePixel=0; overlay.Parent=introGui

    local center = Instance.new("Frame")
    center.Size=UDim2.new(0,260,0,260); center.Position=UDim2.new(0.5,0,0.5,-30)
    center.AnchorPoint=Vector2.new(0.5,0.5); center.BackgroundTransparency=1; center.Parent=overlay

    local glow = Instance.new("Frame")
    glow.Size=UDim2.new(0,220,0,220); glow.Position=UDim2.new(0.5,0,0.5,0)
    glow.AnchorPoint=Vector2.new(0.5,0.5); glow.BackgroundColor3=CONFIG.colors.accent
    glow.BackgroundTransparency=1; glow.BorderSizePixel=0; glow.Parent=center; corner(glow,110)

    local glowRing = Instance.new("Frame")
    glowRing.Size=UDim2.new(0,260,0,260); glowRing.Position=UDim2.new(0.5,0,0.5,0)
    glowRing.AnchorPoint=Vector2.new(0.5,0.5); glowRing.BackgroundTransparency=1
    glowRing.Parent=center; corner(glowRing,130)
    local ringStroke = stroke(glowRing, CONFIG.colors.accent, 1, 1)

    local image = Instance.new("ImageLabel")
    image.Size=UDim2.new(0,CONFIG.introImgW,0,CONFIG.introImgH)
    image.Position=UDim2.new(0.5,0,0.5,0); image.AnchorPoint=Vector2.new(0.5,0.5)
    image.BackgroundTransparency=1; image.Image=CONFIG.introImageId
    image.ImageTransparency=1; image.ScaleType=Enum.ScaleType.Fit; image.Parent=center

    local subtitle = Instance.new("TextLabel")
    subtitle.Size=UDim2.new(1,0,0,30); subtitle.Position=UDim2.new(0.5,0,0.5,120)
    subtitle.AnchorPoint=Vector2.new(0.5,0); subtitle.BackgroundTransparency=1
    subtitle.Text="CONNECTING TO SERVER"; subtitle.TextColor3=Color3.fromRGB(225,230,245)
    subtitle.TextTransparency=1; subtitle.Font=CONFIG.fonts.intro
    subtitle.TextSize=CONFIG.textSizes.intro; subtitle.TextXAlignment=Enum.TextXAlignment.Center
    subtitle.Parent=overlay

    local line = Instance.new("Frame")
    line.Size=UDim2.new(0,0,0,1); line.Position=UDim2.new(0.5,0,0.5,158)
    line.AnchorPoint=Vector2.new(0.5,0); line.BackgroundColor3=CONFIG.colors.accent
    line.BackgroundTransparency=1; line.BorderSizePixel=0; line.Parent=overlay

    tween(overlay, {BackgroundTransparency=0.55}, 0.5)
    tween(image, {ImageTransparency=0}, 0.5)
    tween(glow, {BackgroundTransparency=0.88}, 0.6)
    tween(ringStroke, {Transparency=0.6}, 0.6)
    tween(subtitle, {TextTransparency=0}, 0.5)
    tween(line, {BackgroundTransparency=0.2}, 0.5)
    tween(line, {Size=UDim2.new(0,190,0,1)}, 0.7)

    local spinning = true
    task.spawn(function()
        while spinning do
            local s = TweenService:Create(image, TweenInfo.new(1.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Rotation=image.Rotation+360})
            s:Play(); s.Completed:Wait()
            if not spinning then break end
            task.wait(0.45)
        end
    end)
    task.spawn(function()
        local base="CONNECTING TO SERVER"; local n=0
        while spinning do
            n=(n+1)%4; subtitle.Text=base..string.rep(".",n); task.wait(0.35)
        end
    end)
    task.spawn(function()
        while spinning do
            tween(glow, {BackgroundTransparency=0.95}, 0.9)
            tween(ringStroke, {Transparency=0.9}, 0.9)
            task.wait(0.9)
            if not spinning then break end
            tween(glow, {BackgroundTransparency=0.82}, 0.9)
            tween(ringStroke, {Transparency=0.4}, 0.9)
            task.wait(0.9)
        end
    end)
    task.delay(CONFIG.introDuration, function()
        spinning = false
        tween(overlay, {BackgroundTransparency=1}, 0.55)
        tween(image, {ImageTransparency=1}, 0.5)
        tween(glow, {BackgroundTransparency=1}, 0.5)
        tween(ringStroke, {Transparency=1}, 0.5)
        tween(subtitle, {TextTransparency=1}, 0.4)
        tween(line, {BackgroundTransparency=1}, 0.4)
        tween(line, {Size=UDim2.new(0,0,0,1)}, 0.5)
        task.wait(0.6)
        introGui:Destroy()
        if onComplete then onComplete() end
    end)
end

-- ============================================================
-- CONFIG SYSTEM
-- ============================================================
local ConfigSys = {}
do
    function ConfigSys.ensure()
        if not safeCall(isfolder, "Babis") then safeCall(makefolder, "Babis") end
        if not safeCall(isfolder, CONFIG.cfgFolder) then safeCall(makefolder, CONFIG.cfgFolder) end
    end
    function ConfigSys.list()
        ConfigSys.ensure()
        local out = {}
        local files = safeCall(listfiles, CONFIG.cfgFolder)
        if type(files) ~= "table" then return out end
        for _, path in ipairs(files) do
            local name = path:match("([^/\\]+)$") or path
            name = name:gsub(CONFIG.cfgExt:gsub("%.", "%%."), "")
            table.insert(out, name)
        end
        return out
    end
    function ConfigSys.save(name, data)
        ConfigSys.ensure()
        if type(name) ~= "string" or name == "" then return false, "invalid name" end
        local path = CONFIG.cfgFolder .. "/" .. name .. CONFIG.cfgExt
        local okEnc, resEnc = pcall(function() return HttpService:JSONEncode(data) end)
        if not okEnc then return false, "encode failed" end
        local ok = safeCall(writefile, path, resEnc)
        if ok == nil then return false, "writefile failed" end
        return true
    end
    function ConfigSys.load(name)
        ConfigSys.ensure()
        local path = CONFIG.cfgFolder .. "/" .. name .. CONFIG.cfgExt
        local content = safeCall(readfile, path)
        if type(content) ~= "string" then return nil end
        local ok, data = pcall(function() return HttpService:JSONDecode(content) end)
        if not ok then return nil end
        return data
    end
    function ConfigSys.delete(name)
        local path = CONFIG.cfgFolder .. "/" .. name .. CONFIG.cfgExt
        return safeCall(delfile, path) ~= nil
    end
    function ConfigSys.getAutoload()
        local content = safeCall(readfile, CONFIG.autoloadFile)
        if type(content) == "string" and content ~= "" then return content end
        return nil
    end
    function ConfigSys.setAutoload(name)
        ConfigSys.ensure()
        if name == nil or name == "" then safeCall(delfile, CONFIG.autoloadFile)
        else safeCall(writefile, CONFIG.autoloadFile, name) end
    end
end

-- ============================================================
-- NOTIFICATIONS
-- ============================================================
local function createNotifier()
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name="BabisUIKitNotif"; notifGui.ResetOnSpawn=false; notifGui.IgnoreGuiInset=true
    notifGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; notifGui.DisplayOrder=300
    notifGui.Parent=PlayerGui

    local sound = Instance.new("Sound")
    sound.SoundId=CONFIG.notifySoundId; sound.Volume=CONFIG.notifySoundVol
    sound.Parent=SoundService

    local container = Instance.new("Frame")
    container.BackgroundTransparency=1; container.Size=UDim2.new(0,320,0,0)
    container.AutomaticSize=Enum.AutomaticSize.Y; container.AnchorPoint=Vector2.new(1,0)
    container.Position=UDim2.new(1,-20,0,20); container.Parent=notifGui

    local layout = Instance.new("UIListLayout")
    layout.FillDirection=Enum.FillDirection.Vertical; layout.Padding=UDim.new(0,10)
    layout.SortOrder=Enum.SortOrder.LayoutOrder; layout.VerticalAlignment=Enum.VerticalAlignment.Top
    layout.HorizontalAlignment=Enum.HorizontalAlignment.Right; layout.Parent=container

    local ACCENT = CONFIG.colors.accent
    local order = 0

    local function dismiss(row)
        if not row or not row.Parent then return end
        if row:GetAttribute("Dismissing") then return end
        row:SetAttribute("Dismissing", true)
        local card = row:FindFirstChild("Card")
        local startSize = row.Size
        if card then
            card.AnchorPoint = Vector2.new(0, 0)
            tween(card, {Position=UDim2.new(1,420,0,0), BackgroundTransparency=0.7}, 0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            for _, d in ipairs(card:GetDescendants()) do
                if d:IsA("TextLabel") then tween(d, {TextTransparency=1}, 0.28)
                elseif d:IsA("ImageLabel") then tween(d, {ImageTransparency=1}, 0.28)
                elseif d:IsA("Frame") then tween(d, {BackgroundTransparency=1}, 0.28)
                elseif d:IsA("UIStroke") then tween(d, {Transparency=1}, 0.28) end
            end
        end
        tween(row, {Size=UDim2.new(startSize.X.Scale, startSize.X.Offset, 0, 0)}, 0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        task.delay(0.38, function() if row and row.Parent then row:Destroy() end end)
    end

    local function notify(title, message, duration)
        title=title or "Notification"; message=message or ""; duration=duration or 2.0
        if sound.IsPlaying then sound:Stop() end
        sound.TimePosition=0; sound:Play()

        order = order + 1
        local row = Instance.new("Frame")
        row.Size=UDim2.new(1,0,0,76); row.BackgroundTransparency=1
        row.ClipsDescendants=false; row.LayoutOrder=order; row.Parent=container

        local card = Instance.new("Frame")
        card.Name="Card"; card.Size=UDim2.new(1,0,1,0); card.Position=UDim2.new(1,380,0,0)
        card.BackgroundColor3=Color3.fromRGB(18,20,26); card.BorderSizePixel=0; card.Parent=row
        corner(card,12); stroke(card, Color3.fromRGB(56,55,62), 1.5, 0)

        local bar = Instance.new("Frame")
        bar.Size=UDim2.new(0,5,1,-22); bar.Position=UDim2.new(0,9,0,11)
        bar.BackgroundColor3=ACCENT; bar.BorderSizePixel=0; bar.Parent=card; corner(bar,3)

        local bellBg = Instance.new("Frame")
        bellBg.Size=UDim2.new(0,42,0,42); bellBg.Position=UDim2.new(0,20,0.5,-21)
        bellBg.BackgroundColor3=CONFIG.colors.bellBg; bellBg.BorderSizePixel=0; bellBg.Parent=card
        corner(bellBg,21); stroke(bellBg, ACCENT, 1.2, 0.4)

        local bell = Instance.new("ImageLabel")
        bell.Size=UDim2.new(0,28,0,28); bell.Position=UDim2.new(0.5,-14,0.5,-14)
        bell.BackgroundTransparency=1; bell.Image=CONFIG.bellIconId
        bell.ImageColor3=ACCENT; bell.ScaleType=Enum.ScaleType.Fit; bell.Parent=bellBg

        local titleLbl = Instance.new("TextLabel")
        titleLbl.BackgroundTransparency=1; titleLbl.Text=title
        titleLbl.TextColor3=Color3.fromRGB(245,248,255); titleLbl.Font=Enum.Font.GothamBold
        titleLbl.TextSize=16; titleLbl.TextXAlignment=Enum.TextXAlignment.Left
        titleLbl.TextYAlignment=Enum.TextYAlignment.Top
        titleLbl.Size=UDim2.new(1,-90,0,22); titleLbl.Position=UDim2.new(0,72,0,16)
        titleLbl.Parent=card

        local msgLbl = Instance.new("TextLabel")
        msgLbl.BackgroundTransparency=1; msgLbl.Text=message
        msgLbl.TextColor3=Color3.fromRGB(160,165,185); msgLbl.Font=Enum.Font.Gotham
        msgLbl.TextSize=14; msgLbl.TextXAlignment=Enum.TextXAlignment.Left
        msgLbl.TextYAlignment=Enum.TextYAlignment.Top; msgLbl.TextWrapped=true
        msgLbl.Size=UDim2.new(1,-90,0,34); msgLbl.Position=UDim2.new(0,72,0,38)
        msgLbl.Parent=card

        tween(card, {Position=UDim2.new(0,0,0,0)}, 0.35)

        task.spawn(function()
            task.wait(0.4)
            if not bell.Parent then return end
            bell.Rotation=-12
            tween(bell,{Rotation=12},0.10,Enum.EasingStyle.Quad,Enum.EasingDirection.Out); task.wait(0.11)
            if not bell.Parent then return end
            tween(bell,{Rotation=-8},0.10,Enum.EasingStyle.Quad,Enum.EasingDirection.Out); task.wait(0.11)
            if not bell.Parent then return end
            tween(bell,{Rotation=6},0.10,Enum.EasingStyle.Quad,Enum.EasingDirection.Out); task.wait(0.11)
            if not bell.Parent then return end
            tween(bell,{Rotation=0},0.12,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
        end)

        task.spawn(function() task.wait(duration); dismiss(row) end)
        return row
    end
    return notify
end

-- ============================================================
-- MAIN UI
-- ============================================================
local function buildMainUI()
    local notify = createNotifier()

    local UI = {
        activeTab = CONFIG.defaultTab,
        connections = {},
        isMinimized = false,
        isOpen = false,
        destroyed = false,
        options = {},
        infoOpen = false,
        cfgSelected = nil,
        cfgList = {},
        savedPos = nil,
        everOpened = false,
    }

    local function track(conn) table.insert(UI.connections, conn); return conn end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name="BabisUIKit"; screenGui.ResetOnSpawn=false; screenGui.IgnoreGuiInset=true
    screenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; screenGui.DisplayOrder=100
    screenGui.Parent=PlayerGui

    local scaleWrapper = Instance.new("Frame")
    scaleWrapper.BackgroundTransparency=1
    scaleWrapper.Size=UDim2.new(0, CONFIG.sizes.windowWidth, 0, 0)
    scaleWrapper.Position=UDim2.new(0.5, 0, 0.5, 0)
    scaleWrapper.AnchorPoint=Vector2.new(0.5, 0.5)
    scaleWrapper.ClipsDescendants=true
    scaleWrapper.Parent=screenGui

    local uiScale = Instance.new("UIScale"); uiScale.Parent=scaleWrapper

    local mainWindow = Instance.new("Frame")
    mainWindow.Size=UDim2.new(1,0,1,0); mainWindow.BackgroundColor3=CONFIG.colors.windowBg
    mainWindow.BorderSizePixel=0; mainWindow.ClipsDescendants=true
    mainWindow.BackgroundTransparency=1; mainWindow.Parent=scaleWrapper
    corner(mainWindow, CONFIG.sizes.windowRadius)

    -- viewport
    local function getViewport()
        local cam = workspace.CurrentCamera
        local vp = cam and cam.ViewportSize
        if not vp or vp.X <= 0 or vp.Y <= 0 then return Vector2.new(1920, 1080) end
        return vp
    end

    local function clampToViewport(px, py, overrideH)
        local vp = getViewport()
        local s = uiScale.Scale or 1
        local w = CONFIG.sizes.windowWidth * s
        local h = (overrideH or CONFIG.sizes.windowHeight) * s
        local halfW, halfH = w / 2, h / 2
        local minX, maxX = halfW, vp.X - halfW
        local minY, maxY = halfH, vp.Y - halfH
        if maxX < minX then px = vp.X / 2 else px = math.clamp(px, minX, maxX) end
        if maxY < minY then py = vp.Y / 2 else py = math.clamp(py, minY, maxY) end
        return px, py
    end

    local function centerPos(h)
        local vp = getViewport()
        local cx, cy = clampToViewport(vp.X / 2, vp.Y / 2, h)
        return UDim2.new(0, cx, 0, cy)
    end

    -- HEADER
    local header = Instance.new("Frame")
    header.Size=UDim2.new(1,0,0,CONFIG.sizes.headerHeight)
    header.BackgroundColor3=CONFIG.colors.headerTint; header.BackgroundTransparency=1
    header.BorderSizePixel=0; header.Parent=mainWindow
    corner(header, CONFIG.sizes.windowRadius)

    local headerFlat = Instance.new("Frame")
    headerFlat.Size=UDim2.new(1,0,0,16); headerFlat.Position=UDim2.new(0,0,1,-16)
    headerFlat.BackgroundColor3=CONFIG.colors.headerTint; headerFlat.BackgroundTransparency=1
    headerFlat.BorderSizePixel=0; headerFlat.Parent=header

    local appLabel = Instance.new("TextLabel")
    appLabel.BackgroundTransparency=1; appLabel.Text=CONFIG.appName
    appLabel.TextColor3=CONFIG.colors.accent; appLabel.Font=CONFIG.fonts.appName
    appLabel.TextSize=CONFIG.textSizes.appName; appLabel.TextXAlignment=Enum.TextXAlignment.Left
    appLabel.TextYAlignment=Enum.TextYAlignment.Center
    appLabel.Size=UDim2.new(0,380,0,34); appLabel.Position=UDim2.new(0,22,0,8)
    appLabel.Parent=header

    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.BackgroundTransparency=1; subtitleLabel.Text=CONFIG.edition
    subtitleLabel.TextColor3=Color3.fromRGB(255,255,255); subtitleLabel.Font=Enum.Font.GothamBold
    subtitleLabel.TextSize=14; subtitleLabel.TextXAlignment=Enum.TextXAlignment.Left
    subtitleLabel.TextYAlignment=Enum.TextYAlignment.Center
    subtitleLabel.Size=UDim2.new(0,220,0,18); subtitleLabel.Position=UDim2.new(0,24,0,42)
    subtitleLabel.Parent=header

    local versionLabel = Instance.new("TextLabel")
    versionLabel.BackgroundTransparency=1; versionLabel.Text=CONFIG.version
    versionLabel.TextColor3=CONFIG.colors.textMuted; versionLabel.Font=CONFIG.fonts.version
    versionLabel.TextSize=13; versionLabel.TextXAlignment=Enum.TextXAlignment.Left
    versionLabel.TextYAlignment=Enum.TextYAlignment.Center
    versionLabel.Size=UDim2.new(0,200,0,16); versionLabel.Position=UDim2.new(0,24,0,60)
    versionLabel.Parent=header

    local infoBtn = Instance.new("TextButton")
    infoBtn.Size=UDim2.new(0,60,0,60); infoBtn.Position=UDim2.new(1,-182,0,12)
    infoBtn.BackgroundTransparency=1; infoBtn.Text=""; infoBtn.AutoButtonColor=false
    infoBtn.Parent=header

    local infoIcon = Instance.new("ImageLabel")
    infoIcon.Size=UDim2.new(0,30,0,30); infoIcon.Position=UDim2.new(0.5,-15,0.5,-15)
    infoIcon.BackgroundTransparency=1; infoIcon.Image=CONFIG.infoIconId
    infoIcon.ImageColor3=CONFIG.colors.navIcon; infoIcon.ScaleType=Enum.ScaleType.Fit
    infoIcon.Parent=infoBtn

    local minBtn = Instance.new("TextButton")
    minBtn.Size=UDim2.new(0,60,0,60); minBtn.Position=UDim2.new(1,-122,0,12)
    minBtn.BackgroundTransparency=1; minBtn.Text=""; minBtn.AutoButtonColor=false
    minBtn.Parent=header

    local minGlyph = Instance.new("Frame")
    minGlyph.Size=UDim2.new(0,22,0,3); minGlyph.Position=UDim2.new(0.5,-11,0.5,-1)
    minGlyph.BackgroundColor3=CONFIG.colors.textPrimary; minGlyph.BorderSizePixel=0
    minGlyph.Parent=minBtn; corner(minGlyph, 2)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size=UDim2.new(0,60,0,60); closeBtn.Position=UDim2.new(1,-62,0,12)
    closeBtn.BackgroundTransparency=1; closeBtn.Text=""; closeBtn.AutoButtonColor=false
    closeBtn.Parent=header

    local xLen, xThk = 26, 3
    local xBar1 = Instance.new("Frame")
    xBar1.Size=UDim2.new(0,xLen,0,xThk); xBar1.Position=UDim2.new(0.5,-xLen/2,0.5,-xThk/2)
    xBar1.BackgroundColor3=CONFIG.colors.textPrimary; xBar1.BorderSizePixel=0
    xBar1.Rotation=45; xBar1.Parent=closeBtn; corner(xBar1, 2)

    local xBar2 = Instance.new("Frame")
    xBar2.Size=UDim2.new(0,xLen,0,xThk); xBar2.Position=UDim2.new(0.5,-xLen/2,0.5,-xThk/2)
    xBar2.BackgroundColor3=CONFIG.colors.textPrimary; xBar2.BorderSizePixel=0
    xBar2.Rotation=-45; xBar2.Parent=closeBtn; corner(xBar2, 2)

    local divider = Instance.new("Frame")
    divider.Size=UDim2.new(1,0,0,2); divider.Position=UDim2.new(0,0,0,CONFIG.sizes.headerHeight)
    divider.BackgroundColor3=CONFIG.colors.divider; divider.BorderSizePixel=0
    divider.ZIndex=2; divider.Parent=mainWindow

    local divGrad = Instance.new("UIGradient")
    divGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.85),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 0.85),
    })
    divGrad.Parent = divider

    -- BODY LAYER (nav + content + info, hidden when minimized)
    local bodyLayer = Instance.new("Frame")
    bodyLayer.Size=UDim2.new(1,0,1,0); bodyLayer.BackgroundTransparency=1
    bodyLayer.BorderSizePixel=0; bodyLayer.ClipsDescendants=false
    bodyLayer.Visible=false; bodyLayer.Parent=mainWindow

    -- NAV
    local navBar = Instance.new("Frame")
    navBar.Size=UDim2.new(1,-CONFIG.sizes.navPadX*2,0,CONFIG.sizes.navHeight)
    navBar.Position=UDim2.new(0,CONFIG.sizes.navPadX,0,CONFIG.sizes.headerHeight+12)
    navBar.BackgroundTransparency=1; navBar.Parent=bodyLayer

    local navLayout = Instance.new("UIListLayout")
    navLayout.FillDirection=Enum.FillDirection.Horizontal
    navLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
    navLayout.VerticalAlignment=Enum.VerticalAlignment.Center
    navLayout.Padding=UDim.new(0,CONFIG.sizes.navGap)
    navLayout.SortOrder=Enum.SortOrder.LayoutOrder
    navLayout.Parent=navBar

    -- CONTENT
    local contentContainer = Instance.new("Frame")
    contentContainer.Size=UDim2.new(1,-CONFIG.sizes.contentPadX*2,1,-(CONFIG.sizes.headerHeight+CONFIG.sizes.navHeight+30))
    contentContainer.Position=UDim2.new(0,CONFIG.sizes.contentPadX,0,CONFIG.sizes.headerHeight+CONFIG.sizes.navHeight+20)
    contentContainer.BackgroundTransparency=1; contentContainer.Parent=bodyLayer

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size=UDim2.new(1,0,1,0); scroll.BackgroundTransparency=1
    scroll.BorderSizePixel=0; scroll.ScrollBarThickness=4
    scroll.ScrollBarImageColor3=CONFIG.colors.accent; scroll.ScrollBarImageTransparency=0.3
    scroll.CanvasSize=UDim2.new(0,0,0,0); scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
    scroll.ClipsDescendants=true; scroll.Parent=contentContainer

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.FillDirection=Enum.FillDirection.Vertical
    contentLayout.Padding=UDim.new(0,CONFIG.sizes.cardGap)
    contentLayout.SortOrder=Enum.SortOrder.LayoutOrder
    contentLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
    contentLayout.Parent=scroll

    local contentPad = Instance.new("UIPadding")
    contentPad.PaddingTop=UDim.new(0,6); contentPad.PaddingBottom=UDim.new(0,16)
    contentPad.PaddingLeft=UDim.new(0,CONFIG.sizes.scrollPadL)
    contentPad.PaddingRight=UDim.new(0,CONFIG.sizes.scrollPadR)
    contentPad.Parent=scroll

    -- INFO FRAME
    local infoFrame = Instance.new("Frame")
    infoFrame.Size=UDim2.new(1,-CONFIG.sizes.contentPadX*2,1,-(CONFIG.sizes.headerHeight+20))
    infoFrame.Position=UDim2.new(0,CONFIG.sizes.contentPadX,0,CONFIG.sizes.headerHeight+10)
    infoFrame.BackgroundColor3=CONFIG.colors.cardBg; infoFrame.BorderSizePixel=0
    infoFrame.Visible=false; infoFrame.BackgroundTransparency=1; infoFrame.Parent=bodyLayer
    corner(infoFrame, CONFIG.sizes.cardRadius)
    local infoStroke = stroke(infoFrame, CONFIG.colors.cardBorder, 1.5, 1)

    local aboutTitle = Instance.new("TextLabel")
    aboutTitle.BackgroundTransparency=1; aboutTitle.Text="About"
    aboutTitle.TextColor3=CONFIG.colors.accent; aboutTitle.Font=Enum.Font.GothamBold
    aboutTitle.TextSize=CONFIG.textSizes.aboutTitle; aboutTitle.TextXAlignment=Enum.TextXAlignment.Left
    aboutTitle.TextYAlignment=Enum.TextYAlignment.Center
    aboutTitle.Size=UDim2.new(1,-32,0,40); aboutTitle.Position=UDim2.new(0,18,0,20)
    aboutTitle.TextTransparency=1; aboutTitle.Parent=infoFrame

    local aboutDesc = Instance.new("TextLabel")
    aboutDesc.BackgroundTransparency=1
    aboutDesc.Text="Babis | UI Kit\n\nInterface only build. Every component is a placeholder — wire your own logic to the callbacks.\n\nJoin the Discord below."
    aboutDesc.TextColor3=CONFIG.colors.textPrimary; aboutDesc.Font=Enum.Font.Gotham
    aboutDesc.TextSize=CONFIG.textSizes.aboutDesc; aboutDesc.TextXAlignment=Enum.TextXAlignment.Left
    aboutDesc.TextYAlignment=Enum.TextYAlignment.Top; aboutDesc.TextWrapped=true
    aboutDesc.LineHeight=1.2; aboutDesc.Size=UDim2.new(1,-36,1,-190)
    aboutDesc.Position=UDim2.new(0,18,0,70); aboutDesc.TextTransparency=1
    aboutDesc.Parent=infoFrame

    local discordBtn = Instance.new("TextButton")
    discordBtn.Size=UDim2.new(1,-36,0,108); discordBtn.Position=UDim2.new(0,18,1,-128)
    discordBtn.BackgroundColor3=Color3.fromRGB(255,255,255); discordBtn.Text=""
    discordBtn.AutoButtonColor=false; discordBtn.BackgroundTransparency=1
    discordBtn.Parent=infoFrame; corner(discordBtn, 14)

    local dBtnGrad = Instance.new("Frame")
    dBtnGrad.Size=UDim2.new(1,0,1,0); dBtnGrad.BackgroundColor3=Color3.fromRGB(255,255,255)
    dBtnGrad.BorderSizePixel=0; dBtnGrad.ZIndex=1; dBtnGrad.Parent=discordBtn
    corner(dBtnGrad, 14)

    local dBtnGradFill = Instance.new("UIGradient")
    dBtnGradFill.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(88,101,242)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(22,24,45)),
    })
    dBtnGradFill.Parent = dBtnGrad

    local dBtnStroke = stroke(discordBtn, Color3.fromRGB(88,101,242), 1.5, 0.2)

    local dIcon = Instance.new("ImageLabel")
    dIcon.Size=UDim2.new(0,76,0,76); dIcon.Position=UDim2.new(0,16,0.5,-38)
    dIcon.BackgroundTransparency=1; dIcon.Image=CONFIG.discordIconId
    dIcon.ImageColor3=Color3.fromRGB(255,255,255); dIcon.ScaleType=Enum.ScaleType.Fit
    dIcon.ZIndex=2; dIcon.Parent=discordBtn

    local dTitle = Instance.new("TextLabel")
    dTitle.BackgroundTransparency=1; dTitle.Text="Discord"
    dTitle.TextColor3=Color3.fromRGB(255,255,255); dTitle.Font=Enum.Font.GothamBold
    dTitle.TextSize=CONFIG.textSizes.discordTitle; dTitle.TextXAlignment=Enum.TextXAlignment.Left
    dTitle.TextYAlignment=Enum.TextYAlignment.Center
    dTitle.Size=UDim2.new(1,-130,0,32); dTitle.Position=UDim2.new(0,108,0,22)
    dTitle.ZIndex=2; dTitle.Parent=discordBtn

    local dSub = Instance.new("TextLabel")
    dSub.BackgroundTransparency=1; dSub.Text="Tap to copy the invite"
    dSub.TextColor3=Color3.fromRGB(220,225,245); dSub.Font=Enum.Font.Gotham
    dSub.TextSize=CONFIG.textSizes.discordSub; dSub.TextXAlignment=Enum.TextXAlignment.Left
    dSub.TextYAlignment=Enum.TextYAlignment.Center
    dSub.Size=UDim2.new(1,-130,0,26); dSub.Position=UDim2.new(0,108,0,58)
    dSub.ZIndex=2; dSub.Parent=discordBtn

    discordBtn.MouseEnter:Connect(function()
        tween(dBtnGradFill, {Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(105,118,255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(30,34,60)),
        })}, CONFIG.anim.fast)
    end)
    discordBtn.MouseLeave:Connect(function()
        tween(dBtnGradFill, {Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(88,101,242)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(22,24,45)),
        })}, CONFIG.anim.fast)
    end)
    discordBtn.Activated:Connect(function()
        pcall(function() setclipboard(CONFIG.discordInvite) end)
        notify("Discord", "Invite copied: " .. CONFIG.discordInvite)
    end)

    local function closeInfo()
        if not UI.infoOpen then return end
        UI.infoOpen = false
        tween(aboutTitle, {TextTransparency=1}, 0.18)
        tween(aboutDesc, {TextTransparency=1}, 0.18)
        tween(dTitle, {TextTransparency=1}, 0.18)
        tween(dSub, {TextTransparency=1}, 0.18)
        tween(dIcon, {ImageTransparency=1}, 0.18)
        tween(dBtnGrad, {BackgroundTransparency=1}, 0.18)
        tween(discordBtn, {BackgroundTransparency=1}, 0.18)
        tween(dBtnStroke, {Transparency=1}, 0.18)
        tween(infoFrame, {BackgroundTransparency=1}, 0.22)
        tween(infoStroke, {Transparency=1}, 0.22)
        task.delay(0.24, function()
            infoFrame.Visible = false
            navBar.Visible = true
            contentContainer.Visible = true
            tween(infoIcon, {ImageColor3=CONFIG.colors.navIcon}, CONFIG.anim.fast)
        end)
    end

    local function openInfo()
        if UI.infoOpen then closeInfo() return end
        if UI.isMinimized then UI.isMinimized = false; bodyLayer.Visible = true end
        UI.infoOpen = true
        infoFrame.Visible=true; infoFrame.BackgroundTransparency=1
        infoStroke.Transparency=1; aboutTitle.TextTransparency=1
        aboutDesc.TextTransparency=1; dTitle.TextTransparency=1
        dSub.TextTransparency=1; dIcon.ImageTransparency=1
        dBtnGrad.BackgroundTransparency=1; discordBtn.BackgroundTransparency=1
        dBtnStroke.Transparency=1
        navBar.Visible=false; contentContainer.Visible=false
        tween(infoFrame, {BackgroundTransparency=0}, 0.28)
        tween(infoStroke, {Transparency=0}, 0.28)
        tween(aboutTitle, {TextTransparency=0}, 0.30)
        tween(aboutDesc, {TextTransparency=0}, 0.36)
        task.delay(0.10, function()
            tween(dBtnGrad, {BackgroundTransparency=0}, 0.28)
            tween(discordBtn, {BackgroundTransparency=0}, 0.28)
            tween(dBtnStroke, {Transparency=0.2}, 0.28)
            tween(dIcon, {ImageTransparency=0}, 0.30)
            tween(dTitle, {TextTransparency=0}, 0.30)
            tween(dSub, {TextTransparency=0}, 0.32)
        end)
        tween(infoIcon, {ImageColor3=CONFIG.colors.navIconActive}, CONFIG.anim.fast)
    end

    infoBtn.Activated:Connect(openInfo)
    infoBtn.MouseEnter:Connect(function()
        if not UI.infoOpen then tween(infoIcon, {ImageColor3=CONFIG.colors.accentSoft}, CONFIG.anim.fast) end
    end)
    infoBtn.MouseLeave:Connect(function()
        if not UI.infoOpen then tween(infoIcon, {ImageColor3=CONFIG.colors.navIcon}, CONFIG.anim.fast) end
    end)

    -- TAB BUTTONS
    local tabButtons = {}
    local function createTabButton(tabData, order)
        local btn = Instance.new("TextButton")
        btn.Size=UDim2.new(0,CONFIG.sizes.navBtnSize,0,CONFIG.sizes.navBtnSize)
        btn.BackgroundColor3=CONFIG.colors.navBg; btn.Text=""; btn.AutoButtonColor=false
        btn.ClipsDescendants=false; btn.LayoutOrder=order; btn.Parent=navBar
        corner(btn, CONFIG.sizes.navBtnRadius)
        local btnStroke = stroke(btn, CONFIG.colors.navBorder, 2, 0)
        local baseSize = CONFIG.sizes.iconSize + (tabData.boost or 0)

        local iconGlow = Instance.new("ImageLabel")
        iconGlow.Size=UDim2.new(0,baseSize+8,0,baseSize+8)
        iconGlow.Position=UDim2.new(0.5,-(baseSize+8)/2,0.5,-(baseSize+8)/2)
        iconGlow.BackgroundTransparency=1; iconGlow.Image="rbxassetid://"..tabData.iconId
        iconGlow.ImageColor3=CONFIG.colors.navIcon; iconGlow.ImageTransparency=0.85
        iconGlow.ScaleType=Enum.ScaleType.Fit; iconGlow.ZIndex=2; iconGlow.Parent=btn

        local icon = Instance.new("ImageLabel")
        icon.Size=UDim2.new(0,baseSize,0,baseSize)
        icon.Position=UDim2.new(0.5,-baseSize/2,0.5,-baseSize/2)
        icon.BackgroundTransparency=1; icon.Image="rbxassetid://"..tabData.iconId
        icon.ImageColor3=CONFIG.colors.navIcon; icon.ScaleType=Enum.ScaleType.Fit
        icon.ZIndex=2; icon.Parent=btn

        local hit = Instance.new("TextButton")
        hit.Size=UDim2.new(1,0,1,1); hit.BackgroundTransparency=1; hit.Text=""
        hit.AutoButtonColor=false; hit.ZIndex=3; hit.Parent=btn

        return { button=btn, stroke=btnStroke, icon=icon, iconGlow=iconGlow, hit=hit, id=tabData.id, baseSize=baseSize }
    end
    for i, tab in ipairs(CONFIG.tabs) do tabButtons[tab.id] = createTabButton(tab, i) end

    -- CARD BASE
    local function createCard(order, height)
        local card = Instance.new("Frame")
        card.Size=UDim2.new(1,0,0,height or 128); card.BackgroundColor3=CONFIG.colors.cardBg
        card.BorderSizePixel=0; card.LayoutOrder=order; card.Parent=scroll
        corner(card, CONFIG.sizes.cardRadius)
        local cardStroke = stroke(card, CONFIG.colors.cardBorder, 1.5, 0)

        local title = Instance.new("TextLabel")
        title.BackgroundTransparency=1; title.TextColor3=CONFIG.colors.textPrimary
        title.Font=Enum.Font.GothamBold; title.TextSize=CONFIG.textSizes.cardTitle
        title.TextXAlignment=Enum.TextXAlignment.Left; title.TextYAlignment=Enum.TextYAlignment.Top
        title.Size=UDim2.new(1,-160,0,30); title.Position=UDim2.new(0,CONFIG.sizes.cardPadX,0,24)
        title.Parent=card

        local desc = Instance.new("TextLabel")
        desc.BackgroundTransparency=1; desc.TextColor3=CONFIG.colors.textDesc
        desc.Font=Enum.Font.Gotham; desc.TextSize=CONFIG.textSizes.cardDesc
        desc.TextXAlignment=Enum.TextXAlignment.Left; desc.TextYAlignment=Enum.TextYAlignment.Top
        desc.Size=UDim2.new(1,-160,0,22); desc.Position=UDim2.new(0,CONFIG.sizes.cardPadX,0,68)
        desc.Parent=card

        return card, title, desc, cardStroke
    end

    -- TOGGLE
    local function createToggleCard(order, titleText, descText, key, default, onChange)
        local card, title, desc = createCard(order)
        title.Text=titleText; desc.Text=descText
        if UI.options[key] == nil then UI.options[key] = default and true or false end

        local tW = CONFIG.sizes.toggleW; local tH = CONFIG.sizes.toggleH
        local knob = CONFIG.sizes.toggleKnob; local pad = (tH - knob)/2
        local right = CONFIG.sizes.toggleRight

        local track2 = Instance.new("Frame")
        track2.Size=UDim2.new(0,tW,0,tH); track2.Position=UDim2.new(1,-(tW+right),0.5,-tH/2)
        track2.BackgroundColor3=CONFIG.colors.toggleOff; track2.BorderSizePixel=0
        track2.Parent=card; corner(track2, tH/2)
        local trackStroke = stroke(track2, CONFIG.colors.cardBorder, 1.5, 0)

        local knobFrame = Instance.new("Frame")
        knobFrame.Size=UDim2.new(0,knob,0,knob); knobFrame.Position=UDim2.new(0,pad,0.5,-knob/2)
        knobFrame.BackgroundColor3=CONFIG.colors.textPrimary; knobFrame.BorderSizePixel=0
        knobFrame.Parent=track2; corner(knobFrame, knob/2)

        local hit = Instance.new("TextButton")
        hit.Size=UDim2.new(1,0,1,0); hit.BackgroundTransparency=1; hit.Text=""
        hit.AutoButtonColor=false; hit.ZIndex=10; hit.Parent=card

        local offX, onX = pad, tW - knob - pad
        local function render(animate)
            local dur = animate and CONFIG.anim.normal or 0
            if UI.options[key] then
                tween(track2, {BackgroundColor3=CONFIG.colors.toggleOn}, dur)
                tween(trackStroke, {Color=CONFIG.colors.toggleOn}, dur)
                tween(knobFrame, {Position=UDim2.new(0,onX,0.5,-knob/2)}, dur)
            else
                tween(track2, {BackgroundColor3=CONFIG.colors.toggleOff}, dur)
                tween(trackStroke, {Color=CONFIG.colors.cardBorder}, dur)
                tween(knobFrame, {Position=UDim2.new(0,offX,0.5,-knob/2)}, dur)
            end
        end
        render(false)

        track(hit.Activated:Connect(function()
            UI.options[key] = not UI.options[key]
            render(true)
            if onChange then onChange(UI.options[key], titleText) end
            notify(titleText, UI.options[key] and "Enabled" or "Disabled")
        end))
        return card
    end

    -- BUTTON (with click animation)
    local function createButtonCard(order, titleText, descText, onClick)
        local card, title, desc, cardStroke = createCard(order)
        title.Text=titleText; desc.Text=descText

        local iconSize = CONFIG.sizes.handIconSize
        local iconY    = CONFIG.sizes.handIconY
        local right    = CONFIG.sizes.controlRight

        local hand = Instance.new("ImageLabel")
        hand.Size=UDim2.new(0,iconSize,0,iconSize); hand.Position=UDim2.new(1,-(iconSize+right),0,iconY)
        hand.BackgroundTransparency=1; hand.Image=CONFIG.handIconId
        hand.ImageColor3=CONFIG.colors.handIdle; hand.ScaleType=Enum.ScaleType.Fit
        hand.Parent=card

        local flash = Instance.new("Frame")
        flash.Size=UDim2.new(1,0,1,0); flash.BackgroundColor3=CONFIG.colors.accent
        flash.BackgroundTransparency=1; flash.BorderSizePixel=0; flash.ZIndex=3
        flash.Parent=card; corner(flash, CONFIG.sizes.cardRadius)

        local hit = Instance.new("TextButton")
        hit.Size=UDim2.new(1,0,1,0); hit.BackgroundTransparency=1; hit.Text=""
        hit.AutoButtonColor=false; hit.ZIndex=5; hit.Parent=card

        track(hit.MouseEnter:Connect(function()
            tween(card, {BackgroundColor3=CONFIG.colors.navBg}, CONFIG.anim.fast)
            tween(cardStroke, {Color=CONFIG.colors.accent}, CONFIG.anim.fast)
            tween(hand, {ImageColor3=CONFIG.colors.handHover}, CONFIG.anim.fast)
        end))
        track(hit.MouseLeave:Connect(function()
            tween(card, {BackgroundColor3=CONFIG.colors.cardBg}, CONFIG.anim.fast)
            tween(cardStroke, {Color=CONFIG.colors.cardBorder}, CONFIG.anim.fast)
            tween(hand, {ImageColor3=CONFIG.colors.handIdle}, CONFIG.anim.fast)
        end))

        local playing = false
        track(hit.Activated:Connect(function()
            if playing then return end
            playing = true
            local baseSize = card.Size
            tween(card, {Size=UDim2.new(baseSize.X.Scale, baseSize.X.Offset-6, baseSize.Y.Scale, baseSize.Y.Offset-6)}, 0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            flash.BackgroundTransparency = 0.85
            tween(flash, {BackgroundTransparency=1}, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local origSize, origPos = hand.Size, hand.Position
            local pop = iconSize - 8
            tween(hand, {Size=UDim2.new(0,pop,0,pop), Position=UDim2.new(1,-(pop+right)-3,0,iconY+3), Rotation=12}, 0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            task.delay(0.08, function()
                popTween(hand, {Size=UDim2.new(0,iconSize+6,0,iconSize+6), Position=UDim2.new(1,-(iconSize+6+right)+3,0,iconY-3), Rotation=-6}, 0.18)
                task.delay(0.18, function() tween(hand, {Size=origSize, Position=origPos, Rotation=0}, 0.14) end)
            end)
            task.delay(0.08, function()
                popTween(card, {Size=UDim2.new(baseSize.X.Scale, baseSize.X.Offset+4, baseSize.Y.Scale, baseSize.Y.Offset+4)}, 0.16)
                task.delay(0.16, function() tween(card, {Size=baseSize}, 0.14) end)
            end)
            if onClick then onClick() end
            task.delay(0.4, function() playing = false end)
        end))
        return card
    end

    -- NUMBER
    local function createNumberCard(order, titleText, descText, key, default, onConfirm)
        local card, title, desc = createCard(order)
        title.Text=titleText; desc.Text=descText
        if UI.options[key] == nil then UI.options[key] = default or 0 end

        local boxW = CONFIG.sizes.controlW; local boxH = CONFIG.sizes.controlH
        local right = CONFIG.sizes.controlRight

        local box = Instance.new("TextBox")
        box.Size=UDim2.new(0,boxW,0,boxH); box.Position=UDim2.new(1,-(boxW+right),0.5,-boxH/2)
        box.BackgroundColor3=CONFIG.colors.navBg; box.Text=tostring(UI.options[key])
        box.PlaceholderText="0"; box.PlaceholderColor3=CONFIG.colors.textMuted
        box.TextColor3=CONFIG.colors.textPrimary; box.Font=Enum.Font.GothamBold
        box.TextSize=20; box.TextXAlignment=Enum.TextXAlignment.Center
        box.ClearTextOnFocus=false; box.ZIndex=10; box.Parent=card
        corner(box, 10); local boxStroke = stroke(box, CONFIG.colors.cardBorder, 1.5, 0)

        track(box:GetPropertyChangedSignal("Text"):Connect(function()
            local filtered = box.Text:gsub("[^%d]", "")
            if filtered ~= box.Text then box.Text = filtered end
            UI.options[key] = tonumber(filtered) or 0
        end))
        track(box.Focused:Connect(function() tween(boxStroke, {Color=CONFIG.colors.accent}, CONFIG.anim.fast) end))
        track(box.FocusLost:Connect(function()
            tween(boxStroke, {Color=CONFIG.colors.cardBorder}, CONFIG.anim.fast)
            if onConfirm then onConfirm(UI.options[key], titleText) end
            notify(titleText, "Value set to " .. tostring(UI.options[key]))
        end))
        return card, box
    end

    -- SLIDER
    local function createSliderCard(order, titleText, descText, key, minVal, maxVal, default, onChange)
        local card, title, desc = createCard(order, 150)
        title.Text=titleText; desc.Text=descText
        if UI.options[key] == nil then UI.options[key] = default or minVal end

        local barW, barH = 300, 10
        local barBg = Instance.new("Frame")
        barBg.Size=UDim2.new(0,barW,0,barH); barBg.Position=UDim2.new(0,24,1,-46)
        barBg.BackgroundColor3=CONFIG.colors.toggleOff; barBg.BorderSizePixel=0
        barBg.Parent=card; corner(barBg, barH/2)

        local fill = Instance.new("Frame")
        fill.Size=UDim2.new(0,0,1,0); fill.BackgroundColor3=CONFIG.colors.accent
        fill.BorderSizePixel=0; fill.Parent=barBg; corner(fill, barH/2)

        local knob = Instance.new("Frame")
        knob.Size=UDim2.new(0,26,0,26); knob.Position=UDim2.new(0,-13,0.5,-13)
        knob.BackgroundColor3=CONFIG.colors.textPrimary; knob.BorderSizePixel=0
        knob.ZIndex=5; knob.Parent=barBg; corner(knob, 13); stroke(knob, CONFIG.colors.accent, 2, 0)

        local valueLbl = Instance.new("TextLabel")
        valueLbl.BackgroundTransparency=1; valueLbl.Text=tostring(UI.options[key])
        valueLbl.TextColor3=CONFIG.colors.accent; valueLbl.Font=Enum.Font.GothamBold
        valueLbl.TextSize=18; valueLbl.TextXAlignment=Enum.TextXAlignment.Right
        valueLbl.TextYAlignment=Enum.TextYAlignment.Center
        valueLbl.Size=UDim2.new(0,80,0,26); valueLbl.Position=UDim2.new(1,-104,1,-50)
        valueLbl.Parent=card

        local dragging = false
        local function setFromX(absX)
            local barAbs = barBg.AbsolutePosition.X
            local barSize = barBg.AbsoluteSize.X
            local rel = math.clamp((absX - barAbs)/barSize, 0, 1)
            local val = math.floor(minVal + (maxVal - minVal)*rel + 0.5)
            UI.options[key] = val; valueLbl.Text = tostring(val)
            tween(fill, {Size=UDim2.new(rel,0,1,0)}, 0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            tween(knob, {Position=UDim2.new(rel,-13,0.5,-13)}, 0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        end
        local initialRel = (UI.options[key] - minVal) / (maxVal - minVal)
        fill.Size = UDim2.new(initialRel, 0, 1, 0)
        knob.Position = UDim2.new(initialRel, -13, 0.5, -13)

        local hit = Instance.new("TextButton")
        hit.Size=UDim2.new(1,0,1,0); hit.BackgroundTransparency=1; hit.Text=""
        hit.AutoButtonColor=false; hit.ZIndex=10; hit.Parent=card

        track(hit.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; setFromX(input.Position.X)
            end
        end))
        track(UserInputService.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                setFromX(input.Position.X)
            end
        end))
        track(UserInputService.InputEnded:Connect(function(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                if onChange then onChange(UI.options[key], titleText) end
                notify(titleText, "Set to " .. tostring(UI.options[key]))
            end
        end))
        return card
    end

    -- DROPDOWN
    local function createDropdownCard(order, titleText, descText, key, choices, default, onChange)
        local card, title, desc = createCard(order)
        title.Text=titleText; desc.Text=descText
        if UI.options[key] == nil then UI.options[key] = default or choices[1] end

        local ddBtn = Instance.new("TextButton")
        ddBtn.Size=UDim2.new(0,CONFIG.sizes.controlW,0,CONFIG.sizes.controlH)
        ddBtn.Position=UDim2.new(1,-(CONFIG.sizes.controlW+CONFIG.sizes.controlRight),0.5,-CONFIG.sizes.controlH/2)
        ddBtn.BackgroundColor3=CONFIG.colors.navBg; ddBtn.Text=UI.options[key]
        ddBtn.TextColor3=CONFIG.colors.textPrimary; ddBtn.Font=Enum.Font.GothamBold
        ddBtn.TextSize=17; ddBtn.TextXAlignment=Enum.TextXAlignment.Left
        ddBtn.AutoButtonColor=false; ddBtn.Parent=card
        corner(ddBtn, 10); local ddStroke = stroke(ddBtn, CONFIG.colors.cardBorder, 1.5, 0)
        local ddPad = Instance.new("UIPadding"); ddPad.PaddingLeft=UDim.new(0,12); ddPad.Parent=ddBtn

        local arrow = Instance.new("TextLabel")
        arrow.Size=UDim2.new(0,20,0,CONFIG.sizes.controlH); arrow.Position=UDim2.new(1,-24,0,0)
        arrow.BackgroundTransparency=1; arrow.Text="^"; arrow.TextColor3=CONFIG.colors.accent
        arrow.Font=Enum.Font.GothamBold; arrow.TextSize=16; arrow.Rotation=180
        arrow.Parent=ddBtn

        local ddListOpen, ddBackdrop, ddList = false, nil, nil
        local function closeDd()
            if not ddListOpen then return end
            ddListOpen = false
            if ddBackdrop and ddBackdrop.Parent then ddBackdrop:Destroy() end
            if ddList and ddList.Parent then ddList:Destroy() end
            ddBackdrop, ddList = nil, nil
            tween(ddStroke, {Color=CONFIG.colors.cardBorder}, CONFIG.anim.fast)
            tween(arrow, {Rotation=180}, CONFIG.anim.fast)
        end
        local function openDd()
            if ddListOpen then closeDd() return end
            ddListOpen = true

            ddBackdrop = Instance.new("TextButton")
            ddBackdrop.Size=UDim2.new(1,0,1,0); ddBackdrop.BackgroundTransparency=1
            ddBackdrop.Text=""; ddBackdrop.AutoButtonColor=false; ddBackdrop.ZIndex=60
            ddBackdrop.Parent=scaleWrapper; ddBackdrop.Activated:Connect(closeDd)

            local btnAbs = ddBtn.AbsolutePosition
            local wrapAbs = scaleWrapper.AbsolutePosition
            local s = uiScale.Scale
            local relX = (btnAbs.X - wrapAbs.X)/s
            local relW = ddBtn.AbsoluteSize.X/s
            local btnTopY = (btnAbs.Y - wrapAbs.Y)/s

            local itemH = 38
            local listH = #choices*itemH + 8
            local relY = btnTopY - listH - 6

            ddList = Instance.new("Frame")
            ddList.Size=UDim2.new(0,relW,0,listH); ddList.Position=UDim2.new(0,relX,0,relY)
            ddList.BackgroundColor3=CONFIG.colors.cardBg; ddList.BorderSizePixel=0
            ddList.ZIndex=61; ddList.Parent=scaleWrapper
            corner(ddList, 10); stroke(ddList, CONFIG.colors.accent, 1.5, 0)

            local pad = Instance.new("UIPadding")
            pad.PaddingTop=UDim.new(0,4); pad.PaddingBottom=UDim.new(0,4); pad.Parent=ddList

            local lay = Instance.new("UIListLayout"); lay.FillDirection=Enum.FillDirection.Vertical; lay.Parent=ddList

            for i, choice in ipairs(choices) do
                local item = Instance.new("TextButton")
                item.Size=UDim2.new(1,-8,0,itemH); item.Position=UDim2.new(0,4,0,0)
                item.BackgroundColor3=CONFIG.colors.cardBg; item.BackgroundTransparency=1
                item.Text=choice
                item.TextColor3 = (choice == UI.options[key]) and CONFIG.colors.accent or CONFIG.colors.textPrimary
                item.Font=Enum.Font.GothamBold; item.TextSize=16
                item.TextXAlignment=Enum.TextXAlignment.Left; item.AutoButtonColor=false
                item.LayoutOrder=i; item.ZIndex=62; item.Parent=ddList; corner(item, 6)
                local ipad = Instance.new("UIPadding"); ipad.PaddingLeft=UDim.new(0,10); ipad.Parent=item
                item.MouseEnter:Connect(function() tween(item, {BackgroundTransparency=0, BackgroundColor3=CONFIG.colors.navBg}, CONFIG.anim.fast) end)
                item.MouseLeave:Connect(function() tween(item, {BackgroundTransparency=1}, CONFIG.anim.fast) end)
                item.Activated:Connect(function()
                    UI.options[key] = choice; ddBtn.Text = choice
                    closeDd()
                    if onChange then onChange(choice, titleText) end
                    notify(titleText, "Selected: " .. choice)
                end)
            end

            tween(ddStroke, {Color=CONFIG.colors.accent}, CONFIG.anim.fast)
            tween(arrow, {Rotation=0}, CONFIG.anim.fast)
        end

        ddBtn.Activated:Connect(openDd)
        ddBtn.MouseEnter:Connect(function() tween(ddBtn, {BackgroundColor3=CONFIG.colors.navBg}, CONFIG.anim.fast) end)
        ddBtn.MouseLeave:Connect(function() tween(ddBtn, {BackgroundColor3=CONFIG.colors.navBg}, CONFIG.anim.fast) end)
        return card
    end

    -- CONFIG UI HELPERS
    local function smallButton(parent, y, text, onClick)
        local btn = Instance.new("TextButton")
        btn.Size=UDim2.new(1,-28,0,34); btn.Position=UDim2.new(0,14,0,y)
        btn.BackgroundColor3=CONFIG.colors.cfgBtnBg; btn.Text=text
        btn.TextColor3=CONFIG.colors.textPrimary; btn.Font=Enum.Font.GothamBold
        btn.TextSize=CONFIG.textSizes.cfgBtn; btn.AutoButtonColor=false
        btn.Parent=parent; corner(btn, 8)
        local s = stroke(btn, CONFIG.colors.cfgBtnBorder, 1.2, 0)
        btn.MouseEnter:Connect(function()
            tween(btn, {BackgroundColor3=CONFIG.colors.navBg}, CONFIG.anim.fast)
            tween(s, {Color=CONFIG.colors.accent}, CONFIG.anim.fast)
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, {BackgroundColor3=CONFIG.colors.cfgBtnBg}, CONFIG.anim.fast)
            tween(s, {Color=CONFIG.colors.cfgBtnBorder}, CONFIG.anim.fast)
        end)
        btn.Activated:Connect(function() if onClick then onClick() end end)
        return btn
    end

    local function smallLabel(parent, y, text)
        local lbl = Instance.new("TextLabel")
        lbl.Size=UDim2.new(1,-28,0,22); lbl.Position=UDim2.new(0,14,0,y)
        lbl.BackgroundTransparency=1; lbl.Text=text
        lbl.TextColor3=CONFIG.colors.textPrimary; lbl.Font=Enum.Font.GothamBold
        lbl.TextSize=CONFIG.textSizes.cfgLabel; lbl.TextXAlignment=Enum.TextXAlignment.Left
        lbl.Parent=parent
        return lbl
    end

    local function buildKeybindCard()
        local card = Instance.new("Frame")
        card.Size=UDim2.new(1,0,0,110); card.BackgroundColor3=CONFIG.colors.cardBg
        card.BorderSizePixel=0; card.LayoutOrder=0; card.Parent=scroll
        corner(card, CONFIG.sizes.cardRadius)
        stroke(card, CONFIG.colors.cardBorder, 1.5, 0)

        local title = Instance.new("TextLabel")
        title.BackgroundTransparency=1; title.Text="Toggle Keybind"
        title.TextColor3=CONFIG.colors.textPrimary; title.Font=Enum.Font.GothamBold
        title.TextSize=24; title.TextXAlignment=Enum.TextXAlignment.Left
        title.TextYAlignment=Enum.TextYAlignment.Top
        title.Size=UDim2.new(1,-160,0,28); title.Position=UDim2.new(0,16,0,24)
        title.Parent=card

        local desc = Instance.new("TextLabel")
        desc.BackgroundTransparency=1; desc.Text="Key to open/close the interface"
        desc.TextColor3=CONFIG.colors.textDesc; desc.Font=Enum.Font.Gotham
        desc.TextSize=15; desc.TextXAlignment=Enum.TextXAlignment.Left
        desc.TextYAlignment=Enum.TextYAlignment.Top
        desc.Size=UDim2.new(1,-160,0,22); desc.Position=UDim2.new(0,16,0,60)
        desc.Parent=card

        local keyBtn = Instance.new("TextButton")
        keyBtn.Size=UDim2.new(0,130,0,46); keyBtn.Position=UDim2.new(1,-146,0.5,-23)
        keyBtn.BackgroundColor3=CONFIG.colors.navBg; keyBtn.Text=UI.options["toggle_key"] or "None"
        keyBtn.TextColor3=CONFIG.colors.textPrimary; keyBtn.Font=Enum.Font.GothamBold
        keyBtn.TextSize=18; keyBtn.AutoButtonColor=false; keyBtn.Parent=card
        corner(keyBtn, 10); local keyStroke = stroke(keyBtn, CONFIG.colors.cardBorder, 1.5, 0)

        local listenConn = nil
        local listening = false
        local function stopListening()
            listening = false
            if listenConn then pcall(function() listenConn:Disconnect() end) end
            listenConn = nil
            keyBtn.Text = UI.options["toggle_key"] or "None"
            tween(keyStroke, {Color=CONFIG.colors.cardBorder}, CONFIG.anim.fast)
        end
        keyBtn.Activated:Connect(function()
            if listening then return end
            listening = true
            keyBtn.Text = "Press a key..."
            tween(keyStroke, {Color=CONFIG.colors.accent}, CONFIG.anim.fast)
            listenConn = UserInputService.InputBegan:Connect(function(input, gpe)
                if gpe then return end
                if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
                UI.options["toggle_key"] = input.KeyCode.Name
                stopListening()
                notify("Keybind", "Set to " .. input.KeyCode.Name)
            end)
        end)
    end

    local function buildConfigCard()
        local card = Instance.new("Frame")
        card.Size=UDim2.new(1,0,0,CONFIG.sizes.cfgHeight); card.BackgroundColor3=CONFIG.colors.cardBg
        card.BorderSizePixel=0; card.LayoutOrder=1; card.Parent=scroll
        corner(card, CONFIG.sizes.cardRadius); stroke(card, CONFIG.colors.cardBorder, 1.5, 0)

        local icon = Instance.new("ImageLabel")
        icon.Size=UDim2.new(0,26,0,26); icon.Position=UDim2.new(0,14,0,14)
        icon.BackgroundTransparency=1; icon.Image=CONFIG.cfgIconId
        icon.ImageColor3=CONFIG.colors.cfgIcon; icon.ScaleType=Enum.ScaleType.Fit
        icon.Parent=card

        local headerLbl = Instance.new("TextLabel")
        headerLbl.Size=UDim2.new(1,-60,0,26); headerLbl.Position=UDim2.new(0,48,0,16)
        headerLbl.BackgroundTransparency=1; headerLbl.Text="Configuration"
        headerLbl.TextColor3=CONFIG.colors.textPrimary; headerLbl.Font=Enum.Font.GothamBold
        headerLbl.TextSize=CONFIG.textSizes.cfgTitle; headerLbl.TextXAlignment=Enum.TextXAlignment.Left
        headerLbl.Parent=card

        smallLabel(card, 54, "Config name")

        local nameBox = Instance.new("TextBox")
        nameBox.Size=UDim2.new(1,-28,0,38); nameBox.Position=UDim2.new(0,14,0,78)
        nameBox.BackgroundColor3=CONFIG.colors.cfgBtnBg; nameBox.Text=""
        nameBox.PlaceholderText="type a name..."; nameBox.PlaceholderColor3=CONFIG.colors.textMuted
        nameBox.TextColor3=CONFIG.colors.textPrimary; nameBox.Font=Enum.Font.GothamBold
        nameBox.TextSize=CONFIG.textSizes.cfgInput; nameBox.TextXAlignment=Enum.TextXAlignment.Left
        nameBox.ClearTextOnFocus=false; nameBox.Parent=card
        corner(nameBox, 8); local nameStroke = stroke(nameBox, CONFIG.colors.cfgBtnBorder, 1.2, 0)
        local padLeft = Instance.new("UIPadding"); padLeft.PaddingLeft=UDim.new(0,12); padLeft.Parent=nameBox

        nameBox.Focused:Connect(function() tween(nameStroke, {Color=CONFIG.colors.accent}, CONFIG.anim.fast) end)
        nameBox.FocusLost:Connect(function() tween(nameStroke, {Color=CONFIG.colors.cfgBtnBorder}, CONFIG.anim.fast) end)

        smallButton(card, 126, "Create config", function()
            local name = nameBox.Text
            if name == "" then notify("Config", "Enter a name first") return end
            local ok, err = ConfigSys.save(name, UI.options)
            if ok then
                notify("Config", "\"" .. name .. "\" created")
                nameBox.Text = ""
                UI.cfgList = ConfigSys.list()
                if UI.refreshCfgList then UI.refreshCfgList() end
            else
                notify("Config", "Failed: " .. tostring(err))
            end
        end)

        smallLabel(card, 176, "Config list")

        local ddBtn = Instance.new("TextButton")
        ddBtn.Size=UDim2.new(1,-28,0,38); ddBtn.Position=UDim2.new(0,14,0,200)
        ddBtn.BackgroundColor3=CONFIG.colors.cfgBtnBg; ddBtn.Text="---"
        ddBtn.TextColor3=CONFIG.colors.textPrimary; ddBtn.Font=Enum.Font.GothamBold
        ddBtn.TextSize=CONFIG.textSizes.cfgInput; ddBtn.TextXAlignment=Enum.TextXAlignment.Left
        ddBtn.AutoButtonColor=false; ddBtn.Parent=card
        corner(ddBtn, 8); local ddStroke = stroke(ddBtn, CONFIG.colors.cfgBtnBorder, 1.2, 0)
        local ddPad = Instance.new("UIPadding"); ddPad.PaddingLeft=UDim.new(0,12); ddPad.Parent=ddBtn

        local arrow = Instance.new("TextLabel")
        arrow.Size=UDim2.new(0,24,0,38); arrow.Position=UDim2.new(1,-30,0,0)
        arrow.BackgroundTransparency=1; arrow.Text="^"
        arrow.TextColor3=CONFIG.colors.textDesc; arrow.Font=Enum.Font.GothamBold
        arrow.TextSize=16; arrow.Parent=ddBtn

        local ddListOpen, ddBackdrop, ddList = false, nil, nil
        local function closeDd()
            if not ddListOpen then return end
            ddListOpen = false
            if ddBackdrop and ddBackdrop.Parent then ddBackdrop:Destroy() end
            if ddList and ddList.Parent then ddList:Destroy() end
            ddBackdrop, ddList = nil, nil
        end
        local function openDd()
            if ddListOpen then closeDd() return end
            ddListOpen = true

            ddBackdrop = Instance.new("TextButton")
            ddBackdrop.Size=UDim2.new(1,0,1,0); ddBackdrop.BackgroundTransparency=1
            ddBackdrop.Text=""; ddBackdrop.AutoButtonColor=false; ddBackdrop.ZIndex=60
            ddBackdrop.Parent=scaleWrapper; ddBackdrop.Activated:Connect(closeDd)

            UI.cfgList = ConfigSys.list()
            local list = UI.cfgList
            if #list == 0 then notify("Config", "No configs found"); closeDd(); return end

            local btnAbs = ddBtn.AbsolutePosition
            local wrapAbs = scaleWrapper.AbsolutePosition
            local s = uiScale.Scale
            local relX = (btnAbs.X - wrapAbs.X)/s
            local relW = ddBtn.AbsoluteSize.X/s
            local btnTopY = (btnAbs.Y - wrapAbs.Y)/s
            local itemH = 34
            local listH = #list*itemH + 8
            local relY = btnTopY - listH - 6

            ddList = Instance.new("Frame")
            ddList.Size=UDim2.new(0,relW,0,listH); ddList.Position=UDim2.new(0,relX,0,relY)
            ddList.BackgroundColor3=CONFIG.colors.cardBg; ddList.BorderSizePixel=0
            ddList.ZIndex=61; ddList.Parent=scaleWrapper
            corner(ddList, 10); stroke(ddList, CONFIG.colors.accent, 1.5, 0)

            local pad = Instance.new("UIPadding")
            pad.PaddingTop=UDim.new(0,4); pad.PaddingBottom=UDim.new(0,4); pad.Parent=ddList
            local lay = Instance.new("UIListLayout"); lay.FillDirection=Enum.FillDirection.Vertical; lay.Parent=ddList

            for i, name in ipairs(list) do
                local item = Instance.new("TextButton")
                item.Size=UDim2.new(1,-8,0,itemH); item.Position=UDim2.new(0,4,0,0)
                item.BackgroundTransparency=1; item.Text=name
                item.TextColor3 = (name == UI.cfgSelected) and CONFIG.colors.accent or CONFIG.colors.textPrimary
                item.Font=Enum.Font.GothamBold; item.TextSize=16
                item.TextXAlignment=Enum.TextXAlignment.Left; item.AutoButtonColor=false
                item.LayoutOrder=i; item.ZIndex=62; item.Parent=ddList; corner(item, 6)
                local ipad = Instance.new("UIPadding"); ipad.PaddingLeft=UDim.new(0,10); ipad.Parent=item
                item.MouseEnter:Connect(function() tween(item, {BackgroundTransparency=0, BackgroundColor3=CONFIG.colors.navBg}, CONFIG.anim.fast) end)
                item.MouseLeave:Connect(function() tween(item, {BackgroundTransparency=1}, CONFIG.anim.fast) end)
                item.Activated:Connect(function()
                    UI.cfgSelected = name; ddBtn.Text = name; closeDd()
                end)
            end
        end

        UI.refreshCfgList = function()
            UI.cfgList = ConfigSys.list()
            ddBtn.Text = UI.cfgSelected or "---"
        end

        ddBtn.Activated:Connect(openDd)

        smallButton(card, 250, "Load config", function()
            local name = UI.cfgSelected
            if not name then notify("Config", "Select a config first") return end
            local data = ConfigSys.load(name)
            if not data then notify("Config", "Failed to load") return end
            for k, v in pairs(data) do UI.options[k] = v end
            if UI.rebuildTab then UI.rebuildTab() end
            notify("Config", "\"" .. name .. "\" loaded")
        end)
        smallButton(card, 288, "Overwrite config", function()
            local name = UI.cfgSelected
            if not name then notify("Config", "Select a config first") return end
            local ok = ConfigSys.save(name, UI.options)
            if ok then notify("Config", "\"" .. name .. "\" overwritten")
            else notify("Config", "Failed") end
        end)
        smallButton(card, 326, "Delete config", function()
            local name = UI.cfgSelected
            if not name then notify("Config", "Select a config first") return end
            ConfigSys.delete(name)
            UI.cfgSelected = nil
            ddBtn.Text = "---"
            notify("Config", "\"" .. name .. "\" deleted")
        end)
        smallButton(card, 364, "Refresh list", function()
            UI.cfgList = ConfigSys.list()
            notify("Config", "List refreshed")
        end)
        smallButton(card, 402, "Set as autoload", function()
            local name = UI.cfgSelected
            if not name then notify("Config", "Select a config first") return end
            ConfigSys.setAutoload(name)
            if UI.updateAutoloadText then UI.updateAutoloadText() end
            notify("Config", "\"" .. name .. "\" set as autoload")
        end)
        smallButton(card, 440, "Reset autoload", function()
            ConfigSys.setAutoload(nil)
            if UI.updateAutoloadText then UI.updateAutoloadText() end
            notify("Config", "Autoload cleared")
        end)

        local autoloadText = Instance.new("TextLabel")
        autoloadText.Size=UDim2.new(1,-28,0,22); autoloadText.Position=UDim2.new(0,14,0,482)
        autoloadText.BackgroundTransparency=1
        autoloadText.Text="Current autoload config: " .. (ConfigSys.getAutoload() or "none")
        autoloadText.TextColor3=CONFIG.colors.textDesc; autoloadText.Font=Enum.Font.GothamBold
        autoloadText.TextSize=CONFIG.textSizes.cfgHint
        autoloadText.TextXAlignment=Enum.TextXAlignment.Left
        autoloadText.Parent=card

        UI.updateAutoloadText = function()
            autoloadText.Text = "Current autoload config: " .. (ConfigSys.getAutoload() or "none")
        end
    end

    -- TAB BUILDERS
    local function clearContent()
        for _, c in ipairs(scroll:GetChildren()) do
            if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
        end
    end

    local function buildMainTab()
        clearContent()
        createToggleCard(1, "Toggle Example", "Liga e desliga", "ex_toggle", false, function(v) print("[UI] Toggle:", v) end)
        createButtonCard(2, "Execute Action", "Pressiona para rodar", function() print("[UI] Execute"); notify("Action", "Callback fired") end)
        createNumberCard(3, "Repeat Count", "Digite um número", "ex_number", 5, function(v) print("[UI] Number:", v) end)
        createSliderCard(4, "Walk Speed", "Arrasta com mouse ou toque", "ex_slider", 16, 200, 16, function(v) print("[UI] Slider:", v) end)
        createDropdownCard(5, "Priority Mode", "Abre para cima — 3 opções", "ex_dropdown", {"Normal","Aggressive","Stealth"}, "Normal", function(v) print("[UI] Dropdown:", v) end)
    end
    local function buildVisualTab() clearContent() end
    local function buildPlayerTab() clearContent() end
    local function buildMiscTab()   clearContent() end
    local function buildSettingsTab()
        clearContent()
        buildKeybindCard()
        buildConfigCard()
    end

    local function buildTab(tabId)
        if tabId == "main" then buildMainTab()
        elseif tabId == "visual" then buildVisualTab()
        elseif tabId == "player" then buildPlayerTab()
        elseif tabId == "misc" then buildMiscTab()
        elseif tabId == "settings" then buildSettingsTab()
        else buildMainTab() end
    end

    UI.rebuildTab = function() buildTab(UI.activeTab) end

    -- TAB ANIMATIONS
    local function animateTabActivate(entry, doPop)
        local baseSize = entry.baseSize
        local activeIconSize = UDim2.new(0, baseSize, 0, baseSize)
        local popSize = UDim2.new(0, baseSize * 1.18, 0, baseSize * 1.18)
        entry.icon.Size = activeIconSize
        tween(entry.button, {BackgroundColor3=CONFIG.colors.navBg}, CONFIG.anim.fast)
        tween(entry.icon, {ImageColor3=CONFIG.colors.navIconActive}, CONFIG.anim.fast)
        tween(entry.stroke, {Color=CONFIG.colors.navActiveBrd, Transparency=0, Thickness=3.6}, 0.18)
        task.delay(0.18, function() tween(entry.stroke, {Thickness=2.4}, 0.22) end)
        tween(entry.iconGlow, {ImageColor3=CONFIG.colors.navIconActive, ImageTransparency=0.35}, CONFIG.anim.fast)
        if doPop then
            entry.icon.Size = UDim2.new(0, baseSize * 0.75, 0, baseSize * 0.75)
            entry.icon.Position = UDim2.new(0.5, -(baseSize * 0.75)/2, 0.5, -(baseSize * 0.75)/2)
            popTween(entry.icon, {
                Size = popSize,
                Position = UDim2.new(0.5, -(baseSize * 1.18)/2, 0.5, -(baseSize * 1.18)/2),
            }, 0.22)
            task.delay(0.22, function()
                tween(entry.icon, {
                    Size = activeIconSize,
                    Position = UDim2.new(0.5, -baseSize/2, 0.5, -baseSize/2),
                }, 0.16)
            end)
        end
    end

    local function animateTabDeactivate(entry)
        local baseSize = entry.baseSize
        tween(entry.button, {BackgroundColor3=CONFIG.colors.navBg}, CONFIG.anim.fast)
        tween(entry.stroke, {Color=CONFIG.colors.navBorder, Transparency=0, Thickness=2}, CONFIG.anim.fast)
        tween(entry.icon, {ImageColor3=CONFIG.colors.navIcon}, CONFIG.anim.fast)
        tween(entry.iconGlow, {ImageColor3=CONFIG.colors.navIcon, ImageTransparency=0.85}, CONFIG.anim.fast)
        entry.icon.Size = UDim2.new(0, baseSize, 0, baseSize)
        entry.icon.Position = UDim2.new(0.5, -baseSize/2, 0.5, -baseSize/2)
    end

    local function selectTab(tabId, doPop)
        UI.activeTab = tabId
        for id, entry in pairs(tabButtons) do
            if id == tabId then animateTabActivate(entry, doPop)
            else animateTabDeactivate(entry) end
        end
        buildTab(tabId)
    end

    for id, entry in pairs(tabButtons) do
        track(entry.hit.Activated:Connect(function()
            if UI.activeTab == id then return end
            selectTab(id, true)
        end))
    end

    -- WINDOW CONTROLS
    local function minimizePanel()
        if not UI.isOpen or UI.isMinimized then return end
        UI.isMinimized = true
        local minH = CONFIG.sizes.headerHeight + 2
        local vp = getViewport()
        local targetPos = UI.savedPos or scaleWrapper.Position
        local cx, cy = clampToViewport(targetPos.X.Offset or 0, targetPos.Y.Offset or 0, minH)
        UI.savedPos = UDim2.new(0, cx, 0, cy)
        bodyLayer.Visible = false
        tween(scaleWrapper, {
            Size = UDim2.new(0, CONFIG.sizes.windowWidth, 0, minH),
            Position = UI.savedPos,
        }, CONFIG.anim.slow)
    end

    local function restorePanel()
        if not UI.isMinimized then return end
        UI.isMinimized = false
        local targetPos = UI.savedPos or centerPos(CONFIG.sizes.windowHeight)
        local cx, cy = clampToViewport(targetPos.X.Offset, targetPos.Y.Offset, CONFIG.sizes.windowHeight)
        UI.savedPos = UDim2.new(0, cx, 0, cy)
        bodyLayer.Visible = true
        navBar.Visible = true
        contentContainer.Visible = true
        tween(scaleWrapper, {
            Size = UDim2.new(0, CONFIG.sizes.windowWidth, 0, CONFIG.sizes.windowHeight),
            Position = UI.savedPos,
        }, CONFIG.anim.slow)
    end

    local function closePanel()
        if not UI.isOpen then return end
        UI.isOpen = false
        bodyLayer.Visible = false
        tween(scaleWrapper, {Size=UDim2.new(0, CONFIG.sizes.windowWidth, 0, 0)}, CONFIG.anim.normal)
    end

    local function openPanel(playEntrance)
        if UI.destroyed or UI.isOpen then return end
        UI.isOpen = true

        if not UI.everOpened or not UI.savedPos then
            scaleWrapper.Position = centerPos(CONFIG.sizes.windowHeight)
            UI.savedPos = scaleWrapper.Position
        else
            local cx, cy = clampToViewport(UI.savedPos.X.Offset, UI.savedPos.Y.Offset, CONFIG.sizes.windowHeight)
            scaleWrapper.Position = UDim2.new(0, cx, 0, cy)
            UI.savedPos = scaleWrapper.Position
        end
        UI.everOpened = true

        if playEntrance ~= false then
            scaleWrapper.Size = UDim2.new(0, CONFIG.sizes.windowWidth, 0, 0)
            mainWindow.BackgroundTransparency = 1
            header.BackgroundTransparency = 1
            headerFlat.BackgroundTransparency = 1
            bodyLayer.Visible = false

            local finalSize = UDim2.new(0, CONFIG.sizes.windowWidth, 0, CONFIG.sizes.windowHeight)
            local tw = TweenService:Create(scaleWrapper, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size=finalSize})
            tw:Play()
            tw.Completed:Connect(function() scaleWrapper.Size = finalSize end)

            tween(mainWindow, {BackgroundTransparency=0}, 0.40)
            tween(header, {BackgroundTransparency=0}, 0.40)
            tween(headerFlat, {BackgroundTransparency=0}, 0.40)

            task.delay(0.32, function()
                bodyLayer.Visible = true
                navBar.Visible = true
                contentContainer.Visible = true
                for _, c in ipairs(scroll:GetChildren()) do
                    if c:IsA("Frame") then
                        c.BackgroundTransparency = 1
                        tween(c, {BackgroundTransparency=0}, 0.35)
                    end
                end
            end)
        else
            scaleWrapper.Size = UDim2.new(0, CONFIG.sizes.windowWidth, 0, CONFIG.sizes.windowHeight)
            mainWindow.BackgroundTransparency = 0
            header.BackgroundTransparency = 0
            headerFlat.BackgroundTransparency = 0
            bodyLayer.Visible = true
            navBar.Visible = true
            contentContainer.Visible = true
        end
    end

    minBtn.Activated:Connect(function()
        if UI.isMinimized then restorePanel() else minimizePanel() end
    end)
    closeBtn.Activated:Connect(function()
        closePanel()
        task.delay(CONFIG.anim.normal + 0.05, function()
            screenGui:Destroy()
            local ng = PlayerGui:FindFirstChild("BabisUIKitNotif")
            if ng then ng:Destroy() end
        end)
    end)

    minBtn.MouseEnter:Connect(function() tween(minGlyph, {BackgroundColor3=CONFIG.colors.accent}, CONFIG.anim.fast) end)
    minBtn.MouseLeave:Connect(function() tween(minGlyph, {BackgroundColor3=CONFIG.colors.textPrimary}, CONFIG.anim.fast) end)
    closeBtn.MouseEnter:Connect(function()
        tween(xBar1, {BackgroundColor3=CONFIG.colors.closeHover}, CONFIG.anim.fast)
        tween(xBar2, {BackgroundColor3=CONFIG.colors.closeHover}, CONFIG.anim.fast)
    end)
    closeBtn.MouseLeave:Connect(function()
        tween(xBar1, {BackgroundColor3=CONFIG.colors.textPrimary}, CONFIG.anim.fast)
        tween(xBar2, {BackgroundColor3=CONFIG.colors.textPrimary}, CONFIG.anim.fast)
    end)

    -- DRAG
    local dragging = false
    local dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = scaleWrapper.Position
        end
    end)
    track(UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local vp = getViewport()
            local delta = input.Position - dragStart
            local baseX = startPos.X.Scale * vp.X + startPos.X.Offset
            local baseY = startPos.Y.Scale * vp.Y + startPos.Y.Offset
            local curH = UI.isMinimized and (CONFIG.sizes.headerHeight + 2) or CONFIG.sizes.windowHeight
            local cx, cy = clampToViewport(baseX + delta.X, baseY + delta.Y, curH)
            scaleWrapper.Position = UDim2.new(0, cx, 0, cy)
            UI.savedPos = scaleWrapper.Position
        end
    end))
    track(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))

    -- KEYBIND LISTENER
    track(UserInputService.InputBegan:Connect(function(input, gpe)
        if UI.destroyed then return end
        if gpe then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        local savedKey = UI.options["toggle_key"]
        if not savedKey or savedKey == "None" or savedKey == "" then return end
        if input.KeyCode == Enum.KeyCode[savedKey] then
            if UI.isOpen then closePanel() else openPanel() end
        end
    end))

    -- SCALE + CLAMP
    local function updateScale()
        local vp = getViewport()
        local sx = (vp.X - 16) / CONFIG.sizes.windowWidth
        local sy = (vp.Y - 32) / CONFIG.sizes.windowHeight
        local s = math.min(1.25, math.min(sx, sy))
        s = math.max(s, 0.55)
        uiScale.Scale = s
        local cur = scaleWrapper.Position
        local px = cur.X.Scale * vp.X + cur.X.Offset
        local py = cur.Y.Scale * vp.Y + cur.Y.Offset
        local h = UI.isMinimized and (CONFIG.sizes.headerHeight + 2) or CONFIG.sizes.windowHeight
        local cx, cy = clampToViewport(px, py, h)
        scaleWrapper.Position = UDim2.new(0, cx, 0, cy)
        UI.savedPos = scaleWrapper.Position
    end
    updateScale()
    local cam = workspace.CurrentCamera
    if cam then track(cam:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)) end

    selectTab(CONFIG.defaultTab, false)
    openPanel(true)
end

-- ============================================================
-- BOOT
-- ============================================================
showIntro(buildMainUI)
