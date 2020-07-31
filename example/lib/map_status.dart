import 'package:flutter/material.dart';
import 'package:baidu_map/baidu_map_view.dart';

class MapStatusExample extends StatefulWidget {
  MapStatusExample({Key key, this.title}) : super(key: key);

  final title;
  final mapViewKey = UniqueKey();

  @override
  createState() => _State();
}

class _State extends State<MapStatusExample> {
  static final status1 = MapStatus(
    target: LatLng(39.97837, 116.31363),
    zoom: 19,
    rotation: 45,
    overlook: -45,
  );

  static final status2 = MapStatus(
    target: LatLng(39.90864, 116.39745),
    zoom: 10,
    rotation: 0,
    overlook: 0,
  );

  var _status = status1;

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Stack(
        children: [
          BaiduMapView(
            key: widget.mapViewKey,
            mapStatus: _status,
          ),
          Positioned(
            top: 20,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                RaisedButton(
                  child: Text('Status 1'),
                  onPressed: () {
                    _status = status1;
                    setState(() {});
                  },
                ),
                RaisedButton(
                  child: Text('Status 2'),
                  onPressed: () {
                    _status = status2;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
