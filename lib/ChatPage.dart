import 'dart:async';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/ChatRow.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

String username, userid, useremail, userphotourl;

final analytics = new FirebaseAnalytics();
final reference = FirebaseDatabase.instance.reference().child('chat');

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(title: "Chat", home: new ChatScreen());
  }
}

class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  bool loggedIn = false;
  TextEditingController _textEditingController = new TextEditingController();
  bool _isComposing = false;

  Future<Null> _function() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    this.setState(() {
      if (prefs.getString("username") != null) {
        loggedIn = true;
        username = prefs.getString("username");
        userid = prefs.getString("userid");
        useremail = prefs.getString("useremail");
        userphotourl = prefs.getString("userphotourl");
      } else {
        loggedIn = false;
      }
    });
  }

  Future<Null> _handleClick(String message) async {
    _textEditingController.clear();
    setState(() {
      _isComposing = false;
    });
    _sendMessage(message);
  }

  void _sendMessage(String message) {
    reference.push().set({
      "messageTime": new DateTime.now().millisecondsSinceEpoch.toString(),
      "messageText": message,
      "messageUser": useremail,
      "profileUrl": userphotourl
    });
    analytics.logEvent(name: 'send_message');
  }

  @override
  void initState() {
    super.initState();
    _function();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Chat"),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
              child: new FirebaseAnimatedList(
            query: reference,
            sort: (a, b) => b.key.compareTo(a.key),
            padding: new EdgeInsets.all(8.0),
            reverse: true,
            itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation,
                int index) {
              return new ChatRow(snapshot);
            },
          )),
          new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: new IconTheme(
              data: new IconThemeData(color: Theme.of(context).accentColor),
              child: new Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: new Row(children: <Widget>[
                    new Flexible(
                      child: new TextField(
                        controller: _textEditingController,
                        onChanged: (String text) {
                          setState(() {
                            _isComposing = text.length > 0;
                          });
                        },
                        decoration: new InputDecoration.collapsed(
                            hintText: "Send a message"),
                      ),
                    ),
                    new Container(
                        margin: new EdgeInsets.symmetric(horizontal: 4.0),
                        child: new IconButton(
                            icon: new Icon(Icons.send),
                            onPressed: _isComposing
                                ? () =>
                                    _handleClick(_textEditingController.text)
                                : null)),
                  ]),
                  decoration: Theme.of(context).platform == TargetPlatform.iOS
                      ? new BoxDecoration(
                          border: new Border(
                              top: new BorderSide(color: Colors.grey[200])))
                      : null),
            ),
          ),
        ],
      ),
    );
  }
}
