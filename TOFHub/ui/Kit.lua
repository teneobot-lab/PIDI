-- Tema + helper UI kecil (pembuat instance, tween, hover, aksen, drag global).
local Hub = ...
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Config = Hub.use("config/Config")
local Cfg = Config.Cfg

local Kit = {}

-- Token warna bersama; Theme.apply mengubah tabel ini in-place agar modul UI ikut berubah.
local Theme = Hub.use("ui/Theme")
Kit.T = Theme.T
local T = Kit.T

function Kit.new(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end
local new = Kit.new

function Kit.corner(o, r) return new("UICorner", { CornerRadius = UDim.new(0, r) }, o) end

function Kit.lbl(parent, txt, size, color, font, align)
    return new("TextLabel", {
        BackgroundTransparency = 1, Text = txt, TextSize = size, TextColor3 = color,
        Font = font or Enum.Font.GothamMedium,
        TextXAlignment = align or Enum.TextXAlignment.Left,
    }, parent)
end

function Kit.isPress(i)
    return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
end

function Kit.tween(o, props, t)
    TweenService:Create(o, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end
local tween = Kit.tween

-- hover manis: latar berubah ke steel blue + garis tepi lembut muncul
function Kit.hoverFx(target, trigger, base)
    base = base or T.surface
    local st = new("UIStroke", {
        Color = T.steelEdge, Thickness = 1, Transparency = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, target)
    trigger.MouseEnter:Connect(function()
        tween(target, { BackgroundColor3 = T.steel }, 0.16)
        tween(st, { Transparency = 0.45 }, 0.16)
    end)
    trigger.MouseLeave:Connect(function()
        tween(target, { BackgroundColor3 = base }, 0.22)
        tween(st, { Transparency = 1 }, 0.22)
    end)
end

-- warna aksen: daftarkan fungsi yang mengecat ulang saat Cfg.Accent berubah
local AccentFns = {}
function Kit.onAccent(fn)
    AccentFns[#AccentFns + 1] = fn
    pcall(fn)
end
Config.reg("Accent", function()
    for _, fn in ipairs(AccentFns) do pcall(fn) end
end)

-- drag global (window, resize, slider, tombol melayang): set Drag.fn / Drag.done saat tekan
local Drag = { fn = nil, done = nil }
Kit.Drag = Drag
Hub.track(UIS.InputChanged:Connect(function(i)
    if Drag.fn and (i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch) then
        Drag.fn(i.Position)
    end
end))
Hub.track(UIS.InputEnded:Connect(function(i)
    if Drag.fn and Kit.isPress(i) then
        Drag.fn = nil
        if Drag.done then local d = Drag.done Drag.done = nil d() end
    end
end))

return Kit
