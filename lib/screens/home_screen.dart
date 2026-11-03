import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../models/story.dart';
import '../providers/note_provider.dart';
import '../services/sample_stories.dart';
import '../services/speaker.dart';
import '../services/voice_input.dart';
import '../widgets/voice_page.dart';
import 'about_screen.dart';
import 'language_select_screen.dart';
import 'profile_screen.dart';
import 'progress_notes_screen.dart';

enum _Phase { gate, intro, home }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _id = 'id-ID';
  static const _logo = 'assets/images/SvaraLogo.jpeg';

  /// Foto thumbnail tiap materi, urutannya sama dengan urutan materi.
  static const _thumbs = [
    'assets/stories/materi_1.jpeg',
    'assets/stories/materi_2.jpeg',
    'assets/stories/materi_3.jpeg',
    'assets/stories/materi_4.jpeg',
  ];

  // Sambutan: dibacakan SAMPAI SELESAI, baru otomatis ke beranda.
  static const _introText =
      'Selamat datang di Swara Sains. '
      'Aplikasi belajar sains lewat cerita rakyat Bali, untuk siswa tunanetra dan low vision. '
      'Aplikasi ini punya tiga keistimewaan. '
      'Pertama, dikendalikan dengan suara dan tombol spasi. '
      'Kedua, setiap cerita bisa kamu dengarkan dalam bahasa Bali, Indonesia, atau Inggris. '
      'Ketiga, ada soal dan evaluasi di setiap cerita. '
      'Sekarang, kita menuju beranda.';

  static const _backText =
      'Kembali ke beranda. Tekan spasi, lalu sebutkan materi yang ingin kamu pelajari. '
      'Atau ucapkan tentang, wawasan, catatan, profil, atau bantuan.';

  static const _digits = [
    LogicalKeyboardKey.digit1,
    LogicalKeyboardKey.digit2,
    LogicalKeyboardKey.digit3,
    LogicalKeyboardKey.digit4,
    LogicalKeyboardKey.digit5,
    LogicalKeyboardKey.digit6,
    LogicalKeyboardKey.digit7,
    LogicalKeyboardKey.digit8,
    LogicalKeyboardKey.digit9,
  ];
  static const _numberWords = [
    'satu', 'dua', 'tiga', 'empat', 'lima', 'enam', 'tujuh', 'delapan', 'sembilan'
  ];
  static const _ordinals = [
    'pertama', 'kedua', 'ketiga', 'keempat', 'kelima', 'keenam', 'ketujuh',
    'kedelapan', 'kesembilan'
  ];

  final Speaker _speaker = Speaker();
  late final VoiceInput _voice;
  final FocusNode _focus = FocusNode();

  // Langsung masuk ke sambutan tanpa menunggu tombol apa pun.
  _Phase _phase = _Phase.intro;
  int _introRun = 0;
  int _sel = 0;

  bool get _listening => _voice.listening;
  String get _heard => _voice.heard;

  List<Story> get _stories => sampleStories;

  @override
  void initState() {
    super.initState();
    _voice = VoiceInput(
      speaker: _speaker,
      onChange: () {
        if (mounted) setState(() {});
      },
      onWords: _onWords,
    );
    _init();
  }

  Future<void> _init() async {
    if (mounted) _runIntro(); // sambutan langsung jalan, tanpa menunggu izin mikrofon
    await _voice.init();
  }

  @override
  void dispose() {
    _introRun++;
    _voice.cancel();
    _speaker.stop();
    _focus.dispose();
    super.dispose();
  }

  void _say(String text) => _speaker.say([Utterance(text, _id)]);

  // Di browser, suara baru boleh keluar setelah ada interaksi pertama.
  // Kalau sambutan sempat diblokir, ulang sekali saat ada tombol atau ketukan.
  bool _unlocked = false;
  void _unlockVoice() {
    if (!kIsWeb || _unlocked || _phase != _Phase.intro) return;
    _unlocked = true;
    _runIntro();
  }

  // ── Alur: sambutan -> beranda (otomatis) ───────────────

  Future<void> _runIntro() async {
    final my = ++_introRun;
    setState(() => _phase = _Phase.intro);
    // Pengaman saja (bukan pemotong): kalau suara macet total, tetap lanjut
    // ke beranda setelah 60 detik. Normalnya beranda muncul setelah suara selesai.
    Future.delayed(const Duration(seconds: 60), () {
      if (mounted && my == _introRun && _phase == _Phase.intro) _toHome();
    });
    final done = await _speaker.say([const Utterance(_introText, _id)]);
    if (!mounted || !done || my != _introRun || _phase != _Phase.intro) return;
    _toHome();
  }

  void _toHome() {
    _introRun++;
    _speaker.stop();
    setState(() => _phase = _Phase.home);
    _greet();
  }

  String _cat(String c) => c.replaceAll(':', ',');

  // Sambutan beranda: isi materi, lalu mengarahkan ke tombol spasi.
  void _greet() {
    final b = StringBuffer('Ini beranda. Di sini ada ${_stories.length} materi. ');
    for (var i = 0; i < _stories.length; i++) {
      final num = i < _numberWords.length ? _numberWords[i] : '${i + 1}';
      b.write('Nomor $num, ${_stories[i].title.id}, pelajaran ${_cat(_stories[i].category)}. ');
    }
    b.write('Untuk memilih materi, tekan tombol spasi satu kali, '
        'lalu sebutkan nomor atau judulnya. '
        'Selain materi, ada lima menu lain. Semuanya dimulai dengan menekan spasi. '
        'Ucapkan tentang, untuk mendengar penjelasan program. '
        'Ucapkan wawasan, untuk mendengar ringkasan sains dari Wikipedia. '
        'Ucapkan catatan, untuk membuka catatan belajar. '
        'Ucapkan profil, untuk membuka profil dan pengaturan. '
        'Ucapkan bantuan, untuk mendengar petunjuk. '
        'Kalau ingin mendengar semua ini lagi, tekan spasi lalu ucapkan ulang.');
    _say(b.toString());
  }

  void _help() => _say('Bantuan. Semua perintah dimulai dengan menekan tombol spasi. '
      'Lalu ucapkan nomor atau judul materi, untuk membuka cerita. '
      'Ucapkan tentang, untuk penjelasan program. '
      'Ucapkan wawasan, untuk ringkasan sains. '
      'Ucapkan catatan, untuk catatan belajar. '
      'Ucapkan profil, untuk profil dan pengaturan. '
      'Ucapkan ulang, untuk mendengar sambutan beranda lagi.');

  void _speakSelection() {
    final s = _stories[_sel];
    _say('Nomor ${_sel + 1}, ${s.title.id}, pelajaran ${_cat(s.category)}. '
        'Tekan spasi lalu ucapkan buka.');
  }

  void _open(int i) {
    if (i < 0 || i >= _stories.length) return;
    _speaker.stop();
    setState(() => _sel = i);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LanguageSelectScreen(story: _stories[i])),
    ).then((_) {
      if (!mounted) return;
      _focus.requestFocus();
      _say(_backText);
    });
  }

  // Semua halaman menu dibungkus VoicePage: isinya dibacakan sampai selesai,
  // lalu siswa diarahkan menekan spasi dan mengucapkan "kembali".
  void _openPage(String intro, Widget page,
      {Future<String> Function()? builder}) {
    _speaker.stop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VoicePage(intro: intro, introBuilder: builder, child: page),
      ),
    ).then((_) {
      if (!mounted) return;
      _focus.requestFocus();
      _say(_backText);
    });
  }

  void _openAbout() => _openPage(AboutScreen.spokenText, const AboutScreen());

  // Layar Wawasan Sains membacakan isinya sendiri dan menangani spasi,
  // jadi tidak dibungkus VoicePage.
  void _openScience() {
    _speaker.stop();
    Navigator.pushNamed(context, '/science').then((_) {
      if (!mounted) return;
      _focus.requestFocus();
      _say(_backText);
    });
  }

  void _openNotes() {
    final p = Provider.of<NoteProvider>(context, listen: false);
    var first = true;
    _openPage(
      'Ini halaman catatan belajar.',
      const ProgressNotesScreen(),
      builder: () async {
        // Beri waktu halaman memuat catatan dari server.
        if (first) {
          first = false;
          await Future.delayed(const Duration(milliseconds: 500));
        }
        for (var i = 0; i < 50 && p.isLoading; i++) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
        final notes = p.notes;
        final b = StringBuffer('Ini halaman catatan belajar. ');
        if (notes.isEmpty) {
          b.write('Belum ada catatan tersimpan. '
              'Catatan ditambahkan oleh guru pendamping. ');
        } else {
          b.write('Ada ${notes.length} catatan. ');
          for (var i = 0; i < notes.length && i < 5; i++) {
            final n = notes[i];
            b.write('Catatan ${i + 1}. Materi ${n.moduleName}. '
                'Penilaian ${n.rating} dari 5. ${n.noteContent}. ');
          }
          if (notes.length > 5) {
            b.write('Dan ${notes.length - 5} catatan lainnya. ');
          }
        }
        return b.toString();
      },
    );
  }

  void _openProfile() => _openPage(
      'Ini halaman profil dan pengaturan. '
      'Nama pengguna, I Gede Adiwidya Utama. '
      'Nomor induk mahasiswa, 2 4 1 5 0 5 1 0 0 1. '
      'Kelas, 5 I K I, P T I. '
      'Di halaman ini ada pengaturan kecepatan suara AI, yang diatur oleh guru pendamping, '
      'dan tombol tes suara. '
      'Tentang SvaraSains. Pembelajaran STEM berbasis audio dan cerita rakyat Bali '
      'untuk siswa tunanetra SLB Negeri 1 Buleleng.',
      const ProfileScreen());

  // ── Suara ──────────────────────────────────────────────

  void _listen() => _voice.toggle(
        cue: 'Silakan bicara.',
        cueLocale: _id,
        sttLocale: 'id_ID',
        retryCue: 'Aku belum mendengar. Silakan bicara lagi.',
        unavailable:
            'Pengenalan suara tidak tersedia. Periksa izin mikrofon dan internet, atau minta bantuan pendamping.',
      );

  void _onWords(String w) {
    if (w.isEmpty) {
      _say('Aku tidak mendengar. Tekan spasi dan coba lagi.');
      return;
    }
    _handleWords(w);
  }

  void _handleWords(String w) {
    // 00) wawasan sains (REST API Wikipedia)
    if (w.contains('wawasan') || w.contains('artikel')) {
      _openScience();
      return;
    }
    // 0) penjelasan program
    if (w.contains('tentang') || w.contains('program') || w.contains('aplikasi')) {
      _say('Membuka penjelasan program.');
      _openAbout();
      return;
    }
    // 1) judul / kata kunci cerita
    for (var i = 0; i < _stories.length; i++) {
      if (_stories[i].voiceKeys.any(w.contains)) {
        _say('Membuka materi ${_stories[i].title.id}.');
        _open(i);
        return;
      }
    }
    // 2) nomor materi (satu, 1, pertama)
    final parts = w.split(RegExp(r'\s+'));
    for (var i = 0; i < _stories.length && i < _numberWords.length; i++) {
      if (parts.contains(_numberWords[i]) ||
          parts.contains(_ordinals[i]) ||
          parts.contains('${i + 1}')) {
        _say('Membuka materi ${_stories[i].title.id}.');
        _open(i);
        return;
      }
    }
    // 3) perintah lain
    if (w.contains('catatan')) {
      _openNotes();
    } else if (w.contains('profil')) {
      _openProfile();
    } else if (w.contains('bantuan')) {
      _help();
    } else if (w.contains('ulang') || w.contains('daftar')) {
      _greet();
    } else if (w.contains('lanjut') || w.contains('buka') || w.contains('mulai')) {
      _say('Membuka materi ${_stories[_sel].title.id}.');
      _open(_sel);
    } else {
      _say('Aku belum mengenali itu. Tekan spasi dan sebutkan nomor atau judul materi.');
    }
  }

  // ── Keyboard ───────────────────────────────────────────

  KeyEventResult _onKey(FocusNode node, KeyEvent e) {
    // Tab dimatikan supaya tidak ada tombol di layar yang ikut terpilih.
    if (e.logicalKey == LogicalKeyboardKey.tab) return KeyEventResult.handled;
    if (e is! KeyDownEvent) return KeyEventResult.ignored;
    final k = e.logicalKey;

    if (_phase == _Phase.gate) {
      _runIntro();
      return KeyEventResult.handled;
    }
    if (_phase == _Phase.intro) {
      if (kKeyboardShortcuts &&
          (k == LogicalKeyboardKey.enter || k == LogicalKeyboardKey.escape)) {
        _toHome();
      } else {
        _unlockVoice();
      }
      return KeyEventResult.handled;
    }

    if (k == LogicalKeyboardKey.space) {
      _listen();
      return KeyEventResult.handled;
    }
    if (_listening || !kKeyboardShortcuts) return KeyEventResult.ignored;

    // Tombol cadangan (tidak pernah disebutkan oleh suara).
    final d = _digits.indexOf(k);
    if (d >= 0) {
      _open(d);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowDown) {
      setState(() => _sel = (_sel + 1) % _stories.length);
      _speakSelection();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowUp) {
      setState(() => _sel = (_sel - 1 + _stories.length) % _stories.length);
      _speakSelection();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.enter || k == LogicalKeyboardKey.numpadEnter) {
      _open(_sel);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.keyT) {
      _openAbout();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.keyW) {
      _openScience();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.keyH) {
      _help();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.keyR) {
      _greet();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  // ── Tampilan (hanya untuk dilihat; tidak bisa diklik) ──

  static const _bgGradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFE8EAF6), Color(0xFFE0F7FA), Colors.white],
    ),
  );

  Widget _logoCard(double height) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 6))
          ],
        ),
        child: Image.asset(_logo, height: height, semanticLabel: 'Logo SvaraSains'),
      );

  // Layar cadangan (tidak dipakai lagi: sambutan langsung otomatis).
  Widget _gate() => Container(
        decoration: _bgGradient,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              _logoCard(160).animate().fadeIn(duration: 600.ms).scale(
                  begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
              const SizedBox(height: 28),
              const Text('Belajar sains lewat cerita rakyat Bali',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w600, color: Colors.indigo)),
            ]),
          ),
        ),
      );

  Widget _feature(IconData icon, String label) => Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Column(children: [
          Icon(icon, size: 36, color: Colors.indigo),
          const SizedBox(height: 8),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ]),
      );

  // Layar sambutan (dibacakan, lalu otomatis ke beranda).
  Widget _intro() => Container(
        decoration: _bgGradient,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              _logoCard(110).animate().fadeIn(duration: 500.ms),
              const SizedBox(height: 20),
              const Text('Selamat datang di SvaraSains',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold, color: Colors.indigo))
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 500.ms)
                  .slideY(begin: 0.2),
              const SizedBox(height: 10),
              const Text(
                      'Aplikasi belajar sains lewat cerita rakyat Bali untuk siswa tunanetra dan low vision.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, height: 1.4))
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 500.ms),
              const SizedBox(height: 24),
              Wrap(spacing: 14, runSpacing: 14, alignment: WrapAlignment.center, children: [
                _feature(Icons.keyboard_voice, 'Dikendalikan suara dan tombol spasi'),
                _feature(Icons.translate, 'Bahasa Bali, Indonesia, dan Inggris'),
                _feature(Icons.quiz, 'Soal dan evaluasi di setiap cerita'),
              ]).animate().fadeIn(delay: 700.ms, duration: 600.ms).slideY(begin: 0.15),
              const SizedBox(height: 28),
              const SizedBox(
                  width: 260,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: LinearProgressIndicator(minHeight: 6),
                  )),
              const SizedBox(height: 8),
              const Text('Menuju beranda...', style: TextStyle(color: Colors.black54)),
            ]),
          ),
        ),
      );

  Widget _chip(IconData icon, String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.indigo.shade100),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 16, color: Colors.indigo),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.indigo)),
        ]),
      );

  Widget _banner() => Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _listening
                ? [Colors.red.shade400, Colors.red.shade700]
                : [const Color(0xFF3949AB), const Color(0xFF00ACC1)],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
        ),
        child: Row(children: [
          Icon(_listening ? Icons.mic : Icons.volume_up, color: Colors.white, size: 32)
              .animate(target: _listening ? 1 : 0)
              .scale(begin: const Offset(1, 1), end: const Offset(1.3, 1.3)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _listening
                  ? 'Mendengarkan: "$_heard"'
                  : 'Tekan SPASI, lalu sebutkan nomor atau judul materi'
                      '${_voice.lastError.isEmpty ? '' : '  (${_voice.lastError})'}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white, fontSize: 19),
            ),
          ),
        ]),
      );

  Widget _thumb(int i) {
    final s = _stories[i];
    var url = i < _thumbs.length ? _thumbs[i] : '';
    if (url.isEmpty && s.scenes.isNotEmpty) url = s.scenes.first.imageUrl;
    Widget fallback() => Container(
          color: Colors.indigo.shade100,
          child: const Center(child: Icon(Icons.auto_stories, size: 48)),
        );
    if (url.isEmpty) return fallback();
    Widget onError(BuildContext c, Object e, StackTrace? st) => fallback();
    return url.startsWith('http')
        ? Image.network(url, fit: BoxFit.cover, errorBuilder: onError)
        : Image.asset(url, fit: BoxFit.cover, errorBuilder: onError);
  }

  Widget _card(int i) {
    final s = _stories[i];
    final selected = i == _sel;
    final cs = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: selected ? 8 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: selected ? cs.primary : Colors.transparent, width: 3),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: Stack(fit: StackFit.expand, children: [
            _thumb(i),
            Positioned(
              left: 10,
              top: 10,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.indigo,
                child: Text('${i + 1}',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(s.title.bali,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            const SizedBox(height: 2),
            Text('${s.category} • ${s.questionCount} soal',
                style: TextStyle(color: Colors.indigo.shade700, fontSize: 13)),
          ]),
        ),
      ]),
    ).animate().fadeIn(delay: (100 * i).ms, duration: 400.ms).slideY(begin: 0.08);
  }

  Widget _content() => Container(
        decoration: _bgGradient,
        child: Column(children: [
          _banner(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Wrap(spacing: 8, runSpacing: 8, children: [
              _chip(Icons.info_outline, 'Ucapkan: tentang'),
              _chip(Icons.public, 'Ucapkan: wawasan'),
              _chip(Icons.note_alt_outlined, 'Ucapkan: catatan'),
              _chip(Icons.person_outline, 'Ucapkan: profil'),
              _chip(Icons.help_outline, 'Ucapkan: bantuan'),
            ]),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 380,
                mainAxisExtent: 300,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: _stories.length,
              itemBuilder: (_, i) => _card(i),
            ),
          ),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final home = _phase == _Phase.home;
    return Focus(
      focusNode: _focus,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: home
            ? AppBar(
                title: Row(children: [
                  Image.asset(_logo, height: 32, semanticLabel: 'Logo SvaraSains'),
                  const SizedBox(width: 12),
                  const Text('SvaraSains'),
                ]),
                foregroundColor: Colors.white,
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFF3949AB), Color(0xFF00ACC1)]),
                  ),
                ),
              )
            : null,
        body: switch (_phase) {
          _Phase.gate => _gate(),
          _Phase.intro => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _unlockVoice,
              child: _intro(),
            ),
          _Phase.home => _content(),
        },
      ),
    );
  }
}