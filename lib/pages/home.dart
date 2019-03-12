import 'package:flutter/material.dart';
import 'package:flutter_app_demo/router.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_app_demo/util/util.dart';
import 'searchBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  List slider = [];
  List goodsClass = [];
  List goods = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _pullNet(context);
    getGoodsClass(context);
    _readGoods();
  }

  _pullNet(context) {
    ajax('index/slider', {}, false, (data) {
      if (!mounted) return;
      setState(() {
        slider = data['data'];
      });
    }, () => {}, context);
  }

  getGoodsClass(context) {
    ajax('Goods/getGoodsClass', '', false, (data) {
      List newClass = [];
      const step = 10;
      var len = ((data['goodsClass'].length + 1) / step).ceil();
      var fullClass = {
        'b_logo': null,
        'children': [],
        'f_logo': null,
        'label': '全部分类',
        'm_logo': 'static/images/goods_class/fl.png',
        'pc_logo': null,
        'value': 0
      };
      cls(i) {
        var end = ((i + 1) * step > data['goodsClass'].length) ? data['goodsClass'].length : (i + 1) * step;
        newClass.insert(i, data['goodsClass'].sublist(i * step, end));
        if (i == len - 1) {
          newClass[i].add(fullClass);
        }
      }

      if (len > 1) {
        for (var i = 0; i < len; i += 1) {
          cls(i);
        }
      }
      if (!mounted) return;
      setState(() {
        goodsClass = newClass;
      });
    }, () {}, context);
  }

  _readGoods() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String indexGoods = preferences.get('indexGoods');
    if (!mounted) return;
    if (indexGoods != null) {
      setState(() {
        goods = jsonDecode(indexGoods);
      });
    } else {
      setState(() {
        goods = [];
      });
    }
    getGoods(context);
  }

  _addGoods(data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('indexGoods', data);
  }

  getGoods(context) {
    ajax('Goods/indexG', '', false, (data) {
      if (!mounted) return;
      setState(() {
        goods = data['data'];
      });
      _addGoods(jsonEncode(data['data']));
    }, () {}, context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
          leading: null,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
//              padding: EdgeInsets.all(5),
//              margin: EdgeInsets.only(right: 10),
                child: GestureDetector(
                    onTap: () {
                      showSearch(context: context, delegate: SearchBarDelegate());
                    },
                    child: Container(
                      height: 32,
                      padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
                      color: Colors.white,
                      child: Container(
                        child: Text(
                          '搜索商品',
                          style: TextStyle(color: Colors.black26, fontSize: 14, height: 1.3),
                        ),
                      ),
                    )),
              )
            ],
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: SearchBarDelegate());
                }),
          ]),
      body: ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.width / 1000 * 514,
            child: slider.isEmpty
                ? new Placeholder(
                    fallbackWidth: 100.0,
                    fallbackHeight: 100.0,
                    color: Colors.transparent,
                  )
                : Swiper(
                    autoplay: true,
                    itemBuilder: (c, index) {
                      return (new Image.network(
                        "$pathName${slider[index]['pic_url']}",
                        fit: BoxFit.contain,
                      ));
                    },
                    itemCount: slider.length,
                    pagination: new SwiperPagination(),
                    control: new SwiperControl(),
                  ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
            height: MediaQuery.of(context).size.width / 5 * 2 + 32,
            child: goodsClass.isEmpty
                ? new Placeholder(
                    fallbackWidth: 100.0,
                    fallbackHeight: 100.0,
                    color: Colors.transparent,
                  )
                : Swiper(
                    itemBuilder: (c, index) {
                      return (new Wrap(
                        runSpacing: 6.0,
                        children: goodsClass[index].map<Widget>((item) {
                          return new SizedBox(
                            width: MediaQuery.of(context).size.width / 5,
                            child: GestureDetector(
                              onTap: () {
                                if (item['value'] == 0) {
                                  Routes.router.navigateTo(context, Routes.goodsClass);
                                } else {
                                  var json = jsonEncode({'classID': item['value']});
                                  Routes.router.navigateTo(context, '${Routes.goodsSearch}?data=$json');
                                }
                              },
                              child: new Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new SizedBox(
                                    child: new Container(
                                      child: new Image.network("$pathName${item['m_logo']}"),
                                    ),
                                    height: MediaQuery.of(context).size.width * 0.12,
                                    width: MediaQuery.of(context).size.width * 0.12,
                                  ),
                                  new Padding(
                                    padding: new EdgeInsets.only(top: 6.0, bottom: 8),
                                    child: new Text(item['label']),
                                  )
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ));
                    },
                    itemCount: goodsClass.length,
                    pagination: new SwiperPagination(),
//                    control: new SwiperControl(),
                  ),
          ),
          Container(
            child: (goods.isEmpty
                ? Center(
                    child: Container(padding: EdgeInsets.only(bottom: 10, top: 10), child: CircularProgressIndicator()),
                  )
                : Column(
                    children: goods.map<Widget>((item) {
                      return Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsetsDirectional.only(top: 15),
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage("${pathName}static/images/index/mobile/pic_09.png"),
                                    fit: BoxFit.contain)),
                            child: Container(
                              padding: new EdgeInsets.only(top: 6.0, bottom: 6.0),
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                item['label'],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red),
                              ),
                            ),
                          ),
                          new Wrap(
                            children: item['goods'].map<Widget>((goodsItem) {
                              return SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: GestureDetector(
                                    onTap: () {
//
                                      String json = jsonEncode({
                                        'title': Utf8Encoder().convert(goodsItem['goods_name']),
                                        'goodsID': goodsItem['goods_id']
                                      });
                                      Routes.router.navigateTo(context, '${Routes.goodsDesc}?data=$json');
                                    },
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      child: Column(
                                        children: <Widget>[
                                          Image.network(
                                            "$pathName${goodsItem['goods_pics'][0]['thumbs']['400']['file_path']}",
                                            fit: BoxFit.contain,
                                            width: MediaQuery.of(context).size.width / 2 - 10,
                                            height: MediaQuery.of(context).size.width / 2 - 10,
                                          ),
                                          Align(
                                            alignment: FractionalOffset.topLeft,
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(10, 6, 10, 0),
                                              child: Text(
                                                goodsItem['goods_name'],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: FractionalOffset.topLeft,
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                              child: Text(
                                                "￥${goodsItem['goods_price']}",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                              );
                            }).toList(),
                          )
                        ],
                      );
                    }).toList(),
                  )),
          )
        ],
      ),
    );
  }
}
