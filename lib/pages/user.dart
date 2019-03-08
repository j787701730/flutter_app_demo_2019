import 'package:flutter/material.dart';
import 'package:flutter_app_demo/util/util.dart';
import '../util/menuConfig.dart';

class UserScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _UserScreen();
  }
}

class _UserScreen extends State<UserScreen> with AutomaticKeepAliveClientMixin {
  Map userInfo = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  getUserInfo() {
    ajax('user/info', {}, false, (data) {
      if (!mounted) return;
      setState(() {
        userInfo = data['data'];
      });
    }, () {}, context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(userInfo.isEmpty ? '' : userInfo['full_name']),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Text(
              '个人资料',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          userInfo.isEmpty
              ? Center(
                  child: Container(padding: EdgeInsets.only(bottom: 10, top: 10), child: CircularProgressIndicator()),
                )
              : Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('用户头像：'),
                          Image.network(
                            '$pathName${userInfo['avatar']}',
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[Text('登录账号：'), Text(userInfo['login_name'])],
                      ),
                      Row(
                        children: <Widget>[Text('真实姓名：'), Text(userInfo['full_name'])],
                      ),
                      Row(
                        children: <Widget>[Text('　身份证：'), Text(userInfo['cert_no'])],
                      ),
                      Container(
                        height: 1,
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        color: Colors.black26,
                      ),
                      Row(
                        children: <Widget>[Text('手机号码：'), Text(userInfo['user_phone'])],
                      ),
                      Row(
                        children: <Widget>[Text('用户类型：'), Text(userInfo['user_type'])],
                      ),
                      Row(
                        children: <Widget>[Text('用户状态：'), Text(userInfo['state'])],
                      ),
                      Row(
                        children: <Widget>[Text('　推荐人：'), Text('')],
                      ),
                      Row(
                        children: <Widget>[Text('注册时间：'), Text(userInfo['register_time'])],
                      ),
                    ],
                  ),
                )
        ],
      ),
      drawer: Drawer(
        child: userAsideMenuConfig.isEmpty
            ? Placeholder()
            : ListView(
                children: userAsideMenuConfig.map<Widget>((item) {
                  return ExpansionTile(
                    title: Container(
                      child: Row(
                        children: <Widget>[
                          Icon(IconData(int.parse(item['icon']), fontFamily: 'MaterialIcons')),
                          Text(item['name'])
                        ],
                      ),
                    ),
                    children: item['children'].map<Widget>((child) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: FlatButton(
                                onPressed: () {},
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[Text(child['name'])],
                                )),
                          )
                        ],
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
      ),
    );
  }
}
