import 'package:note_project/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);

final authRepositoryProvider = Provider((ref) {
  final authProvider = ref.watch(firebaseAuthProvider);
  return FirebaseAuthRepository(firebaseAuth: authProvider);
});

class AuthNotifier extends AsyncNotifier<AuthUser?> {
  late AuthRepository _authRepository;

  @override
  AuthUser? build() {
    _authRepository = ref.watch(authRepositoryProvider);
    return _authRepository.currentUser();
  }

  Future<void> signIn() async {
    try {
      state = AsyncValue.loading();
      await _authRepository.signIn();
      state = AsyncValue.data(_authRepository.currentUser());
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, AuthUser?>(() {
  return AuthNotifier();
});
