import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/user.dart';
import 'pages/shop.dart';
import 'pages/admin.dart';

class BottomNavigationWidget extends StatefulWidget {
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget>
    with AutomaticKeepAliveClientMixin {
  final _BottomNavigationColor = Colors.black54;
  final _activeColor = Colors.blue;
  int _currentIndex = 0;
  List<Widget> list = List();

  @override
  void initState() {
    list
      ..add(HomeScreen())
      ..add(UserScreen())
      ..add(ShopScreen())
      ..add(AdminScreen());
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: list[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: _currentIndex == 0
                      ? _activeColor
                      : _BottomNavigationColor,
                ),
                title: Text('首页',
                    style: TextStyle(
                      color: _currentIndex == 0
                          ? _activeColor
                          : _BottomNavigationColor,
                    ))),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.perm_identity,
                  color: _currentIndex == 1
                      ? _activeColor
                      : _BottomNavigationColor,
                ),
                title: Text('个人中心',
                    style: TextStyle(
                        color: _currentIndex == 1
                            ? _activeColor
                            : _BottomNavigationColor))),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.store_mall_directory,
                  color: _currentIndex == 2
                      ? _activeColor
                      : _BottomNavigationColor,
                ),
                title: Text('商家管理',
                    style: TextStyle(
                        color: _currentIndex == 2
                            ? _activeColor
                            : _BottomNavigationColor))),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.assessment,
                  color: _currentIndex == 3
                      ? _activeColor
                      : _BottomNavigationColor,
                ),
                title: Text('后台管理',
                    style: TextStyle(
                      color: _currentIndex == 3
                          ? _activeColor
                          : _BottomNavigationColor,
                    ))),
          ],
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed),
    );
  }
}
