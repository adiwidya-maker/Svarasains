import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _logo = 'assets/images/SvaraLogo.jpeg';

  static const _items = <(IconData, String, String)>[
    (
      Icons.record_voice_over,
      'Apa itu SvaraSains?',
      'SvaraSains adalah aplikasi belajar sains lewat cerita rakyat Bali. '
          'Siswa mendengarkan cerita, lalu menjawab soal untuk mengecek pemahamannya.'
    ),
    (
      Icons.accessibility_new,
      'Untuk siapa?',
      'Aplikasi ini dirancang untuk siswa tunanetra dan low vision. '
          'Semua bagian bisa dipakai tanpa melihat layar dan tanpa mouse.'
    ),
    (
      Icons.keyboard,
      'Cara memakainya',
      'Tekan tombol spasi satu kali, tunggu suara berkata silakan bicara, '
          'lalu ucapkan pilihanmu. Spasi dipakai di semua halaman.'
    ),
    (
      Icons.translate,
      'Tiga bahasa',
      'Setiap cerita bisa didengar dalam bahasa Bali, bahasa Indonesia, atau bahasa Inggris. '
          'Teks cerita di layar selalu berbahasa Bali.'
    ),
    (
      Icons.quiz,
      'Soal dan evaluasi',
      'Di sela cerita ada soal pilihan ganda A sampai D. '
          'Hasil dan persentase nilai ditampilkan dan dibacakan di akhir cerita.'
    ),
  ];

  /// Teks yang dibacakan AI (isinya sama dengan yang tampil di layar).
  static String get spokenText {
    final b = StringBuffer('Tentang SvaraSains. ');
    for (final it in _items) {
      b.write('${it.$2}. ${it.$3} ');
    }
    return b.toString();
  }

  Widget _tile(int i) {
    final it = _items[i];
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Color(0xFF3949AB), Color(0xFF00ACC1)]),
            ),
            child: Icon(it.$1, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(it.$2,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(it.$3, style: const TextStyle(fontSize: 16, height: 1.4)),
            ]),
          ),
        ]),
      ),
    ).animate().fadeIn(delay: (120 * i).ms, duration: 400.ms).slideY(begin: 0.08);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang SvaraSains'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8EAF6), Colors.white],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 70),
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12)],
                    ),
                    child: Image.asset(_logo, height: 90, semanticLabel: 'Logo SvaraSains'),
                  ),
                ),
                const SizedBox(height: 20),
                for (var i = 0; i < _items.length; i++) _tile(i),
              ],
            ),
          ),
        ),
      ),
    );
  }
}