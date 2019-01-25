import 'package:flutter/material.dart';
import 'package:amap_base/amap_base.dart';

class AdminScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _AdminScreen();
  }
}

class _AdminScreen extends State<AdminScreen> {
  AMapController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('admin'),
      ),
      body: Container(
//          child: Text('admin'),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(10),
        child: AMapView(
          onAMapViewCreated: (controller) {
            setState(() => _controller = controller);
          },
          amapOptions: AMapOptions(
            mapType: 1,
            compassEnabled: false,
            zoomControlsEnabled: true,
            logoPosition: LOGO_POSITION_BOTTOM_CENTER,
            camera: CameraPosition(
              target: LatLng(26.113263, 119.26472),
              zoom: 13,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.map),
        onPressed: () async {
          await _controller?.setCustomMapStylePath('amap_assets/style.data');
          await _controller?.setMapCustomEnable(true);
        },
      ),
    );
  }
}
