import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:transparent_image/transparent_image.dart';

@override
class BlogRow extends StatelessWidget {
  final DataSnapshot snapshot;

  BlogRow(this.snapshot);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // 24 is for notification bar on Android

//    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.2;
    final double itemWidth = size.width;

    return new Container(
      child: new Card(
        elevation: 2.5,
        child: new Column(
          children: <Widget>[
            new FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.value['IMAGE'],
              alignment: Alignment.topCenter,
              fit: BoxFit.contain,
            ),
//            new Image.network(snapshot.value['IMAGE']),
            new Text(snapshot.value['Title']),
            new Text(snapshot.value['DESCRIPTION']),
            new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Text(snapshot.value['username']),
                new IconButton(
                    icon: new Icon(Icons.thumb_up), onPressed: _handleLike()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _handleLike() {
//    TODO: handle functionality
  }
}
