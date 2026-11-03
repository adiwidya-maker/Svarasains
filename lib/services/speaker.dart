import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';

class Utterance {
  final String text;
  final String locale;
  const Utterance(this.text, this.locale);
}

/// Pembaca suara berurutan. Tiap potongan bisa beda bahasa
/// (narasi: bahasa pilihan, soal: Indonesia).
class Speaker {
  final FlutterTts _tts = FlutterTts();
  int _token = 0;
  bool _ready = false;

  /// Kalau suara terlalu cepat/lambat, ubah angka ini per 0.1.
  static double get rate => kIsWeb ? 0.9 : 0.5;

  Future<void> _init() async {
    if (_ready) return;
    _ready = true;
    try {
      await _tts.awaitSpeakCompletion(true);
      await _tts.setPitch(1.0);
    } catch (_) {}
  }

  String _clean(String t) => t
      .replaceAll('"', '')
      .replaceAll('“', '')
      .replaceAll('”', '')
      .replaceAll('...', '.')
      .replaceAll('…', '.')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  /// Membaca semua potongan berurutan.
  /// Return true jika selesai sampai akhir, false jika dipotong (stop / say baru).
  Future<bool> say(List<Utterance> items) async {
    final my = ++_token;
    await _init();
    try {
      await _tts.stop();
      await _tts.setSpeechRate(rate);
    } catch (_) {}
    for (final u in items) {
      if (my != _token) return false;
      try {
        await _tts.setLanguage(u.locale);
        await _tts.speak(_clean(u.text));
      } catch (_) {}
    }
    return my == _token;
  }

  Future<void> stop() async {
    _token++;
    try {
      await _tts.stop();
    } catch (_) {}
  }
}