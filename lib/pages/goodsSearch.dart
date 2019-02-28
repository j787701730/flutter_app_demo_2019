import 'package:flutter/material.dart';
import 'package:flutter_app_demo/util/util.dart';
import 'goodsDesc.dart';
import 'shopIndex.dart';

class GoodsSearch extends StatefulWidget {
  final data;

  GoodsSearch(this.data);

  _GoodsSearch createState() => _GoodsSearch(data);
}

class _GoodsSearch extends State<GoodsSearch> {
  final data;
  Map param = {'curr_page': '1', 'page_count': '6'};
  String words = '';
  List goodsData = [];
  var shopData;
  String orderPrice = 'goods_price desc';

  int goodsCount = 0;
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  bool isNotMore = false;
  bool isPassRequest = false;

  _GoodsSearch(this.data);

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    if (data['classID'] != null) {
      param['class_id'] = data['classID'].toString();
    } else if (data['words'] != null) {
      words = data['words'];
    }
    getGoodsSearch(context);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          isPerformingRequest == false &&
          int.parse(param["curr_page"]) < (goodsCount / int.parse(param["page_count"])).ceil()) {
        setState(() {
          param["curr_page"] = (int.parse(param["curr_page"]) + 1).toString();
          isNotMore = false;
          getGoodsSearch(context);
        });
      } else if (int.parse(param["curr_page"]) == (goodsCount / int.parse(param["page_count"])).ceil() &&
          _scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        setState(() {
          isNotMore = true;
        });
      }
    });
//    print(data);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  getGoodsSearch(context) {
    setState(() {
      isPerformingRequest = true;
      isPassRequest = false;
    });
    ajax('Search/keyWords', {'gParam': param, 'words': words}, false, (data) {
      setState(() {
        goodsData.addAll(data['goods']);
        shopData = data['shop'];
        goodsCount = data['gcount'];
        isPerformingRequest = false;
        isPassRequest = true;
      });
    }, () {}, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('商品搜索'), actions: <Widget>[]),
      body: ListView(
        controller: _scrollController,
        children: <Widget>[
          Container(
              child: shopData == null
                  ? Placeholder(
                      fallbackHeight: 1,
                      color: Colors.transparent,
                    )
                  : Container(
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                      margin: EdgeInsets.only(bottom: 15),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                            return new ShopIndex(shopData);
                          }));
                        },
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Color(0xFFEEEEEE)),
                          position: DecorationPosition.background,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
//                                        FF9C8175
                                    Container(
                                        padding: EdgeInsets.only(top: 10),
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width - 20,
                                          height: 100,
                                          child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFF9C8175))),
                                        )),
                                    Padding(
                                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child: Image.network(
                                          '$pathName${shopData["shop_logo"]}',
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.contain,
                                        )),
                                    Positioned(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width - 170,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Icon(
                                              Icons.store_mall_directory,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              shopData['shop_name'],
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ),
                                      left: 140,
                                      top: 10,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 20) / 4,
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        param.remove('order');
                        param['curr_page'] = '1';
                        isNotMore = false;
                        goodsData = [];
                        getGoodsSearch(context);
                      });
                    },
                    child: Text('综合', style: TextStyle(color: param['order'] == null ? Colors.red : Colors.black)),
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 20) / 4,
                  child: FlatButton(
                    onPressed: () {
                      param['curr_page'] = '1';
                      isNotMore = false;
                      param['order'] = 'sales_volume';
                      goodsData = [];
                      getGoodsSearch(context);
                    },
                    child: Text('销量',
                        style: TextStyle(color: param['order'] == 'sales_volume' ? Colors.red : Colors.black)),
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 20) / 4,
                  child: FlatButton(
                    onPressed: () {
                      param['curr_page'] = '1';
                      isNotMore = false;
                      param['order'] = 'browse_times';
                      goodsData = [];
                      getGoodsSearch(context);
                    },
                    child: Text(
                      '人气',
                      style: TextStyle(color: param['order'] == 'browse_times' ? Colors.red : Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 20) / 4,
                  child: FlatButton(
                    onPressed: () {
                      param['curr_page'] = '1';
                      isNotMore = false;
                      if (orderPrice == 'goods_price desc') {
                        param['order'] = 'goods_price';
                        orderPrice = 'goods_price';
                      } else {
                        param['order'] = 'goods_price desc';
                        orderPrice = 'goods_price desc';
                      }
                      goodsData = [];
                      getGoodsSearch(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('价格',
                            style: TextStyle(
                                color: param['order'] == 'goods_price desc' || param['order'] == 'goods_price'
                                    ? Colors.red
                                    : Colors.black)),
                        Icon(
                          orderPrice == 'goods_price desc' ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                          color: param['order'] == 'goods_price desc' || param['order'] == 'goods_price'
                              ? Colors.red
                              : Colors.black,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: goodsData.length == 0
                ? isPassRequest == false
                    ? Placeholder(
                        color: Colors.transparent,
                        fallbackHeight: 1,
                      )
                    : Container(
                        padding: EdgeInsets.only(top: 100),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.network(
                                '$pathName/assets/8c382430f673ad2237bbf19e5c8a4b00.png',
                                width: 200,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text('无商品数据'),
                              ),
                            ],
                          ),
                        ))
                : Wrap(
                    children: goodsData.map<Widget>((item) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        width: MediaQuery.of(context).size.width / 2 - 10,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                              return new GoodsDesc(item['goods_name'], item['goods_id']);
                            }));
                          },
                          child: Column(
                            children: <Widget>[
                              Image.network(
                                '$pathName${item["goods_pics"][0]["thumbs"]["400"]["file_path"]}',
                                width: MediaQuery.of(context).size.width / 2 - 20,
                                height: MediaQuery.of(context).size.width / 2 - 20,
                                fit: BoxFit.contain,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  item['goods_name'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '￥${item['goods_price']}',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        '销量${item["sales_volume"]}笔',
                                        style: TextStyle(color: Colors.black38),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4, bottom: 4),
            child: isNotMore == true && isPassRequest == true
                ? Center(
                    child: Text(
                      '没有更多了',
                      style: TextStyle(color: Colors.black38),
                    ),
                  )
                : Placeholder(
                    fallbackHeight: 1,
                    color: Colors.transparent,
                  ),
          ),
          Center(
            child: isPerformingRequest == true
                ? Container(
                    child: CircularProgressIndicator(),
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                  )
                : Placeholder(
                    color: Colors.transparent,
                    fallbackHeight: 100,
                  ),
          ),
        ],
      ),
    );
  }
}
