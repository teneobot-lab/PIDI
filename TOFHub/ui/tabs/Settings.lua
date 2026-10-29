-- Tab Settings: tampilan, deteksi role, info, unload.
local Hub = ...
local Config = Hub.use("config/Config")
local Window = Hub.use("ui/Window")
local Page = Hub.use("ui/Controls")
local Theme = Hub.use("ui/Theme")
local Root = Hub.use("ui/Root")

local page = Page.new("Settings")

page:Header("Settings", "Tampilan dan deteksi")
page:Section("Tampilan")
page:Choice("Tema UI", "Theme", Theme.names)
page:Button("Terapkan tema", function()
    Theme.set(Config.Cfg.Theme, Root.gui)
    Window.toast("Tema: " .. Config.Cfg.Theme)
end)
page:Color("Warna aksen UI", "Accent")
page:Toggle("Tombol melayang", "ShowFloat")
page:Button("Reset ukuran window", function()
    Window.resetSize()
    Window.toast("Ukuran direset")
end)
page:Button("Reset semua warna", function()
    for k, v in pairs(Config.Default) do
        if typeof(v) == "Color3" then Config.set(k, v) end
    end
    Window.toast("Warna direset")
end)
page:Section("Deteksi role")
page:Slider("Jumlah killer", "KillerCount", 1, 3, 1, "")
page:Section("Info")
page:Info("RightShift: tampil/sembunyi window\nTombol melayang: tap buka/tutup, geser untuk pindah\nTombol – : minimize | ◢ : ubah ukuran\nAngka di slider bisa diketik\nConfig tersimpan otomatis (TOFHub_config.json)")
page:Section("Script")
page:Button("Unload", function() Hub.unload() end, "danger")

return { page = page }
