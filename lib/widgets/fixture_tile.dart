import 'package:flutter/material.dart';

class FixtureTile extends StatelessWidget {
  FixtureTile(
      {this.homeTeam,
      this.awayTeam,
      this.awayTeamCrest,
      this.datetimeOfMatch,
      this.homeTeamCrest,
      this.matchday});
  final String homeTeam, homeTeamCrest, awayTeam, awayTeamCrest;
  final String datetimeOfMatch;
  final int matchday;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                child: Image.network(homeTeamCrest),
                radius: 20,
              ),
              Text(
                homeTeam,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(matchday.toString()),
              Text(datetimeOfMatch.toString()),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                child: Image.network(awayTeamCrest),
                radius: 20,
              ),
              Text(
                awayTeam,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
