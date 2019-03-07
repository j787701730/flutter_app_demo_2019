import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/user.dart';
import 'pages/shop.dart';
import 'pages/admin.dart';

class BottomNavigationWidget extends StatefulWidget {
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final _BottomNavigationColor = Colors.black54;
  final _activeColor = Colors.blue;
  int _currentIndex = 0;

  List<Widget> list = List();
  TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
//    list..add(HomeScreen())..add(UserScreen())..add(ShopScreen())..add(AdminScreen());
    _tabController = TabController(
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

//  @override
//  bool get wantKeepAlive => true;
  DateTime _lastPressedAt;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
        child: Scaffold(
            body: new TabBarView(
                controller: _tabController,
                children: <Widget>[HomeScreen(), UserScreen(), ShopScreen(), AdminScreen()]),
            bottomNavigationBar: Material(
              child: SafeArea(
                  child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: const Color(0xFFd0d0d0),
                      blurRadius: 1.0,
                      spreadRadius: 1.0,
//                  offset: Offset(-1.0, -1.0),
                    ),
                  ],
                ),
                height: 48,
                child: TabBar(
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.black26,
                  indicatorColor: Colors.transparent,
                  labelStyle: TextStyle(fontSize: 12),
                  // 下划线颜色
//              indicatorWeight: 3.0,
                  tabs: <Tab>[
//                Tab(text: '首页', icon: Icon(Icons.home)),
//                Tab(text: '个人中心', icon: Icon(Icons.person)),
//                Tab(text: '商家管理', icon: Icon(Icons.store_mall_directory)),
//                Tab(text: '后台管理', icon: Icon(Icons.assessment)),
                    Tab(
                        child: Container(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[Icon(Icons.home), Text('　首页　')],
                      ),
                    )),
                    Tab(
                      child: Container(
                          width: MediaQuery.of(context).size.width / 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[Icon(Icons.person), Text('个人中心')],
                          )),
                    ),
                    Tab(
                      child: Container(
                          width: MediaQuery.of(context).size.width / 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[Icon(Icons.store_mall_directory), Text('商家管理')],
                          )),
                    ),
                    Tab(
                        child: Container(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[Icon(Icons.assessment), Text('后台管理')],
                      ),
                    )),
                  ],
                  controller: _tabController,
                ),
              )),
            )
//      BottomNavigationBar(
//          items: [
//            BottomNavigationBarItem(
//                icon: Icon(
//                  Icons.home,
//                  color: _currentIndex == 0
//                      ? _activeColor
//                      : _BottomNavigationColor,
//                ),
//                title: Text('首页',
//                    style: TextStyle(
//                      color: _currentIndex == 0
//                          ? _activeColor
//                          : _BottomNavigationColor,
//                    ))),
//            BottomNavigationBarItem(
//                icon: Icon(
//                  Icons.perm_identity,
//                  color: _currentIndex == 1
//                      ? _activeColor
//                      : _BottomNavigationColor,
//                ),
//                title: Text('个人中心',
//                    style: TextStyle(
//                        color: _currentIndex == 1
//                            ? _activeColor
//                            : _BottomNavigationColor))),
//            BottomNavigationBarItem(
//                icon: Icon(
//                  Icons.store_mall_directory,
//                  color: _currentIndex == 2
//                      ? _activeColor
//                      : _BottomNavigationColor,
//                ),
//                title: Text('商家管理',
//                    style: TextStyle(
//                        color: _currentIndex == 2
//                            ? _activeColor
//                            : _BottomNavigationColor))),
//            BottomNavigationBarItem(
//                icon: Icon(
//                  Icons.assessment,
//                  color: _currentIndex == 3
//                      ? _activeColor
//                      : _BottomNavigationColor,
//                ),
//                title: Text('后台管理',
//                    style: TextStyle(
//                      color: _currentIndex == 3
//                          ? _activeColor
//                          : _BottomNavigationColor,
//                    ))),
//          ],
//          currentIndex: _currentIndex,
//          onTap: (int index) {
//            setState(() {
//              _currentIndex = index;
//            });
//          },
//          type: BottomNavigationBarType.fixed),
            ),
        onWillPop: () async {
          if (_lastPressedAt == null || DateTime.now().difference(_lastPressedAt) > Duration(seconds: 1)) {
            //两次点击间隔超过1秒则重新计时
            _lastPressedAt = DateTime.now();
            return false;
          }
          return true;
        });
  }
}
