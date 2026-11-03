# SvaraSains

Aplikasi belajar sains lewat cerita rakyat Bali untuk siswa tunanetra dan low vision.
Seluruh aplikasi dikendalikan dengan suara dan tombol spasi, tanpa mouse.

## Fitur
- Narasi cerita dalam bahasa Bali, Indonesia, dan Inggris (subtitle selalu Bali)
- Perintah suara dan tombol spasi di semua halaman
- Penjelasan program yang dibacakan, lalu beranda dengan 4 materi
- Soal pilihan ganda A sampai D di sela cerita
- Evaluasi dan persentase nilai di akhir cerita
- Jawaban kuis tersimpan di Supabase

## Teknologi
- Flutter (web)
- flutter_tts (suara narator)
- speech_to_text (perintah suara)
- flutter_animate (animasi)
- provider (state)
- supabase_flutter (database)

## Cara menjalankan
1. Pasang Flutter SDK
2. Clone repo ini
3. Jalankan di folder proyek:

   flutter pub get
   flutter run -d chrome

## Catatan penggunaan
- Gunakan Chrome dengan internet aktif, lalu izinkan akses mikrofon.
- Tekan tombol apa saja di layar pertama untuk memulai suara
  (browser memblokir suara sebelum ada interaksi).
- Setelah itu tekan spasi sekali, tunggu "Silakan bicara", lalu ucapkan pilihanmu.

## Keterbatasan
- Teks Bali masih draf dan perlu dikoreksi penutur asli.
- Suara Bali dibaca oleh suara Indonesia karena batas text-to-speech.
- Perintah suara bergantung pada browser dan paling stabil di Chrome.

## Identitas
- Nama: I Gede Adiwidya Utama
- NIM: 2415051001
- Kelas: 5 IKI PTI