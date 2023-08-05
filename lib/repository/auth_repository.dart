import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool isLoggedIn() {
    try {
      return _firebaseAuth.currentUser != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  String currentUserEmailLoggedIn() {
    try {
      return _firebaseAuth.currentUser?.email ?? "";
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
