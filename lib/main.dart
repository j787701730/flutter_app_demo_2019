import 'package:flutter/material.dart';
//import 'package:flutter_app_demo/bottom_navigation_widget.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_app_demo/router.dart';

void main() {
  final router = new Router();
  Routes.configureRoutes(router);
  runApp(MaterialApp(onGenerateRoute: Routes.router.generator));
}

//void main() => runApp(new MyApp());
//
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      title: 'Welcome to Flutter',
//      debugShowCheckedModeBanner: false,
//      theme: ThemeData(platform: TargetPlatform.iOS),
//      home: BottomNavigationWidget(),
//    );
//  }
//}
