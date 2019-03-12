import 'package:flutter/material.dart';
import 'package:flutter_app_demo/util/util.dart';
import 'package:flutter_app_demo/bottom_navigation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _Login();
  }
}

class _Login extends State<Login> {
  bool isNotShowPwd = true;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String userName;
  String pwd;

  saveData(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userInfo', jsonEncode(data["userInfo"]));
    print(prefs.getString('userInfo'));
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('userInfo'));
  }

  void _onSubmit(con) {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      ajax('user/login', {'autoLogin': true, 'lockAccount': false, 'password': pwd, 'username': userName}, false,
          (data) {
        saveData(data);
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context) => new BottomNavigationWidget()), (route) => route == null);
      }, () {}, con);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 100, left: 30, right: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
//                      controller: _username,
                      initialValue: 'yangxb',
                      onSaved: (val) => userName = val,
                      validator: (val) => (val == null || val.isEmpty) ? "请输入账号/手机号" : null,
                      maxLength: 20,
                      decoration: InputDecoration(icon: Icon(Icons.person), hintText: '账号/手机号'),
                    ),
                    TextFormField(
                      validator: (val) => (val == null || val.isEmpty) ? "请输入密码" : null,
                      onFieldSubmitted: (v) => print("submit"),
                      onSaved: (val) => pwd = val,
//                      controller: _pwd,
                      initialValue: '123456',
                      obscureText: isNotShowPwd,
                      decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          hintText: '密码',
                          suffixIcon: GestureDetector(
                            onLongPress: () {
                              setState(() {
                                isNotShowPwd = false;
                              });
                            },
                            onLongPressUp: () {
                              setState(() {
                                isNotShowPwd = true;
                              });
                            },
                            child: Icon(Icons.remove_red_eye),
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              onPressed: () {
                                _onSubmit(context);
                              },
                              color: Colors.blue,
                              child: Text(
                                '登录',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                            child: Text('立即注册'),
                            onPressed: () {},
                          ),
                          FlatButton(
                            child: Text('忘记密码'),
                            onPressed: () {},
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
