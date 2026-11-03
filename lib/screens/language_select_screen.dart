import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../models/story.dart';
import '../services/speaker.dart';
import 'story_player_screen.dart';

class LanguageSelectScreen extends StatefulWidget {
  final Story story;
  const LanguageSelectScreen({super.key, required this.story});

  @override
  State<LanguageSelectScreen> createState() => _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends State<LanguageSelectScreen> {
  final Speaker _speaker = Speaker();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FocusNode _focus = FocusNode();
  bool _listening = false;
  bool _delivered = false;
  bool _sttReady = false;
  String _heard = '';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      _sttReady = await _speech.initialize(
        onStatus: _onStatus,
        onError: (_) => _onStatus('done'),
      );
    } catch (_) {
      _sttReady = false;
    }
    _say('Kamu memilih cerita ${widget.story.title.id}. '
        'Pilih bahasa suara narator. '
        'Tekan satu atau katakan Bali. Tekan dua atau katakan Indonesia. '
        'Tekan tiga atau katakan Inggris. '
        'Untuk bicara, tekan spasi lalu ucapkan pilihanmu.');
  }

  void _say(String text) => _speaker.say([Utterance(text, 'id-ID')]);

  @override
  void dispose() {
    _speaker.stop();
    _speech.stop();
    _focus.dispose();
    super.dispose();
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

  void _onStatus(String s) {
    if (!(s == 'done' || s == 'notListening') || !_listening || !mounted) return;
    setState(() => _listening = false);
    if (_delivered) return;
    _delivered = true;
    if (_heard.trim().isEmpty) {
      _say('Aku tidak mendengar. Tekan spasi dan coba lagi.');
    } else {
      _match(_heard.toLowerCase());
    }
  }

  void _match(String w) {
    if (w.contains('bali') || w.contains('satu')) {
      _choose(NarrationLang.bali);
    } else if (w.contains('indo') || w.contains('dua')) {
      _choose(NarrationLang.id);
    } else if (w.contains('inggris') || w.contains('english') || w.contains('tiga')) {
      _choose(NarrationLang.en);
    } else {
      _say('Bahasa tidak dikenali. Tekan spasi dan coba lagi.');
    }
  }

  Future<void> _listen() async {
    if (_listening) return;
    await _speaker.stop();
    if (!_sttReady) {
      _say('Pengenalan suara tidak tersedia. Tekan angka satu, dua, atau tiga.');
      return;
    }
    _delivered = false;
    setState(() {
      _listening = true;
      _heard = '';
    });
    await _speech.listen(
      localeId: 'id_ID',
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 3),
      onResult: (r) {
        setState(() => _heard = r.recognizedWords);
        if (r.finalResult && !_delivered) {
          _delivered = true;
          setState(() => _listening = false);
          _match(r.recognizedWords.toLowerCase());
        }
      },
    );
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent e) {
    if (e is! KeyDownEvent) return KeyEventResult.ignored;
    final k = e.logicalKey;
    if (k == LogicalKeyboardKey.space) {
      _listen();
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
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Teks (subtitle) tetap berbahasa Bali.',
                      textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  for (final lang in NarrationLang.values)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(64)),
                        onPressed: () => _choose(lang),
                        icon: const Icon(Icons.record_voice_over),
                        label: Text('${lang.index + 1}.  ${lang.label}',
                            style: const TextStyle(fontSize: 18)),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    _listening
                        ? 'Mendengarkan: "$_heard"'
                        : 'Tekan [SPASI] lalu ucapkan: Bali / Indonesia / Inggris (atau tekan angka 1, 2, 3)',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontStyle: FontStyle.italic),
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