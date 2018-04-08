import 'dart:async';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_blog_app/BlogRow.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_blog_app/PostBlogPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/ProfilePage.dart';

final googleSignIn = new GoogleSignIn();
final analytics = new FirebaseAnalytics();
final auth = FirebaseAuth.instance;
final reference = FirebaseDatabase.instance.reference().child('Blogs');
String temp;
enum _DesignAppMenuItems { profile, logout, cod, ccc }

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

  Future<Null> checkStatusOfUser() async {
    await _ensureLoggedIn();
  }

  Future<Null> _ensureLoggedIn() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();

    GoogleSignInAccount user = googleSignIn.currentUser;

    try {
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
      print(user.displayName);
      prefs.setString("username", user.displayName);
      prefs.setString("userid", user.id);
      prefs.setString("useremail", user.email);
      prefs.setString("userphotourl", user.photoUrl);
      analytics.logLogin();

      this.setState(() {
        loggedIn = true;
      });
    } catch (error) {
      print(error);
    }
  }

  Future<Null> logoutUser() async {
    //logout user
    await FirebaseAuth.instance.signOut();
    this.setState(() {
      loggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Scaffold homeScaffold = new Scaffold(
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
            new PopupMenuButton<_DesignAppMenuItems>(
                onSelected: (_DesignAppMenuItems value) {
                  _handleStockMenu(context, value);
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuItem<_DesignAppMenuItems>>[
                      new PopupMenuItem<_DesignAppMenuItems>(
                          value: _DesignAppMenuItems.profile,
                          child: const Text('PROFILE')),
                      new PopupMenuItem<_DesignAppMenuItems>(
                          value: _DesignAppMenuItems.logout,
                          child: const Text('LOG OUT')),
                      new PopupMenuItem<_DesignAppMenuItems>(
                          value: _DesignAppMenuItems.cod,
                          child: const Text('COD')),
                      new PopupMenuItem<_DesignAppMenuItems>(
                          value: _DesignAppMenuItems.ccc,
                          child: const Text('CCC'))
                    ])
          ],
        ),
        body: new Container(
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
        ));
    Scaffold loginScaffold = new Scaffold(
      appBar: new AppBar(
        title: new Text("Login"),
      ),
      body: new Center(
        child: new RaisedButton(
            onPressed: () {
              checkStatusOfUser();
            },
            child: new Text("Google Sign in..")),
      ),
    );

    return new MaterialApp(
        title: "SimpleBlogApp",
        routes: <String, WidgetBuilder>{
          "/profile": (BuildContext context) => new ProfilePage(),
        },
        home: loggedIn ? homeScaffold : loginScaffold);
  }

  @override
  void initState() {
    super.initState();
//    checkStatusOfUser();
    this._function();
  }

  void _handleStockMenu(BuildContext context, _DesignAppMenuItems value) {
    switch (value) {
      case _DesignAppMenuItems.profile:
        print('Profile');
        Navigator.of(context).pushNamed("/profile");
        //        Navigator
//            .of(context)
//            .push(new MaterialPageRoute(builder: (BuildContext context) {
//          new ProfilePage();
//        }));
        break;
      case _DesignAppMenuItems.logout:
        logoutUser();
        break;
      case _DesignAppMenuItems.cod:
        break;
      case _DesignAppMenuItems.ccc:
        break;
    }
  }
}
