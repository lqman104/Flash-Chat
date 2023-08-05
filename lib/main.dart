import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/repository/auth_repository.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

AuthRepository authRepository = AuthRepository();

void main() async {
  // wait run the app until the firebase is initialize
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  String getInitialRoute() {
    try {
      if (authRepository.isLoggedIn()) {
        return ChatScreen.id;
      } else {
        return WelcomeScreen.id;
      }
    } catch (e) {
      print(e);
      return WelcomeScreen.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      initialRoute: getInitialRoute(),
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
