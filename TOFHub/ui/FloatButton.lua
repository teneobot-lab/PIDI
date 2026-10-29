-- Tombol melayang: tap buka/tutup window, geser untuk pindah.
local Hub = ...
local Config = Hub.use("config/Config")
local Cfg = Config.Cfg
local Kit = Hub.use("ui/Kit")
local Root = Hub.use("ui/Root")
local Window = Hub.use("ui/Window")
local T, new, corner, tween = Kit.T, Kit.new, Kit.corner, Kit.tween
local Drag = Kit.Drag

local float = new("TextButton", {
    Size = UDim2.fromOffset(38, 38), Position = UDim2.new(0, 12, 0.5, -19),
    BackgroundColor3 = Cfg.Accent, BorderSizePixel = 0, AutoButtonColor = false,
    Text = "T", TextSize = 15, Font = Enum.Font.GothamBold, TextColor3 = T.bg,
}, Root.gui)
corner(float, 19)
Kit.onAccent(function() float.BackgroundColor3 = Cfg.Accent end)
float.MouseEnter:Connect(function() tween(float, { Size = UDim2.fromOffset(42, 42) }) end)
float.MouseLeave:Connect(function() tween(float, { Size = UDim2.fromOffset(38, 38) }) end)
float.Visible = Cfg.ShowFloat
Config.reg("ShowFloat", function() float.Visible = Cfg.ShowFloat end)

float.InputBegan:Connect(function(i)
    if not Kit.isPress(i) then return end
    local sp, st, moved = i.Position, float.Position, 0
    Drag.fn = function(pos)
        local d = pos - sp
        moved = math.max(moved, d.Magnitude)
        float.Position = UDim2.new(st.X.Scale, st.X.Offset + d.X, st.Y.Scale, st.Y.Offset + d.Y)
    end
    Drag.done = function() if moved < 6 then Window.toggle() end end
end)

return float
