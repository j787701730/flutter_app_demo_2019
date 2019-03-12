import 'package:flutter/material.dart';
import 'package:flutter_app_demo/util/util.dart';
import 'shopNav.dart';

//import 'package:amap_base_map/amap_base_map.dart';
import 'dart:convert';
import '../util/pageLoading.dart';

class ShopDesc extends StatefulWidget {
  final data;

  ShopDesc(this.data);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _ShopDesc(data);
  }
}

class _ShopDesc extends State<ShopDesc> {
  final shopInfo;

//  AMapController _controller;

  _ShopDesc(this.shopInfo);

  List hotSale = [];

  var shopData={};

  bool isPerformingRequest = true;

  @override
  initState() {
    super.initState();
    print(shopInfo);
    getShopInfo();
  }

  @override
  void dispose() {
//    _controller.dispose();
    super.dispose();
  }

  getShopInfo() {
    setState(() {
      isPerformingRequest = true;
    });
    ajax(
        'shops/info',
        {
          'shop_id': jsonDecode(shopInfo)['shop_id'],
//          'getExt': ["hot_sale", "shop"]
        },
        false, (data) {
          print(data);
      setState(() {
        hotSale = data['hot_sale'];
        shopData = data['shop'];
        isPerformingRequest = false;
      });
    }, () {}, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(shopData.isEmpty? '': shopData['shop_name']),
      ),
      body:
      shopData.isEmpty ? PageLoading():
      ListView(
        children: <Widget>[
          ShopNav(shopData, isNotJumpShopDesc: true),
          Container(
            height: 1,
            decoration: BoxDecoration(color: Colors.black26),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: shopData['shop_pics'].keys.map<Widget>((item) {
                return Image.network("$pathName${shopData['shop_pics'][item]['file_path']}");
              }).toList(),
            ),
          ),
          Container(
            height: 1,
            color: Colors.black26,
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '工作时间',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  padding: EdgeInsets.only(left: 16, top: 6),
                  child: Column(
                    children: <Widget>[
                      Text(
                        '周一至周五 9:00 - 20:00',
                        style: TextStyle(color: Colors.black26),
                      ),
                      Text(
                        '周一至周五 9:00 - 20:00',
                        style: TextStyle(color: Colors.black26),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 1,
            margin: EdgeInsets.only(top: 10, bottom: 10),
            color: Colors.black26,
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Wrap(
              children: <Widget>[
                Text('地址：'),
                Text(shopData['shop_address'], style: TextStyle(color: Colors.black26)),
                Icon(
                  Icons.location_on,
                  color: Colors.black26,
                  size: 14,
                )
              ],
            ),
          )
//          Container(
//            padding: EdgeInsets.only(top: 10, left: 10),
//            child: GestureDetector(
//              onTap: () {
//
//                  _controller.addMarker(
//                      MarkerOptions(position: LatLng(double.parse(shopInfo['lat']), double.parse(shopInfo['lng']))));
//
//              },
//              child: Wrap(
//                children: <Widget>[
//                  Text(
//                    '地址：${shopInfo['shop_address']}',
//                    style: TextStyle(color: Colors.black26),
//                  ),
//                  Icon(
//                    Icons.location_on,
//                    color: Colors.black26,
//                    size: 14,
//                  )
//                ],
//              ),
//            ),
//          ),
//          Container(
//            height: MediaQuery.of(context).size.height - 250,
//            padding: EdgeInsets.only(top: 10),
//            child:
//            AMapView(
//              onAMapViewCreated: (controller) {
//                _controller = controller;
//                controller.addMarker(MarkerOptions(
//                  position: LatLng(double.parse(shopInfo['lat']), double.parse(shopInfo['lng'])),
//                ));
//              },
//              amapOptions: AMapOptions(
//                zoomControlsEnabled: true,
//                logoPosition: LOGO_POSITION_BOTTOM_LEFT,
//                camera: CameraPosition(
////                  target: LatLng(double.parse(shopInfo['lat']), double.parse(shopInfo['lng'])),
//                  zoom: 17,
//                ),
//              ),
//            ),
//          ),
        ],
      ),
    );
  }
}
