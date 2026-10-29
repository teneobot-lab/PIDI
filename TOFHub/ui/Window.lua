-- Window utama: panel, title bar (minimize/tutup), sidebar tab, area konten, resize, toast, keybind.
--   Window.sidebar / Window.content   wadah yang diisi ui/Page
--   Window.toast(msg)  Window.toggle()  Window.resetSize()  Window.statLbl
local Hub = ...
local UIS = game:GetService("UserInputService")
local Config = Hub.use("config/Config")
local Cfg = Config.Cfg
local Kit = Hub.use("ui/Kit")
local Root = Hub.use("ui/Root")
local T, new, corner, lbl = Kit.T, Kit.new, Kit.corner, Kit.lbl
local tween, isPress, onAccent, Drag = Kit.tween, Kit.isPress, Kit.onAccent, Kit.Drag

local TITLE_H = 36
local MINW, MINH = 320, 220
local function clampSize(w, h)
    local v = workspace.CurrentCamera.ViewportSize
    return math.clamp(w, MINW, math.max(MINW, v.X - 20)), math.clamp(h, MINH, math.max(MINH, v.Y - 20))
end
local fullW, fullH = clampSize(Cfg.W, Cfg.H)
local minimized = false

local win = new("Frame", {
    Size = UDim2.fromOffset(fullW, fullH), Position = UDim2.new(0.5, -fullW / 2, 0.5, -fullH / 2),
    BackgroundTransparency = 1, Active = true,
}, Root.gui)
new("ImageLabel", {
    Image = "rbxassetid://6015897843", ImageColor3 = Color3.new(0, 0, 0), ImageTransparency = 0.55,
    ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49, 49, 450, 450),
    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 4),
    Size = UDim2.new(1, 44, 1, 44), BackgroundTransparency = 1, ZIndex = 0,
}, win)
local panel = new("Frame", {
    Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = T.bg, BorderSizePixel = 0,
    ClipsDescendants = true, ZIndex = 1,
}, win)
corner(panel, 12)
new("UIStroke", { Color = T.stroke, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, panel)

--------------------------------------------------------
-- Title bar
--------------------------------------------------------
local titleBar = new("Frame", { Size = UDim2.new(1, 0, 0, TITLE_H), BackgroundTransparency = 1 }, panel)
local logo = new("Frame", { Position = UDim2.fromOffset(10, 8), Size = UDim2.fromOffset(20, 20), BackgroundColor3 = Cfg.Accent, BorderSizePixel = 0 }, titleBar)
corner(logo, 6)
local logoT = lbl(logo, "T", 12, T.bg, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
logoT.Size = UDim2.new(1, 0, 1, 0)
onAccent(function() logo.BackgroundColor3 = Cfg.Accent end)

local title = lbl(titleBar, "TOF HUB", 12, T.text, Enum.Font.GothamBold)
title.Position, title.Size = UDim2.fromOffset(38, 0), UDim2.fromOffset(64, TITLE_H)
local ver = lbl(titleBar, "v4", 10, T.muted, Enum.Font.GothamBold)
ver.Position, ver.Size = UDim2.fromOffset(92, 1), UDim2.fromOffset(30, TITLE_H)

local statLbl = lbl(titleBar, "", 10, T.muted, Enum.Font.Code, Enum.TextXAlignment.Right)
statLbl.AnchorPoint, statLbl.Position, statLbl.Size = Vector2.new(1, 0), UDim2.new(1, -64, 0, 0), UDim2.fromOffset(110, TITLE_H)

local function titleBtn(txt, xoff, hoverCol)
    local b = new("TextButton", {
        Size = UDim2.fromOffset(24, 24), Position = UDim2.new(1, xoff, 0, 6),
        BackgroundColor3 = T.steel, BackgroundTransparency = 1, AutoButtonColor = false,
        Text = txt, TextSize = 15, Font = Enum.Font.GothamBold, TextColor3 = T.muted,
    }, titleBar)
    corner(b, 6)
    b.MouseEnter:Connect(function()
        tween(b, { BackgroundTransparency = 0, BackgroundColor3 = hoverCol or T.steel, TextColor3 = T.text })
    end)
    b.MouseLeave:Connect(function()
        tween(b, { BackgroundTransparency = 1, TextColor3 = T.muted })
    end)
    return b
end
local minBtn = titleBtn("–", -58)
local closeBtn = titleBtn("×", -32, T.danger)

local accentLine = new("Frame", { Position = UDim2.fromOffset(0, TITLE_H), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0 }, panel)
local accentGrad = new("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0.9) }) }, accentLine)
onAccent(function() accentGrad.Color = ColorSequence.new(Cfg.Accent, T.stroke) end)

--------------------------------------------------------
-- Body: sidebar + konten
--------------------------------------------------------
local body = new("Frame", { Position = UDim2.fromOffset(0, TITLE_H + 1), Size = UDim2.new(1, 0, 1, -(TITLE_H + 1)), BackgroundTransparency = 1 }, panel)

local sidebar = new("ScrollingFrame", {
    Position = UDim2.fromOffset(8, 8), Size = UDim2.new(0, 88, 1, -16),
    BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0,
    CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, body)
new("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, sidebar)

local content = new("Frame", {
    Position = UDim2.fromOffset(104, 8), Size = UDim2.new(1, -112, 1, -16), BackgroundTransparency = 1,
}, body)

local grip = new("TextButton", {
    AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -3, 1, -3), Size = UDim2.fromOffset(18, 18),
    BackgroundTransparency = 1, Text = "◢", TextSize = 11, TextColor3 = T.muted, ZIndex = 10,
}, panel)
grip.MouseEnter:Connect(function() tween(grip, { TextColor3 = T.steelEdge }) end)
grip.MouseLeave:Connect(function() tween(grip, { TextColor3 = T.muted }) end)

local function applySize()
    if minimized then
        win.Size = UDim2.fromOffset(math.min(fullW, 240), TITLE_H)
    else
        win.Size = UDim2.fromOffset(fullW, fullH)
    end
    body.Visible = not minimized
    accentLine.Visible = not minimized
    grip.Visible = not minimized
    minBtn.Text = minimized and "+" or "–"
end
minBtn.Activated:Connect(function() minimized = not minimized applySize() end)

titleBar.InputBegan:Connect(function(i)
    if isPress(i) then
        local sp, st = i.Position, win.Position
        Drag.fn = function(pos)
            local d = pos - sp
            win.Position = UDim2.new(st.X.Scale, st.X.Offset + d.X, st.Y.Scale, st.Y.Offset + d.Y)
        end
    end
end)

grip.InputBegan:Connect(function(i)
    if isPress(i) then
        local sp, sw, sh = i.Position, fullW, fullH
        Drag.fn = function(pos)
            fullW, fullH = clampSize(sw + (pos.X - sp.X), sh + (pos.Y - sp.Y))
            Cfg.W, Cfg.H = fullW, fullH
            applySize()
            Config.markDirty()
        end
    end
end)

--------------------------------------------------------
-- Toast
--------------------------------------------------------
local toastLbl = new("TextLabel", {
    AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -12), Size = UDim2.fromOffset(0, 26),
    AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = T.steel, BorderSizePixel = 0,
    Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = T.text, Text = "", Visible = false, ZIndex = 30,
}, panel)
corner(toastLbl, 8)
new("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) }, toastLbl)
new("UIStroke", { Color = T.steelEdge, Transparency = 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, toastLbl)
local toastTok = 0

--------------------------------------------------------
-- API publik
--------------------------------------------------------
local Window = {
    win = win, panel = panel, sidebar = sidebar, content = content,
    statLbl = statLbl, closeBtn = closeBtn,
}

function Window.toast(msg)
    toastTok += 1
    local t = toastTok
    toastLbl.Text = msg
    toastLbl.Visible = true
    task.delay(2.2, function() if t == toastTok then toastLbl.Visible = false end end)
end

function Window.toggle() win.Visible = not win.Visible end

function Window.resetSize()
    fullW, fullH = clampSize(Config.Default.W, Config.Default.H)
    Cfg.W, Cfg.H = fullW, fullH
    minimized = false
    applySize()
    Config.markDirty()
end

closeBtn.Activated:Connect(function() Hub.unload() end)

Hub.track(UIS.InputBegan:Connect(function(i, gpe)
    if not gpe and i.KeyCode == Enum.KeyCode.RightShift then Window.toggle() end
end))

return Window
