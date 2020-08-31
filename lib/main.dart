import 'package:flutter/material.dart';
import 'package:foo_bot/screens/chat_screen.dart';
import 'package:foo_bot/screens/login_screen.dart';
import 'package:foo_bot/screens/registration_screen.dart';
import 'package:foo_bot/screens/welcome_screen.dart';

void main() => runApp(FooBallChat());

class FooBallChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen()
      },
    );
  }
}
