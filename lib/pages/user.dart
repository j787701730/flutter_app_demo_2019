import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _UserScreen();
  }
}

class _UserScreen extends State<UserScreen> {
  showADialog(context) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
                title: new Text("Dialog Title"),
                content: new Text("This is my content"),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("CANCEL"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  new FlatButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        appBar: AppBar(
//          title: Center(child: Text('USER')),
//        ),
        body: Center(
          child: FlatButton(
              onPressed: () {
                showADialog(context);
              },
              child: Text('btn')),
        ));
  }
}
