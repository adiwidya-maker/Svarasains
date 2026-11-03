import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/story.dart';
import '../services/speaker.dart';
import '../services/voice_input.dart';
import 'story_player_screen.dart';

class LanguageSelectScreen extends StatefulWidget {
  final Story story;
  const LanguageSelectScreen({super.key, required this.story});

  @override
  State<LanguageSelectScreen> createState() => _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends State<LanguageSelectScreen> {
  static const _id = 'id-ID';

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

  void _intro() => _say('Kamu memilih cerita ${widget.story.title.id}. '
      'Sekarang pilih bahasa suara. '
      'Tekan spasi, lalu ucapkan Bali, Indonesia, atau Inggris.');

  void _back() {
    _speaker.stop();
    Navigator.of(context).pop();
  }

  void _choose(NarrationLang lang) {
    _speaker.stop();
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (_) => StoryPlayerScreen(story: widget.story, lang: lang)))
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
    _match(w);
  }

  void _match(String w) {
    if (w.contains('kembali') || w.contains('batal')) {
      _back();
    } else if (w.contains('ulang') || w.contains('bantuan')) {
      _intro();
    } else if (w.contains('bali') || w.contains('satu')) {
      _choose(NarrationLang.bali);
    } else if (w.contains('indo') || w.contains('dua')) {
      _choose(NarrationLang.id);
    } else if (w.contains('inggris') || w.contains('english') || w.contains('tiga')) {
      _choose(NarrationLang.en);
    } else {
      _say('Aku belum mengenali itu. Tekan spasi, lalu ucapkan Bali, Indonesia, atau Inggris.');
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
    if (k == LogicalKeyboardKey.digit1) {
      _choose(NarrationLang.bali);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.digit2) {
      _choose(NarrationLang.id);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.digit3) {
      _choose(NarrationLang.en);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  // ── Tampilan ───────────────────────────────────────────

  Widget _langBox(NarrationLang lang) => Container(
        height: 64,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.record_voice_over, color: Colors.white),
          const SizedBox(width: 12),
          Text(lang.label,
              style: const TextStyle(
                  fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600)),
        ]),
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
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Pilih bahasa suara narator',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Teks (subtitle) cerita tetap berbahasa Bali.',
                      textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 24),
                  for (final lang in NarrationLang.values)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _langBox(lang),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    _listening
                        ? 'Mendengarkan: "$_heard"'
                        : 'Tekan SPASI, lalu ucapkan: Bali, Indonesia, atau Inggris',
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