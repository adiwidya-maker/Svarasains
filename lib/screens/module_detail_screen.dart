import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../providers/module_provider.dart';

class ModuleDetailScreen extends StatefulWidget {
  const ModuleDetailScreen({super.key});

  @override
  State<ModuleDetailScreen> createState() => _ModuleDetailScreenState();
}

class _ModuleDetailScreenState extends State<ModuleDetailScreen> {
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() async {
    await _tts.setLanguage("id-ID");
    await _tts.setSpeechRate(0.45);
    final selectedModule = Provider.of<ModuleProvider>(context, listen: false).selectedModule;
    if (selectedModule != null) {
      _tts.speak("Memutar cerita ${selectedModule.title}. ${selectedModule.narration}");
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final module = Provider.of<ModuleProvider>(context).selectedModule;

    if (module == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Detail Materi")),
        body: const Center(child: Text("Tidak ada materi yang dipilih.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(module.title),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                module.imageUrl,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  height: 200,
                  color: Colors.indigo.shade100,
                  child: const Icon(Icons.image, size: 50),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.indigo.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Topik: ${module.topic}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                    const SizedBox(height: 8),
                    Text(module.narration, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}