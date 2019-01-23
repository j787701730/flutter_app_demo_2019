import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_app_demo/util/util.dart';
import 'searchBar.dart';
import 'goodsDesc.dart';
import 'goodsClass.dart';
import 'goodsSearch.dart';

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
    // TODO: implement initState
    _pullNet(context);
    getGoodsClass(context);
    getGoods(context);
    super.initState();
  }

  _pullNet(context) {
    ajax('index/slider', {}, false, (data) {
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
      } else {}
      setState(() {
        goodsClass = newClass;
      });
    }, () {}, context);
  }

  getGoods(context) {
    ajax('Goods/indexG', '', false, (data) {
      setState(() {
        goods = data['data'];
      });
    }, () {}, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('home'), actions: <Widget>[
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
            child: Swiper(
              autoplay: true,
              itemBuilder: (c, index) {
                return (slider.length == 0
                    ? new Placeholder(
                        fallbackWidth: 100.0,
                        fallbackHeight: 100.0,
                        color: Colors.transparent,
                      )
                    : new Image.network(
                        "$pathName${slider[index]['pic_url']}",
                        fit: BoxFit.contain,
                      ));
              },
              itemCount: slider.length == 0 ? 1 : slider.length,
              pagination: new SwiperPagination(),
              control: new SwiperControl(),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
            height: MediaQuery.of(context).size.width / 5 * 2 + 24,
            child: Swiper(
              itemBuilder: (c, index) {
                return (goodsClass.length == 0
                    ? new Placeholder(
                        fallbackWidth: 100.0,
                        fallbackHeight: 100.0,
                        color: Colors.transparent,
                      )
                    : new Wrap(
                        runSpacing: 6.0,
                        children: goodsClass[index].map<Widget>((item) {
                          return new SizedBox(
                            width: MediaQuery.of(context).size.width / 5,
                            child: GestureDetector(
                              onTap: () {
                                if (item['value'] == 0) {
                                  Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                                    return new GoodsClass();
                                  }));
                                } else {
                                  Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                                    return new GoodsSearch({'classID': item['value']});
                                  }));
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
              itemCount: goodsClass.length == 0 ? 1 : goodsClass.length,
              pagination: new SwiperPagination(),
//              control: new SwiperControl(),
            ),
          ),
          Container(
            child: (goods.length == 0
                ? Placeholder(
                    fallbackWidth: 100.0,
                    fallbackHeight: 100.0,
                    color: Colors.transparent,
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
                                      Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                                        return new GoodsDesc(goodsItem['goods_name'], goodsItem['goods_id']);
                                      }));
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
