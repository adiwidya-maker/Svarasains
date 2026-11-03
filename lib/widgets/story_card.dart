import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/story.dart';

class StoryCard extends StatelessWidget {
  final Story story;
  final int index;
  final bool selected;
  final String thumbUrl;
  const StoryCard({
    super.key,
    required this.story,
    required this.index,
    required this.selected,
    required this.thumbUrl,
  });

  Widget _fallback() => Container(
        color: Colors.indigo.shade100,
        child: const Center(child: Icon(Icons.auto_stories, size: 48)),
      );

  Widget _thumb() {
    if (thumbUrl.isEmpty) return _fallback();
    Widget onError(BuildContext c, Object e, StackTrace? st) => _fallback();
    return thumbUrl.startsWith('http')
        ? Image.network(thumbUrl, fit: BoxFit.cover, errorBuilder: onError)
        : Image.asset(thumbUrl, fit: BoxFit.cover, errorBuilder: onError);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: selected ? 8 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: selected ? cs.primary : Colors.transparent, width: 3),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: Stack(fit: StackFit.expand, children: [
            _thumb(),
            Positioned(
              left: 10,
              top: 10,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.indigo,
                child: Text('${index + 1}',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(story.title.bali,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            const SizedBox(height: 2),
            Text('${story.category} • ${story.questionCount} soal',
                style: TextStyle(color: Colors.indigo.shade700, fontSize: 13)),
          ]),
        ),
      ]),
    ).animate().fadeIn(delay: (100 * index).ms, duration: 400.ms).slideY(begin: 0.08);
  }
}