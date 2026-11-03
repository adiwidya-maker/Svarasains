import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/story.dart';
import '../repositories/quiz_repository.dart';
import '../services/app_exception.dart';
import '../services/speaker.dart';

class ResultScreen extends StatefulWidget {
  final Story story;
  final List<int> answers;
  final NarrationLang lang;
  const ResultScreen({
    super.key,
    required this.story,
    required this.answers,
    required this.lang,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  static const _letters = ['A', 'B', 'C', 'D'];

  final Speaker _speaker = Speaker();
  final QuizRepository _repo = QuizRepository();
  final FocusNode _focus = FocusNode();

  bool _loading = true;
  String? _error;
  List<List<double>>? _stats;

  NarrationLang get _l => widget.lang;
  String _t(String id, String en, String bali) => _l.t(id, en, bali);
  List<Question> get _qs => widget.story.questions;

  int get _correct {
    var n = 0;
    for (var i = 0; i < _qs.length && i < widget.answers.length; i++) {
      if (widget.answers[i] == _qs[i].correctIndex) n++;
    }
    return n;
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      await _repo.save(
        storyId: widget.story.id,
        answers: widget.answers,
        language: widget.lang.name,
      );
    } catch (e) {
      _error = errorText(e);
    }
    try {
      _stats = await _repo.percentages(widget.story.id, _qs.length);
    } catch (e) {
      _error ??= errorText(e);
    }
    if (!mounted) return;
    setState(() => _loading = false);
    _speakResult();
  }

  void _speakResult() {
    final loc = _l.ttsLocale;
    final n = _qs.length;
    final items = <Utterance>[
      Utterance(
          _t(
            'Cerita selesai. Kamu menjawab $_correct dari $n soal dengan benar. Berikut evaluasi tiap soal. Tekan spasi kapan saja untuk kembali ke beranda.',
            'The story is over. You answered $_correct of $n questions correctly. Here is the evaluation of each question. Press space at any time to return home.',
            'Satua sampun puput. Semeton nyawis $_correct saking $n pitakén sané patut. Puniki evaluasi soang-soang pitakén. Pencet spasi mangda mawali ka beranda.',
          ),
          loc),
    ];
    for (var i = 0; i < n; i++) {
      final q = _qs[i];
      final b = StringBuffer(
          '${_t('Soal', 'Question', 'Pitakén')} ${i + 1}. ${q.text.of(_l)} ');
      b.write(_t(
        'Jawaban yang benar adalah ${_letters[q.correctIndex]}, ${q.options[q.correctIndex].of(_l)}.',
        'The correct answer is ${_letters[q.correctIndex]}, ${q.options[q.correctIndex].of(_l)}.',
        'Jawaban sané patut inggih punika ${_letters[q.correctIndex]}, ${q.options[q.correctIndex].of(_l)}.',
      ));
      if (i < widget.answers.length) {
        b.write(' ${_t('Kamu memilih', 'You chose', 'Semeton milih')} ${_letters[widget.answers[i]]}.');
      }
      final s = _stats?[i];
      if (s != null) {
        b.write(' ${_t('Persentase siswa yang memilih:', 'Percentage of students who chose each option:', 'Persentase murid sané milih:')} ');
        for (var j = 0; j < q.options.length; j++) {
          b.write('${_letters[j]}, ${s[j].round()} ${_t('persen', 'percent', 'persén')}. ');
        }
      }
      b.write(' ${q.explanation.of(_l)}');
      items.add(Utterance(b.toString(), loc));
    }
    _speaker.say(items);
  }

  @override
  void dispose() {
    _speaker.stop();
    _focus.dispose();
    super.dispose();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent e) {
    if (e.logicalKey == LogicalKeyboardKey.tab) return KeyEventResult.handled;
    if (e is! KeyDownEvent) return KeyEventResult.ignored;
    final k = e.logicalKey;
    if (k == LogicalKeyboardKey.space ||
        k == LogicalKeyboardKey.escape ||
        k == LogicalKeyboardKey.enter) {
      _speaker.stop();
      Navigator.of(context).popUntil((r) => r.isFirst);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.keyR && !_loading) {
      _speakResult();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Widget _option(Question q, int qi, int j) {
    final isCorrect = j == q.correctIndex;
    final mine = qi < widget.answers.length && widget.answers[qi] == j;
    final pct = _stats?[qi][j];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Text('${_letters[j]}.  ${q.options[j].of(_l)}',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: isCorrect || mine ? FontWeight.bold : FontWeight.normal)),
          ),
          Text(pct == null ? '-' : '${pct.round()}%',
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: (pct ?? 0) / 100,
          minHeight: 10,
          borderRadius: BorderRadius.circular(6),
        ),
        if (isCorrect || mine)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Wrap(spacing: 12, children: [
              if (isCorrect)
                const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 18),
                  SizedBox(width: 4),
                  Text('Jawaban benar'),
                ]),
              if (mine)
                const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.person, size: 18),
                  SizedBox(width: 4),
                  Text('Pilihanmu'),
                ]),
            ]),
          ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focus,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Evaluasi Cerita'),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: _loading
            ? const Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Menyiapkan hasil...'),
                ]),
              )
            : Column(children: [
                Expanded(
                  child: ListView(padding: const EdgeInsets.all(16), children: [
                    Card(
                      color: Colors.indigo.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(children: [
                          Text(widget.story.title.bali,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('Benar $_correct dari ${_qs.length} soal',
                              style: const TextStyle(fontSize: 22)),
                        ]),
                      ),
                    ),
                    if (_error != null)
                      Card(
                        color: Colors.orange.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text('Persentase siswa belum tersedia. $_error'),
                        ),
                      ),
                    for (var i = 0; i < _qs.length; i++)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Soal ${i + 1}: ${_qs[i].text.of(_l)}',
                                    style: const TextStyle(
                                        fontSize: 17, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 12),
                                for (var j = 0; j < _qs[i].options.length; j++)
                                  _option(_qs[i], i, j),
                                const Divider(),
                                Text('Penjelasan: ${_qs[i].explanation.of(_l)}'),
                              ]),
                        ),
                      ),
                  ]),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.indigo,
                  padding: const EdgeInsets.all(14),
                  child: const Text(
                                        'Tekan [SPASI] untuk kembali ke beranda',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
      ),
    );
  }
}