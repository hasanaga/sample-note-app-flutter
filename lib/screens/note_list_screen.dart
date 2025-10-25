import 'package:note_project/providers/note_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NoteListScreen extends ConsumerWidget {
  const NoteListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(title: Text("My notes")),
      body: notesAsync.when(
        data: (notes) {
          if (notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'No any note',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];

              return Card(
                margin: EdgeInsets.all(5),
                child: ListTile(
                  title: Text(
                    note.title,
                    maxLines: 1,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.content,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      SizedBox(height: 8),

                      Text(
                        note.updatedAt.toIso8601String(),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),

                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'edit') {
                        context.push('/edit/${note.id}');
                      } else if (value == 'delete') {
                        _showDeleteConfirmationDialog(context, ref, note.id);
                      }
                    },

                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 18),
                              SizedBox(width: 8),
                              Text("Edit"),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18),
                              SizedBox(width: 8),
                              Text("Delete"),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 60, color: Colors.red),

                const SizedBox(height: 16),

                Text('Problem occured'),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(notesProvider);
                  },
                  child: Text("Try again"),
                ),
              ],
            ),
          );
        },
        loading: () {
          return Center(child: CircularProgressIndicator());
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Do you want to remove the note?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),

          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(notesProvider.notifier).deleteNote(id);
            },
            child: Text("Remove"),
          ),
        ],
      ),
    );
  }
}
