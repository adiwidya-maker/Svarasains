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

  const Question({
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.afterScene,
  });
}

class Story {
  final String id;
  final L10n title;
  final String category;
  final String description;
  final String coverUrl;
  final List<String> voiceKeys; // kata kunci untuk perintah suara
  final List<StoryScene> scenes;
  final List<Question> questions; // urut berdasarkan afterScene

  const Story({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.coverUrl,
    required this.voiceKeys,
    required this.scenes,
    required this.questions,
  });

  int get questionCount => questions.length;
}