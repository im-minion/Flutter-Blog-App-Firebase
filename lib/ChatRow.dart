import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
@override
class ChatRow extends StatelessWidget {
  final DataSnapshot snapshot;

  ChatRow(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new CircleAvatar(
                backgroundImage:
                    new NetworkImage(snapshot.value['profileUrl'])),
          ),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(snapshot.value['messageUser'],
                    style: Theme.of(context).textTheme.subhead),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(snapshot.value['messageText']),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
