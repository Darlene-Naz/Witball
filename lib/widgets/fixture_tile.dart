import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
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
                  radius: 30,
                ),
                Flexible(
                  child: Text(
                    homeTeam,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    softWrap: true,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  matchday.toString(),
                  softWrap: true,
                ),
                Text(datetimeOfMatch.toString()),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  child: SvgPicture.network(awayTeamCrest),
                  radius: 30,
                ),
                Text(
                  awayTeam,
                  softWrap: true,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
