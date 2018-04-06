import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'dart:io';

final googleSignIn = new GoogleSignIn();
final analytics = new FirebaseAnalytics();
final auth = FirebaseAuth.instance;
final reference = FirebaseDatabase.instance.reference().child('Blog');
String temp;

void main() => runApp(new HomePage());

Future<Null> _ensureLoggedIn() async {
  GoogleSignInAccount user = googleSignIn.currentUser;
  if (user == null)
    user = await googleSignIn.signInSilently();
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

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "SimpleBlogApp",
      home: new Scaffold(
          body: new Column(children: <Widget>[
            new Flexible(
              child: new FirebaseAnimatedList(
                query: reference,
                sort: (a, b) => b.key.compareTo(a.key),
                padding: new EdgeInsets.all(8.0),
                reverse: false,
                itemBuilder: (_, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  return new BlogRow(
                    snapshot,
                  );
                },
//              itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation) {
//                return new ChatMessage(
//                    snapshot: snapshot,
//                    animation: animation
//                );
//              },
              ),
            ),
            new Divider(height: 1.0),

          ])
      ),
    );
  }

  Future<Null> checkStatusOfUser() async {
    await _ensureLoggedIn();
  }


  @override
  void initState() {
    super.initState();
    checkStatusOfUser();
  }

}

@override
class BlogRow extends StatelessWidget {
  final DataSnapshot snapshot;

  BlogRow(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Card(
        child: new Column(children: <Widget>[
          new Image.network(snapshot.value['IMAGE']),
          new Text(snapshot.value['Title']),
          new Text(snapshot.value['DESCRIPTION']),
          new Text(snapshot.value['username']),
        ],

        ),
      ),

    );
  }
}