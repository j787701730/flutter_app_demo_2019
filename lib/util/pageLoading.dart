import 'package:flutter/material.dart';

/// 页面loading
class PageLoading extends StatelessWidget {
  final color; // 圈圈动画颜色

  PageLoading({this.color: Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.2)),
      child: Center(
        child: SizedBox(
            width: 50,
            height: 50,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(8))),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(color),
              ),
            )),
      ),
    );
  }
}
