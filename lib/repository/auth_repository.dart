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
}
