import 'package:flutter/material.dart';
import 'package:flutter_app_demo/util/util.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'shopNav.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_html/flutter_html.dart';

class GoodsDesc extends StatefulWidget {
  final title;
  final goodsID;

  GoodsDesc(this.title, this.goodsID);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _GoodsDesc(title, goodsID);
  }
}

class _GoodsDesc extends State<GoodsDesc> {
  final title;
  final goodsID;
  Map goodsData = {};
  List hotSale = [];
  Map shopInfo = {};

  _GoodsDesc(this.title, this.goodsID);

  @override
  initState() {
    super.initState();
    getDesc();
    getShopInfo();
  }

  getDesc() {
    ajax('goods/desc', {'goods_id': goodsID}, false, (data) {
      setState(() {
        goodsData = data['data'];
      });
    }, () {}, context);
  }

  getShopInfo() {
    ajax(
        'shops/info',
        {
          'goods_id': goodsID,
          'getExt': ["hot_sale", "shop"]
        },
        false, (data) {
      setState(() {
        hotSale = data['hot_sale'];
        shopInfo = data['shop'];
      });
    }, () {}, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.width,
            child: goodsData.length == 0
                ? new Placeholder(
                    fallbackWidth: 100.0,
                    fallbackHeight: 100.0,
                    color: Colors.transparent,
                  )
                : Swiper(
                    autoplay: true,
                    itemBuilder: (c, index) {
                      return (goodsData.length == 0
                          ? new Placeholder(
                              fallbackWidth: 100.0,
                              fallbackHeight: 100.0,
                              color: Colors.transparent,
                            )
                          : new Image.network(
                              "$pathName${goodsData['goods_pics'][index]['file_path']}",
                              fit: BoxFit.contain,
                            ));
                    },
                    itemCount: goodsData.length == 0 ? 1 : goodsData['goods_pics'].length,
                    pagination: new SwiperPagination(),
                    control: new SwiperControl(),
                  ),
          ),
          (goodsData.length == 0
              ? Placeholder(
                  fallbackWidth: 100.0,
                  fallbackHeight: 100.0,
                  color: Colors.transparent,
                )
              : Container(
                  alignment: FractionalOffset.bottomLeft,
                  padding: EdgeInsets.only(top: 10, bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          '￥${goodsData['goods_price']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Text(
                          '￥${goodsData['goods_org_price']}',
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            decorationStyle: TextDecorationStyle.solid,
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          (goodsData.length == 0
              ? Placeholder(
                  fallbackWidth: 100.0,
                  fallbackHeight: 100.0,
                  color: Colors.transparent,
                )
              : Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    goodsData['goods_name'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
          Container(
            height: 4,
            margin: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(color: Colors.black26),
          ),
          ShopNav(shopInfo),
          Container(
            height: 1,
            margin: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(color: Colors.black26),
          ),
          Container(
//            padding: EdgeInsets.all(10),
            child: goodsData.length == 0
                ? Placeholder(
                    fallbackHeight: 1,
                    color: Colors.transparent,
                  )
                : Column(
              mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          '商品详情',
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                        ),
                      ),
                      Html(
                          data: goodsData['goods_desc'],
                          customRender: (node, children) {
                            if (node is dom.Element) {
                              switch (node.localName) {
                                case "img":
                                  return Image.network('$pathName${node.attributes['src']}');
//                      case "custom_tag":
//                        return CustomWidget(...);
                              }
                            }
                          }),
                    ],
                  ),
          )
        ],
      ),
    );
  }
}
