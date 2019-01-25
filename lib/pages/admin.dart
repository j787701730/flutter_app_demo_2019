import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _AdminScreen();
  }
}

class _AdminScreen extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('admin'),
      ),
      body: Container(child: Text('admin')),
    );
  }
}
