import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/science_article.dart';

class ScienceNotFound implements Exception {
  final String topic;
  ScienceNotFound(this.topic);
}

class ScienceApiService {
  static const _base = 'https://id.wikipedia.org/api/rest_v1/page/summary/';

  Future<ScienceArticle> fetchSummary(String topic) async {
    final uri = Uri.parse('$_base${Uri.encodeComponent(topic)}');
    final res = await http.get(uri).timeout(const Duration(seconds: 10));
    if (res.statusCode == 404) throw ScienceNotFound(topic);
    if (res.statusCode != 200) {
      throw Exception('Server mengembalikan kode ${res.statusCode}');
    }
    return ScienceArticle.fromJson(
        jsonDecode(res.body) as Map<String, dynamic>);
  }
}