import 'package:flutter/material.dart';
import 'package:foo_bot/widgets/fixtures_list.dart';
import 'package:foo_bot/widgets/players_list.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.response, this.isMe});

  final String sender;
  final Map<String, dynamic> response;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return response['type'] == 'string'
        ? Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  sender,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black54,
                  ),
                ),
                Material(
                  borderRadius: isMe
                      ? BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0))
                      : BorderRadius.only(
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                  elevation: 5.0,
                  color: isMe ? Colors.lightBlueAccent : Colors.white,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      response['message'],
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black54,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : response['intent'] == 'get_players'
            ? ShowPlayersList(
                response: response,
              )
            : ShowFixturesList(
                response: response,
              );
  }
}
