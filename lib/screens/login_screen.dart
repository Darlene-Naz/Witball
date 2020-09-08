import 'package:flutter/material.dart';
import 'package:foo_bot/constants.dart';
import 'package:foo_bot/widgets/rounded_button.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var box;

  @override
  void initState() {
    super.initState();
    openBox();
  }

  Future<void> openBox() async {
    box = await Hive.openBox('data');
    if (box.get('name').toString() != null) {
      Navigator.pushReplacementNamed(context, ChatScreen.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset('images/background.jpg'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  onChanged: (value) {
                    box.put('name', value);
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your name',
                    focusColor: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  onChanged: (value) {
                    box.put('teamName', value);
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your fav team name'),
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  title: 'Lets Go!',
                  colour: Colors.lightBlueAccent,
                  onPressed: () async {
                    Navigator.pushReplacementNamed(context, ChatScreen.id);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
