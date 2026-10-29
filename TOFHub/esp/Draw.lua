-- Helper gambar ESP bersama: label (BillboardGui) + chams (Highlight).
-- Setiap objek ESP memegang "rec" ({ bb, tl, hl, ... }); helper ini yang membuat/memindah/menghapusnya.
local Hub = ...
local Cfg = Hub.use("config/Config").Cfg
local new = Hub.use("ui/Kit").new
local espFolder = Hub.use("ui/Root").espFolder

local Draw = {}

function Draw.dropBB(rec)
    if rec.bb then pcall(function() rec.bb:Destroy() end) rec.bb, rec.tl = nil, nil end
end
function Draw.dropHL(rec)
    if rec.hl then pcall(function() rec.hl:Destroy() end) rec.hl = nil end
end
function Draw.dropGui(rec) Draw.dropBB(rec) Draw.dropHL(rec) end

local function ensureBB(rec, w, h, off)
    if not rec.bb then
        rec.bb = new("BillboardGui", {
            Name = "TOFTag", Size = UDim2.fromOffset(w, h), StudsOffset = Vector3.new(0, off, 0),
            AlwaysOnTop = true, ResetOnSpawn = false,
        })
        rec.tl = new("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold, TextSize = 12, TextStrokeTransparency = 0.4,
        }, rec.bb)
    end
end

local function placeBB(rec, part)
    rec.bb.Adornee = part
    local want = (Cfg.ESPMode == "Workspace") and part or espFolder
    if rec.bb.Parent ~= want then rec.bb.Parent = want end
end

local function ensureHL(rec)
    if not rec.hl then
        rec.hl = new("Highlight", { Name = "TOFHL", DepthMode = Enum.HighlightDepthMode.AlwaysOnTop })
    end
end

local function placeHL(rec, adornee)
    rec.hl.Adornee = adornee
    local want = (Cfg.ESPMode == "Workspace") and adornee or espFolder
    if rec.hl.Parent ~= want then rec.hl.Parent = want end
end

-- label teks di atas `part` (ukuran w x h px, naik `off` stud)
function Draw.label(rec, w, h, off, col, text, part)
    ensureBB(rec, w, h, off)
    rec.tl.TextColor3 = col
    rec.tl.TextSize = Cfg.TextSize
    rec.tl.Text = text
    placeBB(rec, part)
end

-- chams (outline + isi) pada `adornee`
function Draw.chams(rec, adornee, col, fillT)
    ensureHL(rec)
    rec.hl.FillColor, rec.hl.OutlineColor = col, col
    rec.hl.FillTransparency = fillT
    placeHL(rec, adornee)
end

return Draw
