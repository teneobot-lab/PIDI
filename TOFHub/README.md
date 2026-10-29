# TOF Hub v4 — struktur modular

## Menjalankan
- **Folder lokal**: salin folder `TOFHub/` ke workspace executor, lalu jalankan `main.lua`
  (`loadstring(readfile("TOFHub/main.lua"))()`).
- **Satu file**: jalankan `TOFHub_bundle.lua` (hasil `python3 build.py`, isinya sama persis).
- **Online**: isi `BASE_URL` di `main.lua` dengan URL folder (akhiri dengan `/`).

## Peta folder
```
main.lua            entry: Hub (track, safe, onUnload, use, unload) + daftar BOOT
core/   Util        fungsi murni (hex, splitKeys, esc, ...)
        Scheduler   satu Heartbeat untuk semua tugas berkala
        Roles       deteksi Killer/Survivor
config/ Categories  daftar kategori ESP (data)
        Config      nilai awal, simpan/muat JSON, Config.set / Config.reg
features/ Aim, World, Movement      logika fitur (tanpa UI)
esp/    Draw, Players, Zombies, Objects
ui/     Kit (tema+helper), Root, Window, FovCircle, FloatButton,
        Page (tab+layout), Controls (Toggle/Slider/...), CategoryGroup
ui/tabs Dashboard, Aim, ESP, Objects, World, Move, Settings
```

## Aturan modul
1. Awali dengan `local Hub = ...`, akhiri dengan `return <tabel>`.
2. Ambil dependensi dengan `Hub.use("folder/Nama")` (di-cache, tidak boleh melingkar).
3. Event: `Hub.track(signal:Connect(...))`. Pembersihan: `Hub.onUnload(fn)` (jalan terbalik).
4. Tugas berkala: `Scheduler.add("Nama", detik, fn)` (0 = tiap frame). Error tampil di Dashboard > Diagnostik.
5. Opsi baru: tambah di tabel `Cfg` (`config/Config.lua`), baca lewat `Cfg.Nama`, ubah lewat `Config.set`.

## Resep cepat
- **Tab baru**: buat `ui/tabs/Nama.lua` (`Page.new("Nama")` + kontrol), tambah satu baris di `BOOT` (`main.lua`).
- **Objek ESP baru**: tambah satu baris di `config/Categories.lua`; teks khusus (opsional) di `LABEL_HOOKS` (`esp/Objects.lua`).
- **Fitur baru**: buat `features/Nama.lua` (logika + `Scheduler.add` + `Hub.onUnload`), tambah ke `BOOT`, lalu tabnya.
- **Kontrol UI baru**: tambah `function Page:NamaBaru(...)` di `ui/Controls.lua`.
