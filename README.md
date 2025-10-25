# Note Project — Flutter Sample Note App

This repository is a small, focused example of a note-taking app built with Flutter. It demonstrates a minimal, well-structured app architecture using models, a repository layer, Riverpod-based state management, and basic UI screens for creating, reading, updating, and deleting notes. The project includes platform scaffolding for mobile, web and desktop (Linux/Windows) builds.

---

## Overview / Purpose
- Provide a clear example of a simple Flutter CRUD app for notes.
- Illustrate separation of concerns: model → repository → provider → UI.
- Show usage of Riverpod for asynchronous state management and GoRouter for navigation.
- Act as a starting point for adding persistence, backend sync, tests, and UI refinements.

---

## Key Features
- Create, edit, and delete notes.
- Notes are represented by a Note model with id, title, content, createdAt and updatedAt fields.
- Riverpod AsyncNotifierProvider used for fetching and updating notes reactively.
- Routing via go_router with typed routes for list/add/edit screens.
- Platform scaffolding present for Android, iOS, Web, Linux and Windows (CMake files included).

---

## Libraries / Packages Used
Based on imports and repository files, the app uses the following packages:
- flutter_riverpod — state management (Provider, AsyncNotifierProvider, ConsumerWidget).
- go_router — declarative routing and navigation.
- uuid — generate unique IDs for Note objects.
- flutter_test — widget test (default test scaffold).
- flutter — Flutter SDK and platform toolchains.
- CMake / platform-specific native scaffolding for desktop builds.

Note: The pubspec.yaml may include additional dev or test dependencies; the list above is derived from code-level imports.

---

## Project Structure (important files)
- lib/
  - main.dart — app entrypoint; wraps app in ProviderScope and uses MaterialApp.router with appRouter.
  - router/app_router.dart — app routing configuration (routes for list/add/edit).
  - models/note.dart — Note model (UUID id generation, copyWith, toJson/fromJson).
  - repositories/note_repository.dart — NoteRepository abstract class and LocalNoterepository in-memory implementation.
  - providers/note_provider.dart — Riverpod providers and NotesNotifier (load notes, add, update, delete).
  - screens/
    - note_list_screen.dart — displays list of notes, empty state UI, navigation to add/edit.
    - add_note_screen.dart — UI to create a new note and call NotesNotifier.addNote.
    - edit_note_screen.dart — UI to load a note by id and call NotesNotifier.updateNote.
- test/
  - widget_test.dart — example widget test (default counter test template).
- platform directories: android/, ios/, web/, linux/, windows/ — Flutter scaffolding and CMake files for desktop targets.

---

## How the App Works (flow)
1. Startup
   - main.dart initializes ProviderScope and launches MaterialApp.router configured with appRouter.
2. Data model
   - Note model (lib/models/note.dart) encapsulates note data and JSON serialization helpers.
3. Repository layer
   - NoteRepository defines the contract (getAllNotes, addNote, updateNote, deleteNote, getNoteById).
   - LocalNoterepository implements the contract with a List<Note> kept in memory.
4. State management
   - noteRepositoryProvider supplies the LocalNoterepository instance.
   - notesProvider is an AsyncNotifierProvider (NotesNotifier) that:
     - build() fetches all notes from repository.
     - addNote(title, content) creates a Note, calls repository.addNote, then refreshes state.
     - updateNote(note) and deleteNote(id) call repository and refresh the notes list.
   - UI widgets subscribe to providers with ref.watch or Consumer/ConsumerWidget.
5. UI
   - NoteListScreen watches notesProvider and shows notes or empty state.
   - AddNoteScreen collects user input and calls NotesNotifier.addNote to save.
   - EditNoteScreen fetches a specific note via noteProvider(id) and calls update on save.
6. Persistence
   - Currently, storage is in-memory only (LocalNoterepository). Data will be lost when the app exits.

---

## How to run locally
Prerequisites:
- Flutter SDK installed (stable channel recommended)
- For desktop targets: required platform dependencies (GTK/CMake for Linux, Visual Studio/CMake for Windows)
- An emulator/device or web browser for the target platform

Commands:
1. Clone the repo:
   git clone https://github.com/hasanaga/sample-note-app-flutter.git
2. Enter project dir:
   cd sample-note-app-flutter
3. Install dependencies:
   flutter pub get
4. Run the app:
   - Web: flutter run -d chrome
   - Android: flutter run -d <android-device>
   - iOS (macOS required): flutter run -d <ios-device-or-simulator>
   - Linux: flutter run -d linux (ensure GTK and CMake are available)
   - Windows: flutter run -d windows (ensure Windows build tools are available)
5. Run tests:
   flutter test

---

## Current limitations
- No persistent storage (LocalNoterepository uses in-memory List). Add persistence (Hive, sqflite, sembast) to retain notes between sessions.
- No authentication or backend sync — adding Firebase / REST API would enable multi-device syncing.
- Tests are minimal (default counter widget test). Unit tests for repository and provider and widget/integration tests for UI flows should be added.
- No advanced UI/UX features (search, tags, sorting, attachments).

---

## Suggested improvements (next steps)
- Replace LocalNoterepository with a persistent implementation (e.g., Hive or sqflite).
- Add unit tests for models and repository logic and widget/integration tests for screens and navigation.
- Add search and sorting/filtering for notes.
- Add export/import or cloud sync with Firestore or custom backend.
- Add CI (GitHub Actions) to run analyzer, tests and format checks on push/PR.
- Improve accessibility and responsive layout for larger screens.

---

## Quick code references
- Note model: lib/models/note.dart
- Repository: lib/repositories/note_repository.dart
- Providers & state: lib/providers/note_provider.dart
- Screens: lib/screens/note_list_screen.dart, lib/screens/add_note_screen.dart, lib/screens/edit_note_screen.dart
- App entry & router: lib/main.dart, lib/router/app_router.dart

---

## Summary
This project is a compact, easy-to-follow starting point for a Flutter-based notes application. It cleanly demonstrates model, repository, Riverpod state management, and UI screens for basic CRUD operations. The main missing piece for production readiness is persistent storage and more comprehensive testing.
