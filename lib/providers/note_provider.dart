import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';

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

  /// Baris tabel student_notes -> objek Dart.
  factory StudentNote.fromMap(Map<String, dynamic> m) => StudentNote(
        id: '${m['id']}',
        studentId: '${m['student_id']}',
        moduleName: '${m['module_title']}',
        noteContent: '${m['note']}',
        rating: (m['rating'] as num?)?.toInt() ?? 5,
        createdAt: '${m['created_at']}',
      );
}

class NoteProvider with ChangeNotifier {
  static const _table = 'student_notes';
  static const _studentId = '2415051001';

  List<StudentNote> _notes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<StudentNote> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  SupabaseClient get _db {
    if (!AppConfig.supabaseReady) {
      throw Exception('Supabase belum dikonfigurasi (cek app_config.dart).');
    }
    return Supabase.instance.client;
  }

  String _msg(Object e) => e is PostgrestException ? e.message : '$e';

  // READ
  Future<void> fetchNotes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final rows = await _db
          .from(_table)
          .select()
          .eq('student_id', _studentId)
          .order('created_at', ascending: false);
      _notes = [for (final r in rows) StudentNote.fromMap(r)];
    } catch (e) {
      _errorMessage = 'Gagal mengambil catatan: ${_msg(e)}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- Tahap 2-4 menggantikan tiga fungsi di bawah ini ---

  Future<void> addNote(String moduleName, String noteContent, int rating) async {
    final newNote = StudentNote(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      studentId: _studentId,
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