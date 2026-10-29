-- Dunia: fullbright, tanpa kabut, matikan PostEffect, kunci jam.
-- World.apply() tiap frame; World.fxScan() tiap 0.5 detik. Nilai asli dipulihkan saat dimatikan.
local Hub = ...
local Lighting = game:GetService("Lighting")
local Cfg = Hub.use("config/Config").Cfg
local Scheduler = Hub.use("core/Scheduler")

local World = { saved = nil, fx = {} }

local function restoreFx(onlyKind)
    for inst, d in pairs(World.fx) do
        if not onlyKind or d.kind == onlyKind then
            if inst.Parent then
                pcall(function()
                    if d.kind == "atm" then inst.Density, inst.Haze = d.Density, d.Haze
                    else inst.Enabled = d.Enabled end
                end)
            end
            World.fx[inst] = nil
        end
    end
end

function World.apply()
    if not Cfg.Fullbright then
        if World.saved then
            for k, v in pairs(World.saved) do pcall(function() Lighting[k] = v end) end
            World.saved = nil
            restoreFx()
        end
        return
    end
    if not World.saved then
        World.saved = {
            Brightness = Lighting.Brightness, Ambient = Lighting.Ambient,
            OutdoorAmbient = Lighting.OutdoorAmbient, ClockTime = Lighting.ClockTime,
            FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart,
        }
    end
    Lighting.Brightness = Cfg.Bright
    Lighting.Ambient = Cfg.AmbientColor
    Lighting.OutdoorAmbient = Cfg.AmbientColor
    if Cfg.ForceTime then Lighting.ClockTime = Cfg.Time end
    if Cfg.NoFog then Lighting.FogEnd, Lighting.FogStart = 1e6, 1e5 end
end

function World.fxScan()
    if not Cfg.Fullbright then return end
    if not Cfg.NoFog then restoreFx("atm") end
    if not Cfg.NoFx then restoreFx("fx") end
    for _, e in ipairs(Lighting:GetChildren()) do
        if e:IsA("Atmosphere") and Cfg.NoFog then
            if not World.fx[e] then World.fx[e] = { kind = "atm", Density = e.Density, Haze = e.Haze } end
            e.Density, e.Haze = 0, 0
        elseif e:IsA("PostEffect") and Cfg.NoFx then
            if not World.fx[e] then World.fx[e] = { kind = "fx", Enabled = e.Enabled } end
            e.Enabled = false
        end
    end
end

Scheduler.add("Dunia fx", 0.5, World.fxScan)
Scheduler.add("Dunia", 0, World.apply)

Hub.onUnload(function()
    Cfg.Fullbright = false
    pcall(World.apply)
end)

return World
