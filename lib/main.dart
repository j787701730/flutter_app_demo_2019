import 'package:flutter/material.dart';
import 'package:flutter_app_demo/bottom_navigation_widget.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome to Flutter',
      debugShowCheckedModeBanner: false,
      home: BottomNavigationWidget(),
    );
  }
}
