import 'package:flutter/material.dart';
import 'package:flutter_app_demo/util/util.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../util/menuConfig.dart';

class AdminScreen extends StatefulWidget {
  _AdminScreen createState() => _AdminScreen();
}

class _AdminScreen extends State<AdminScreen> //  with AutomaticKeepAliveClientMixin
{
  Map userOrdersData = {};
  Map trend = {};
  Map orderData = {};
  Map cntData = {};
  var _year;
  var _sales;
  var _userMonth;
  var _userNum;
  int offstageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsersOrders();
    getTrend();
//    getOrdersData();
//    getCntsData();
  }

//  @override
//  bool get wantKeepAlive => true;

  getUsersOrders() {
    ajax('admin.Platform/usersOrdsCnt', {}, false, (data) {
      setState(() {
        userOrdersData = data['data'];
      });
    }, () {}, context);
  }

  getTrend() {
    ajax('admin.Platform/trend', {}, false, (data) {
      setState(() {
        trend = data['data'];
      });
    }, () {}, context);
  }

  getOrdersData() {
    ajax('shops/ordsData', {}, false, (data) {
      setState(() {
        orderData = data['ords'];
      });
    }, () {}, context);
  }

  getCntsData() {
    ajax('shops/cntsData', {}, false, (data) {
      setState(() {
        cntData = data['cnts'];
      });
    }, () {}, context);
  }

  static List<charts.Series<LinearSales, int>> _data() {
    final data = [
      new LinearSales(0, 5),
      new LinearSales(1, 25),
      new LinearSales(2, 100),
      new LinearSales(3, 75),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  List<charts.Series<LinearUser, int>> _userData() {
    List<LinearUser> userData = [
      new LinearUser(0, 5),
    ];
    if (trend.length > 0) {
      userData.clear();
      trend['users'].forEach((k, v) {
//        print(k);
        userData.add(new LinearUser(int.parse(k), trend['users'][k]));
      });
    }

    return [
      new charts.Series<LinearUser, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearUser sales, _) => sales.month,
        measureFn: (LinearUser sales, _) => sales.num,
        data: userData,
      )
    ];
  }

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    int time;
    final measures = <String, num>{};
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.year;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.sales;
      });
    }
    // Request a build.
    setState(() {
      _year = time;
      _sales = measures;
    });
  }

  _onSelectionChangedUser(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    int time;
    final measures = <String, num>{};
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.month;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.num;
      });
    }
    // Request a build.
    setState(() {
      _userMonth = time;
      _userNum = measures;
    });
  }

  changeOffstageIndex(index) {
    setState(() {
      offstageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('后台管理'),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            userOrdersData.length == 0
                ? Center(
                    child: Container(padding: EdgeInsets.only(bottom: 10, top: 10), child: CircularProgressIndicator()),
                  )
                : Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('今日新增用户数'),
                        Text(
                          '${userOrdersData['regCnts']['today']}',
                          style: TextStyle(fontSize: 30),
                        ),
                        Text('较前日 ' +
                            (userOrdersData['regCnts']['today'] - userOrdersData['regCnts']['yesterday']).toString() +
                            ' 近7日 ' +
                            (userOrdersData['regCnts']['total']).toString()),
                        Container(
                          height: 10,
                        ),
                        Text('昨日新增用户数'),
                        Text(
                          '${userOrdersData['regCnts']['yesterday']}',
                          style: TextStyle(fontSize: 30),
                        ),
                        Text('较前日 ' +
                            (userOrdersData['regCnts']['yesterday'] - userOrdersData['regCnts']['dayBeforYes'])
                                .toString() +
                            ' 近7日 ' +
                            (userOrdersData['regCnts']['total']).toString()),
                        Container(
                          height: 10,
                        ),
                        Text('今日订单总数及金额'),
                        Text(
                          '${userOrdersData['ordCnts']['today']['nums']}  ￥${userOrdersData['ordCnts']['today']['order_price']}',
                          style: TextStyle(fontSize: 30),
                        ),
                        Text('较前日 ' +
                            (userOrdersData['ordCnts']['today']['nums'] -
                                    userOrdersData['ordCnts']['yesterday']['nums'])
                                .toString() +
                            ' ￥' +
                            (userOrdersData['ordCnts']['today']['order_price'] -
                                    userOrdersData['ordCnts']['yesterday']['order_price'])
                                .toString() +
                            ' 近7日 ' +
                            (userOrdersData['ordCnts']['total']['nums']).toString() +
                            ' ￥' +
                            (userOrdersData['ordCnts']['today']['order_price'] -
                                    userOrdersData['ordCnts']['total']['order_price'])
                                .toString()),
                        Container(
                          height: 10,
                        ),
                        Text('昨日订单总数及金额'),
                        Text(
                            '${userOrdersData['ordCnts']['yesterday']['nums']}  ￥${userOrdersData['ordCnts']['yesterday']['order_price']}',
                            style: TextStyle(fontSize: 30)),
                        Text('较前日 ' +
                            (userOrdersData['ordCnts']['yesterday']['nums'] -
                                    userOrdersData['ordCnts']['dayBeforYes']['nums'])
                                .toString() +
                            ' ￥' +
                            (userOrdersData['ordCnts']['yesterday']['order_price'] -
                                    userOrdersData['ordCnts']['dayBeforYes']['order_price'])
                                .toString() +
                            ' 近7日 ' +
                            (userOrdersData['ordCnts']['total']['nums']).toString() +
                            ' ￥' +
                            (userOrdersData['ordCnts']['total']['order_price']).toString()),
                      ],
                    ),
                  ),
            // 趋势
            Container(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      FlatButton(
                          onPressed: () {
                            changeOffstageIndex(0);
                          },
                          child: Text(
                            '用户趋势',
                            style: TextStyle(color: offstageIndex == 0 ? Colors.red : Colors.black),
                          )),
                      FlatButton(
                          onPressed: () {
                            changeOffstageIndex(1);
                          },
                          child: Text(
                            '订单趋势',
                            style: TextStyle(color: offstageIndex == 1 ? Colors.red : Colors.black),
                          )),
                      FlatButton(
                          onPressed: () {
                            changeOffstageIndex(2);
                          },
                          child: Text(
                            '商品趋势',
                            style: TextStyle(color: offstageIndex == 2 ? Colors.red : Colors.black),
                          )),
                    ],
                  ),
                  Offstage(
                    offstage: offstageIndex == 0 ? false : true,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 300,
                          child: charts.LineChart(
                            _userData(),
                            animate: true,
                            selectionModels: [
                              new charts.SelectionModelConfig(
                                type: charts.SelectionModelType.info, changedListener: _onSelectionChangedUser)
                            ],
                          ),
                        ),
                        Container(
                          child: _userMonth == null
                            ? Placeholder(
                            fallbackHeight: 14,
                            color: Colors.transparent,
                          )
                            : Text('$_userMonth月：${_userNum['Sales']}'),
                        ),
                      ],
                    ),
                  ),
                  Offstage(
                    offstage: offstageIndex == 1 ? false : true,
                    child: Container(
                      height: 300,
                      child: Text('订单'),
                    ),
                  ),
                  Offstage(
                    offstage: offstageIndex == 2 ? false : true,
                    child: Container(
                      height: 300,
                      child: Text('商品'),
                    ),
                  )
                ],
              ),
            ),

//          订单
            orderData.length == 0
                ? Center(
                    child: Container(padding: EdgeInsets.only(bottom: 10, top: 10), child: CircularProgressIndicator()),
                  )
                : Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              Text('店铺订单趋势分析'),
                              Container(
                                height: 300,
                                child: charts.LineChart(
                                  _data(),
                                  animate: true,
                                  selectionModels: [
                                    new charts.SelectionModelConfig(
                                        type: charts.SelectionModelType.info, changedListener: _onSelectionChanged)
                                  ],
                                ),
                              ),
                              Container(
                                child: _year == null
                                    ? Placeholder(
                                        fallbackHeight: 14,
                                        color: Colors.transparent,
                                      )
                                    : Text('$_year月：${_sales['Sales']}'),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Wrap(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width / 2 - 10,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                                color: Color(0xFFEFF6FF)),
                                            child: Icon(
                                              Icons.sentiment_satisfied,
                                              size: 40,
                                              color: Color(0xFF66AAFF),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  '昨日订单',
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  '${orderData['yesterdayCnts']}',
                                                  style: TextStyle(fontSize: 30),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width / 2 - 10,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                                color: Color(0xFFEFF6FF)),
                                            child: Icon(
                                              Icons.sentiment_dissatisfied,
                                              size: 40,
                                              color: Color(0xFF66AAFF),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  '今日订单',
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  '${orderData['todayCnts']}',
                                                  style: TextStyle(fontSize: 30),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width / 2 - 10,
                                      padding: EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                                color: Color(0xFFEFF6FF)),
                                            child: Icon(
                                              Icons.score,
                                              size: 40,
                                              color: Color(0xFF66AAFF),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  '上周订单',
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  '${orderData['lastWeekCnts']}',
                                                  style: TextStyle(fontSize: 30),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width / 2 - 10,
                                      padding: EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                                color: Color(0xFFEFF6FF)),
                                            child: Icon(
                                              Icons.score,
                                              size: 40,
                                              color: Color(0xFF66AAFF),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  '本周订单',
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  '${orderData['weekCnts']}',
                                                  style: TextStyle(fontSize: 30),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width / 2 - 10,
                                      padding: EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                                color: Color(0xFFEFF6FF)),
                                            child: Icon(
                                              Icons.score,
                                              size: 40,
                                              color: Color(0xFF66AAFF),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  '上月订单',
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  '${orderData['lastMonthCnts']}',
                                                  style: TextStyle(fontSize: 30),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width / 2 - 10,
                                      padding: EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                                color: Color(0xFFEFF6FF)),
                                            child: Icon(
                                              Icons.score,
                                              size: 40,
                                              color: Color(0xFF66AAFF),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  '本月订单',
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  '${orderData['monthCnts']}',
                                                  style: TextStyle(fontSize: 30),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 1,
                                      color: Colors.black26,
                                      margin: EdgeInsets.only(top: 10, bottom: 10),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
            // 统计
            cntData.length == 0
                ? Center(
                    child: Container(padding: EdgeInsets.only(bottom: 10, top: 10), child: CircularProgressIndicator()),
                  )
                : Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(6),
                              ),
                              color: Color(0xFF31B48D)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '商品统计',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text('24H', style: TextStyle(color: Colors.white))
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  '${cntData['goodsCnts']['cnts'] == null ? 0 : cntData['goodsCnts']['cnts']}',
                                  style: TextStyle(color: Colors.white, fontSize: 30),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 6),
                                child: Text(
                                  '上架-${cntData['goodsCnts']['1'] == null ? 0 : cntData['goodsCnts']['1']} 下架-${cntData['goodsCnts']['0'] == null ? 0 : cntData['goodsCnts']['0']}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Container(
                                child: Text(
                                  '请注意及时上架商品',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(top: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(6),
                              ),
                              color: Color(0xFF38A1F2)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '订单统计',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text('24H', style: TextStyle(color: Colors.white))
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  '${cntData['orderCnts']['cnts'] == null ? 0 : cntData['orderCnts']['cnts']}',
                                  style: TextStyle(color: Colors.white, fontSize: 30),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 6),
                                child: Text(
                                  '总金额 ￥${cntData['orderCnts']['order_price'] == null ? 0 : cntData['orderCnts']['order_price']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  '请及时核对订单信息',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(top: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(6),
                              ),
                              color: Color(0xFF7538C7)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '金融申请',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text('实时', style: TextStyle(color: Colors.white))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(
                                      top: 10,
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          '${cntData['financial'] == null ? "无" : cntData['financial']['financial_party']}',
                                          style: TextStyle(color: Colors.white, fontSize: 30),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top: 10, bottom: 10),
                                          child: Text(
                                            '申请状态',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            '${cntData['financial'] == null ? "无" : cntData['financial']['audit_state'] == 1 ? "通过" : "不通过"}',
                                            style: TextStyle(color: Colors.white, fontSize: 30),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Text(
                                              '审核状态',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(top: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(6),
                              ),
                              color: Color(0xFF3B67A4)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '文章统计',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text('24H', style: TextStyle(color: Colors.white))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(
                                      top: 10,
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          '${cntData['articleCnts'] == null ? 0 : cntData['articleCnts']['cnts']}',
                                          style: TextStyle(color: Colors.white, fontSize: 30),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top: 10, bottom: 10),
                                          child: Text(
                                            '文章总量',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            '${cntData['articleCnts'] == null ? 0 : cntData['articleCnts']['cnts']}',
                                            style: TextStyle(color: Colors.white, fontSize: 30),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Text(
                                              '评论总量',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
//                Container(
//                  height: 1,
//                  color: Colors.black26,
//                  margin: EdgeInsets.all(10),
//                )
                      ],
                    ),
                  ),
          ],
        ),
      ),
      drawer: Drawer(
        child: adminAsideMenuConfig.length == 0
            ? Placeholder()
            : ListView(
                children: adminAsideMenuConfig.map<Widget>((item) {
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

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

class LinearUser {
  final int month;
  final int num;

  LinearUser(this.month, this.num);
}
