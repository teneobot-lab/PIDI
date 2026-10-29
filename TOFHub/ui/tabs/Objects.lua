-- Tab Objek: ESP generator, hook, gate, pallet, window (grup diambil dari config/Categories).
local Hub = ...
local Config = Hub.use("config/Config")
local OBJ_GROUPS = Hub.use("config/Categories").objGroups
local Scheduler = Hub.use("core/Scheduler")
local Obj = Hub.use("esp/Objects")
local Window = Hub.use("ui/Window")
local Page = Hub.use("ui/Controls")
local CategoryGroup = Hub.use("ui/CategoryGroup")

local page = Page.new("Objek")

page:Header("Objek", "Generator, hook, gate, pallet, window")
page:Button("Aktifkan semua objek", function()
    for _, c in ipairs(OBJ_GROUPS) do Config.set(c.on, true) end
    Window.toast("Semua objek aktif")
end, "accent")
page:Button("Scan ulang objek", function() Obj.rescan() Window.toast("Scan ulang dimulai") end)
page:Section("Per objek (tap untuk buka)")
for _, c in ipairs(OBJ_GROUPS) do CategoryGroup(page, c) end
page:Section("Terdeteksi")
local infoObj = page:Info("...")

local function update()
    local counts = {}
    for _, g in ipairs(OBJ_GROUPS) do counts[g.id] = 0 end
    for _, rec in pairs(Obj.tracked) do counts[rec.g.id] += 1 end
    local parts = {}
    for _, g in ipairs(OBJ_GROUPS) do
        parts[#parts + 1] = ("%s: %d terdeteksi / %d tampil"):format(g.name, counts[g.id], Obj.shown[g.id] or 0)
    end
    infoObj.Text = table.concat(parts, "\n") .. "\n0 terdeteksi = nama di game berbeda, ubah kata kunci di grup objeknya"
end
Scheduler.add("Info objek", 0.5, update)

return { page = page }
