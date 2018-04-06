import 'package:flutter/material.dart';
import 'package:flutter_blog_app/main.dart';

class PostBlogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'a',
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => new HomePage(),
        },
      home: new Scaffold(
        body: new Center(
          child: new Text("a"),
        ),
      )
    );
  }
}
