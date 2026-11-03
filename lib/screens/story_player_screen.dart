import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/story.dart';
import '../services/speaker.dart';
import '../services/voice_input.dart';
import 'result_screen.dart';

/// Satu langkah di alur cerita: adegan ATAU soal.
class _Item {
  final StoryScene? scene;
  final Question? question;
  final int questionNumber; // mulai 1; 0 jika adegan
  const _Item.scene(StoryScene this.scene)
      : question = null,
        questionNumber = 0;
  const _Item.question(Question this.question, this.questionNumber) : scene = null;
}

class StoryPlayerScreen extends StatefulWidget {
  final Story story;
  final NarrationLang lang;
  const StoryPlayerScreen({super.key, required this.story, required this.lang});

  @override
  State<StoryPlayerScreen> createState() => _StoryPlayerScreenState();
}

class _StoryPlayerScreenState extends State<StoryPlayerScreen> {
  static const _letters = ['A', 'B', 'C', 'D'];

  final Speaker _speaker = Speaker();
  late final VoiceInput _voice;
  final FocusNode _focus = FocusNode();

  late final List<_Item> _items;
  int _pos = 0;
  int _run = 0; // penanda putaran bacaan; mencegah auto-lanjut yang basi
  final Map<int, int> _answers = {}; // indeks soal (0..) -> opsi (0..3)

  bool get _listening => _voice.listening;
  String get _heard => _voice.heard;

  NarrationLang get _lang => widget.lang;
  String _t(String id, String en, String bali) => _lang.t(id, en, bali);

  @override
  void initState() {
    super.initState();
    _voice = VoiceInput(
      speaker: _speaker,
      onChange: () {
        if (mounted) setState(() {});
      },
      onWords: _handleWords,
    );
    _items = [];
    var qn = 0;
    for (var i = 0; i < widget.story.scenes.length; i++) {
      _items.add(_Item.scene(widget.story.scenes[i]));
      for (final q in widget.story.questions.where((q) => q.afterScene == i)) {
        qn++;
        _items.add(_Item.question(q, qn));
      }
    }
    _init();
  }

  Future<void> _init() async {
    await _voice.init();
    if (!mounted) return;
    final s = widget.story;
    _play(
        prefix: _t(
      'Memutar cerita ${s.title.id}. Tekan spasi kapan saja untuk berbicara denganku.',
      'Playing the story ${s.title.en}. Press space at any time to talk to me.',
      'Nyaritayang satua ${s.title.bali}. Pencet spasi sasuwene mangda mabaos sareng titiang.',
    ));
  }

  @override
  void dispose() {
    _run++;
    _voice.cancel();
    _speaker.stop();
    _focus.dispose();
    super.dispose();
  }

  _Item get _item => _items[_pos];

  /// Adegan terakhir yang sudah lewat (untuk gambar dan subtitle Bali).
  StoryScene get _displayScene {
    for (var i = _pos; i >= 0; i--) {
      final s = _items[i].scene;
      if (s != null) return s;
    }
    return widget.story.scenes.first;
  }

  String _questionSpeech(_Item it) {
    final q = it.question!;
    final b = StringBuffer(_t('Pertanyaan nomor ${it.questionNumber}.',
        'Question number ${it.questionNumber}.', 'Pitakén nomer ${it.questionNumber}.'));
    b.write(' ${q.text.of(_lang)}');
    for (var i = 0; i < q.options.length && i < _letters.length; i++) {
      b.write(' ${_t('Pilihan', 'Option', 'Pilihan')} ${_letters[i]}. ${q.options[i].of(_lang)}.');
    }
    b.write(' ${_t('Tekan spasi, lalu ucapkan jawabanmu: A, B, C, atau D.', 'Press space, then say your answer: A, B, C or D.', 'Pencet spasi, lantas tuturang jawabané: A, B, C, utawi D.')}');
    return b.toString();
  }

  /// Membaca langkah sekarang. Adegan lanjut otomatis; soal menunggu jawaban.
  Future<void> _play({String prefix = ''}) async {
    final my = ++_run;
    final it = _item;
    final loc = _lang.ttsLocale;
    final done = await _speaker.say([
      if (prefix.isNotEmpty) Utterance(prefix, loc),
      Utterance(it.scene != null ? it.scene!.narration.of(_lang) : _questionSpeech(it), loc),
    ]);
    if (!mounted || !done || my != _run) return;
    if (it.scene != null) _advance();
  }

  void _advance({String prefix = ''}) {
    if (_pos >= _items.length - 1) {
      _finish();
      return;
    }
    setState(() => _pos++);
    _play(prefix: prefix);
  }

  /// Lewati manual. Soal tidak boleh dilewati.
  void _next() {
    final it = _item;
    if (it.question != null && !_answers.containsKey(it.questionNumber - 1)) {
      _run++;
      _speaker.say([
        Utterance(
            _t('Jawab dulu pertanyaan ini.', 'Please answer this question first.',
                'Jawab pitakén puniki malu.'),
            _lang.ttsLocale)
      ]).then((done) {
        if (mounted && done) _play();
      });
      return;
    }
    _advance();
  }

  void _finish() {
    _run++;
    _voice.cancel();
    _speaker.stop();
    final count = widget.story.questionCount;
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => ResultScreen(
        story: widget.story,
        answers: [for (var i = 0; i < count; i++) _answers[i] ?? 0],
        lang: _lang,
      ),
    ));
  }

  void _exit() {
    _run++;
    _voice.cancel();
    _speaker.stop();
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  Future<void> _help() async {
    final my = ++_run;
    final isQ = _item.question != null;
    final text = isQ
        ? _t(
            'Bantuan. Tekan spasi, lalu ucapkan jawabanmu: A, B, C, atau D. Ucapkan ulang untuk mendengar soal lagi, atau kembali untuk keluar.',
            'Help. Press space, then say your answer: A, B, C or D. Say repeat to hear the question again, or back to leave.',
            'Tulung. Pencet spasi, lantas tuturang jawabané: A, B, C, utawi D. Matur ulang mangda ngrengepang pitakén malih, utawi kembali mangda medal.')
        : _t(
            'Bantuan. Cerita berjalan otomatis. Tekan spasi, lalu ucapkan lanjut untuk melewati adegan, ulang untuk mendengar lagi, atau kembali untuk keluar.',
            'Help. The story plays automatically. Press space, then say next to skip a scene, repeat to hear it again, or back to leave.',
            'Tulung. Satuané mamargi surya. Pencet spasi, lantas matur lanjut mangda nglangkungin, ulang mangda ngrengepang malih, utawi kembali mangda medal.');
    final done = await _speaker.say([Utterance(text, _lang.ttsLocale)]);
    if (mounted && done && my == _run) _play();
  }

  // ── Suara ────────────────────────────────────────────────

  void _listen() {
    if (!_voice.listening) _run++; // hentikan auto-lanjut cerita
    _voice.toggle(
      cue: _t('Silakan bicara.', 'Please speak.', 'Mangda mabaos.'),
      cueLocale: _lang.ttsLocale,
      sttLocale: _lang.sttLocale,
      retryCue: _t(
          'Aku belum mendengar. Silakan bicara lagi.',
          'I did not hear you. Please speak again.',
          'Titiang durung ngerunguang. Mangda mabaos malih.'),
      unavailable: _t(
          'Pengenalan suara tidak tersedia. Periksa izin mikrofon dan internet, atau minta bantuan pendamping.',
          'Speech recognition is not available. Check the microphone permission and internet, or ask your helper.',
          'Pangrengeg suara nénten wénten. Mangda nunas tulung ring pendamping.'),
      seconds: 12,
    );
  }

  bool _has(String w, List<String> keys) => keys.any(w.contains);

  void _handleWords(String w) {
    if (w.trim().isEmpty) {
      _retryPrompt(_t('Aku tidak mendengar. Coba lagi dengan menekan spasi.',
          'I did not hear anything. Try again by pressing space.',
          'Titiang nénten ngerunguang. Pencet spasi malih.'));
      return;
    }
    final q = _item.question;
    if (q != null && !_answers.containsKey(_item.questionNumber - 1)) {
      final i = _matchAnswer(w, q);
      if (i != null) {
        _answer(i);
        return;
      }
    }
    if (_has(w, ['bantuan', 'help', 'tulung'])) {
      _help();
      return;
    }
    if (_has(w, ['kembali', 'keluar', 'exit', 'back', 'stop', 'medal'])) {
      _exit();
      return;
    }
    if (_has(w, ['ulang', 'again', 'repeat'])) {
      _play();
      return;
    }
    if (q == null && _has(w, ['lanjut', 'berikut', 'next', 'skip', 'lewati'])) {
      _next();
      return;
    }
    _retryPrompt(q != null
        ? _t('Aku mendengar $w. Tapi itu belum cocok. Ucapkan A, B, C, atau D.',
            'I heard $w. That did not match. Say A, B, C or D.',
            'Titiang ngerunguang $w. Nanging nénten cocok. Matur A, B, C, utawi D.')
        : _t('Aku belum mengenali itu. Tekan spasi lalu ucapkan bantuan.',
            'I did not recognise that. Press space and say help.',
            'Titiang nénten uning. Pencet spasi lantas matur tulung.'));
  }

  void _retryPrompt(String text) async {
    final my = ++_run;
    final done = await _speaker.say([Utterance(text, _lang.ttsLocale)]);
    if (mounted && done && my == _run) _play();
  }

  static const _idNums = ['nol', 'satu', 'dua', 'tiga', 'empat', 'lima', 'enam', 'tujuh', 'delapan', 'sembilan', 'sepuluh', 'sebelas', 'dua belas', 'tiga belas', 'empat belas'];
  static const _enNums = ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten', 'eleven', 'twelve', 'thirteen', 'fourteen'];

  int? _matchAnswer(String raw, Question q) {
    // Bersihkan tanda baca dan spasi ganda.
    final words = raw
        .toLowerCase()
        .replaceAll(RegExp(r'[^\p{L}\p{N}\s]', unicode: true), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    final parts = words.split(' ');

    // 1) sebut isi opsi (teks atau angka)
    for (var i = 0; i < q.options.length; i++) {
      final o = q.options[i].id.toLowerCase().trim();
      final n = int.tryParse(o);
      if (n != null) {
        if (parts.contains(o) ||
            (n < _idNums.length && words.contains(_idNums[n])) ||
            (n < _enNums.length && words.contains(_enNums[n]))) {
          return i;
        }
      } else {
        for (final lang in NarrationLang.values) {
          final t = q.options[i].of(lang).toLowerCase();
          if (t.length > 2 && words.contains(t)) return i;
        }
      }
    }

    // 2) sebut huruf pilihan, termasuk variasi cara Chrome menuliskannya
    const letters = [
      ['a', 'ah', 'ha', 'ei', 'eh', 'aa', 'e'],
      ['b', 'be', 'bee', 'bi', 'beh', 'bei'],
      ['c', 'ce', 'se', 'see', 'sea', 'si', 'ci'],
      ['d', 'de', 'dee', 'di', 'deh', 'te'],
    ];
    for (var i = 0; i < q.options.length && i < letters.length; i++) {
      if (parts.any(letters[i].contains)) return i;
    }

    // 3) urutan: pertama, kedua, ketiga, keempat
    const ordinals = ['pertama', 'kedua', 'ketiga', 'keempat'];
    for (var i = 0; i < q.options.length && i < ordinals.length; i++) {
      if (parts.contains(ordinals[i])) return i;
    }
    return null;
  }

  // Jawaban hanya dicatat. TIDAK diberi tahu benar/salah (evaluasi di akhir).
  void _answer(int i) {
    final it = _item;
    final q = it.question;
    if (q == null || i >= q.options.length) return;
    if (_answers.containsKey(it.questionNumber - 1)) return;
    _answers[it.questionNumber - 1] = i;
    _advance(
        prefix: _t('Jawaban ${_letters[i]} tercatat.', 'Answer ${_letters[i]} recorded.',
            'Jawaban ${_letters[i]} sampun kacatet.'));
  }

  // ── Keyboard ─────────────────────────────────────────────

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
      _exit();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.keyH) {
      _help();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.keyR) {
      _play();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowRight || k == LogicalKeyboardKey.keyN) {
      _next();
      return KeyEventResult.handled;
    }
    if (_item.question != null) {
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
    }
    return KeyEventResult.ignored;
  }

  // ── Tampilan (hanya untuk dilihat; tidak bisa diklik) ───

  Widget _image(String url) {
    Widget fallback(IconData icon) => Container(
          height: 240,
          width: double.infinity,
          color: Colors.indigo.shade100,
          child: Center(child: Icon(icon, size: 64)),
        );
    if (url.isEmpty) return fallback(Icons.auto_stories);
    Widget err(BuildContext c, Object e, StackTrace? s) =>
        fallback(Icons.image_not_supported);
    if (url.startsWith('http')) {
      return Image.network(url,
          height: 240,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: err);
    }
    return Image.asset(url,
        height: 240,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: err);
  }

  Widget _optionBox(int i, Question q) => Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 52),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.indigo, width: 1.5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text('${_letters[i]}.  ${q.options[i].of(_lang)}',
            style: const TextStyle(fontSize: 18)),
      );

  @override
  Widget build(BuildContext context) {
    final it = _item;
    final q = it.question;
    final scene = _displayScene;
    return Focus(
      focusNode: _focus,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.story.title.bali),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: LinearProgressIndicator(value: (_pos + 1) / _items.length),
          ),
        ),
        body: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: KeyedSubtree(
                        key: ValueKey(scene), child: _image(scene.imageUrl)),
                  ),
                ),
                const SizedBox(height: 12),
                // Subtitle: SELALU bahasa Bali, apa pun bahasa suaranya.
                Card(
                  color: Colors.indigo.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(scene.narration.bali,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 22, height: 1.4, fontWeight: FontWeight.w600)),
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
                            Text('${_t('Soal', 'Question', 'Pitakén')} ${it.questionNumber}: ${q.text.of(_lang)}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            for (var i = 0; i < q.options.length; i++) _optionBox(i, q),
                          ]),
                    ),
                  ),
                ],
              ]),
            ),
          ),
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
                      : _heard.isNotEmpty
                          ? 'Terdengar: "$_heard"'
                          : q != null
                              ? 'Tekan SPASI, lalu ucapkan jawabanmu: A, B, C, atau D'
                              : 'Cerita berjalan otomatis  •  Tekan SPASI untuk berbicara',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}