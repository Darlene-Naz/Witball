import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foo_bot/constants.dart';
import 'package:foo_bot/widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  String messageText;
  List<Widget> messageWidgets = List<Widget>();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
              }),
        ],
        title: Text('FooBall Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // Column(
            //   children: messageWidgets,
            // ),
            Expanded(
              child: Container(
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(20.0, 20, 20, 10),
                    itemCount: messageWidgets.length,
                    itemBuilder: (context, index) => messageWidgets[index]),
              ),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              margin: EdgeInsets.only(left: 4, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        messageWidgets.add(
                          MessageBubble(
                              sender: '@darlene',
                              text: messageText,
                              isMe: true),
                        );
                        messageController.clear();
                      });
                    },
                    child: Transform.rotate(
                        angle: -math.pi / 6,
                        child: Icon(
                          Icons.send,
                          color: Colors.amber,
                          size: 24,
                        )),
                    // child: Text(
                    //   'Send',
                    //   style: kSendButtonTextStyle,
                    // ),
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
