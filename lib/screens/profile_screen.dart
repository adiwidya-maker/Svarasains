import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FlutterTts _tts = FlutterTts();
  double _speechRate = 0.45;

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _testVoice() async {
    await _tts.setLanguage('id-ID');
    await _tts.setSpeechRate(_speechRate);
    await _tts.speak('Halo, aku asisten suara SvaraSains. Selamat belajar sains bersama cerita rakyat Bali.');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Memutar suara contoh...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil & Pengaturan'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: ListTile(
              leading: CircleAvatar(radius: 28, child: Icon(Icons.person)),
              title: Text('I Gede Adiwidya Utama',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('NIM 2415051001 • Kelas 5IKI-PTI'),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kecepatan suara AI: ${_speechRate.toStringAsFixed(2)}'),
                  Slider(
                    value: _speechRate,
                    min: 0.3,
                    max: 0.8,
                    divisions: 10,
                    onChanged: (v) => setState(() => _speechRate = v),
                  ),
                  ElevatedButton.icon(
                    onPressed: _testVoice,
                    icon: const Icon(Icons.volume_up),
                    label: const Text('Tes Suara'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Tentang SvaraSains'),
              subtitle: Text(
                  'Pembelajaran STEM berbasis audio dan cerita rakyat Bali untuk siswa tunanetra SLB Negeri 1 Buleleng.'),
            ),
          ),
        ],
      ),
    );
  }
}