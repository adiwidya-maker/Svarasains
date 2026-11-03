import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/speaker.dart';
import '../services/voice_input.dart';

class VoicePage extends StatefulWidget {
  /// Teks yang dibacakan (dipakai kalau [introBuilder] kosong).
  final String intro;

  /// Pembuat teks yang dinamis, misalnya membacakan daftar catatan.
  final Future<String> Function()? introBuilder;

  final Widget child;
  const VoicePage({
    super.key,
    required this.intro,
    required this.child,
    this.introBuilder,
  });

  @override
  State<VoicePage> createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> {
  static const _id = 'id-ID';
  static const _backHint =
      'Untuk kembali ke beranda, tekan spasi, lalu ucapkan kembali.';
  static const _backWords = [
    'kembali', 'kembal', 'balik', 'beranda', 'tutup', 'keluar', 'mundur', 'back',
  ];

  final Speaker _speaker = Speaker();
  late final VoiceInput _voice;
  final FocusNode _focus = FocusNode();
  int _introRun = 0;

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
    _voice.init();
    WidgetsBinding.instance.addPostFrameCallback((_) => _intro());
  }

  @override
  void dispose() {
    _introRun++;
    _voice.cancel();
    _speaker.stop();
    _focus.dispose();
    super.dispose();
  }

  void _say(String t) => _speaker.say([Utterance(t, _id)]);

  Future<void> _intro() async {
    final my = ++_introRun;
    var text = widget.intro;
    final build = widget.introBuilder;
    if (build != null) {
      try {
        text = await build();
      } catch (e) {
        debugPrint('Intro gagal: $e');
      }
    }
    // Jangan menimpa kalau siswa sudah menekan spasi saat menunggu.
    if (!mounted || my != _introRun || _voice.listening || _voice.busy) return;
    _say('$text $_backHint');
  }

  void _listen() {
    _introRun++;
    _voice.toggle(
      cue: 'Silakan bicara.',
      cueLocale: _id,
      sttLocale: 'id_ID',
      retryCue: 'Aku belum mendengar. Silakan bicara lagi.',
      unavailable:
          'Pengenalan suara tidak tersedia. Periksa izin mikrofon dan internet, atau minta bantuan pendamping.',
    );
  }

  void _back() {
    _introRun++;
    _speaker.stop();
    Navigator.of(context).maybePop();
  }

  void _onWords(String words) {
    final w = words.toLowerCase();
    if (w.isEmpty) {
      _say('Aku tidak mendengar. Tekan spasi dan coba lagi.');
    } else if (_backWords.any(w.contains)) {
      _back();
    } else if (w.contains('ulang') || w.contains('bantuan')) {
      _intro();
    } else {
      _say('Aku belum mengenali itu. $_backHint');
    }
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent e) {
    if (e.logicalKey == LogicalKeyboardKey.tab) return KeyEventResult.handled;
    if (e is! KeyDownEvent) return KeyEventResult.ignored;
    if (e.logicalKey == LogicalKeyboardKey.space) {
      _listen();
      return KeyEventResult.handled;
    }
    if (kKeyboardShortcuts && e.logicalKey == LogicalKeyboardKey.escape) {
      _back();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focus,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Stack(children: [
        widget.child,
        Positioned(
          left: 0,
          right: 0,
          bottom: 8,
          child: IgnorePointer(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _voice.listening ? Colors.red.shade700 : Colors.indigo,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  _voice.listening
                      ? 'Mendengarkan: "${_voice.heard}"'
                      : 'Tekan SPASI, lalu ucapkan: kembali',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      fontSize: 14),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}