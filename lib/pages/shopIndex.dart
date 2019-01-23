import 'package:flutter/material.dart';
import 'package:flutter_app_demo/util/util.dart';
import 'shopNav.dart';
import 'goodsDesc.dart';

class ShopIndex extends StatefulWidget {
  final data;

  ShopIndex(this.data);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _ShopIndex(data);
  }
}

class _ShopIndex extends State<ShopIndex> {
  final data;

  _ShopIndex(this.data);

  List goodsData = [];
  List hotSale = [];
  Map shopInfo = {};
  Map param = {'curr_page': '1', 'page_count': '6'};
  String words = '';
  var shopData;
  String orderPrice = 'goods_price desc';

  int goodsCount = 0;
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  bool isNotMore = false;
  bool isPassRequest = false;

  @override
  initState() {
//    getDesc();
    getShopInfo();
    getGoodsList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          isPerformingRequest == false &&
          int.parse(param["curr_page"]) < (goodsCount / int.parse(param["page_count"])).ceil()) {
        setState(() {
          param["curr_page"] = (int.parse(param["curr_page"]) + 1).toString();
          isNotMore = false;
          getGoodsList();
        });
      } else if (int.parse(param["curr_page"]) == (goodsCount / int.parse(param["page_count"])).ceil() &&
          _scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        setState(() {
          isNotMore = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  getShopInfo() {
    ajax(
        'shops/info',
        {
          'shop_id': data['shop_id'],
          'getExt': ["hot_sale", "shop"]
        },
        false, (data) {
      setState(() {
        hotSale = data['hot_sale'];
        shopInfo = data['shop'];
      });
    }, () {}, context);
  }

  getGoodsList() {
    setState(() {
      isPerformingRequest = true;
      isPassRequest = false;
    });
    param['shop_id'] = data['shop_id'];
    ajax('goods/lists', param, false, (data) {
      setState(() {
        goodsData.addAll(data['data']);
        goodsCount = data['count'];
        isPerformingRequest = false;
        isPassRequest = true;
      });
    }, () {}, context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(data['shop_name']),
      ),
      body: ListView(
        controller: _scrollController,
        children: <Widget>[
          ShopNav(shopInfo),
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
                        goodsData = [];
                        getGoodsList();
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
                      param['order'] = 'sales_volume';
                      goodsData = [];
                      getGoodsList();
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
                      param['order'] = 'browse_times';
                      goodsData = [];
                      getGoodsList();
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
                      if (orderPrice == 'goods_price desc') {
                        param['order'] = 'goods_price';
                        orderPrice = 'goods_price';
                      } else {
                        param['order'] = 'goods_price desc';
                        orderPrice = 'goods_price desc';
                      }
                      goodsData = [];
                      getGoodsList();
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
          Container(
            height: 1,
            decoration: BoxDecoration(color: Colors.black26),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: goodsData.length == 0
                ? isPassRequest == false
                    ? Placeholder(
                        color: Colors.transparent,
                      )
                    : Container(
                        padding: EdgeInsets.only(top: 100),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.network(
                                '${pathName}/assets/8c382430f673ad2237bbf19e5c8a4b00.png',
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
                : Text(''),
          ),
          Center(
            child: isPerformingRequest == true
                ? CircularProgressIndicator()
                : Placeholder(
                    color: Colors.transparent,
                    fallbackHeight: 1,
                  ),
          )
        ],
      ),
    ));
  }
}
