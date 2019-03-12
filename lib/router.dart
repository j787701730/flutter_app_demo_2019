import 'package:fluro/fluro.dart';
import 'package:flutter_app_demo/bottom_navigation_widget.dart';
import 'pages/goodsClass.dart';
import 'pages/goodsDesc.dart';
import 'pages/goodsSearch.dart';
import 'pages/shopIndex.dart';
import 'pages/shopDesc.dart';

class Routes {
  static Router router;
  static String home = '/';
  static String goodsClass = '/goodsClass';
  static String goodsDesc = '/goodsDesc';
  static String goodsSearch = '/goodsSearch';
  static String shopIndex = '/shopIndex';
  static String shopDesc = '/shopDesc';

  static void configureRoutes(Router router) {
    router.define(home, handler: Handler(handlerFunc: (context, params) => BottomNavigationWidget()));
    router.define(goodsClass, handler: Handler(handlerFunc: (context, params) => GoodsClass()));
    router.define(goodsSearch, handler: Handler(handlerFunc: (context, params) {
      var data = params['data']?.first; //取出传参
      return GoodsSearch(data);
    }));
    router.define(goodsDesc, handler: Handler(handlerFunc: (context, params) {
      var data = params['data']?.first; //取出传参
      return GoodsDesc(data);
    }));
    router.define(shopIndex, handler: Handler(handlerFunc: (context, params) {
      var data = params['data']?.first; //取出传参
      return ShopIndex(data);
    }));
    router.define(shopDesc, handler: Handler(handlerFunc: (context, params) {
      var data = params['data']?.first; //取出传参
      return ShopDesc(data);
    }));
    Routes.router = router;
  }
}
