import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

@override
class BlogRow extends StatelessWidget {
  final DataSnapshot snapshot;

  BlogRow(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Card(
        child: new Column(
          children: <Widget>[
//            TODO: add network image with retry
            new Image.network(snapshot.value['IMAGE']),
            new Text(snapshot.value['Title']),
            new Text(snapshot.value['DESCRIPTION']),
//            TODO: add like button and its functionality
            new Text(snapshot.value['username']),
          ],
        ),
      ),
    );
  }
}
