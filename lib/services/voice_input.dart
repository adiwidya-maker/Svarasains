import 'dart:async';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'speaker.dart';

/// Pengelola mikrofon untuk semua layar.
/// Plugin hanya punya SATU mesin dan mendaftarkan pendengar status/error SEKALI,
/// jadi mesin dipakai bersama dan pendengarnya diarahkan ke layar yang aktif.
class VoiceInput {
  VoiceInput({
    required this.speaker,
    required this.onChange,
    required this.onWords,
  });

  final Speaker speaker;
  final void Function() onChange;

  /// Dipanggil dengan hasil ucapan (huruf kecil). Kosong = tidak terdengar.
  final void Function(String words) onWords;

  static final stt.SpeechToText _speech = stt.SpeechToText();
  static bool _ready = false;
  static VoiceInput? _active;

  static Future<bool> _ensure() async {
    if (_ready) return true;
    try {
      _ready = await _speech.initialize(
        onStatus: (s) => _active?._onStatus(s),
        onError: (e) {
          debugPrint('STT error: ${e.errorMsg}');
          _active?._onError(e.errorMsg);
        },
      );
    } catch (e) {
      debugPrint('STT init gagal: $e');
      _ready = false;
    }
    return _ready;
  }

  bool _disposed = false;
  bool _delivered = true;
  bool busy = false;
  bool listening = false;
  String heard = '';
  String lastError = '';
  int _session = 0;
  int _retries = 0;
  Timer? _guard;
  DateTime _startedAt = DateTime.now();

  String _cueLocale = 'id-ID';
  String _sttLocale = 'id_ID';
  String _retryCue = '';
  int _seconds = 10;

  Future<bool> init() => _ensure();

  void _onError(String msg) {
    lastError = msg;
    if (!_disposed) onChange();
    _onStatus('done');
  }

  void _onStatus(String s) {
    if (s != 'done' && s != 'notListening') return;
    if (!listening) return;
    final my = _session;
    // Tunggu sebentar supaya hasil akhir sempat masuk.
    Future.delayed(const Duration(milliseconds: 350), () {
      if (my == _session) _finish();
    });
  }

  /// Dipanggil saat spasi ditekan.
  Future<void> toggle({
    required String cue,
    required String cueLocale,
    required String sttLocale,
    required String retryCue,
    required String unavailable,
    int seconds = 10,
  }) async {
    if (_disposed) return;
    if (listening) {
      // Abaikan tekanan spasi yang tidak sengaja di awal.
      if (DateTime.now().difference(_startedAt).inMilliseconds < 1500) return;
      try {
        await _speech.stop();
      } catch (_) {}
      return;
    }
    if (busy) return;
    busy = true;
    _retries = 0;
    _cueLocale = cueLocale;
    _sttLocale = sttLocale;
    _retryCue = retryCue;
    _seconds = seconds;
    _active = this;

    await speaker.stop();
    if (!await init()) {
      busy = false;
      speaker.say([Utterance(unavailable, cueLocale)]);
      return;
    }
    final ok = await speaker.say([Utterance(cue, cueLocale)]);
    if (!ok || _disposed) {
      busy = false;
      return;
    }
    // Jeda supaya sisa suara AI tidak tertangkap mikrofon.
    await Future.delayed(const Duration(milliseconds: 350));
    await _start();
    busy = false;
  }

  Future<void> _start() async {
    if (_disposed) return;
    _active = this;
    final my = ++_session;
    _delivered = false;
    heard = '';
    lastError = '';
    listening = true;
    _startedAt = DateTime.now();
    onChange();

    // Bersihkan sesi lama yang mungkin tersangkut.
    try {
      if (_speech.isListening) await _speech.cancel();
    } catch (_) {}

    // Pengaman: kalau mesin tidak pernah melapor selesai, paksa selesai.
    _guard?.cancel();
    _guard = Timer(Duration(seconds: _seconds + 5), () async {
      if (my != _session || !listening) return;
      debugPrint('STT: dipaksa selesai (tidak ada laporan dari mesin)');
      try {
        await _speech.stop();
      } catch (_) {}
      _finish();
    });

    try {
      await _speech.listen(
        listenOptions: stt.SpeechListenOptions(
          localeId: _sttLocale,
          listenFor: Duration(seconds: _seconds),
          pauseFor: const Duration(seconds: 4),
        ),
        onResult: (r) {
          if (my != _session) return;
          heard = r.recognizedWords;
          onChange();
          if (r.finalResult) _finish();
        },
      );
    } catch (e) {
      debugPrint('STT listen gagal: $e');
      lastError = 'listen_gagal';
      _finish();
    }
  }

  void _finish() {
    if (_delivered || _disposed) return;
    _guard?.cancel();
    _guard = null;
    _delivered = true;
    listening = false;
    final words = heard.trim().toLowerCase();
    debugPrint('STT terdengar: "$words"');
    onChange();
    if (words.isEmpty && _retries < 1) {
      _retries++;
      _retry();
      return;
    }
    _retries = 0;
    onWords(words);
  }

  Future<void> _retry() async {
    busy = true;
    final ok = await speaker.say([Utterance(_retryCue, _cueLocale)]);
    if (ok && !_disposed) {
      await Future.delayed(const Duration(milliseconds: 350));
      await _start();
    }
    busy = false;
  }

  void cancel() {
    _disposed = true;
    _session++;
    _guard?.cancel();
    _guard = null;
    listening = false;
    busy = false;
    if (_active == this) {
      _active = null;
      try {
        _speech.cancel();
      } catch (_) {}
    }
  }
}