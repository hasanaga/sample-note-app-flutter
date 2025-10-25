import 'package:note_project/screens/add_note_screen.dart';
import 'package:note_project/screens/edit_note_screen.dart';
import 'package:note_project/screens/note_list_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => NoteListScreen(),
    ),

    GoRoute(
      path: '/add',
      name: 'add',
      builder: (context, state) {
        return AddNoteScreen();
      },
    ),

    GoRoute(
      path: '/edit/:id',
      name: 'edit-note',
      builder: (context, state) {
        final noteId = state.pathParameters['id']!;
        return EditNoteScreen(id: noteId);
      },
    ),
  ],
);
