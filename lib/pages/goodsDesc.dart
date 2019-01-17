import 'package:flutter/material.dart';
import 'package:flutter_app_demo/util/util.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

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

  _GoodsDesc(this.title, this.goodsID);

  @override
  initState() {
    getDesc();
    super.initState();
  }

  getDesc() {
    ajax('goods/desc', {'goods_id': goodsID}, false, (data) {
      print(data);
      setState(() {
        goodsData = data['data'];
      });
    }, () {}, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.width,
            child: Swiper(
              autoplay: true,
              itemBuilder: (c, index) {
                return (goodsData.length == 0
                    ? new Placeholder(
                        fallbackWidth: 100.0,
                        fallbackHeight: 100.0,
                        color: Colors.transparent,
                      )
                    : new Image.network(
                        pathName + goodsData['goods_pics'][index]['file_path'],
                        fit: BoxFit.contain,
                      ));
              },
              itemCount: goodsData.length == 0 ? 1 : goodsData['goods_pics'].length,
              pagination: new SwiperPagination(),
              control: new SwiperControl(),
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomLeft,
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
                      decorationColor: Colors.red,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              goodsData['goods_name'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
