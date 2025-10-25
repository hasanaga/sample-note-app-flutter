import 'package:note_project/models/note.dart';

abstract class NoteRepository {
  Future<List<Note>> getAllNotes();
  Future<void> deleteNote(String id);
  Future<Note> updateNote(Note note);
  Future<Note> addNote(Note note);
  Future<Note?> getNoteById(String id);
}

class LocalNoterepository extends NoteRepository {
  final List<Note> _notes = [];

  @override
  Future<Note> addNote(Note note) async {
    final newNote = note.copyWith(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _notes.add(newNote);
    return newNote;
  }

  @override
  Future<void> deleteNote(String id) async {
    _notes.removeWhere((element) => element.id == id);
  }

  @override
  Future<List<Note>> getAllNotes() async {
    return _notes.toList()..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  Future<Note?> getNoteById(String id) async {
    try {
      return _notes.firstWhere((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Note> updateNote(Note note) async {
    final index = _notes.indexWhere((element) => element.id == note.id);

    final updatedNote = note.copyWith(updatedAt: DateTime.now());

    _notes[index] = updatedNote;

    return updatedNote;
  }
}
