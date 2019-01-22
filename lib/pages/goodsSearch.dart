import 'package:flutter/material.dart';
import 'package:flutter_app_demo/util/util.dart';
import 'goodsDesc.dart';

class GoodsSearch extends StatefulWidget {
  final data;

  GoodsSearch(this.data);

  _GoodsSearch createState() => _GoodsSearch(data);
}

class _GoodsSearch extends State<GoodsSearch> {
  final data;
  var param = {'curr_page': 1, 'page_count': 6};
  String words = '';
  List goodsData = [];
  Map shopData = {};
  int goodsCount = 0;
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  bool isNotMore = false;

  _GoodsSearch(this.data);

  @override
  void initState() {
    // TODO: implement initState
    if (data['classID'] != null) {
      param['class_id'] = data['classID'];
    } else if (data['words'] != null) {
      words = data['words'];
    }
    getGoodsSearch(context);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          isPerformingRequest == false &&
          param["curr_page"] < (goodsCount / param["page_count"]).ceil()) {
        setState(() {
          param["curr_page"] += param["curr_page"];
          isNotMore = false;
          getGoodsSearch(context);
        });
      } else if (param["curr_page"] == (goodsCount / param["page_count"]).ceil() &&
          _scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        setState(() {
          isNotMore = true;
        });
      }
    });
//    print(data);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  getGoodsSearch(context) {
    setState(() {
      isPerformingRequest = true;
    });
    ajax('Search/keyWords', {'gParam': param, 'words': words}, false, (data) {
      setState(() {
        goodsData.addAll(data['goods']);
        shopData = data['shop'];
        goodsCount = data['gcount'];
        isPerformingRequest = false;
      });
    }, () {}, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('商品搜索'), actions: <Widget>[]),
        body: SafeArea(
          child: ListView(
            controller: _scrollController,
            children: <Widget>[
//              Container(
//                child: Text('goods search'),
//              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: goodsData.length == 0
                    ? Placeholder(
                        color: Colors.transparent,
                      )
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
                child: isNotMore == true
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
