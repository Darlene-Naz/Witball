import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:foo_bot/constants.dart';
import 'package:foo_bot/widgets/message_bubble.dart';
import 'package:hive/hive.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  SocketIO socketIO;
  ScrollController scrollController;
  final messageController = TextEditingController();
  String messageText;
  var box;
  bool loading = true;
  String name, teamName;
  List<Widget> messageWidgets = List<Widget>();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    //Creating the socket
    socketIO = SocketIOManager().createSocketIO(
      'https://wit-bot-server.herokuapp.com/',
      '/',
    );
    //Call init before doing anything with socket
    socketIO.init();
    print('In initState');
    //Subscribe to an event to listen to
    socketIO.subscribe('receive_message', (jsonData) {
      print('In receive_message');
      //Convert the JSON data received into a Map

      Map<String, dynamic> data = json.decode(jsonData);
      print(data);
      this.setState(
        () => messageWidgets.insert(
          0,
          MessageBubble(sender: '@foobot', response: data, isMe: false),
        ),
      );
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    });
    //Connect to the socket
    socketIO.connect();
    openBox();
  }

  Future<void> openBox() async {
    box = await Hive.openBox('data');
    name = box.get('name');
    teamName = box.get('teamName');
    this.setState(() {
      this.loading = false;
    });
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
        title: Text('WitBall Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: this.loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Column(
                  //   children: messageWidgets,
                  // ),
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                          reverse: true,
                          controller: scrollController,
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(20.0, 20, 20, 10),
                          itemCount: messageWidgets.length,
                          itemBuilder: (context, index) =>
                              messageWidgets[index]),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 8.0, bottom: 8, right: 8, top: 4),
                    decoration: kMessageContainerDecoration,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: messageController,
                            onChanged: (value) {
                              messageText = value;
                            },
                            decoration: kMessageTextFieldDecoration,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            setState(() {
                              //Send the message as JSON data to send_message event
                              socketIO.sendMessage(
                                'send_query',
                                json.encode({'message': messageText}),
                              );
                              messageWidgets.insert(
                                0,
                                MessageBubble(
                                  sender: '@d$name',
                                  response: {
                                    'type': 'string',
                                    'message': messageText,
                                  },
                                  isMe: true,
                                ),
                              );
                              messageController.clear();
                              scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 600),
                                curve: Curves.ease,
                              );
                            });
                          },
                          child: Transform.rotate(
                            angle: -math.pi / 6,
                            child: Icon(
                              Icons.send,
                              size: 24,
                            ),
                          ),
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
