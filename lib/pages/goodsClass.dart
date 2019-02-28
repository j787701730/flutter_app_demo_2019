import 'package:flutter/material.dart';
import 'package:flutter_app_demo/util/util.dart';
import 'goodsSearch.dart';

class GoodsClass extends StatefulWidget {
  _GoodsClass createState() => _GoodsClass();
}

class _GoodsClass extends State<GoodsClass> {
  List goodsClassData = [];
  var goodsClassIndex;
  Map goodsClassItem = {};

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    getGoodsClass(context);
  }

  getGoodsClass(context) {
    ajax('Goods/getGoodsClass', '', false, (data) {
      setState(() {
        goodsClassData = data['goodsClass'];
        goodsClassIndex = data['goodsClass'][0]['value'];
        goodsClassItem = data['goodsClass'][0];
      });
    }, () {}, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('分类'), actions: <Widget>[]),
        body: Row(
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
                            decoration: BoxDecoration(
                                color: goodsClassIndex == item['value'] ? Color(0x00000000) : Color(0x15658734)),
                            child: Container(
                              padding: EdgeInsets.only(top: 20, bottom: 20, left: 8),
                              child: Row(
                                children: <Widget>[
                                  Image.network(
                                    '$pathName${item["pc_logo"]}',
                                    width: 25,
                                    height: 25,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 4),
                                    child: Text(
                                      item['label'],
                                      style: TextStyle(
                                          color: goodsClassIndex == item['value'] ? Colors.red : Colors.black),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              goodsClassIndex = item['value'];
                              goodsClassItem = item;
                            });
                          },
                        );
                      }).toList(),
                    )),
            ),
            Expanded(
              child: goodsClassItem.length == 0
                  ? Placeholder(
                      color: Colors.transparent,
                    )
                  : Container(
                      padding: EdgeInsets.only(left: 6, right: 6, top: 6),
                      child: ListView(
                        children: <Widget>[
                          Image.network(
                            '$pathName${goodsClassItem['b_logo']}',
                            height: (MediaQuery.of(context).size.width - 120 - 12) / 748 * 350,
                            fit: BoxFit.fill,
                          ),
                          Wrap(
                            children: goodsClassItem['children'].map<Widget>((item) {
                              return SizedBox(
                                width: (MediaQuery.of(context).size.width - 120 - 12) / 3,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                                      return new GoodsSearch({'classID': item['value']});
                                    }));
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Image.network(
                                        '$pathName${item["pc_logo"]}',
                                        fit: BoxFit.fill,
                                        width: (MediaQuery.of(context).size.width - 120 - 12) / 3 - 10,
                                        height: (MediaQuery.of(context).size.width - 120 - 12) / 3 - 10,
                                      ),
                                      Text(item['label'])
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ),
            )
          ],
        ));
  }
}
