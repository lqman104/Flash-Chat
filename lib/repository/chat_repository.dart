import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  static const String _collection = 'messages';

  void sendMessage(String sender, String message) async {
    try {
      await _firebaseFirestore
          .collection(_collection)
          .add({'sender': sender, 'message': message});
    } catch (e) {
      print(e);
    }
  }

  void streamMessages() async {
    await for(var snapshot in _firebaseFirestore.collection(_collection).snapshots()) {
      for(var document in snapshot.docs) {
        print(document);
      }
    }
  }
}
