import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

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
  final DateFormat formatter = DateFormat(
    'dd-MM-yy',
  ).add_jm();

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
                child: SvgPicture.network(homeTeamCrest),
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
              SizedBox(
                height: 10,
              ),
              Text(
                formatter.format(DateTime.parse(datetimeOfMatch).toLocal()),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                child: SvgPicture.network(awayTeamCrest),
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
