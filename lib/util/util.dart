import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//const pathName = 'http://192.168.1.218/';
const pathName = 'https://www.anju.site/';

showADialog(context, msg) {
  showDialog(
      context: context,
      builder: (_) => new AlertDialog(title: new Text("提示"), content: new Text(msg), actions: <Widget>[
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
    response = await Dio().post(
      "$pathName$url",
      data: data,
      options: new Options(
//            contentType: ContentType.parse("application/x-www-form-urlencoded"),
//            contentType: ContentType.json,
          headers: {
            'X-Requested-With': 'XMLHttpRequest',
            'Cookie': 'PHPSESSID=eu0oh9qc53a2iuetq17dt008e3'
            // 'Content-Type': 'application/x-www-form-urlencoded',
          }),
    );

    if (response.data['err_code'] == 0) {
      if (toast == true) {
        showADialog(context, response.data['err_msg']);
      }
      if (sucFun != null) {
        sucFun(response.data);
      }
    } else if (response.data['err_code'] == 88888) {
      // 登录处理
      showADialog(context, response.data['err_msg']);
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

/// 只允许输入小数
class ClearNotNum extends TextInputFormatter {
  /// 保留小数位数
  final decimal;

  /// 正负
  final sign;

  ClearNotNum({this.decimal = 2, this.sign = '+'});

  static const defaultDouble = 0.001;

  static double strToFloat(String str, [double defaultValue = defaultDouble]) {
    try {
      return double.parse(str);
    } catch (e) {
      return defaultValue;
    }
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String value = newValue.text;
    int selectionIndex = newValue.selection.end;
    if (sign == '-') {
      if (value == ".") {
        value = "0.";
        selectionIndex++;
      } else if (value == '-') {
        value = "-";
        selectionIndex = value.length;
      } else if (value.startsWith('-.')) {
        value = "-0." + oldValue.text.substring(2, oldValue.text.indexOf('.'));
        selectionIndex = value.length;
      } else if (value != "" &&
          value != defaultDouble.toString() &&
          strToFloat(value, defaultDouble) == defaultDouble) {
        value = oldValue.text;
        selectionIndex = oldValue.selection.end;
      } else if (value.startsWith('0') && value.length > 1 && value.substring(1, 2) == '0') {
        value = double.tryParse(value).toString();
        selectionIndex = value.length;
      } else if (value.contains('.')) {
        if (value.substring(value.indexOf('.') + 1).length > decimal) {
          value = value.substring(0, value.indexOf('.') + decimal + 1);
        }
        selectionIndex = newValue.selection.end;
        if (selectionIndex > value.length) {
          selectionIndex = value.length;
        }
      }

      if (value.startsWith('-') && value.length > 2 && value.substring(1, 2) == '0') {
        if (value.contains('.')) {
          if (double.tryParse(value) != 0) {
            value = double.tryParse(value).toString();
          }
        } else {
          value = int.tryParse(value).toString();
        }
        selectionIndex = value.length;
      }
    } else {
      if (value.startsWith('-')) {
        value = value.substring(1);
        if (value.substring(value.indexOf('.') + 1).length > decimal) {
          value = value.substring(0, value.indexOf('.') + decimal + 1);
        }
        selectionIndex = value.length;
      } else {
        if (value.startsWith(".")) {
          value = "0" + value;
          if (value.substring(value.indexOf('.') + 1).length > decimal) {
            value = value.substring(0, value.indexOf('.') + decimal + 1);
          }
          selectionIndex++;
        } else if (value != "" &&
            value != defaultDouble.toString() &&
            strToFloat(value, defaultDouble) == defaultDouble) {
          value = oldValue.text;
          selectionIndex = oldValue.selection.end;
        } else if (value.contains('.')) {
          if (value.substring(value.indexOf('.') + 1).length > decimal) {
            value = value.substring(0, value.indexOf('.') + decimal + 1);
          }
          selectionIndex = newValue.selection.end;
          if (selectionIndex > value.length) {
            selectionIndex = value.length;
          }
        }
      }
    }
    if (value.startsWith('0') && value.length > 1) {
      if (value.contains('.')) {
        if (double.tryParse(value) != 0) {
          value = double.tryParse(value).toString();
        }
      } else {
        value = int.tryParse(value).toString();
      }
      selectionIndex = value.length;
    }

    return new TextEditingValue(
      text: value,
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
