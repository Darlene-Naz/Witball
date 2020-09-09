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
          child: Hero(
            tag: 'team_logo',
            child: ClipOval(
              child: SvgPicture.network(url),
            ),
          ),
          radius: 20,
        ),
        title: Text(
          name,
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
        trailing: GestureDetector(
          child: Icon(Icons.more_vert),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Row(
                    children: [
                      CircleAvatar(
                        child: Hero(
                          tag: 'team_logo',
                          child: ClipOval(
                            child: SvgPicture.network(url),
                          ),
                        ),
                        radius: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        name,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            border: Border.all(
                                width: 3,
                                color: Colors.grey,
                                style: BorderStyle.solid),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Icon(Icons.location_on),
                        ),
                        title: Text('Position'),
                        subtitle: Text('$position'),
                      ),
                      ListTile(
                        leading: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            border: Border.all(
                                width: 3,
                                color: Colors.grey,
                                style: BorderStyle.solid),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Icon(Icons.flag),
                        ),
                        title: Text('Nationality'),
                        subtitle: Text('$nationality'),
                      ),
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
        onLongPress: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Row(
                  children: [
                    CircleAvatar(
                      child: Hero(
                        tag: 'team_logo',
                        child: ClipOval(
                          child: SvgPicture.network(url),
                        ),
                      ),
                      radius: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      name,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          border: Border.all(
                              width: 3,
                              color: Colors.grey,
                              style: BorderStyle.solid),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Icon(Icons.location_on),
                      ),
                      title: Text('Position'),
                      subtitle: Text('$position'),
                    ),
                    ListTile(
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          border: Border.all(
                              width: 3,
                              color: Colors.grey,
                              style: BorderStyle.solid),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Icon(Icons.flag),
                      ),
                      title: Text('Nationality'),
                      subtitle: Text('$nationality'),
                    ),
                  ],
                ),
                actions: [
                  FlatButton(
                    child: Text("Close"),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
