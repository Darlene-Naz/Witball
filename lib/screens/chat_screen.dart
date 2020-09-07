import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:foo_bot/constants.dart';
import 'package:foo_bot/widgets/message_bubble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool micListening = false;
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  final SpeechToText speech = SpeechToText();

  SocketIO socketIO;
  ScrollController scrollController;
  final messageController = TextEditingController();
  String messageText;
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
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
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
        title: Text('FooBall Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
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
                    padding: EdgeInsets.fromLTRB(20.0, 20, 20, 10),
                    reverse: true,
                    controller: scrollController,
                    physics: BouncingScrollPhysics(),
                    itemCount: messageWidgets.length,
                    itemBuilder: (context, index) => messageWidgets[index]),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 8.0, bottom: 8, right: 8, top: 4),
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
                      decoration: kMessageTextFieldDecoration.copyWith(
                        prefixIcon: GestureDetector(
                          child: micListening
                              ? Icon(Icons.mic_off)
                              : Icon(Icons.mic),
                          onTap: () {
                            if (micListening) {
                              setState(() {
                                micListening = !micListening;
                              });
                              if (speech.isListening) {
                                stopListening();
                              }
                            } else {
                              requestPermission();
                              setState(() {
                                micListening = !micListening;
                              });
                              if (!(!_hasSpeech || speech.isListening)) {
                                startListening();
                              }
                            }
                          },
                        ),
                        hintText: micListening
                            ? "Listening voice....."
                            : 'Send message...',
                      ),
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
                            sender: '@darlene',
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

  void startListening() {
    lastWords = "";
    lastError = "";
    speech.listen(
      onResult: resultListener,
      listenFor: Duration(seconds: 10),
      localeId: _currentLocaleId,
      onSoundLevelChange: soundLevelListener,
      cancelOnError: true,
      partialResults: true,
    );

    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords}";
      setState(() {
        messageController.text = lastWords;
      });
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = math.min(minSoundLevel, level);
    maxSoundLevel = math.max(maxSoundLevel, level);
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void requestPermission() async {
    await PermissionHandler().requestPermissions([PermissionGroup.camera]);
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = "$status";
      if ("$status" == "notListening") {
        setState(() {
          micListening = false;
        });
      }
    });
  }
}
