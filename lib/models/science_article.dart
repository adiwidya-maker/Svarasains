class ScienceArticle {
  final String title;
  final String extract;
  final String? thumbnailUrl;
  final String pageUrl;

  const ScienceArticle({
    required this.title,
    required this.extract,
    this.thumbnailUrl,
    this.pageUrl = '',
  });

  factory ScienceArticle.fromJson(Map<String, dynamic> j) {
    final thumb = j['thumbnail'] as Map<String, dynamic>?;
    final urls = j['content_urls'] as Map<String, dynamic>?;
    final desktop = urls?['desktop'] as Map<String, dynamic>?;
    return ScienceArticle(
      title: (j['title'] ?? '') as String,
      extract: (j['extract'] ?? '') as String,
      thumbnailUrl: thumb?['source'] as String?,
      pageUrl: (desktop?['page'] ?? '') as String,
    );
  }
}