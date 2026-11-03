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

  // ── READ ───────────────────────────────────────────────
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

  // ── CREATE ─────────────────────────────────────────────
  Future<bool> addNote(String moduleName, String noteContent, int rating) async {
    _errorMessage = null;
    try {
      final row = await _db.from(_table).insert({
        'student_id': _studentId,
        'module_title': moduleName,
        'note': noteContent,
        'rating': rating,
      }).select().single();
      _notes.insert(0, StudentNote.fromMap(row));
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menambah catatan: ${_msg(e)}';
      notifyListeners();
      return false;
    }
  }

  // ── UPDATE ─────────────────────────────────────────────
  Future<bool> updateNote(String id, String newContent, int newRating) async {
    _errorMessage = null;
    try {
      final row = await _db
          .from(_table)
          .update({'note': newContent, 'rating': newRating})
          .eq('id', id)
          .select()
          .single();
      final i = _notes.indexWhere((n) => n.id == id);
      if (i != -1) _notes[i] = StudentNote.fromMap(row);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal memperbarui catatan: ${_msg(e)}';
      notifyListeners();
      return false;
    }
  }

  // ── DELETE ─────────────────────────────────────────────
  Future<bool> deleteNote(String id) async {
    _errorMessage = null;
    try {
      await _db.from(_table).delete().eq('id', id);
      _notes.removeWhere((n) => n.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menghapus catatan: ${_msg(e)}';
      notifyListeners();
      return false;
    }
  }
}