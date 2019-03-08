import 'package:flutter/material.dart';
import 'package:flutter_app_demo/util/util.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../util/menuConfig.dart';

class ShopScreen extends StatefulWidget {
  _SearchBarDemoState createState() => _SearchBarDemoState();
}

class _SearchBarDemoState extends State<ShopScreen> with AutomaticKeepAliveClientMixin {
  Map scoreData = {};
  Map orderData = {};
  Map cntData = {};
  var _year;
  var _sales;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getScoreData();
    getOrdersData();
    getCntsData();
  }

  @override
  bool get wantKeepAlive => true;

  getScoreData() {
    ajax('shops/scoreData', {}, false, (data) {
      if (!mounted) return;
      setState(() {
        scoreData = data['score'];
      });
    }, () {}, context);
  }

  getOrdersData() {
    ajax('shops/ordsData', {}, false, (data) {
      if (!mounted) return;
      setState(() {
        orderData = data['ords'];
      });
    }, () {}, context);
  }

  getCntsData() {
    ajax('shops/cntsData', {}, false, (data) {
      if (!mounted) return;
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
    if (!mounted) return;
    setState(() {
      _year = time;
      _sales = measures;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('商家管理'),
      ),
      body: SafeArea(
          child: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              '店铺数据概况 - 每24小时更新一次',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          scoreData.isEmpty
              ? Center(
                  child: Container(padding: EdgeInsets.only(bottom: 10, top: 10), child: CircularProgressIndicator()),
                )
              : Container(
                  padding: EdgeInsets.all(10),
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
                                  borderRadius: BorderRadius.all(Radius.circular(100)), color: Color(0xFFEFF6FF)),
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
                                    '好评量',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${scoreData['evaluate_nums3']}',
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
                                  borderRadius: BorderRadius.all(Radius.circular(100)), color: Color(0xFFEFF6FF)),
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
                                    '差评量',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${scoreData['evaluate_nums1']}',
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
                                  borderRadius: BorderRadius.all(Radius.circular(100)), color: Color(0xFFEFF6FF)),
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
                                    '评分',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${scoreData['score']}',
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
                                  borderRadius: BorderRadius.all(Radius.circular(100)), color: Color(0xFFEFF6FF)),
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
                                    '评分',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${scoreData['score_percent']}',
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
//          订单
          orderData.isEmpty
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
          cntData.isEmpty
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
      ),),
      drawer: Drawer(
        child: sellerAsideMenuConfig.isEmpty
          ? Placeholder()
          : ListView(
          children: sellerAsideMenuConfig.map<Widget>((item) {
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
