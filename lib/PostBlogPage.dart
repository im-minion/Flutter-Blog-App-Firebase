import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blog_app/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

final googleSignIn = new GoogleSignIn();
final analytics = new FirebaseAnalytics();
final auth = FirebaseAuth.instance;
final reference = FirebaseDatabase.instance.reference().child('Blogs');

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

class PostBlogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          body: new _PostPage()),
    );
  }

}

class _PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => new _PostPageState();
}

class _PostPageState extends State<_PostPage> {
  File _image;
  final TextEditingController _title = new TextEditingController();
  final TextEditingController _desc = new TextEditingController();
  bool _isTitle = false;
  bool _isDesc = false;
  bool _isImage = false;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Padding(padding: const EdgeInsets.only(top: 24.0)),
          new InkWell(
            child: _image == null
                ? new Image.asset(
                    'assets/img/addbutton.png',
                    height: 300.0,
                    width: 300.0,
                    fit: BoxFit.fill,
                  )
                : new Image.file(
                    _image,
                    height: 200.0,
                    width: 200.0,
                  ),
            onTap: () {
              getImage();
              _isImage = true;
            },
          ),
          new TextField(
            controller: _title,
            onChanged: (String text) {
              setState(() {
                _isTitle = text.length > 0;
              });
            },
            decoration: new InputDecoration.collapsed(hintText: "Title"),
          ),
          new TextField(
            controller: _desc,
            onChanged: (String text) {
              setState(() {
                _isDesc = text.length > 0;
              });
            },
            decoration: new InputDecoration.collapsed(hintText: "Description"),
          ),
          new RaisedButton(
            onPressed: _isTitle && _isDesc && _isImage
                ? () => _handleSubmitted(_title.text, _desc.text, _image)
                : null,
          )
        ],
      ),
    );
  }

  Future<Null> _handleSubmitted(String title, String desc, File img) async {
    await _ensureLoggedIn();

    StorageReference ref = FirebaseStorage.instance.ref().child("Blog_Images/" +
        new DateTime.now().millisecondsSinceEpoch.toString()); //new
    StorageUploadTask uploadTask = ref.put(img); //new
    Uri downloadUrl = (await uploadTask.future).downloadUrl;
    _addBlog(title, desc, downloadUrl.toString());
  }

  void _addBlog(String title, String description, String imageUrl) {
//    analytics.logEvent(name: 'post_blog');
//    print(googleSignIn.currentUser.displayName);
//    print(googleSignIn.currentUser.id);
//    print(title);
//    print(imageUrl);
//    print(description);
    reference.push().set({
      'IMAGE': imageUrl,
      'Title': title,
      'DESCRIPTION': description,
      'uid': googleSignIn.currentUser.id,
      'username': googleSignIn.currentUser.displayName
    });
//    Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (Builder)))
//    Navigator.of(context).pushAndRemoveUntil(
//        new MaterialPageRoute(
//            builder: (BuildContext context) => new HomePage()),
//        (Route route) => route == null);
    Navigator.of(context).pop();

  }
}
