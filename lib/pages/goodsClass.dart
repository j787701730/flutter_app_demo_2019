import 'package:flutter/material.dart';
import 'package:flutter_app_demo/util/util.dart';

class GoodsClass extends StatefulWidget {
  _GoodsClass createState() => _GoodsClass();
}

class _GoodsClass extends State<GoodsClass> {
  var goodsClassData = [];

  @override
  void initState() {
    // TODO: implement initState
    getGoodsClass(context);
    super.initState();
  }

  getGoodsClass(context) {
    ajax('Goods/getGoodsClass', '', false, (data) {
      print(data);
      setState(() {
        goodsClassData = data['goodsClass'];
      });
    }, () {}, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        appBar: AppBar(title: Text('SearchBarDemo'), actions: <Widget>[
//          IconButton(
//              icon: Icon(Icons.search),
//              onPressed: () {
//                showSearch(context: context, delegate: searchBarDelegate());
//              }
//              // showSearch(context:context,delegate: searchBarDelegate()),
//              ),
//        ]),
        body: SafeArea(
            child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 120,
          child: (goodsClassData.length == 0
              ? Placeholder(
                  color: Colors.transparent,
                )
              : ListView(
                  children: goodsClassData.map<Widget>((item) {
                    return GestureDetector(
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: Color(0x00000000)),
                        child: Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10, left: 8),
                          child: Row(
                            children: <Widget>[Image.network('$pathName${item["pc_logo"]}'), Text(item['label'])],
                          ),
                        ),
                      ),
                      onTap: () {
                        print(item['value']);
                      },
                    );
                  }).toList(),
                )),
        ),
        Expanded(
          child: Text('内容'),
        )
      ],
    )));
  }
}
