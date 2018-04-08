import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String username, userid, useremail, userphotourl;

class ProfilePage extends StatefulWidget {
  ProfilePageState createState() => new ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  Future<Null> _function() async {
    bool loggedIn = false;
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

  @override
  Widget build(BuildContext context) {
//   print(username);
//   print(userid);
//   print(useremail);
//   print(userphotourl);
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Profile"),
        ),
        body: new Container(
          alignment: Alignment.center,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new CircleAvatar(
                child: new Image.network(
                  userphotourl,
                  fit: BoxFit.fill,
                  height: 120.0,
                  width: 120.0,
                ),
                radius: 100.0,
                backgroundColor: Colors.blueAccent,
              ),
              new Text(username),
              new Text(useremail)
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this._function();
  }
}
