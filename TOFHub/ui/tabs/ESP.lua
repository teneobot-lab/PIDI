-- Tab ESP: pengaturan umum + grup per kategori (Killer, Survivor, Zombie).
local Hub = ...
local Config = Hub.use("config/Config")
local Cats = Hub.use("config/Categories")
local Zom = Hub.use("esp/Zombies")
local Window = Hub.use("ui/Window")
local Page = Hub.use("ui/Controls")
local CategoryGroup = Hub.use("ui/CategoryGroup")

local CAT = Cats.byId
local page = Page.new("ESP")

page:Header("ESP", "Killer, survivor, zombie")
page:Section("Umum")
page:Toggle("Tag [KILLER]", "ShowRole")
page:Toggle("Nama", "ShowName")
page:Toggle("Jarak", "ShowDist")
page:Toggle("HP", "ShowHP")
page:Slider("Transparansi isi chams", "FillT", 0, 100, 5, "%")
page:Slider("Ukuran teks", "TextSize", 9, 22, 1, "")
page:Choice("Mode ESP", "ESPMode", { "CoreGui", "Workspace" })
page:Button("Aktifkan semua ESP", function()
    for _, c in ipairs(Cats.list) do Config.set(c.on, true) end
    Window.toast("Semua ESP aktif")
end, "accent")
page:Section("Per kategori (tap untuk buka)")
CategoryGroup(page, CAT.Killer)
CategoryGroup(page, CAT.Surv)
CategoryGroup(page, CAT.Zombie, function(g)
    g:Input("Kata kunci zombie", "KeyZombie", "scp2, zombie", Zom.rebuild)
    g:Toggle("Semua NPC bernyawa", "ZomAll")
end)

return { page = page }
