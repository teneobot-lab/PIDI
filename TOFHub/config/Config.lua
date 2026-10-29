-- Konfigurasi: nilai awal, simpan/muat JSON, dan sinkronisasi ke komponen UI.
--   Config.Cfg      tabel nilai aktif (baca langsung: Cfg.FOV)
--   Config.Default  salinan nilai awal
--   Config.set(k,v) ubah nilai + segarkan UI + simpan otomatis
--   Config.reg(k,f) daftarkan fungsi yang dipanggil tiap Cfg[k] berubah lewat set()
-- Opsi baru: tambah di tabel Cfg di bawah (kelompokkan per fitur).
local Hub = ...
local Http = game:GetService("HttpService")
local Util = Hub.use("core/Util")
local Cats = Hub.use("config/Categories")

local FILE = "TOFHub_config.json"

local Cfg = {
    Ver = 4,
    -- Aim
    Aimlock = false, Silent = false, WallCheck = false, ShowFOV = true,
    FOV = 200, Lock = 100, Predict = 0, Part = "HumanoidRootPart", AutoUnstick = true,
    FOVColor = Color3.fromRGB(240, 240, 245),
    -- Deteksi role
    KillerCount = 1, ManualKiller = "",
    -- ESP umum
    ShowName = true, ShowDist = true, ShowHP = true, ShowRole = true,
    FillT = 65, TextSize = 12, ESPMode = "CoreGui",
    ZomAll = false, KeyZombie = "scp2, zombie",
    -- Dunia (lighting)
    Fullbright = false, Bright = 2, AmbientColor = Color3.fromRGB(210, 210, 210),
    ForceTime = false, Time = 14, NoFog = true, NoFx = false,
    -- Gerak
    Speed = false, SpeedVal = 24, SpeedSafe = true, Noclip = false, Fly = false, FlySpeed = 50,
    -- Violence District
    VDAutoSkillCheck = false, VDSkillMode = "Perfect",
    VDSpeedBoost = false, VDSpeedMultiplier = 0.30, VDSpeedSafeMode = true,
    -- GUI
    Accent = Color3.fromRGB(124, 106, 255), Theme = "Overworld", ShowFloat = true, W = 420, H = 320,
}
-- kunci per kategori ESP (dibangkitkan dari config/Categories)
for _, c in ipairs(Cats.list) do
    Cfg[c.on] = true
    Cfg[c.col] = c.def
    Cfg[c.chams] = (c.kind ~= "obj") -- objek: label saja (hemat batas Highlight Roblox)
    Cfg[c.label] = true
    Cfg[c.dist] = 2000
    if c.keyCfg then Cfg[c.keyCfg] = c.keyDef end
end

local Default = {}
for k, v in pairs(Cfg) do Default[k] = v end

local Config = { Cfg = Cfg, Default = Default, FILE = FILE }
local Refresh = {}

-- simpan otomatis 1 detik setelah perubahan terakhir
local saveToken = 0
function Config.markDirty()
    if not writefile then return end
    saveToken += 1
    local t = saveToken
    task.delay(1, function()
        if t ~= saveToken or Hub.Dead then return end
        local out = {}
        for k, v in pairs(Cfg) do
            if k ~= "ManualKiller" then
                if typeof(v) == "Color3" then out[k] = "#" .. Util.hex(v) else out[k] = v end
            end
        end
        pcall(writefile, FILE, Http:JSONEncode(out))
    end)
end

local function load()
    if not (readfile and isfile and isfile(FILE)) then return end
    local ok, data = pcall(function() return Http:JSONDecode(readfile(FILE)) end)
    -- config versi lama dilewati supaya default baru (ESP aktif) terpakai
    if not (ok and type(data) == "table" and data.Ver == Cfg.Ver) then return end
    for k, v in pairs(data) do
        if Cfg[k] ~= nil and k ~= "ManualKiller" and k ~= "Ver" then
            if typeof(Cfg[k]) == "Color3" then
                Cfg[k] = Util.parseHex(v) or Cfg[k]
            elseif type(v) == type(Cfg[k]) then
                Cfg[k] = v
            end
        end
    end
end

function Config.reg(key, fn)
    Refresh[key] = Refresh[key] or {}
    table.insert(Refresh[key], fn)
end

function Config.set(key, v)
    Cfg[key] = v
    for _, fn in ipairs(Refresh[key] or {}) do pcall(fn) end
    Config.markDirty()
end

load()
return Config
