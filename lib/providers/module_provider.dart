import 'package:flutter/material.dart';
import '../models/stem_module.dart';

class ModuleProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<StemModule> _modules = [];
  StemModule? _selectedModule;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<StemModule> get modules => _modules;
  StemModule? get selectedModule => _selectedModule;

  // Simulasi REST API GET Data Materi STEM
  Future<void> fetchModules() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulasi network delay
      _modules = [
        StemModule(
          id: 'stem-01',
          title: 'I Kambing teken I Macan',
          topic: 'Ekosistem & Rantai Makanan',
          description: 'Mengenal pengelompokan hewan berdasarkan jenis makanannya melalui cerita rakyat Bali.',
          imageUrl: 'https://images.unsplash.com/photo-1534188753412-3e26d0d618d6?w=600',
          narration: 'Mémé... mémé.... ada buron tawah mé. Macan mendekati kambing dengan perlahan di dalam hutan.',
          question: 'Macan ingin memakan kambing karena macan merupakan kelompok hewan...',
          options: ['Karnivora', 'Herbivora', 'Omnivora'],
          correctAnswer: 'Karnivora',
        ),
        StemModule(
          id: 'stem-02',
          title: 'Suhu & Perubahan Benda',
          topic: 'Fisika Dasar',
          description: 'Pembelajaran konsep perpindahan kalor dan penguapan.',
          imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600',
          narration: 'Air laut yang dipanaskan oleh terik matahari akan menguap menjadi awan.',
          question: 'Proses perubahan wujud cair menjadi gas disebut...',
          options: ['Membeku', 'Menguap', 'Mencair'],
          correctAnswer: 'Menguap',
        ),
      ];
    } catch (e) {
      _errorMessage = 'Gagal memuat data materi: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectModule(StemModule module) {
    _selectedModule = module;
    notifyListeners();
  }
}