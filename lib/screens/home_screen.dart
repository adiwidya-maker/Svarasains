import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/module_provider.dart';
import '../services/sample_stories.dart';
import 'language_select_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterTts _tts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FocusNode _focusNode = FocusNode();
  bool _isListening = false;
  String _spokenText = '';

  @override
  void initState() {
    super.initState();
    _initVoiceSystem();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ModuleProvider>(context, listen: false).fetchModules();
    });
  }

  @override
  void dispose() {
    _tts.stop();
    _speech.stop();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _initVoiceSystem() async {
    await _tts.setLanguage("id-ID");
    await _tts.setSpeechRate(0.45);
    try {
      await _speech.initialize();
    } catch (_) {}
    _tts.speak("Selamat datang di Svara Sains. Tekan SPASI lalu ucapkan nama materi.");
  }

  // Buka screen lain, lalu kembalikan fokus keyboard saat kembali ke Home.
  void _go(String route) {
    Navigator.pushNamed(context, route).then((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  // Buka cerita: pilih bahasa dulu, lalu player cerita.
  // Sementara semua kartu membuka cerita pertama.
  void _openStory() {
    _tts.stop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LanguageSelectScreen(story: sampleStories.first),
      ),
    ).then((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) {
      if (!_isListening) _startVoiceCommand();
    }
  }

  Future<void> _startVoiceCommand() async {
    await _tts.stop();
    if (!_speech.isAvailable) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pengenalan suara tidak tersedia di perangkat ini.")),
      );
      return;
    }
    setState(() => _isListening = true);

    await _speech.listen(
      localeId: "id_ID",
      onResult: (result) {
        setState(() => _spokenText = result.recognizedWords);
        if (result.finalResult) {
          _processVoiceCommand(_spokenText.toLowerCase());
        }
      },
    );
  }

  void _processVoiceCommand(String command) {
    setState(() => _isListening = false);
    _speech.stop();

    if (command.contains("kambing") || command.contains("macan")) {
      _tts.speak("Membuka materi I Kambing teken I Macan.");
      _openStory();
    } else if (command.contains("catatan")) {
      _tts.speak("Membuka catatan belajar.");
      _go('/notes');
    } else if (command.contains("profil")) {
      _tts.speak("Membuka profil.");
      _go('/profile');
    } else {
      _tts.speak("Perintah tidak dikenali. Silakan tekan SPASI lagi.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ModuleProvider>(context);

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SvaraSains Mobile'),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        body: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : provider.errorMessage != null
                ? Center(child: Text(provider.errorMessage!))
                : provider.modules.isEmpty
                    ? const Center(child: Text("Belum ada materi."))
                    : Column(
                        children: [
                          // Banner AI Voice Status
                          Container(
                            padding: const EdgeInsets.all(16),
                            color: Colors.indigo.shade50,
                            child: Row(
                              children: [
                                Icon(
                                  _isListening ? Icons.mic : Icons.volume_up,
                                  color: Colors.indigo,
                                )
                                    .animate(target: _isListening ? 1 : 0)
                                    .scale(
                                        begin: const Offset(1, 1),
                                        end: const Offset(1.3, 1.3)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _isListening
                                        ? "Mendengarkan: '$_spokenText'..."
                                        : "Tekan [SPASI] di keyboard untuk perintah suara.",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, color: Colors.indigo),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // List Modul STEM (Responsive: 1 kolom compact, 2 kolom wide)
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                bool isWide = constraints.maxWidth > 600;
                                return GridView.builder(
                                  padding: const EdgeInsets.all(16),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: isWide ? 2 : 1,
                                    childAspectRatio: isWide ? 2.5 : 2.2,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                                  itemCount: provider.modules.length,
                                  itemBuilder: (context, index) {
                                    final module = provider.modules[index];
                                    return Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12)),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: _openStory,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: Image.network(
                                                  module.imageUrl,
                                                  width: 90,
                                                  height: 90,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (context, error, stackTrace) =>
                                                          Container(
                                                              color: Colors.indigo.shade100,
                                                              width: 90,
                                                              height: 90,
                                                              child: const Icon(Icons.book)),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      module.title,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      module.topic,
                                                      style: TextStyle(
                                                          color: Colors.indigo.shade700,
                                                          fontSize: 12),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Text(
                                                      module.description,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black54),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: (index) {
            if (index == 1) _go('/notes');
            if (index == 2) _go('/profile');
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Materi'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Catatan'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}