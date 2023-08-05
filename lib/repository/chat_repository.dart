import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/Message.dart';

class ChatRepository {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  static const String _collection = 'messages';

  void sendMessage(String sender, String message) async {
    try {
      await _firebaseFirestore
          .collection(_collection)
          .add({'sender': sender, 'message': message, 'date': Timestamp.now()});
    } catch (e) {
      print(e);
    }
  }

  Stream<List<Message>> streamMessages() {
    return _firebaseFirestore.collection(_collection).orderBy('date').snapshots().map((event) {
      List<Message> messages = [];
      event.docs.reversed.forEach((element) {
        Message message = Message(element['sender'], element['message']);
        messages.add(message);
      });

      return messages;
    });
  }
}
