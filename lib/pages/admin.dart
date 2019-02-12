import 'package:flutter/material.dart';
import 'package:flutter_app_demo/util/util.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../util/menuConfig.dart';

class AdminScreen extends StatefulWidget {
  _AdminScreen createState() => _AdminScreen();
}

class _AdminScreen extends State<AdminScreen> with AutomaticKeepAliveClientMixin{
  Map userOrdersData = {};
  Map trend = {};
  Map orderData = {};
  Map cntData = {};
  var _userMonth;
  var _userNum;
  var _orderMonth;
  var _orderCnt;
  var _goodsMonth;
  var _goodsNum;

  var _pieUserType;
  var _pieUserNum;
  var _pieGoodsName;
  var _pieGoodsNum;
  int offstageIndex = 0;

  Map pieData = {};
  List activeShops = [];
  Map param = {'curr_page': 1, 'page_count': 15};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsersOrders();
    getTrend();
    getPieData();
    getActiveShops();
  }

  @override
  bool get wantKeepAlive => true;

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

  getPieData() {
    ajax('admin.Platform/pieChart', {}, false, (data) {
      setState(() {
        pieData = data['data'];
      });
    }, () {}, context);
  }

  getActiveShops() {
    ajax('admin.platForm/activeShops', activeShops, false, (data) {
      setState(() {
        activeShops = data['data'];
      });
    }, () {}, context);
  }

  List<charts.Series<LinearUser, int>> _userData() {
    List<LinearUser> userData = [
      new LinearUser(0, 5),
    ];
    if (trend.length > 0) {
      userData.clear();
      trend['users'].forEach((k, v) {
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

  List<charts.Series<LinearOrder, int>> _orderData() {
    List<LinearOrder> orderCntData = [
      new LinearOrder(0, 5),
    ];
    List<LinearOrder> orderPriceData = [
      new LinearOrder(0, 5),
    ];
    if (trend.length > 0) {
      orderCntData.clear();
      orderPriceData.clear();
      trend['ord'].forEach((k, v) {
        orderCntData.add(new LinearOrder(int.parse(k), trend['ord'][k]['cnts']));
        orderPriceData.add(new LinearOrder(int.parse(k), trend['ord'][k]['order_price']));
      });
    }

    return [
      new charts.Series<LinearOrder, int>(
        id: 'OrdersCnt',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearOrder orders, _) => orders.month,
        measureFn: (LinearOrder orders, _) => orders.num,
        data: orderCntData,
      ),
      new charts.Series<LinearOrder, int>(
        id: 'OrdersPrice',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearOrder orders, _) => orders.month,
        measureFn: (LinearOrder orders, _) => orders.num,
        data: orderPriceData,
      ),
    ];
  }

  _onSelectionChangedOrder(charts.SelectionModel model) {
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
      _orderMonth = time;
      _orderCnt = measures;
    });
  }

  List<charts.Series<LinearGoods, int>> _goodsData() {
    List<LinearGoods> goodsData = [
      new LinearGoods(0, 5),
    ];
    if (trend.length > 0) {
      goodsData.clear();
      trend['goods'].forEach((k, v) {
        goodsData.add(new LinearGoods(int.parse(k), trend['goods'][k]));
      });
    }

    return [
      new charts.Series<LinearGoods, int>(
        id: 'Goods',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearGoods orders, _) => orders.month,
        measureFn: (LinearGoods orders, _) => orders.num,
        data: goodsData,
      )
    ];
  }

  _onSelectionChangedGoods(charts.SelectionModel model) {
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
      _goodsMonth = time;
      _goodsNum = measures;
    });
  }

// 饼图 PieUser
  List<charts.Series<PieUser, int>> _pieUserData() {
    List<PieUser> goodsData = [
      new PieUser(0, 'x', 5),
    ];
    if (pieData.length > 0) {
      goodsData.clear();
      pieData['user'].forEach((v) {
        goodsData.add(new PieUser(int.parse(v['id']), v['user_type'], v['cnts']));
      });
    }
    return [
      new charts.Series<PieUser, int>(
        id: 'PieUser',
//        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (PieUser orders, _) => orders.id,
        measureFn: (PieUser orders, _) => orders.num,
        data: goodsData,
        labelAccessorFn: (PieUser row, _) => '${row.type}: ${row.num}',
      )
    ];
  }

  _onSelectionChangedPieUser(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    int time;
    String type;
    final measures = <String, num>{};
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.id;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        type = datumPair.datum.type;
        measures[datumPair.series.displayName] = datumPair.datum.num;
      });
    }
    // Request a build.
    setState(() {
      _pieUserType = type;
      _pieUserNum = measures['PieUser'];
    });
  }

  List<charts.Series<PieGoods, int>> _pieGoodsData() {
    List<PieGoods> goodsData = [
      new PieGoods(0, 'x', 5),
    ];
    if (pieData.length > 0) {
      goodsData.clear();
      pieData['goods'].forEach((v) {
        goodsData.add(new PieGoods(v['id'], v['class_name'], v['cnts']));
      });
    }

    return [
      new charts.Series<PieGoods, int>(
        id: 'PieGoods',
//        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (PieGoods orders, _) => orders.id,
        measureFn: (PieGoods orders, _) => orders.num,
        data: goodsData,
        labelAccessorFn: (PieGoods row, _) => '${row.name}: ${row.num}',
      )
    ];
  }

  _onSelectionChangedPieGoods(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    int time;
    String type;
    final measures = <String, num>{};
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.id;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        type = datumPair.datum.name;
        measures[datumPair.series.displayName] = datumPair.datum.num;
      });
    }
    // Request a build.
    setState(() {
      _pieGoodsName = type;
      _pieGoodsNum = measures;
    });
  }

  changeOffstageIndex(index) {
    setState(() {
      offstageIndex = index;
    });
  }

  _tableRow() {
    var arr = [
      TableRow(children: [
        Container(
          child: Text(
            '店铺名称',
            style: TextStyle(fontSize: 14),
          ),
          padding: EdgeInsets.all(4),
        ),
        Container(child: Text('成交金额(元)', style: TextStyle(fontSize: 14)), padding: EdgeInsets.all(4))
      ], decoration: BoxDecoration(color: Color(0xFFEEEEEE))),
    ];
    activeShops.forEach((item) {
      arr.add(TableRow(children: [
        Container(
          child: Text(item['shop_name']),
          padding: EdgeInsets.all(4),
        ),
        Container(
          child: Text('${item['order_price']}'),
          padding: EdgeInsets.all(4),
        )
      ]));
    });
    return arr;
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
            trend.length == 0
                ? Center(
                    child: Container(padding: EdgeInsets.only(bottom: 10, top: 10), child: CircularProgressIndicator()),
                  )
                : Container(
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
                        Container(
                          height: 1,
                          color: Colors.black26,
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
                                        fallbackHeight: 16,
                                        color: Colors.transparent,
                                      )
                                    : Text('$_userMonth月：${_userNum['Sales']}'),
                              ),
                            ],
                          ),
                        ),
                        Offstage(
                          offstage: offstageIndex == 1 ? false : true,
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 300,
                                child: charts.LineChart(
                                  _orderData(),
                                  animate: true,
                                  selectionModels: [
                                    new charts.SelectionModelConfig(
                                        type: charts.SelectionModelType.info, changedListener: _onSelectionChangedOrder)
                                  ],
                                ),
                              ),
                              Container(
                                child: _orderMonth == null
                                    ? Placeholder(
                                        fallbackHeight: 16,
                                        color: Colors.transparent,
                                      )
                                    : Text('$_orderMonth月：${_orderCnt['OrdersCnt']} ￥${_orderCnt['OrdersPrice']}'),
                              ),
                            ],
                          ),
                        ),
                        Offstage(
                          offstage: offstageIndex == 2 ? false : true,
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 300,
                                child: charts.LineChart(
                                  _goodsData(),
                                  animate: true,
                                  selectionModels: [
                                    new charts.SelectionModelConfig(
                                        type: charts.SelectionModelType.info, changedListener: _onSelectionChangedGoods)
                                  ],
                                ),
                              ),
                              Container(
                                child: _goodsMonth == null
                                    ? Placeholder(
                                        fallbackHeight: 16,
                                        color: Colors.transparent,
                                      )
                                    : Text('$_goodsMonth月：${_goodsNum['Goods']}'),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
            // 饼图
            Container(
              child: userOrdersData.length == 0
                  ? Center(
                      child:
                          Container(padding: EdgeInsets.only(bottom: 10, top: 10), child: CircularProgressIndicator()),
                    )
                  : Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '用户分布',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Container(
                            height: 300,
                            child: charts.PieChart(_pieUserData(),
                                animate: false,
                                selectionModels: [
                                  new charts.SelectionModelConfig(
                                      type: charts.SelectionModelType.info, changedListener: _onSelectionChangedPieUser)
                                ],
                                defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
                                  new charts.ArcLabelDecorator(labelPosition: charts.ArcLabelPosition.inside)
                                ])),
                          ),
                          Container(
                            child: _pieUserType == null
                                ? Placeholder(
                                    fallbackHeight: 16,
                                    color: Colors.transparent,
                                  )
                                : Text('$_pieUserType：$_pieUserNum'),
                          ),
                        ],
                      ),
                    ),
            ),
            Container(
              child: userOrdersData.length == 0
                  ? Center(
                      child:
                          Container(padding: EdgeInsets.only(bottom: 10, top: 10), child: CircularProgressIndicator()),
                    )
                  : Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('商品分布', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                          Container(
                            height: 300,
                            child: charts.PieChart(
                              _pieGoodsData(),
                              animate: false,
                              selectionModels: [
                                new charts.SelectionModelConfig(
                                    type: charts.SelectionModelType.info, changedListener: _onSelectionChangedPieGoods)
                              ],
                              defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
                                new charts.ArcLabelDecorator(labelPosition: charts.ArcLabelPosition.inside)
                              ]),
                            ),
                          ),
                          Container(
                            child: _pieGoodsName == null
                                ? Placeholder(
                                    fallbackHeight: 16,
                                    color: Colors.transparent,
                                  )
                                : Text('$_pieGoodsName：${_pieGoodsNum['PieGoods']}'),
                          ),
                        ],
                      ),
                    ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Text('本月最活跃商家', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: activeShops.length == 0
                  ? Center(
                      child:
                          Container(padding: EdgeInsets.only(bottom: 10, top: 10), child: CircularProgressIndicator()),
                    )
                  : Column(
                      children: <Widget>[
                        Table(
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          children: _tableRow(),
                          border: TableBorder.all(color: Colors.black26),
                        )
                      ],
                    ),
            ),
            Container(
              height: 20,
            )
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

class LinearOrder {
  final int month;
  final int num;

  LinearOrder(this.month, this.num);
}

class LinearGoods {
  final int month;
  final int num;

  LinearGoods(this.month, this.num);
}

class PieUser {
  final String type;
  final int num;
  final int id;

  PieUser(this.id, this.type, this.num);
}

class PieGoods {
  final String name;
  final int num;
  final int id;

  PieGoods(this.id, this.name, this.num);
}
