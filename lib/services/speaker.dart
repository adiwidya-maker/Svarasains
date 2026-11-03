import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:flutter_tts/flutter_tts.dart';

/// true  = tombol cadangan (angka, panah, huruf, Esc) tetap aktif untuk uji coba.
/// false = siswa HANYA memakai SPASI dan suara. Ubah ke false sebelum demo akhir.
const bool kKeyboardShortcuts = true;

/// false = pakai suara bawaan perangkat tanpa memilih suara perempuan.
const bool kPickVoice = true;

class Utterance {
  final String text;
  final String locale;
  const Utterance(this.text, this.locale);
}

/// Pembaca suara berurutan yang tahan gagal.
/// Satu mesin dipakai bersama oleh semua layar; hanya pembicara yang sedang
/// aktif yang boleh menghentikan mesin.
class Speaker {
  static final FlutterTts _tts = FlutterTts();
  static Future<void>? _initFuture;
  static Speaker? _current;
  static Completer<bool>? _pending;
  static bool _startSeen = false; // platform ini mengirim sinyal "mulai"
  static bool _startedThis = false; // bacaan sekarang sudah mulai bersuara
  static String _lastError = '';
  static List<Map<String, String>> _voices = [];
  static final Map<String, Map<String, String>> _picked = {};

  /// true kalau browser memblokir suara (belum ada tombol yang ditekan).
  static bool blocked = false;

  /// Kalau suara terlalu cepat/lambat, ubah angka ini per 0.05.
  static double get rate => kIsWeb ? 0.85 : 0.45;

  /// Boleh dipanggil lebih awal (misalnya di main) supaya suara siap lebih cepat.
  static Future<void> warmUp() => _initEngine();

  int _token = 0;

  static void _finishPending(bool ok) {
    final p = _pending;
    if (p != null && !p.isCompleted) p.complete(ok);
  }

  static Future<void> _initEngine() {
    return _initFuture ??= () async {
      try {
        _tts.setStartHandler(() {
          _startSeen = true;
          _startedThis = true;
        });
        _tts.setCompletionHandler(() {
          // Abaikan sinyal selesai milik bacaan lama.
          if (_startSeen && !_startedThis) return;
          _finishPending(true);
        });
        _tts.setCancelHandler(() {
          // Pembatalan ditangani sendiri lewat stop() dan say().
        });
        _tts.setErrorHandler((dynamic m) {
          final msg = '$m'.toLowerCase();
          debugPrint('TTS error: $m');
          if (msg.contains('interrupted') ||
              msg.contains('canceled') ||
              msg.contains('cancelled')) {
            return; // akibat stop() kita sendiri
          }
          _lastError = msg;
          _finishPending(false);
        });
        await _tts.awaitSpeakCompletion(true);
        await _tts.setPitch(1.0);
      } catch (e) {
        debugPrint('TTS init gagal: $e');
      }
      await _loadVoices();
    }();
  }

  static Future<void> _loadVoices() async {
    if (!kPickVoice) return;
    for (var i = 0; i < 6 && _voices.isEmpty; i++) {
      try {
        final raw = await _tts.getVoices.timeout(const Duration(seconds: 2));
        if (raw is List) {
          _voices = [
            for (final v in raw)
              if (v is Map) {'name': '${v['name']}', 'locale': '${v['locale']}'}
          ];
        }
      } catch (e) {
        debugPrint('TTS getVoices gagal: $e');
      }
      if (_voices.isEmpty) {
        await Future.delayed(const Duration(milliseconds: 300));
      }
    }
    debugPrint('TTS: ${_voices.length} suara tersedia');
  }

  static Map<String, String>? _pick(String locale) {
    final want = locale.toLowerCase().replaceAll('_', '-');
    final lang = want.split('-').first;
    Map<String, String>? best;
    var bestScore = -1000;
    for (final v in _voices) {
      final loc = (v['locale'] ?? '').toLowerCase().replaceAll('_', '-');
      if (!loc.startsWith(lang)) continue;
      final n = (v['name'] ?? '').toLowerCase();
      var s = 0;
      if (loc == want) s += 3;
      if (n.contains('google')) s += 12;
      if (n.contains('gadis')) s += 12;
      for (final f in ['aria', 'jenny', 'zira', 'samantha', 'female', 'natural']) {
        if (n.contains(f)) s += 6;
      }
      for (final m in ['ardi', 'andika', 'david', 'mark', 'guy', 'ryan', ' male']) {
        if (n.contains(m)) s -= 20;
      }
      if (s > bestScore) {
        bestScore = s;
        best = v;
      }
    }
    if (best == null || bestScore < 0) return null;
    return best;
  }

  static Future<void> _applyVoice(String locale) async {
    try {
      await _tts.setLanguage(locale).timeout(const Duration(seconds: 2));
    } catch (e) {
      debugPrint('TTS setLanguage gagal: $e');
    }
    if (!kPickVoice) return;
    var v = _picked[locale];
    if (v == null) {
      v = _pick(locale);
      if (v != null) {
        _picked[locale] = v;
        debugPrint('Suara dipilih ($locale): ${v['name']}');
      }
    }
    if (v != null) {
      try {
        await _tts.setVoice(v).timeout(const Duration(seconds: 2));
      } catch (e) {
        debugPrint('TTS setVoice gagal: $e');
      }
    }
  }

  static String _clean(String t) => t
      .replaceAll('"', '')
      .replaceAll('“', '')
      .replaceAll('”', '')
      .replaceAll('...', '.')
      .replaceAll('…', '.')
      .replaceAll('•', '.')
      .replaceAll(':', ',')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  /// Memecah per kalimat. Chrome sering memotong suara yang terlalu panjang.
  static List<String> _chunks(String t, {int max = 150}) {
    final sentences = <String>[];
    var start = 0;
    for (var i = 0; i < t.length; i++) {
      final c = t[i];
      final end = (c == '.' || c == '!' || c == '?') &&
          (i == t.length - 1 || t[i + 1] == ' ');
      if (end) {
        sentences.add(t.substring(start, i + 1).trim());
        start = i + 1;
      }
    }
    if (start < t.length) sentences.add(t.substring(start).trim());

    final out = <String>[];
    var cur = '';
    for (final s in sentences) {
      if (s.isEmpty) continue;
      if (cur.isEmpty) {
        cur = s;
      } else if (cur.length + 1 + s.length <= max) {
        cur = '$cur $s';
      } else {
        out.add(cur);
        cur = s;
      }
    }
    if (cur.isNotEmpty) out.add(cur);
    return out;
  }

  bool _alive(int my) => my == _token && _current == this;

  /// Membaca satu potongan. Diulang sampai 3 kali kalau suara tidak keluar.
  Future<bool> _speakChunk(String chunk, int my) async {
    final expectMs = chunk.length * 55;
    final timeoutMs = chunk.length * 95 + 2500;

    for (var attempt = 0; attempt < 3; attempt++) {
      if (!_alive(my)) return false;
      final pending = Completer<bool>();
      _pending = pending;
      _startedThis = false;
      _lastError = '';
      final sw = Stopwatch()..start();
      void finish(bool ok) {
        if (!pending.isCompleted) pending.complete(ok);
      }

      try {
        unawaited(_tts.speak(chunk).then((_) async {
          if (pending.isCompleted) return;
          // speak() kembali setelah suara selesai.
          if (sw.elapsedMilliseconds >= expectMs * 0.25) {
            finish(true);
            return;
          }
          // Kembali terlalu cepat: beri waktu sinyal "mulai" masuk.
          await Future.delayed(const Duration(milliseconds: 500));
          if (pending.isCompleted) return;
          if (_startedThis) return; // suara berjalan; tunggu sinyal selesai
          if (_startSeen) {
            finish(false); // platform biasanya mengirim "mulai", ini tidak: terbuang
          } else {
            final left = expectMs - sw.elapsedMilliseconds;
            if (left > 0) await Future.delayed(Duration(milliseconds: left));
            finish(true);
          }
        }).catchError((Object e) {
          debugPrint('TTS speak gagal: $e');
          _lastError = '$e'.toLowerCase();
          finish(false);
        }));
      } catch (e) {
        debugPrint('TTS speak melempar: $e');
        _lastError = '$e'.toLowerCase();
        finish(false);
      }

      final ok = await pending.future.timeout(
        Duration(milliseconds: timeoutMs),
        onTimeout: () {
          debugPrint('TTS: batas waktu, lanjut');
          return true;
        },
      );
      if (!_alive(my)) return false;
      if (ok) {
        blocked = false;
        return true;
      }

      if (_lastError.contains('not-allowed') || _lastError.contains('not_allowed')) {
        blocked = true;
        debugPrint('TTS: diblokir browser, menunggu tombol pertama');
        return false;
      }
      debugPrint('TTS: percobaan ${attempt + 1} gagal, mengulang');
      try {
        await _tts.stop();
      } catch (_) {}
      await Future.delayed(Duration(milliseconds: 250 * (attempt + 1)));
    }
    // Semua percobaan gagal: beri jeda seukuran bacaan supaya alur tidak macet.
    debugPrint('TTS: gagal setelah 3 percobaan');
    await Future.delayed(Duration(milliseconds: expectMs));
    return true;
  }

  /// Membaca semua potongan berurutan.
  /// Return true jika selesai sampai akhir, false jika dipotong atau diblokir.
  Future<bool> say(List<Utterance> items) async {
    final my = ++_token;
    _current = this;
    _finishPending(false); // putuskan bacaan sebelumnya
    await _initEngine();
    if (!_alive(my)) return false;

    try {
      await _tts.stop();
    } catch (_) {}
    // Jeda setelah stop: tanpa ini Chrome sering membuang suara berikutnya.
    await Future.delayed(Duration(milliseconds: kIsWeb ? 150 : 80));
    if (!_alive(my)) return false;
    try {
      await _tts.setSpeechRate(rate);
    } catch (_) {}

    for (final u in items) {
      if (!_alive(my)) return false;
      final cleaned = _clean(u.text);
      if (cleaned.isEmpty) continue;
      await _applyVoice(u.locale);
      for (final chunk in _chunks(cleaned)) {
        if (!_alive(my)) return false;
        final ok = await _speakChunk(chunk, my);
        if (!_alive(my) || !ok) return false;
        await Future.delayed(const Duration(milliseconds: 60));
      }
    }
    return _alive(my);
  }

  Future<void> stop() async {
    _token++;
    // Hanya pembicara yang sedang aktif yang boleh menghentikan mesin.
    // Layar yang sedang ditutup tidak boleh memotong suara layar baru.
    if (_current == this) {
      _current = null;
      _finishPending(false);
      try {
        await _tts.stop();
      } catch (_) {}
    }
  }
}