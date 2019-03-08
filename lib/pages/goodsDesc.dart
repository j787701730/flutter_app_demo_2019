import 'package:flutter/material.dart';
import 'package:flutter_app_demo/util/util.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'shopNav.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_html/flutter_html.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:chewie/chewie.dart';
import 'package:chewie/src/chewie_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

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
  bool goodsEvaShow = true;

  _GoodsDesc(this.title, this.goodsID);

  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;

  @override
  initState() {
    super.initState();
    getDesc();
    getShopInfo();
    _initFluwx();
    _videoPlayerController1 =
        VideoPlayerController.network(
          'http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4');
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  _initFluwx() async {
    await fluwx.register(appId: "wxca37bcab7fbd96a4", doOnAndroid: true, doOnIOS: true, enableMTA: false);
    var result = await fluwx.isWeChatInstalled();
    print("is installed $result");
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

  String evaFlag = '0';

  evaChange(val) {
    setState(() {
      evaFlag = val;
    });
  }

  Future<void> initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                fluwx.share(fluwx.WeChatShareTextModel(
                    text: "text from fluwx",
                    transaction: "transaction}", //仅在android上有效，下同。
                    scene: fluwx.WeChatScene.SESSION));
              },
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ))
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Chewie(
              controller: _chewieController,
            ),
          ),
          FlatButton(
            onPressed: () {
              _chewieController.enterFullScreen();
            },
            child: Text('Fullscreen'),
          ),
          Container(
            height: MediaQuery.of(context).size.width,
            child: goodsData.isEmpty
                ? new Placeholder(
                    fallbackWidth: 100.0,
                    fallbackHeight: 100.0,
                    color: Colors.transparent,
                  )
                : Swiper(
                    autoplay: true,
                    itemBuilder: (c, index) {
                      return (goodsData.isEmpty
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
                    itemCount: goodsData.isEmpty ? 1 : goodsData['goods_pics'].length,
                    pagination: new SwiperPagination(),
                    control: new SwiperControl(),
                  ),
          ),
          (goodsData.isEmpty
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
          (goodsData.isEmpty
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
            child: Row(
              children: <Widget>[
                FlatButton(
                  child: Text('商品详情'),
                  onPressed: () {
                    setState(() {
                      goodsEvaShow = true;
                    });
                  },
                ),
                FlatButton(
                  child: Text('商品评价'),
                  onPressed: () {
                    setState(() {
                      goodsEvaShow = false;
                    });
                  },
                )
              ],
            ),
          ),
          Offstage(
            offstage: !goodsEvaShow,
            child: Container(
//            padding: EdgeInsets.all(10),
              child: goodsData.isEmpty
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
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
            ),
          ),
          Offstage(
            offstage: goodsEvaShow,
            child: Wrap(
              children: <Widget>[
                SizedBox(
                    width: 120,
                    child: RadioListTile(
                      value: '0',
                      groupValue: evaFlag,
                      title: Text('全部'),
                      onChanged: evaChange,
                    )),
                SizedBox(
                    width: 120,
                    child: RadioListTile(value: '1', groupValue: evaFlag, title: Text('好评'), onChanged: evaChange)),
                SizedBox(
                    width: 120,
                    child: RadioListTile(value: '2', groupValue: evaFlag, title: Text('中评'), onChanged: evaChange)),
                SizedBox(
                    width: 120,
                    child: RadioListTile(value: '3', groupValue: evaFlag, title: Text('差评'), onChanged: evaChange)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
