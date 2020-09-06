import 'package:flutter/material.dart';
import 'package:foo_bot/widgets/fixture_tile.dart';
import 'package:foo_bot/widgets/player_tile.dart';

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

class ShowPlayersList extends StatelessWidget {
  ShowPlayersList({this.response});
  final Map<String, dynamic> response;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MessageBubble(
            sender: '@witbot',
            response: {
              'type': 'string',
              'message': 'Players of ${response['teamName']}...'
            },
            isMe: false,
          ),
          Card(
            margin: EdgeInsets.only(left: 0, top: 8),
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              margin: EdgeInsets.all(4),
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: RangeMaintainingScrollPhysics(),
                  itemBuilder: (context, index) => PlayerTile(
                    name: response['object'][index]['name'],
                    nationality: response['object'][index]['nationality'],
                    position: response['object'][index]['position'],
                    url: response['crestUrl'],
                  ),
                  itemCount: response['object'].length,
                ),
              ),
            ),
          ),
          MessageBubble(
            sender: '',
            response: {'type': 'string', 'message': 'Hope this helps!'},
            isMe: false,
          ),
        ],
      ),
    );
  }
}

class ShowFixturesList extends StatelessWidget {
  ShowFixturesList({this.response});
  final Map<String, dynamic> response;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '@witbot',
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.black54,
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) => FixtureTile(
              homeTeam: response['object'][index]['homeTeam'],
              awayTeam: response['object'][index]['awayTeam'],
              homeTeamCrest: response['object'][index]['homeTeamCrest'],
              awayTeamCrest: response['object'][index]['awayTeamCrest'],
              datetimeOfMatch: response['object'][index]['datetimeOfMatch'],
              matchday: response['object'][index]['matchday'],
            ),
            itemCount: response['object'].length,
          ),
        ),
      ],
    );
  }
}
