import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/app_config.dart';
import 'providers/module_provider.dart';
import 'providers/note_provider.dart';
import 'screens/home_screen.dart';
import 'screens/module_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/progress_notes_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (AppConfig.supabaseReady) {
    try {
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        anonKey: AppConfig.supabaseAnonKey,
      );
    } catch (e) {
      debugPrint('Supabase init gagal: $e');
    }
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ModuleProvider()),
        ChangeNotifierProvider(create: (_) => NoteProvider()),
      ],
      child: const SvaraSainsApp(),
    ),
  );
}

class SvaraSainsApp extends StatelessWidget {
  const SvaraSainsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SvaraSains Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/detail': (context) => const ModuleDetailScreen(),
        '/notes': (context) => const ProgressNotesScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}