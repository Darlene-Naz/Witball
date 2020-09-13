import 'package:flutter/material.dart';
import 'package:foo_bot/widgets/fixtures_list.dart';
import 'package:foo_bot/widgets/players_list.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.response, this.isMe, this.color});

  final String sender;
  final Map<String, dynamic> response;
  final bool isMe;
  final Color color;

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
                  softWrap: true,
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                      fontStyle: FontStyle.italic),
                ),
                SizedBox(
                  height: 1,
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
                  color: isMe ? color : Colors.white,
                  child: Container(
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
            : response['intent'] == 'get_fixtures'
                ? ShowFixturesList(
                    response: response,
                  )
                : MessageBubble(
                    sender: '@witbot',
                    response: {
                      'type': 'string',
                      'message': response['object'] != null
                          ? '${response['teamName']}\'s score: ${response['object']}'
                          : 'Oops! Some error may have occurred while fetching ${response['teamName']}\'s score'
                    },
                    isMe: false,
                  );
  }
}
