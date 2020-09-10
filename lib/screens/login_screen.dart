import 'package:flutter/cupertino.dart';
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
  Map<String, Color> colors = {
    'Arsenal': Colors.red,
    'Aston Villa': Colors.pink[900],
    'Brighton & Hove Albion': Colors.blue,
    'Burnley': Colors.redAccent[700],
    'Chelsea': Colors.blueAccent[200],
    'Crystal Palace': Colors.blueAccent[700],
    'Everton': Colors.blue,
    'Fulham': Colors.black26,
    'Leeds United': Colors.grey,
    'Leicester City': Colors.blueAccent[700],
    'Liverpool': Colors.red[900],
    'Manchester City': Colors.lightBlueAccent[400],
    'Manchester United': Colors.red[500],
    'Newcastle United': Colors.grey,
    'Sheffield United': Colors.red,
    'Southampton': Colors.red,
    'Tottenham Hotspur': Colors.indigo,
    'West Bromwich Albion': Colors.indigo[800],
    'West Ham United': Colors.pink[900],
    'Wolverhampton Wanderers': Colors.amber[600]
  };
  String _selectedTeam = "Select your team";

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
              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(32.0),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: Container(),
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
                    return DropdownMenuItem(
                      value: value,
                      child: new Text(value),
                      onTap: () {
                        box.put('teamName', value);
                        box.put('color', colors[value]);
                        setState(() {
                          _selectedTeam = value;
                        });
                      },
                    );
                  }).toList(),
                  onChanged: (_) {},
                  hint: Text(
                    "$_selectedTeam",
                  ),
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
