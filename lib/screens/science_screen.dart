import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/science_provider.dart';
import '../services/speaker.dart';

class ScienceScreen extends StatefulWidget {
  const ScienceScreen({super.key});

  @override
  State<ScienceScreen> createState() => _ScienceScreenState();
}

class _ScienceScreenState extends State<ScienceScreen> {
  static const _id = 'id-ID';

  final Speaker _speaker = Speaker();
  final FocusNode _focus = FocusNode();
  int _run = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tour());
  }

  @override
  void dispose() {
    _run++;
    _speaker.stop();
    _focus.dispose();
    super.dispose();
  }

  /// Memuat dan membacakan tiap topik berurutan, lalu berhenti.
  Future<void> _tour() async {
    final my = ++_run;
    final p = context.read<ScienceProvider>();
    var done = await _speaker.say([
      const Utterance(
          'Wawasan sains. Aku akan membacakan ringkasan dari Wikipedia. '
          'Tekan spasi kapan saja untuk kembali ke beranda.',
          _id)
    ]);
    for (var i = 0; i < ScienceProvider.topics.length; i++) {
      if (!done || !mounted || my != _run) return;
      await p.select(i);
      if (!mounted || my != _run) return;
      final String text;
      switch (p.status) {
        case ScienceStatus.loaded:
          text = '${p.article!.title}. ${p.article!.extract}';
        case ScienceStatus.empty:
          text = 'Tidak ada ringkasan untuk ${p.topic}.';
        case ScienceStatus.error:
          await _speaker.say([
            Utterance('${p.error} Tekan spasi untuk kembali ke beranda.', _id)
          ]);
          return;
        default:
          text = '';
      }
      done = await _speaker.say([Utterance(text, _id)]);
    }
    if (done && mounted && my == _run) {
      _speaker.say([
        const Utterance('Selesai. Tekan spasi untuk kembali ke beranda.', _id)
      ]);
    }
  }

  void _back() {
    _run++;
    _speaker.stop();
    Navigator.of(context).maybePop();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent e) {
    if (e.logicalKey == LogicalKeyboardKey.tab) return KeyEventResult.handled;
    if (e is! KeyDownEvent) return KeyEventResult.ignored;
    final k = e.logicalKey;
    if (k == LogicalKeyboardKey.space ||
        (kKeyboardShortcuts && k == LogicalKeyboardKey.escape)) {
      _back();
      return KeyEventResult.handled;
    }
    if (kKeyboardShortcuts && k == LogicalKeyboardKey.keyR) {
      _tour();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Widget _chips(ScienceProvider p) => Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          for (var i = 0; i < ScienceProvider.topics.length; i++)
            Chip(
              label: Text(ScienceProvider.topics[i]),
              backgroundColor:
                  i == p.index ? Colors.indigo : Colors.indigo.shade50,
              labelStyle: TextStyle(
                  color: i == p.index ? Colors.white : Colors.indigo,
                  fontWeight: FontWeight.w600),
            ),
        ],
      );

  Widget _message(IconData icon, String text, Color color) => Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            Icon(icon, size: 56, color: color),
            const SizedBox(height: 12),
            Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18)),
          ]),
        ),
      );

  Widget _body(ScienceProvider p) {
    switch (p.status) {
      case ScienceStatus.idle:
      case ScienceStatus.loading:
        return const Padding(
          padding: EdgeInsets.all(40),
          child: Center(child: CircularProgressIndicator()),
        );
      case ScienceStatus.error:
        return _message(Icons.wifi_off, p.error, Colors.red);
      case ScienceStatus.empty:
        return _message(Icons.search_off,
            'Tidak ada ringkasan untuk "${p.topic}".', Colors.orange);
      case ScienceStatus.loaded:
        final a = p.article!;
        return Card(
          clipBehavior: Clip.antiAlias,
          elevation: 3,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            if (a.thumbnailUrl != null)
              Image.network(a.thumbnailUrl!,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => const SizedBox.shrink()),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(a.title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(a.extract,
                    style: const TextStyle(fontSize: 18, height: 1.5)),
                const SizedBox(height: 8),
                const Text('Sumber: Wikipedia',
                    style: TextStyle(color: Colors.black54)),
              ]),
            ),
          ]),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ScienceProvider>();
    return Focus(
      focusNode: _focus,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Wawasan Sains'),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _chips(p),
                const SizedBox(height: 16),
                _body(p),
                const SizedBox(height: 16),
                const Center(
                  child: Text('Tekan SPASI untuk kembali ke beranda',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}