import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:transparent_image/transparent_image.dart';

@override
class ChatRow extends StatefulWidget {
  final DataSnapshot snapshot;

  ChatRow(this.snapshot);

  ChatRowState createState() => new ChatRowState(this.snapshot);
}

class ChatRowState extends State<ChatRow> {
  bool _liked = false;
  final DataSnapshot snapshot;

  ChatRowState(this.snapshot);

  @override
  Widget build(BuildContext context) {
    /*  return new Container(
      color: Colors.amberAccent,
      margin: const EdgeInsets.all(4.0),
      child: new ListTile(
        title: new Text(snapshot.value['messageUser'],
            style: new TextStyle(fontSize: 16.0)),
        leading: new Image.network(snapshot.value['profileUrl']),
        subtitle: new Text(
          snapshot.value['messageText'],
          style: new TextStyle(fontSize: 22.0),
        ),

*/
//        trailing: new Text(
//          snapshot.value['messageTime'],
//          style: new TextStyle(fontSize: 12.0),
//        ),
//        color: Colors.white,
//        child: new Row(
//          children: <Widget>[
////          1.userImage
//            new FadeInImage.memoryNetwork(
//                height: 40.0,
//                width: 40.0,
//                placeholder: kTransparentImage,
//                image: snapshot.value['profileUrl']),
////        2.message Text
//            new Text(snapshot.value['messageText'])
//          ],
//        ),
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new CircleAvatar(
                backgroundImage: new NetworkImage(snapshot.value['profileUrl'])),
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
