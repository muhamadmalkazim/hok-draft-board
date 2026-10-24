-- ─────────────────────────────────────────────────────────────
-- HOK Draft Board — skema Supabase
--
-- Jalanin SEKALI di Supabase: menu kiri -> SQL Editor -> New query
-- -> tempel semua isi file ini -> Run.
-- ─────────────────────────────────────────────────────────────

-- 1. Tabel data. Semua state disimpan sebagai dokumen JSON ber-path,
--    sama persis dengan versi di claude.ai:
--      heroes/<id>      data tiap hero
--      teams/<id>       roster + riwayat seri
--      boards/<id>      papan taktik
--      state/series     seri yang lagi jalan
create table if not exists public.docs (
  path        text primary key,
  data        jsonb not null,
  updated_at  timestamptz not null default now()
);

create index if not exists docs_path_prefix on public.docs (path text_pattern_ops);

-- 2. Hak akses.
--    Versi ini dipakai sendiri / tim kecil tanpa login, jadi kunci
--    anon dibolehkan baca-tulis. Kunci anon ada di config.js yang
--    ikut terkirim ke browser — anggap situsnya tidak rahasia.
alter table public.docs enable row level security;

drop policy if exists docs_all on public.docs;
create policy docs_all on public.docs
  for all
  using (true)
  with check (true);

-- 3. Bucket penyimpanan gambar (portrait hero, logo tim, map papan).
insert into storage.buckets (id, name, public)
values ('hok', 'hok', true)
on conflict (id) do update set public = true;

drop policy if exists hok_read on storage.objects;
create policy hok_read on storage.objects
  for select using (bucket_id = 'hok');

drop policy if exists hok_write on storage.objects;
create policy hok_write on storage.objects
  for insert with check (bucket_id = 'hok');

drop policy if exists hok_update on storage.objects;
create policy hok_update on storage.objects
  for update using (bucket_id = 'hok');

-- ─────────────────────────────────────────────────────────────
-- CATATAN KEAMANAN — baca ini.
--
-- Kebijakan di atas membuat siapa pun yang punya URL situs dan
-- kunci anon bisa baca DAN tulis data. Untuk papan draft pribadi
-- itu biasanya tidak masalah. Yang perlu diingat:
--
--   * Jangan simpan apa pun yang rahasia di sini.
--   * Kalau situsnya dipasang di domain publik, orang yang
--     menemukannya bisa mengubah data.
--
-- Kalau nanti butuh dikunci, aktifkan Supabase Auth lalu ganti
-- policy jadi:
--     using (auth.uid() is not null)
--     with check (auth.uid() is not null)
-- dan tambahkan alur login di aplikasinya.
-- ─────────────────────────────────────────────────────────────
