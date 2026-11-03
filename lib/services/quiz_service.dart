import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import 'app_exception.dart';

class QuizService {
  SupabaseClient get _db {
    if (!AppConfig.supabaseReady) {
      throw const AppException(
          'Supabase belum dikonfigurasi. Periksa lib/config/app_config.dart.');
    }
    return Supabase.instance.client;
  }

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on AppException {
      rethrow;
    } on PostgrestException catch (e) {
      throw AppException('Database error: ${e.message}');
    } catch (_) {
      throw const AppException('Gagal terhubung ke database. Periksa internet.');
    }
  }

  Future<void> saveAnswers({
    required String storyId,
    required List<int> answers,
    required String language,
  }) =>
      _guard(() async {
        if (answers.isEmpty) return;
        await _db.from('quiz_answers').insert([
          for (var i = 0; i < answers.length; i++)
            {
              'student_id': AppConfig.studentId,
              'story_id': storyId,
              'question_index': i,
              'chosen_index': answers[i],
              'language': language,
            }
        ]);
      });

  Future<List<Map<String, dynamic>>> fetchAnswers(String storyId) =>
      _guard(() async {
        final res = await _db
            .from('quiz_answers')
            .select('question_index, chosen_index')
            .eq('story_id', storyId);
        return List<Map<String, dynamic>>.from(res);
      });
}