import 'dart:async';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_blog_app/BlogRow.dart';
import 'package:flutter_blog_app/main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_blog_app/PostBlogPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

final googleSignIn = new GoogleSignIn();
final analytics = new FirebaseAnalytics();
final auth = FirebaseAuth.instance;
final reference = FirebaseDatabase.instance.reference().child('Blogs');
String temp;

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  bool loggedIn = false;
  SharedPreferences prefs;

  Future<Null> _function() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    this.setState(() {
      if (prefs.getString("username") != null) {
        loggedIn = true;
      } else {
        loggedIn = false;
      }
    });
  }

  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null) user = await googleSignIn.signInSilently();
    if (user == null) {
      user = await googleSignIn.signIn();
      analytics.logLogin();
    }
    if (await auth.currentUser() == null) {
      GoogleSignInAuthentication credentials =
          await googleSignIn.currentUser.authentication;
      await auth.signInWithGoogle(
        idToken: credentials.idToken,
        accessToken: credentials.accessToken,
      );
    }
  }

  Future<Null> checkStatusOfUser() async {
    await _ensureLoggedIn();
  }

  void _select(Choice choice) {
    setState(() {
      // Causes the app to rebuild with the new _selectedChoice.
      choiceSelected(choice);
    });
  }

  void choiceSelected(Choice selectedChoice) {
    switch (selectedChoice.title) {
      case 'Profile':
       print("pro");
        break;
      case 'Logout':
       print("lo");
        logoutUser();
        break;
    }
  }

  void logoutUser() {
    //logout user
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "SimpleBlogApp",
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text("Simple Blog App"),
              actions: <Widget>[
                new Builder(builder: (context) {
                  return new IconButton(
                      icon: new Icon(Icons.add),
                      onPressed: () {
                        Navigator.of(context).push(
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new PostBlogPage()),
                            );
                      });
                }),
                new Builder(builder: (context) {
                  return new PopupMenuButton(
                      onSelected: _select,
                      itemBuilder: (BuildContext context) {
                        return choices.map((Choice choice) {
                          return new PopupMenuItem<Choice>(
                            value: choice,
                            child: new Text(choice.title),
                          );
                        }).toList();
                      });
                })
              ],
            ),
            body: new Builder(builder: (context) {
              return new Container(
                child: new Column(children: <Widget>[
                  new Flexible(
                    child: new FirebaseAnimatedList(
                      query: reference,
                      sort: (a, b) => b.key.compareTo(a.key),
                      padding: new EdgeInsets.all(8.0),
                      reverse: false,
                      itemBuilder: (_, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        return new BlogRow(snapshot);
                      },
                    ),
                  ),
                  new Divider(height: 1.0),
                ]),
              );
            })));
  }

  @override
  void initState() {
    super.initState();
    checkStatusOfUser();
    this._function();
  }
}
