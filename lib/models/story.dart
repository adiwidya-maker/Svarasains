import 'dart:math';

enum NarrationLang { bali, id, en }

extension NarrationLangX on NarrationLang {
  String get label => switch (this) {
        NarrationLang.bali => 'Basa Bali',
        NarrationLang.id => 'Bahasa Indonesia',
        NarrationLang.en => 'English',
      };

  /// Belum ada suara TTS bahasa Bali, jadi teks Bali dibaca suara Indonesia.
  String get ttsLocale => this == NarrationLang.en ? 'en-US' : 'id-ID';
  String get sttLocale => this == NarrationLang.en ? 'en_US' : 'id_ID';

  /// Pilih teks sesuai bahasa narasi.
  String t(String id, String en, String bali) => switch (this) {
        NarrationLang.bali => bali,
        NarrationLang.id => id,
        NarrationLang.en => en,
      };
}

/// Jumlah soal yang diambil dari bank soal tiap kali materi dibuka.
const int kQuestionsPerSession = 3;

/// Tingkat kelas, mengikuti fase Kurikulum Merdeka:
/// a = kelas 2 (fase A), b = kelas 3-4 (fase B), c = kelas 5-6 (fase C).
enum GradeBand { a, b, c }

GradeBand? gradeFromClass(int kelas) => switch (kelas) {
      2 => GradeBand.a,
      3 || 4 => GradeBand.b,
      5 || 6 => GradeBand.c,
      _ => null,
    };

class L10n {
  final String bali;
  final String id;
  final String en;
  const L10n({required this.bali, required this.id, required this.en});

  String of(NarrationLang lang) => switch (lang) {
        NarrationLang.bali => bali,
        NarrationLang.id => id,
        NarrationLang.en => en,
      };
}

/// Satu adegan cerita (mengalir terus, tidak harus ada soal).
class StoryScene {
  final String imageUrl;
  final L10n narration;
  const StoryScene({required this.imageUrl, required this.narration});
}

/// Soal disisipkan SETELAH adegan ke-[afterScene] (index mulai 0).
class Question {
  final L10n text;
  final List<L10n> options; // 4 opsi: A, B, C, D
  final int correctIndex;
  final L10n explanation;
  final int afterScene;

  /// Tingkat kelas yang cocok untuk soal ini.
  final Set<GradeBand> grades;

  /// true = urutan pilihan tidak diacak (misalnya pilihan angka).
  final bool keepOrder;

  const Question({
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.afterScene,
    this.grades = const {GradeBand.a, GradeBand.b, GradeBand.c},
    this.keepOrder = false,
  });

  /// Salinan dengan urutan pilihan diacak; correctIndex ikut disesuaikan.
  Question shuffled(Random r) {
    if (keepOrder) return this;
    final idx = List<int>.generate(options.length, (i) => i)..shuffle(r);
    return Question(
      text: text,
      options: [for (final i in idx) options[i]],
      correctIndex: idx.indexOf(correctIndex),
      explanation: explanation,
      afterScene: afterScene,
      grades: grades,
      keepOrder: keepOrder,
    );
  }
}

class Story {
  static final Random _rng = Random();

  /// Soal yang dipakai pada sesi sebelumnya, per materi (di memori).
  static final Map<String, Set<String>> _lastUsed = {};

  final String id;
  final L10n title;
  final String category;
  final String description;
  final String coverUrl;
  final List<String> voiceKeys; // kata kunci untuk perintah suara
  final List<StoryScene> scenes;

  /// Bank soal. Pada salinan sesi, isinya soal terpilih saja.
  final List<Question> questions;

  /// true = salinan untuk satu sesi belajar (soal sudah dipilih dan diacak).
  final bool isSession;

  const Story({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.coverUrl,
    required this.voiceKeys,
    required this.scenes,
    required this.questions,
    this.isSession = false,
  });

  /// Jumlah soal yang akan dikerjakan siswa (bukan ukuran bank soal).
  int get questionCount =>
      isSession || questions.length < kQuestionsPerSession
          ? questions.length
          : kQuestionsPerSession;

  static int _distance(Question q, GradeBand g) =>
      q.grades.map((x) => (x.index - g.index).abs()).reduce(min);

  /// Membuat salinan materi dengan soal terpilih untuk [grade].
  Story forSession(GradeBand grade, {int count = kQuestionsPerSession}) {
    final pool = questions.where((q) => q.grades.contains(grade)).toList();
    if (pool.length < count) {
      // Kekurangan soal: tambah dari tingkat kelas terdekat.
      final rest = questions.where((q) => !pool.contains(q)).toList()
        ..sort((a, b) => _distance(a, grade).compareTo(_distance(b, grade)));
      pool.addAll(rest.take(count - pool.length));
    }
    final last = _lastUsed[id] ?? <String>{};
    final fresh = pool.where((q) => !last.contains(q.text.id)).toList()
      ..shuffle(_rng);
    final seen = pool.where((q) => last.contains(q.text.id)).toList()
      ..shuffle(_rng);
    final picked = [...fresh, ...seen].take(count).toList();
    _lastUsed[id] = {for (final q in picked) q.text.id};
    picked.sort((a, b) => a.afterScene.compareTo(b.afterScene));

    return Story(
      id: id,
      title: title,
      category: category,
      description: description,
      coverUrl: coverUrl,
      voiceKeys: voiceKeys,
      scenes: scenes,
      questions: [for (final q in picked) q.shuffled(_rng)],
      isSession: true,
    );
  }
}