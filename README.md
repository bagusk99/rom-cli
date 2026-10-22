# rom

CLI Python untuk mencari dan mengunduh ROM, ISO, serta game Switch lewat terminal.
Punya UI interaktif (Textual) seperti `epub-search`, pencarian berdasarkan nama,
unduhan dengan bar progres, dan folder yang tersusun per platform.

## Kebutuhan

- Python 3.8+
- macOS atau Linux
- `textual` (`install.sh` memasangnya di venv khusus)

## Pemasangan

```bash
git clone git@github.com:sostenesapollo/rom-cli.git
cd rom-cli
./install.sh
```

Membuat venv di `~/.venvs/rom`, memasang `textual`, lalu memublish `rom` (dan
`rom-remote`) ke `~/bin`. Pakai `PREFIX=/usr/local ./install.sh` untuk lokasi lain.

## Penggunaan

```bash
rom                          # membuka pemilih platform lalu menelusuri
rom -p switch                # langsung membuka katalog Switch
rom -p switchports           # hanya port/homebrew Switch
rom "metroid"                # mencari di semua sumber
rom -y -p gba "pokemon"      # mengunduh yang terbaik tanpa bertanya
rom --list "metroid"         # hanya daftar, tidak mengunduh
rom --print-url -p switch …  # menampilkan tautan langsung (aria2/curl)
rom -l                       # daftar platform
rom --index                  # membuat/menampilkan indeks katalog
rom --refresh                # membangun ulang indeks (abaikan cache)
```

Tanpa query, `rom` membuka **pemilih platform**; setelah memilih satu, seluruh
katalog platform itu ditampilkan (halaman berisi 300 item, `n`/`b` untuk pindah)
— jadi bisa menelusuri tanpa mengetik apa pun. Mengetik di kolom pencarian lalu
`Enter` kembali ke mode cari.

Di UI: `↑↓` navigasi, `spasi` tandai, `d` unduh (yang ditandai atau yang disorot),
`p` ganti platform, `n`/`b` halaman, `ctrl+b` palet opsi, `ctrl+a` tandai semua,
`ctrl+n` bersihkan, `q` keluar.

| Flag | Keterangan |
|------|------------|
| `-p, --platform` | platform (switch, snes, gba, ps2, nds, wii…) |
| `-y, --yes` | unduh yang terbaik tanpa menu |
| `--list` | hanya daftar |
| `--print-url` | hanya mencari dan mencetak tautan langsung |
| `--refresh` | membangun ulang indeks katalog |
| `--index` | mengunduh/menampilkan indeks lalu keluar |
| `-n, --number` | jumlah hasil yang ditampilkan (bawaan 15) |
| `-o, --out` | folder tujuan (bawaan `~/Downloads/roms` atau `$ROM_DIR`) |
| `-l, --platforms` | daftar platform |

Platform: `switch`, `switchports`, `ps5`, `ps4`, `ps3`, `psv`, `ps2`, `ps1`,
`psp`, `nds`, `gba`, `snes`, `pc`, `nes`, `gb`, `gbc`, `n64`, `3ds`, `gc`, `wii`,
`genesis`, `mastersystem`, `dreamcast`, `saturn`, `arcade`.

Berkas disimpan ke `~/Downloads/roms/<platform>/`.

## Cara kerjanya

- **Switch**: indeks dari dlarchive (`files_api.php`). Halaman nsp-roms memuat
  tautan dengan token yang kedaluwarsa; di sini `rom` menyelesaikan lewat indeks
  dan mengambil URL langsung tanpa token. Berlaku juga untuk NDS, GBA, SNES, dan PC.
- **Port Switch**: platform `switchports` menggabungkan dua sumber — katalog
  dlarchive dan pemindaian Archive.org (`switch port` / `homebrew port` / `nsp`+`port`),
  dengan cache 7 hari. Ada ~35 port (GTA, Halo, Simpsons Hit & Run, SM64 NX,
  Twilight Princess, Cave Story, Pizza Tower, Max Payne, Hello Neighbor, Diablo...).
- **PS3 dan PS Vita**: NoPayStation — mengunduh `.pkg` langsung dari CDN Sony
  (`zeus.dl.playstation.net`), tanpa token.
- **PS2, PS1, dan PSP**: RomsGames (pencarian + POST yang mengembalikan berkas).
- **PS4 dan PS5**: dlpsgame (pencarian lewat WP REST). Unduhan langsung tersedia
  bila artikel punya tautan host yang didukung (mediafire, Google Drive, 1fichier);
  bila tidak, `rom` menampilkan halaman untuk mengambil tautannya.
- **Terlaris lebih dulu**: saat menelusuri sebuah platform, judul paling laris
  (daftar Wikipedia, cache 30 hari) tampil pertama dengan ★; sisanya urutan abis.
  Platform tanpa daftar lengkap (PS4/PS5) ditelusuri lewat daftar terlaris itu sendiri.
- **Cadangan**: Archive.org untuk platform dengan penawaran sedikit.
- Indeks katalog dicache (`~/.cache/rom-cli/dlarchive.json`, TTL 12 jam) —
  membuat pencarian instan. `--refresh` membangun ulang.
- Peringkat berdasarkan kecocokan judul, penalti untuk hack/terjemahan/beta, dan
  preferensi `Dasar` di atas `Pembaruan`/`DLC`.
- Berkas divalidasi sebelum disimpan (zip, 7z, `PFS0` untuk `.nsp`, serta
  `PKG`/`CNT` untuk `.pkg`).
- Unduhan bisa dilanjutkan (`.part` + `Range`).

## Mode jarak jauh (`rom-remote`)

Berjalan di Mac worker (`ssh mac`) lalu menarik berkasnya kembali. Berguna saat
jaringan Mac ini memblokir host unduhan.

```bash
rom-remote -p switch "mario kart"    # membuka UI di worker
rom-remote -y -p snes "metroid"      # mengunduh di sana lalu sinkron ke sini
```

Atur lewat `ROM_REMOTE_HOST`, `ROM_REMOTE_DIR`, dan `ROM_DIR`.

## Peringatan

Gunakan hanya konten yang memang Anda berhak miliki.
