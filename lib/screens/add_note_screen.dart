import 'package:note_project/providers/note_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddNoteScreen extends ConsumerStatefulWidget {
  const AddNoteScreen({super.key});

  @override
  ConsumerState<AddNoteScreen> createState() {
    return _AddNoteScreenState();
  }
}

class _AddNoteScreenState extends ConsumerState<AddNoteScreen> {
  bool _isLoading = false;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  final _titleFocusNode = FocusNode();
  final _contentFocusNode = FocusNode();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_isLoading
            ? Text("Save")
            : const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(),
              ),
        actions: [TextButton(onPressed: _save, child: Text("Save"))],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              focusNode: _titleFocusNode,
              decoration: InputDecoration(
                hintText: "Title...",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),

              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textInputAction: TextInputAction.next,
              onSubmitted: (value) {
                _contentFocusNode.requestFocus();
              },
            ),
            Divider(height: 1),

            Expanded(
              child: TextField(
                controller: _contentController,
                focusNode: _contentFocusNode,
                decoration: InputDecoration(
                  hintText: 'Note...',
                  border: InputBorder.none,
                ),

                style: TextStyle(fontSize: 16),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Title or content are empty."),
          backgroundColor: Colors.orange,
        ),
      );

      return;
    }

    try {
      await ref
          .read(notesProvider.notifier)
          .addNote(
            title.isEmpty ? 'untitle' : title,
            content.isEmpty ? '...' : content,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Added succesfully"),
            backgroundColor: Colors.orange,
          ),
        );

        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.orange),
        );
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
