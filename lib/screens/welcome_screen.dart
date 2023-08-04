import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/button_component.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    animation = ColorTween(begin: Colors.lightBlueAccent, end: Colors.white)
        .animate(controller);
    controller.addListener(() {
      setState(() {
        // do nothing, just set the new value of controller.value
      });
    });
  }

  bool isLoggedIn() {
    try {
      return _auth.currentUser != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                AnimatedTextKit(
                  totalRepeatCount: 1,
                  onFinished: () {
                    controller.forward();
                  },
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flash Chat',
                      speed: Duration(milliseconds: 80),
                      textStyle: TextStyle(
                        fontSize: 45.0,
                        color: Colors.grey[900],
                        fontWeight: FontWeight.w900,
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            ButtonComponent(
              color: Colors.lightBlueAccent,
              text: 'Log in',
              onclick: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            ButtonComponent(
              color: Colors.blueAccent,
              text: 'Register',
              onclick: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
