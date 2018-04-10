import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:transparent_image/transparent_image.dart';

@override
class BlogRow extends StatelessWidget {
  final DataSnapshot snapshot;

  BlogRow(this.snapshot);

  bool _liked = false;

  @override
  Widget build(BuildContext context) {
//    var size = MediaQuery.of(context).size;
//    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.2;
//    final double itemWidth = size.width;
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Text(snapshot.value['username'],
                    style: new TextStyle(color: Colors.blueAccent)),
                new IconButton(
                    icon: _liked
                        ? new Icon(
                            Icons.favorite,
                            color: Colors.blueAccent,
                          )
                        : new Icon(
                            Icons.favorite_border,
                            color: Colors.blueAccent,
                          ),
                    onPressed: () {
                      Scaffold.of(context).showSnackBar(new SnackBar(
                            content: new Text("Coming Soon!"),
                          ));
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
