import 'package:flutter/material.dart';
import 'package:foo_bot/widgets/message_bubble.dart';

import 'player_tile.dart';

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
                physics: BouncingScrollPhysics(),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
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
