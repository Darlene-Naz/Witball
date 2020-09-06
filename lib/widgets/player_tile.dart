import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PlayerTile extends StatelessWidget {
  PlayerTile({
    this.name,
    this.nationality,
    this.position,
    this.url,
  });
  final String name, nationality, position, url;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: SvgPicture.network(url),
          radius: 20,
        ),
        title: Text(
          name,
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
        trailing: Icon(Icons.more_vert),
        onLongPress: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  name,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                content: Column(
                  children: [
                    Text(position),
                    Text(nationality),
                  ],
                ),
                actions: [
                  FlatButton(
                    child: Text("Close"),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
