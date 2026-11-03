import 'package:flutter/material.dart';

class StudentNote {
  final String id;
  final String studentId;
  final String moduleName;
  final String noteContent;
  final int rating;
  final String createdAt;

  StudentNote({
    required this.id,
    required this.studentId,
    required this.moduleName,
    required this.noteContent,
    required this.rating,
    required this.createdAt,
  });
}

class NoteProvider with ChangeNotifier {
  List<StudentNote> _notes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<StudentNote> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchNotes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      if (_notes.isEmpty) {
        _notes = [
          StudentNote(
            id: '1',
            studentId: '2415051001',
            moduleName: 'I Kambing teken I Macan',
            noteContent: 'Siswa dapat menyebutkan hewan karnivora dengan sangat baik.',
            rating: 5,
            createdAt: DateTime.now().toString(),
          ),
        ];
      }
    } catch (e) {
      _errorMessage = 'Gagal mengambil catatan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addNote(String moduleName, String noteContent, int rating) async {
    final newNote = StudentNote(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      studentId: '2415051001',
      moduleName: moduleName,
      noteContent: noteContent,
      rating: rating,
      createdAt: DateTime.now().toString(),
    );
    _notes.insert(0, newNote);
    notifyListeners();
  }

  Future<void> updateNote(String id, String newContent, int newRating) async {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes[index] = StudentNote(
        id: id,
        studentId: _notes[index].studentId,
        moduleName: _notes[index].moduleName,
        noteContent: newContent,
        rating: newRating,
        createdAt: _notes[index].createdAt,
      );
      notifyListeners();
    }
  }

  Future<void> deleteNote(String id) async {
    _notes.removeWhere((note) => note.id == id);
    notifyListeners();
  }
}
