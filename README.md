# SvaraSains Mobile

Aplikasi belajar sains (STEM) lewat cerita rakyat Bali untuk siswa tunanetra dan low vision.
Seluruh aplikasi dikendalikan dengan suara dan tombol spasi, tanpa mouse.

## Identitas
- Nama: I Gede Adiwidya Utama
- NIM: 2415051001
- Kelas: 5IKI-PTI

## Fitur
- Sambutan suara otomatis dan panduan di setiap halaman
- 4 materi cerita rakyat Bali (Biologi, Matematika, Fisika)
- Narasi dalam bahasa Bali, Indonesia, dan Inggris; subtitle tetap Bali
- Perintah suara: tekan spasi, lalu ucapkan pilihan
- Soal pilihan ganda di sela cerita, evaluasi dan persentase di akhir
- Catatan belajar (CRUD) tersimpan di database
- Artikel sains dari REST API
- Loading, error, dan empty state

## Tech Stack
Flutter, Dart, Provider (ChangeNotifier), Supabase (PostgreSQL),
flutter_tts, speech_to_text, flutter_animate

## REST API
[ISI: nama dan URL API yang dipakai science_api_service.dart, operasi GET]

## Backend dan Database
Supabase (PostgreSQL)
- `student_notes`: id, student_id, module_title, note, quiz_score, rating, created_at
- `quiz_answers`: id, student_id, story_id, question_index, chosen_index, language, created_at

## Arsitektur
lib/
- config/        konfigurasi aplikasi
- models/        model data (Story, Question, ScienceArticle, StudentNote)
- services/      speaker (TTS), voice_input (STT), API dan Supabase
- repositories/  akses data kuis
- providers/     state management (NoteProvider, ScienceProvider)
- screens/       halaman aplikasi
- widgets/       komponen yang dipakai ulang (VoicePage)

## Screenshot
[ISI: tempel gambar Home, List, Detail, Create, Edit, tampilan responsif, data API, data database]

## Cara Menjalankan
1. `flutter pub get`
2. Isi URL dan anon key Supabase di `lib/config/app_config.dart`
   (jangan memakai service_role key)
3. Jalankan skema SQL di Supabase SQL Editor
4. `flutter run -d chrome`