import 'package:flutter/material.dart';
import 'package:foo_bot/constants.dart';
import 'package:foo_bot/widgets/rounded_button.dart';
import 'package:hive/hive.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
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
              new DropdownButton<String>(
                items: <String>[
                  'Arsenal',
                  'Aston Villa',
                  'Brighton & Hove Albion',
                  'Burnley',
                  'Chelsea',
                  'Crystal Palace',
                  'Everton',
                  'Fulham',
                  'Leeds United',
                  'Leicester City',
                  'Liverpool',
                  'Manchester City',
                  'Manchester United',
                  'Newcastle United',
                  'Sheffield United',
                  'Southampton',
                  'Tottenham Hotspur',
                  'West Bromwich Albion',
                  'West Ham United',
                  'Wolverhampton Wanderers'
                ].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                    onTap: () {
                      box.put('teamName', value);
                    },
                  );
                }).toList(),
                onChanged: (_) {},
                hint: Text(
                  "Please select the number!",
                ),
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
      ),
    );
  }
}
