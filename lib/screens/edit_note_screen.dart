import 'package:note_project/models/note.dart';
import 'package:note_project/providers/note_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EditNoteScreen extends ConsumerStatefulWidget {
  final String id;
  const EditNoteScreen({required this.id, super.key});

  @override
  ConsumerState<EditNoteScreen> createState() {
    return _EditNoteScreenState();
  }
}

class _EditNoteScreenState extends ConsumerState<EditNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  final _titleFocusNode = FocusNode();
  final _contentFocusNode = FocusNode();
  Note? _originalNote;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _titleFocusNode.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noteAsync = ref.watch(noteProvider(widget.id));

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit note"),
        actions: [
          TextButton(
            onPressed: _update,
            child: !_isLoading
                ? Text("Save")
                : SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      ),

      body: noteAsync.when(
        data: (note) {
          if (note == null) {
            return Center(child: Text("Note not found"));
          }

          if (_originalNote == null) {
            _originalNote = note;
            _titleController.text = note.title;
            _contentController.text = note.content;
          }

          return Padding(
            padding: EdgeInsetsGeometry.all(10),
            child: Column(
              children: [
                TextField(
                  focusNode: _titleFocusNode,
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    _contentFocusNode.requestFocus();
                  },
                ),

                Divider(height: 1),
                Expanded(
                  child: TextField(
                    maxLines: null,
                    expands: true,
                    focusNode: _contentFocusNode,
                    controller: _contentController,
                    decoration: InputDecoration(
                      labelText: "Note",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Column(
              children: [
                const Icon(Icons.error, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: $error'),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(noteProvider(widget.id));
                  },
                  child: Text("Try again"),
                ),
              ],
            ),
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<void> _update() async {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Title or content should not be empty!"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_originalNote?.title == title && _originalNote?.content == content) {
      context.pop();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final updatedNote = _originalNote!.copyWith(
      title: title.isEmpty ? 'Untitled note' : title,
      content: content.isEmpty ? 'no content' : content,
    );

    try {
      await ref.read(notesProvider.notifier).updateNote(updatedNote);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Note successfully updated!")));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error occured: $e")));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
