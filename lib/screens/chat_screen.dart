import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/repository/chat_repository.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

import '../model/Message.dart';

final ChatRepository repository = ChatRepository();

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _editingController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        print(user);
      } else {
        Navigator.popUntil(context, ModalRoute.withName(WelcomeScreen.id));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    String message = "";
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                await _auth.signOut();
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacementNamed(context, LoginScreen.id);
                }
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _editingController,
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (message.isNotEmpty) {
                        repository.sendMessage(
                            _auth.currentUser?.email ?? "", message);
                        _editingController.clear();

                        setState(() {
                          message = "";
                        });
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: repository.streamMessages(),
      initialData: [],
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data?.isEmpty == true) {
          return Center(
            child: Text(
              "No data",
            ),
          );
        }

        List<MessageBubble> widgetsText = [];
        List<Message> data = snapshot.data ?? [];
        for (Message item in data) {
          widgetsText
              .add(MessageBubble(sender: item.sender, text: item.text));
        }
        return Expanded(
          child: ListView(
            children: widgetsText,
          ),
        );
      },
    );
  }
}


class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;

  MessageBubble({required this.sender, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Text(
              sender,
              style: TextStyle(color: Colors.black54),
            ),
          ),
          Material(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
            ),
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(30),
            elevation: 5,
          )
        ],
      ),
    );
  }
}
