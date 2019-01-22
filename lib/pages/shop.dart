import 'package:flutter/material.dart';
import 'searchBar.dart';

class ShopScreen extends StatefulWidget {
  _SearchBarDemoState createState() => _SearchBarDemoState();
}

class _SearchBarDemoState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        appBar: AppBar(title: Text('SearchBarDemo'), actions: <Widget>[
//          IconButton(
//              icon: Icon(Icons.search),
//              onPressed: () {
//                showSearch(context: context, delegate: SearchBarDelegate());
//              }
//              // showSearch(context:context,delegate: SearchBarDelegate()),
//              ),
//        ]),
        body: Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(context: context, delegate: SearchBarDelegate());
                  }
                  // showSearch(context:context,delegate: SearchBarDelegate()),
                  ),
            ],
            title: Text('CustomScrollView'),
            backgroundColor: Theme.of(context).primaryColor,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                  'https://m.360buyimg.com/mobilecms/s750x324_jfs/t1/9840/31/8814/317082/5c0fa77dE734fab06/0274ab09e7571c9d.png',
                  fit: BoxFit.cover),
            ),
            pinned: true, //固定导航
          ),
          SliverFixedExtentList(
            delegate: SliverChildListDelegate([1, 2, 3, 4, 5, 6, 7, 7, 8, 9].map((product) {
              return Container(
                padding: EdgeInsets.all(20.0),
                child: Text('$product'),
              );
            }).toList()),
            itemExtent: 120.0,
          )
        ],
      ),
    ));
  }
}
