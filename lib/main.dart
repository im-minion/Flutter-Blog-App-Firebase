import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blog_app/HomePage.dart';

void main() => runApp(new HomePage());

class Choice {
  const Choice({this.title});

  final String title;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Profile'),
  const Choice(title: 'Logout'),
];
