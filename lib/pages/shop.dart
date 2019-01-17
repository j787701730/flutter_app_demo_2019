import 'package:flutter/material.dart';
import 'searchBar.dart';

class ShopScreen extends StatefulWidget {
  _SearchBarDemoState createState() => _SearchBarDemoState();
}

class _SearchBarDemoState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('SearchBarDemo'), actions: <Widget>[
      IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(context: context, delegate: searchBarDelegate());
          }
          // showSearch(context:context,delegate: searchBarDelegate()),
          ),
    ]));
  }
}
