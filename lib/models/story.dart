enum NarrationLang { bali, id, en }

extension NarrationLangX on NarrationLang {
  String get label => switch (this) {
        NarrationLang.bali => 'Basa Bali',
        NarrationLang.id => 'Bahasa Indonesia',
        NarrationLang.en => 'English',
      };

  /// Belum ada suara TTS bahasa Bali, jadi teks Bali dibaca suara Indonesia.
  String get ttsLocale => this == NarrationLang.en ? 'en-US' : 'id-ID';
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

class Question {
  final L10n text;
  final List<L10n> options; // 4 opsi: A, B, C, D
  final int correctIndex;
  final L10n explanation;

  const Question({
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class StoryPart {
  final String imageUrl;
  final L10n narration;
  final Question? question;

  const StoryPart({required this.imageUrl, required this.narration, this.question});
}

class Story {
  final String id;
  final L10n title;
  final String category;
  final String description;
  final String coverUrl;
  final List<StoryPart> parts;

  const Story({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.coverUrl,
    required this.parts,
  });

  List<Question> get questions =>
      parts.where((p) => p.question != null).map((p) => p.question!).toList();

  int get questionCount => questions.length;
}