class StemModule {
  final String id;
  final String title;
  final String topic;
  final String description;
  final String imageUrl;
  final String narration;
  final String question;
  final List<String> options;
  final String correctAnswer;

  StemModule({
    required this.id,
    required this.title,
    required this.topic,
    required this.description,
    required this.imageUrl,
    required this.narration,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory StemModule.fromJson(Map<String, dynamic> json) {
    return StemModule(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      topic: json['topic'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      narration: json['narration'] ?? '',
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'] ?? '',
    );
  }
}