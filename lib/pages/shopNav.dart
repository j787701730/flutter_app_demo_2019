import 'package:flutter/material.dart';
import 'package:flutter_app_demo/util/util.dart';
import 'shopIndex.dart';
import 'shopDesc.dart';

class ShopNav extends StatelessWidget {
  final shopInfo;
  final isNotJumpShopIndex;
  final isNotJumpShopDesc;

  ShopNav(this.shopInfo, {this.isNotJumpShopIndex,this.isNotJumpShopDesc});

  @override
  Widget build(BuildContext context) {
    return (shopInfo.length == 0
        ? Placeholder(
            fallbackHeight: 120,
            color: Colors.transparent,
          )
        : Container(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (isNotJumpShopIndex != true) {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                        return new ShopIndex({'shop_id': shopInfo['shop_id'], 'shop_name': shopInfo['shop_name']});
                      }));
                    }
                  },
                  child: Image.network(
                    '$pathName${shopInfo['shop_logo']}',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (isNotJumpShopIndex != true) {
                        Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                          return new ShopIndex({'shop_id': shopInfo['shop_id'], 'shop_name': shopInfo['shop_name']});
                        }));
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            shopInfo['shop_name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[Text('描述'), Text('0.0-')],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[Text('服务'), Text('0.0-')],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[Text('物流'), Text('0.0-')],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  child: Column(
                    children: <Widget>[
                      FlatButton(
                        child: Text('店铺说明'),
                        onPressed: () {
                          if(isNotJumpShopDesc != true){
                            Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                              return new ShopDesc({'shop_id': shopInfo['shop_id'], 'shop_name': shopInfo['shop_name']});
                            }));
                          }
                        },
                      ),
                      FlatButton(
                        color: Colors.red,
                        textColor: Colors.white,
                        onPressed: () {},
                        child: Row(
                          children: <Widget>[Icon(Icons.star_border), Text('收藏')],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ));
  }
}
