import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:foo_bot/screens/chat_screen.dart';
import 'package:foo_bot/screens/login_screen.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  String animationType;
  bool loading = true;
  var box;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    );
    _controller.forward();
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.animateBack(0,
            duration: Duration(seconds: 3), curve: Curves.easeInOutSine);
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    // _animation = ColorTween(begin: Colors.blueGrey,end: Colors.amber).animate(_controller);

    _controller.addListener(() {
      setState(() {});
    });
    openBox();
//    startTime();
  }

//  startTime() async {
//    var _duration = new Duration(seconds: 10);
//    return new Timer(_duration, navigationPage);
//  }

  void navigationPage() {
    if (box.get('name') != null) {
      _controller.dispose();
      Navigator.pushReplacementNamed(context, ChatScreen.id);
    } else {
      _controller.dispose();
      Navigator.pushReplacementNamed(context, LoginScreen.id);
    }
  }

  Future<void> openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('data');
    print(box.get('name'));
    box.put('name', null);
    if (box.get('name') != null) {
//      Navigator.pushReplacementNamed(context, ChatScreen.id);
    } else {
      print('login');
      Navigator.of(context).pushReplacementNamed(LoginScreen.id);
    }
    this.setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset('images/background.jpg')),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Align(
                      alignment: AlignmentDirectional(0, 2),
                      child: Transform.translate(
                        offset: Offset(0, _animation.value * 50),
                        child: Hero(
                          tag: 'logo',
                          child: Container(
                            child: Image.asset('images/logo.png'),
                            height: 60.0,
                          ),
                        ),
                      ),
                    ),
                    TyperAnimatedTextKit(
                      text: ['WitBall_'],
                      textStyle: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                      speed: Duration(milliseconds: 200),
                    ),
                  ],
                ),
                SizedBox(
                  height: 60.0,
                ),
                !this.loading ? Container() : CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
