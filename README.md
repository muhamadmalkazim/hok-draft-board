# HOK Draft Board — versi standalone

Satu file HTML. Nggak butuh Node, nggak butuh build, nggak butuh server.

```
hok-draft.html   seluruh aplikasi — CSS, JS, semuanya di dalam
supabase.sql     dijalankan sekali kalau mau sync (opsional)
```

Upload `hok-draft.html` ke hosting mana pun. Selesai.
Kalau mau jadi halaman utama, ganti namanya jadi `index.html`.

---

## 1. Upload

**Netlify** — buka [app.netlify.com/drop](https://app.netlify.com/drop),
seret `hok-draft.html` ke kotaknya. Langsung dapat URL.

**Hosting sendiri** — upload `hok-draft.html` ke `public_html/`
lewat cPanel atau FTP. Buka `domainkamu.com/hok-draft.html`.

Ganti nama file jadi `index.html` kalau mau langsung kebuka di akar domain.

---

## 2. Pindahin data dari versi claude.ai

1. Buka versi claude.ai → tab **Hero** → tombol **Export semua**
2. Tunggu sampai ZIP-nya kedownload (sekitar 16 MB, 124 gambar)
3. Buka versi standalone → tab **Hero** → **Import backup** → pilih ZIP tadi

Masuk semua: 120 hero beserta gambar, lane, tipe damage, prioritas,
relasi counter/combo, 4 tim dengan logo dan riwayat seri, papan, dan
seri yang lagi jalan.

ZIP yang sama juga jadi backup. Biasakan export sesekali.

---

---

## 4. Nyalain sync antar device (opsional)

Tanpa langkah ini aplikasinya tetap jalan penuh — datanya cuma ada di
satu browser. Kalau mau data yang sama kebuka di kantor, rumah, dan HP,
ikuti ini. Sekitar 15 menit, gratis.

1. Daftar di [supabase.com](https://supabase.com), bikin project baru.
   Region terdekat: **Southeast Asia (Singapore)**.

2. Menu kiri → **SQL Editor** → **New query** → tempel seluruh isi
   `supabase.sql` → **Run**. Ini bikin tabel dan bucket gambarnya.

3. Menu kiri → **Project Settings** → **API**. Salin dua nilai:
   - **Project URL** (`https://xxxx.supabase.co`)
   - kunci **anon public**

4. Buka `hok-draft.html` pakai teks editor. Di bagian paling atas
   script ada blok `window.HOK_CONFIG`. Isi dua nilainya:

```js
window.HOK_CONFIG = {
  supabase: {
    url: "https://xxxx.supabase.co",
    anonKey: "eyJhbGciOi...",
    bucket: "hok"
  }
};
```

5. Simpan, upload ulang filenya. Badge di pojok kanan atas bakal berubah
   dari "Data kesimpen di browser ini" jadi "Tersinkron lewat Supabase".

6. Buka situsnya, **Import backup** sekali lagi pakai ZIP yang tadi —
   kali ini datanya masuk ke Supabase, bukan ke browser. Sejak itu
   semua device baca data yang sama.

**Yang perlu kamu tahu:** kunci anon ikut terkirim ke browser, jadi
siapa pun yang nemu situsnya bisa baca dan ubah data. Buat papan draft
pribadi biasanya nggak masalah. Kalau nanti perlu dikunci, catatan di
bagian bawah `supabase.sql` menjelaskan cara menambah login.

---

## Yang ada di aplikasinya

- **Draft** — ban & pick 18 langkah (4 ban + 5 pick per tim), GBP
  terkunci per tim lintas game, sisi tukar tiap game (bisa dimatikan),
  deteksi ban sia-sia, analisis komposisi, saran pick/ban
- **Arsip** — masukin hasil scrim lama: pick saja, tanpa ban, tanpa urutan
- **Hero** — 120 hero, edit nama/lane/tipe damage/gambar, tanda prioritas,
  upload massal yang cocokin nama file
- **Relasi** — counter dan combo yang kamu isi sendiri; ini yang jadi
  sumber saran pas draft
- **Papan** — upload map, coret-coret, taruh token hero, export PNG
- **Tim** — roster, logo, pemain, riwayat seri lengkap dengan draft
  tiap game dari sudut pandang tim itu

Semua tersimpan otomatis. Nggak ada tombol save.

---

## Kalau ada yang nggak beres

**Tampilannya polos, cuma teks hitam putih**
Filenya nggak lengkap keupload. Versi ini satu file — pastikan yang
diupload `hok-draft.html` utuh, bukan file lain.

**Gambar nggak muncul setelah import**
Buka DevTools → Application → IndexedDB → `hokdraft` → `blobs`.
Kalau kosong, import-nya gagal di tengah; ulangi dengan ZIP yang sama.

**Badge tetap "Data kesimpen di browser ini" padahal udah isi config**
File belum ke-upload ulang, atau masih ke-cache. Hard refresh
(Ctrl+Shift+R). Pastikan `url` dan `anonKey` nggak kosong.

**Supabase nolak nyimpen**
`supabase.sql` belum dijalankan, atau cuma sebagian. Jalankan ulang
seluruhnya — aman diulang.
