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
      Provider.of<NoteProvider>(context, listen: false).fetchNotes();
    });
  }

  void _showNoteDialog({String? id, String? currentModule, String? currentContent, int? currentRating}) {
    final formKey = GlobalKey<FormState>();
    final moduleController = TextEditingController(text: currentModule ?? 'I Kambing teken I Macan');
    final contentController = TextEditingController(text: currentContent ?? '');
    int selectedRating = currentRating ?? 5;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(id == null ? 'Tambah Catatan Belajar' : 'Edit Catatan'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: moduleController,
                decoration: const InputDecoration(labelText: 'Nama Modul STEM'),
                validator: (val) => val == null || val.isEmpty ? 'Modul wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Catatan Evaluasi / Progres'),
                maxLines: 3,
                validator: (val) => val == null || val.isEmpty ? 'Catatan tidak boleh kosong' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final provider = Provider.of<NoteProvider>(context, listen: false);
                if (id == null) {
                  provider.addNote(moduleController.text, contentController.text, selectedRating);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Catatan berhasil ditambahkan!')));
                } else {
                  provider.updateNote(id, contentController.text, selectedRating);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Catatan berhasil diperbarui!')));
                }
                Navigator.pop(ctx);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              Provider.of<NoteProvider>(context, listen: false).deleteNote(id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Catatan dihapus.')));
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Progres Belajar'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: noteProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : noteProvider.notes.isEmpty
              ? const Center(child: Text('Belum ada catatan progres tersimpan.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: noteProvider.notes.length,
                  itemBuilder: (ctx, i) {
                    final note = noteProvider.notes[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(note.moduleName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(note.noteContent),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(),
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}