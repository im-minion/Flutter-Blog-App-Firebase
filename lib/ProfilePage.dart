import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

String username, userid, useremail, userphotourl;

class ProfilePage extends StatefulWidget {
  ProfilePageState createState() => new ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  bool loggedIn = false;
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: userphotourl,
                  height: 150.0,
                  width: 150.0,
                  fadeInDuration: const Duration(milliseconds: 1000),
                  alignment: Alignment.topCenter,
                  fit: BoxFit.contain,
                ),
              ),
              new Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 8.0),
                child: new Text(
                  username,
                  style: new TextStyle(
                      fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
              ),
              new Text(
                useremail,
                style: new TextStyle(fontSize: 18.0),
              ),
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
