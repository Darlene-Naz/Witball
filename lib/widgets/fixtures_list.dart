import 'package:flutter/material.dart';
import 'package:foo_bot/widgets/fixture_tile.dart';
import 'package:foo_bot/widgets/message_bubble.dart';

class ShowFixturesList extends StatelessWidget {
  ShowFixturesList({this.response});
  final Map<String, dynamic> response;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MessageBubble(
          sender: '@witbot',
          response: {'type': 'string', 'message': 'This is what I found...'},
          isMe: false,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
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
        ),
      ],
    );
  }
}
