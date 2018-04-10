import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  ChatPageState createState() => new ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Chat"),
        ),
        body: new Text("chat :)"),
      ),
    );
  }
}
