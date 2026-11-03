import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';

class ProgressNotesScreen extends StatefulWidget {
  const ProgressNotesScreen({super.key});

  @override
  State<ProgressNotesScreen> createState() => _ProgressNotesScreenState();
}

class _ProgressNotesScreenState extends State<ProgressNotesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<NoteProvider>().fetchNotes();
    });
  }

  void _snack(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? Colors.red.shade700 : null,
    ));
  }

  Future<void> _save({
    String? id,
    required String module,
    required String content,
    required int rating,
  }) async {
    final p = context.read<NoteProvider>();
    final ok = id == null
        ? await p.addNote(module, content, rating)
        : await p.updateNote(id, content, rating);
    _snack(
      ok
          ? (id == null ? 'Catatan berhasil ditambahkan!' : 'Catatan berhasil diperbarui!')
          : (p.errorMessage ?? 'Gagal menyimpan catatan.'),
      error: !ok,
    );
  }

  Future<void> _delete(String id) async {
    final p = context.read<NoteProvider>();
    final ok = await p.deleteNote(id);
    _snack(ok ? 'Catatan dihapus.' : (p.errorMessage ?? 'Gagal menghapus catatan.'),
        error: !ok);
  }

  void _showNoteDialog({
    String? id,
    String? currentModule,
    String? currentContent,
    int? currentRating,
  }) {
    final formKey = GlobalKey<FormState>();
    final moduleController =
        TextEditingController(text: currentModule ?? 'I Kambing teken I Macan');
    final contentController = TextEditingController(text: currentContent ?? '');
    var rating = currentRating ?? 5;
    final editing = id != null;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(editing ? 'Edit Catatan' : 'Tambah Catatan Belajar'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: moduleController,
                    readOnly: editing,
                    decoration: const InputDecoration(labelText: 'Nama Modul STEM'),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Modul wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: contentController,
                    decoration:
                        const InputDecoration(labelText: 'Catatan Evaluasi / Progres'),
                    maxLines: 3,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Catatan tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 16),
                  const Text('Penilaian (1 sampai 5)'),
                  const SizedBox(height: 4),
                  Wrap(spacing: 6, children: [
                    for (var r = 1; r <= 5; r++)
                      ChoiceChip(
                        label: Text('$r'),
                        selected: rating == r,
                        onSelected: (_) => setLocal(() => rating = r),
                      ),
                  ]),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                Navigator.pop(ctx);
                _save(
                  id: id,
                  module: moduleController.text.trim(),
                  content: contentController.text.trim(),
                  rating: rating,
                );
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus catatan progres ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              _delete(id);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Widget _errorState(NoteProvider p) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.cloud_off, size: 56, color: Colors.red),
            const SizedBox(height: 12),
            Text(p.errorMessage ?? 'Terjadi kesalahan.', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: p.fetchNotes,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
            ),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final p = context.watch<NoteProvider>();

    Widget body;
    if (p.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (p.errorMessage != null && p.notes.isEmpty) {
      body = _errorState(p);
    } else if (p.notes.isEmpty) {
      body = const Center(child: Text('Belum ada catatan progres tersimpan.'));
    } else {
      body = ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        itemCount: p.notes.length,
        itemBuilder: (ctx, i) {
          final note = p.notes[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(note.moduleName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('${note.noteContent}\nPenilaian: ${note.rating} dari 5'),
              ),
              isThreeLine: true,
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showNoteDialog(
                    id: note.id,
                    currentModule: note.moduleName,
                    currentContent: note.noteContent,
                    currentRating: note.rating,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(note.id),
                ),
              ]),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Progres Belajar'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(),
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}