import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:foo_bot/constants.dart';
import 'package:foo_bot/widgets/message_bubble.dart';
import 'package:hive/hive.dart';
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
  SpeechToText speech;
  var box;
  bool loading = true;
  Map<String, Color> colors = new Map();
  String name, teamName;
  SocketIO socketIO;
  ScrollController scrollController;
  TextEditingController messageController;
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
    speech = SpeechToText();
    messageController = TextEditingController();
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
      print('hey');
      print(data);
      this.setState(
        () => messageWidgets.insert(
          0,
          MessageBubble(
            sender: '@witball',
            response: data,
            isMe: false,
            color: Colors.white,
          ),
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
    initSpeechState();
    colors = {
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
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            elevation: 4,
            shape: CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: Hero(
              tag: 'logo',
              child: ClipOval(
                child: Image.asset('images/logo.png'),
              ),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
              }),
        ],
        title: Text('FooBall Chat'),
        backgroundColor: colors[teamName],
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
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      controller: messageController,
                      keyboardType: micListening ? null : TextInputType.text,
                      decoration: kMessageTextFieldDecoration.copyWith(
                        prefixIcon: GestureDetector(
                          child: micListening
                              ? Icon(
                                  Icons.mic,
                                )
                              : Icon(
                                  Icons.mic_off,
                                  color: Colors.grey,
                                ),
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
                            : 'Type your message here...',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  FloatingActionButton(
                    backgroundColor: colors[teamName],
                    onPressed: () {
                      setState(() {
                        //Send the message as JSON data to send_message event
                        socketIO.sendMessage(
                          'send_query',
                          json.encode({'message': messageController.text}),
                        );
                        messageWidgets.insert(
                          0,
                          MessageBubble(
                            sender: '@$name',
                            response: {
                              'type': 'string',
                              'message': messageController.text,
                            },
                            isMe: true,
                            color: colors[teamName],
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
      listenFor: Duration(seconds: 20),
      localeId: _currentLocaleId,
      onSoundLevelChange: soundLevelListener,
      cancelOnError: true,
      partialResults: true,
    );
  }

  void stopListening() {
    speech.stop();
    level = 0.0;
  }

  void cancelListening() {
    speech.cancel();

    level = 0.0;
  }

  void resultListener(SpeechRecognitionResult result) {
    lastWords = "${result.recognizedWords}";
    messageController.text = lastWords;
    messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: messageController.text.length),
    );
    print(lastWords + "   ...these were the last words i heard");
  }

  void soundLevelListener(double level) {
    minSoundLevel = math.min(minSoundLevel, level);
    maxSoundLevel = math.max(maxSoundLevel, level);

    level = level;
  }

  void errorListener(SpeechRecognitionError error) {
    lastError = "${error.errorMsg} - ${error.permanent}";
  }

  void requestPermission() async {
    await PermissionHandler().requestPermissions([PermissionGroup.microphone]);
  }

  void statusListener(String status) {
    lastStatus = "$status";
    if ("$status" == "notListening") {
      setState(() {
        micListening = false;
        messageController.text = lastWords;
        messageController.selection = TextSelection.fromPosition(
          TextPosition(offset: messageController.text.length),
        );
      });
    }
  }
}
