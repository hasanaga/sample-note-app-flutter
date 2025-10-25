import 'dart:async';

import 'package:note_project/models/note.dart';
import 'package:note_project/repositories/note_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final noteRepositoryProvider = Provider((ref) => LocalNoterepository());

final notesProvider = AsyncNotifierProvider<NotesNotifier, List<Note>>(
  () => NotesNotifier(),
);

class NotesNotifier extends AsyncNotifier<List<Note>> {
  late NoteRepository _repository;

  @override
  Future<List<Note>> build() async {
    _repository = ref.read(noteRepositoryProvider);
    return await _repository.getAllNotes();
  }

  Future<void> addNote(String title, String content) async {
    state = AsyncValue.loading();

    try {
      final note = Note(title: title, content: content);
      await _repository.addNote(note);
      final updatedNotes = await _repository.getAllNotes();
      state = AsyncValue.data(updatedNotes);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateNote(Note note) async {
    state = AsyncValue.loading();

    try {
      await _repository.updateNote(note);
      final updatedNotes = await _repository.getAllNotes();
      state = AsyncValue.data(updatedNotes);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteNote(String id) async {
    state = AsyncValue.loading();

    try {
      await _repository.deleteNote(id);
      final updatedNotes = await _repository.getAllNotes();
      state = AsyncValue.data(updatedNotes);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final noteProvider = FutureProvider.family<Note?, String>((ref, id) async {
  final repository = ref.read(noteRepositoryProvider);
  return await repository.getNoteById(id);
});
