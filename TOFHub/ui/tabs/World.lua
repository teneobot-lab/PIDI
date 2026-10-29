-- Tab Dunia: pencahayaan.
local Hub = ...
local Page = Hub.use("ui/Controls")

local page = Page.new("Dunia")

page:Header("Dunia", "Terang di semua map")
page:Section("Pencahayaan")
page:Toggle("Fullbright", "Fullbright")
page:Slider("Kecerahan", "Bright", 0, 6, 0.5, "")
page:Color("Warna ambient (tema)", "AmbientColor")
page:Section("Tambahan")
page:Toggle("Hilangkan kabut", "NoFog")
page:Toggle("Matikan efek gelap (blur/bloom/dll)", "NoFx")
page:Toggle("Kunci waktu (jam)", "ForceTime")
page:Slider("Jam", "Time", 0, 24, 0.5, "")

return { page = page }
