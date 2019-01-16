import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

//const pathName = 'http://192.168.1.218/';
const pathName = 'https://www.anju.site/';

showADialog(context, msg) {
  showDialog(
      context: context,
      builder: (_) => new AlertDialog(
              title: new Text("提示"),
              content: new Text(msg),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("CANCEL"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]));
}

ajax(String url, Object data, toast, sucFun, failFun, context) async {
  try {
    Response response;
    response = await Dio().post("$pathName$url",
        data: data,
        options: new Options(
//            contentType: ContentType.parse("application/x-www-form-urlencoded"),
//            contentType: ContentType.json,
            headers: {
              'X-Requested-With': 'XMLHttpRequest',
              // 'Content-Type': 'application/x-www-form-urlencoded',
            }));

    if (response.data['err_code'] == 0) {
      if (toast == true) {
        showADialog(context, response.data['err_msg']);
      }
      if (sucFun != null) {
        sucFun(response.data);
      }
    } else if (response.data['err_code'] == 88888) {
      // 登录处理

    } else {
      showADialog(context, response.data['err_code']);
      if (failFun != null) {
        failFun(response.data);
      }
    }
  } catch (e) {
    return print(e);
  }
}
