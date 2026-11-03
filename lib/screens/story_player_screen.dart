import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../models/story.dart';
import '../services/speaker.dart';
import 'result_screen.dart';

class StoryPlayerScreen extends StatefulWidget {
  final Story story;
  final NarrationLang lang;
  const StoryPlayerScreen({super.key, required this.story, required this.lang});

  @override
  State<StoryPlayerScreen> createState() => _StoryPlayerScreenState();
}

class _StoryPlayerScreenState extends State<StoryPlayerScreen> {
  static const _letters = ['A', 'B', 'C', 'D'];
  static const _id = 'id-ID';

  final Speaker _speaker = Speaker();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FocusNode _focus = FocusNode();

  int _index = 0;
  bool _listening = false;
  bool _delivered = false;
  bool _finished = false;
  bool _sttReady = false;
  String _heard = '';
  // Pilihan siswa per soal (0=A ... 3=D). Dievaluasi di Langkah 3.
  final List<int> _answers = [];

  List<StoryPart> get _parts => widget.story.parts;
  StoryPart get _part => _parts[_index];

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
    _playPart(prefix: 'Memutar cerita ${widget.story.title.id}.');
  }

  @override
  void dispose() {
    _speaker.stop();
    _speech.stop();
    _focus.dispose();
    super.dispose();
  }

  int get _questionNumber =>
      _parts.take(_index + 1).where((p) => p.question != null).length;

  String _questionSpeech(Question q) {
    final b = StringBuffer('Pertanyaan nomor $_questionNumber. ${q.text.id}');
    for (var i = 0; i < q.options.length && i < _letters.length; i++) {
      b.write(' Pilihan ${_letters[i]}. ${q.options[i].id}.');
    }
    b.write(' Tekan spasi, lalu sebutkan jawabanmu.');
    return b.toString();
  }

  // Narasi (bahasa pilihan) -> soal (selalu Indonesia). Tanpa klik.
  Future<void> _playPart({String prefix = ''}) async {
    final l = widget.lang;
    final q = _part.question;
    final done = await _speaker.say([
      if (prefix.isNotEmpty) Utterance(prefix, _id),
      Utterance(_part.narration.of(l), l.ttsLocale),
      if (q != null) Utterance(_questionSpeech(q), _id),
    ]);
    if (!mounted || !done) return;
    if (q == null) _advance();
  }

    void _advance({String prefix = ''}) {
    if (_index >= _parts.length - 1) {
      setState(() => _finished = true);
      _speaker.stop();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => ResultScreen(
          story: widget.story,
          answers: List<int>.from(_answers),
          lang: widget.lang,
        ),
      ));
      return;
    }
    setState(() => _index++);
    _playPart(prefix: prefix);
  }
  

  // Jawaban hanya dicatat. TIDAK diberi tahu benar/salah.
  void _answer(int i) {
    final q = _part.question;
    if (q == null || _finished || i >= q.options.length) return;
    _answers.add(i);
    _advance(prefix: 'Jawaban ${_letters[i]} tercatat.');
  }

  void _onStatus(String s) {
    if (!(s == 'done' || s == 'notListening') || !_listening || !mounted) return;
    setState(() => _listening = false);
    if (_delivered) return;
    _delivered = true;
    if (_heard.trim().isEmpty) {
      _speaker.say([
        const Utterance('Aku tidak mendengar jawabanmu. Tekan spasi dan coba lagi.', _id)
      ]);
    } else {
      _match(_heard.toLowerCase());
    }
  }

  Future<void> _listen() async {
    if (_listening || _finished) return;
    await _speaker.stop();
    if (!_sttReady) {
      _speaker.say([
        const Utterance(
            'Pengenalan suara tidak tersedia. Tekan huruf A, B, C, atau D di keyboard.', _id)
      ]);
      return;
    }
    _delivered = false;
    setState(() {
      _listening = true;
      _heard = '';
    });
    await _speech.listen(
      localeId: 'id_ID',
      listenFor: const Duration(seconds: 12),
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

  void _match(String words) {
    final q = _part.question;
    if (q == null) return;
    for (var i = 0; i < q.options.length; i++) {
      if (words.contains(q.options[i].id.toLowerCase())) return _answer(i);
    }
    const keys = [
      ['a', 'satu', '1'],
      ['b', 'be', 'dua', '2'],
      ['c', 'ce', 'se', 'tiga', '3'],
      ['d', 'de', 'empat', '4'],
    ];
    final parts = words.split(RegExp(r'\s+'));
    for (var i = 0; i < q.options.length && i < keys.length; i++) {
      if (parts.any(keys[i].contains)) return _answer(i);
    }
    _speaker.say([
      const Utterance('Jawaban tidak dikenali. Tekan spasi dan coba lagi.', _id)
    ]);
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent e) {
    if (e is! KeyDownEvent) return KeyEventResult.ignored;
    final k = e.logicalKey;

    if (k == LogicalKeyboardKey.space) {
      if (_finished) {
        Navigator.of(context).popUntil((r) => r.isFirst);
      } else if (_part.question == null) {
        _advance();
      } else {
        _listen();
      }
      return KeyEventResult.handled;
    }

    if (_finished || _listening || _part.question == null) {
      return KeyEventResult.ignored;
    }

    final direct = <LogicalKeyboardKey, int>{
      LogicalKeyboardKey.keyA: 0,
      LogicalKeyboardKey.keyB: 1,
      LogicalKeyboardKey.keyC: 2,
      LogicalKeyboardKey.keyD: 3,
      LogicalKeyboardKey.digit1: 0,
      LogicalKeyboardKey.digit2: 1,
      LogicalKeyboardKey.digit3: 2,
      LogicalKeyboardKey.digit4: 3,
    };
    final i = direct[k];
    if (i != null) {
      _answer(i);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.keyR) {
      _playPart();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Widget _image(String url) {
    Widget fallback(IconData icon) => Container(
          height: 220,
          color: Colors.indigo.shade100,
          child: Center(child: Icon(icon, size: 64)),
        );
    if (url.isEmpty) return fallback(Icons.auto_stories);
    return Image.network(url,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => fallback(Icons.image_not_supported));
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
          bottom: _finished
              ? null
              : PreferredSize(
                  preferredSize: const Size.fromHeight(4),
                  child: LinearProgressIndicator(value: (_index + 1) / _parts.length),
                ),
        ),
        body: _finished ? _finishedView() : _playerView(),
      ),
    );
  }

  Widget _playerView() {
    final q = _part.question;
    return Column(children: [
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(12), child: _image(_part.imageUrl)),
            const SizedBox(height: 12),
            // Subtitle: SELALU bahasa Bali, apa pun bahasa suaranya.
            Card(
              color: Colors.indigo.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_part.narration.bali,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, height: 1.4, fontWeight: FontWeight.w600)),
              ),
            ),
            if (q != null) ...[
              const SizedBox(height: 12),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Soal $_questionNumber: ${q.text.id}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        // Soal & jawaban bahasa Indonesia. Klik opsional (untuk guru).
                        for (var i = 0; i < q.options.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(52)),
                              onPressed: () => _answer(i),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text('${_letters[i]}.  ${q.options[i].id}',
                                    style: const TextStyle(fontSize: 16)),
                              ),
                            ),
                          ),
                      ]),
                ),
              ),
            ],
          ]),
        ),
      ),
      // Bar status suara
      Container(
        width: double.infinity,
        color: _listening ? Colors.red.shade700 : Colors.indigo,
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          Icon(_listening ? Icons.mic : Icons.keyboard_voice, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _listening
                  ? 'Mendengarkan: "$_heard"'
                  : q == null
                      ? 'Tekan [SPASI] untuk melanjutkan cerita.'
                      : 'Tekan [SPASI] lalu sebutkan jawaban  •  atau tekan A / B / C / D  •  R = ulangi',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ]),
      ),
    ]);
  }

  Widget _finishedView() => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.check_circle, size: 72, color: Colors.green),
            const SizedBox(height: 12),
            const Text('Cerita selesai!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Kamu menjawab ${_answers.length} pertanyaan.'),
            const SizedBox(height: 4),
            const Text('(Evaluasi per soal menyusul di langkah berikutnya.)',
                style: TextStyle(fontSize: 12)),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
              child: const Text('Kembali ke Beranda (SPASI)'),
            ),
          ]),
        ),
      );
}