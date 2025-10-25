import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class AuthUser {
  String? id;
  String? email;
  String? displayName;
  AuthUser({this.id, this.email, this.displayName});
}

abstract class AuthRepository {
  Future<void> signIn();
  Stream<AuthUser> userChanged();
  AuthUser? currentUser();
}

class FirebaseAuthRepository extends AuthRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthRepository({required FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;

  @override
  Future<void> signIn() async {
    await _firebaseAuth.signInAnonymously();
  }

  @override
  Stream<AuthUser> userChanged() async* {
    _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;

      return AuthUser(
        id: user.uid,
        email: user.email,
        displayName: user.displayName,
      );
    });
  }

  @override
  AuthUser? currentUser() => AuthUser()
    ..email = _firebaseAuth.currentUser?.email
    ..id = _firebaseAuth.currentUser?.uid
    ..displayName = _firebaseAuth.currentUser?.displayName;
}

abstract class RemoteConfigRepository {
  Future<void> fetch();
  Future<void> activate();
}

class RemoteConfigRepositoryFirebaseImpl extends RemoteConfigRepository {
  final FirebaseRemoteConfig _firebaseRemoteConfig;

  RemoteConfigRepositoryFirebaseImpl({
    required FirebaseRemoteConfig firebaseRemoteConfig,
  }) : _firebaseRemoteConfig = firebaseRemoteConfig;

  @override
  Future<void> fetch() async {
    await _firebaseRemoteConfig.fetch();
  }

  @override
  Future<void> activate() async {
    await _firebaseRemoteConfig.activate();
  }
}
