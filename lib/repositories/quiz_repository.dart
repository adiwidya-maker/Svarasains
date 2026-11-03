import '../services/quiz_service.dart';

class QuizRepository {
  final QuizService _service = QuizService();

  Future<void> save({
    required String storyId,
    required List<int> answers,
    required String language,
  }) =>
      _service.saveAnswers(storyId: storyId, answers: answers, language: language);

  /// Hasil: persen[soal][opsi], nilainya 0-100.
  Future<List<List<double>>> percentages(String storyId, int questionCount) async {
    final rows = await _service.fetchAnswers(storyId);
    final counts = List.generate(questionCount, (_) => List<int>.filled(4, 0));
    for (final r in rows) {
      final q = r['question_index'] as int;
      final c = r['chosen_index'] as int;
      if (q >= 0 && q < questionCount && c >= 0 && c < 4) counts[q][c]++;
    }
    return [
      for (final row in counts)
        () {
          final total = row.fold<int>(0, (a, b) => a + b);
          return [for (final n in row) total == 0 ? 0.0 : n * 100 / total];
        }()
    ];
  }
}