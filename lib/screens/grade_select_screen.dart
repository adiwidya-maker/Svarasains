import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/story.dart';
import '../services/speaker.dart';
import '../services/voice_input.dart';
import 'story_player_screen.dart';

/// Memilih kelas (2 sampai 6) sebelum cerita dimulai.
/// Soal diambil dari bank soal sesuai kelas, dan berbeda tiap sesi.
class GradeSelectScreen extends StatefulWidget {
  final Story story;
  final NarrationLang lang;
  const GradeSelectScreen({super.key, required this.story, required this.lang});

  @override
  State<GradeSelectScreen> createState() => _GradeSelectScreenState();
}

class _GradeSelectScreenState extends State<GradeSelectScreen> {
  static const _id = 'id-ID';
  static const _classes = [2, 3, 4, 5, 6];
  static const _words = <String, int>{
    '2': 2, 'dua': 2, 'kedua': 2, 'two': 2,
    '3': 3, 'tiga': 3, 'ketiga': 3, 'three': 3,
    '4': 4, 'empat': 4, 'keempat': 4, 'four': 4,
    '5': 5, 'lima': 5, 'kelima': 5, 'five': 5,
    '6': 6, 'enam': 6, 'keenam': 6, 'six': 6,
  };
  static final _keys = <LogicalKeyboardKey, int>{
    LogicalKeyboardKey.digit2: 2,
    LogicalKeyboardKey.digit3: 3,
    LogicalKeyboardKey.digit4: 4,
    LogicalKeyboardKey.digit5: 5,
    LogicalKeyboardKey.digit6: 6,
  };

  final Speaker _speaker = Speaker();
  late final VoiceInput _voice;
  final FocusNode _focus = FocusNode();

  bool get _listening => _voice.listening;
  String get _heard => _voice.heard;

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
    await _voice.init();
    _intro();
  }

  @override
  void dispose() {
    _voice.cancel();
    _speaker.stop();
    _focus.dispose();
    super.dispose();
  }

  void _say(String text) => _speaker.say([Utterance(text, _id)]);

  void _intro() => _say('Sekarang pilih kelasmu. '
      'Tekan spasi, lalu ucapkan kelas dua, tiga, empat, lima, atau enam. '
      'Soal akan disesuaikan dengan kelasmu.');

  void _back() {
    _speaker.stop();
    Navigator.of(context).pop();
  }

  void _choose(int kelas) {
    final band = gradeFromClass(kelas);
    if (band == null) return;
    _speaker.stop();
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (_) => StoryPlayerScreen(
                  story: widget.story.forSession(band),
                  lang: widget.lang,
                )))
        .then((_) {
      if (mounted) _focus.requestFocus();
    });
  }

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
    if (w.contains('kembali') || w.contains('batal')) {
      _back();
      return;
    }
    if (w.contains('ulang') || w.contains('bantuan')) {
      _intro();
      return;
    }
    final kelas = w
        .split(RegExp(r'\s+'))
        .map((t) => _words[t.replaceAll(RegExp(r'[^\p{L}\p{N}]', unicode: true), '')])
        .whereType<int>()
        .firstOrNull;
    if (kelas != null) {
      _choose(kelas);
    } else {
      _say('Aku belum mengenali itu. Tekan spasi, lalu ucapkan kelas dua, tiga, empat, lima, atau enam.');
    }
  }

  // ── Keyboard ───────────────────────────────────────────

  KeyEventResult _onKey(FocusNode node, KeyEvent e) {
    if (e.logicalKey == LogicalKeyboardKey.tab) return KeyEventResult.handled;
    if (e is! KeyDownEvent) return KeyEventResult.ignored;
    final k = e.logicalKey;
    if (k == LogicalKeyboardKey.space) {
      _listen();
      return KeyEventResult.handled;
    }
    if (_listening || !kKeyboardShortcuts) return KeyEventResult.ignored;

    // Tombol cadangan (tidak pernah disebutkan oleh suara).
    if (k == LogicalKeyboardKey.escape) {
      _back();
      return KeyEventResult.handled;
    }
    final kelas = _keys[k];
    if (kelas != null) {
      _choose(kelas);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  // ── Tampilan ───────────────────────────────────────────

  Widget _box(int kelas) => Container(
        width: 150,
        height: 72,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(36),
        ),
        child: Text('Kelas $kelas',
            style: const TextStyle(
                fontSize: 22, color: Colors.white, fontWeight: FontWeight.w600)),
      );

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focus,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.story.title.bali),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Pilih kelasmu',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Soal disesuaikan dengan kelas dan berbeda tiap kali belajar.',
                      textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    alignment: WrapAlignment.center,
                    children: [for (final k in _classes) _box(k)],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _listening
                        ? 'Mendengarkan: "$_heard"'
                        : 'Tekan SPASI, lalu ucapkan: kelas dua, tiga, empat, lima, atau enam',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}