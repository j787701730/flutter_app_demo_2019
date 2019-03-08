import 'package:flutter/material.dart';
import 'package:flutter_app_demo/util/util.dart';
import '../util/menuConfig.dart';

import 'dart:async';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class UserScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _UserScreen();
  }
}

class _UserScreen extends State<UserScreen> with AutomaticKeepAliveClientMixin {
  Map userInfo = {};
  Map userInfoModify = {};

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
      userInfoModify = data['data'];
      setState(() {
        userInfo = data['data'];
      });
    }, () {}, context);
  }

  loginName(val) {
    userInfoModify['login_name'] = val;
  }

  fullName(val) {
    userInfoModify['full_name'] = val;
  }

  certNo(val) {
    userInfoModify['cert_no'] = val;
  }

  commitUserInfo() {
    print(userInfoModify);
  }

  var _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    var image2 = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
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
                          FloatingActionButton(
                            onPressed: getImage,
                            tooltip: 'Pick Image',
                            child: Icon(Icons.add_a_photo),
                          )
                        ],
                      ),
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
                      Container(
                        child: TextField(
                          controller: TextEditingController.fromValue(TextEditingValue(
                              // 设置内容
                              text: userInfo['login_name'],
                              // 保持光标在最后
                              selection: TextSelection.fromPosition(TextPosition(
                                  affinity: TextAffinity.downstream, offset: userInfo['login_name'].length)))),
                          decoration: InputDecoration(hintText: '登录账号', prefixText: '登录账号：'),
                          onChanged: loginName,
                          maxLines: 1,
                          maxLength: 20,
                        ),
                      ),
                      Container(
                        child: TextField(
                          controller: TextEditingController.fromValue(TextEditingValue(
                              // 设置内容
                              text: userInfo['full_name'],
                              // 保持光标在最后
                              selection: TextSelection.fromPosition(TextPosition(
                                  affinity: TextAffinity.downstream, offset: userInfo['full_name'].length)))),
                          decoration: InputDecoration(hintText: '真实姓名', prefixText: '真实姓名：'),
                          onChanged: fullName,
                          maxLines: 1,
                          maxLength: 20,
                        ),
                      ),
                      Container(
                        child: TextField(
                          controller: TextEditingController.fromValue(TextEditingValue(
                              // 设置内容
                              text: userInfo['cert_no'],
                              // 保持光标在最后
                              selection: TextSelection.fromPosition(TextPosition(
                                  affinity: TextAffinity.downstream, offset: userInfo['cert_no'].length)))),
                          decoration: InputDecoration(hintText: '身份证', prefixText: '　身份证：'),
                          onChanged: certNo,
                          keyboardType: TextInputType.phone,
                          maxLines: 1,
                          maxLength: 18,
                          inputFormatters: <TextInputFormatter>[
//                            WhitelistingTextInputFormatter.digitsOnly, // 整数
//                            BlacklistingTextInputFormatter.singleLineFormatter // 单行
                            ClearNotNum(2)
                          ],
                        ),
                      ),
                      Container(
                        child: RaisedButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          onPressed: commitUserInfo,
                          child: Text('保存'),
                        ),
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
                        children: <Widget>[Text('　推荐人：'), Text(userInfo['invite_user'])],
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
