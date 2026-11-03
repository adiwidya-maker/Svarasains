import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/science_article.dart';
import '../services/science_api_service.dart';

enum ScienceStatus { idle, loading, loaded, empty, error }

class ScienceProvider extends ChangeNotifier {
  static const topics = ['Gamelan', 'Bunyi', 'Getaran', 'Gelombang', 'Cahaya'];

  final ScienceApiService _service = ScienceApiService();
  int _token = 0;

  ScienceStatus status = ScienceStatus.idle;
  ScienceArticle? article;
  String error = '';
  int index = 0;

  String get topic => topics[index];

  Future<void> select(int i) async {
    index = i.clamp(0, topics.length - 1);
    final my = ++_token;
    status = ScienceStatus.loading;
    article = null;
    error = '';
    notifyListeners();
    try {
      final a = await _service.fetchSummary(topic);
      if (my != _token) return;
      article = a;
      status = a.extract.trim().isEmpty ? ScienceStatus.empty : ScienceStatus.loaded;
    } on ScienceNotFound {
      if (my != _token) return;
      status = ScienceStatus.empty;
    } on TimeoutException {
      if (my != _token) return;
      error = 'Koneksi terlalu lambat. Periksa internet lalu coba lagi.';
      status = ScienceStatus.error;
    } catch (e) {
      if (my != _token) return;
      debugPrint('Science API gagal: $e');
      error = 'Data sains tidak dapat dimuat. Periksa internet lalu coba lagi.';
      status = ScienceStatus.error;
    }
    notifyListeners();
  }
}