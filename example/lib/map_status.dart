import 'package:baidu_map/baidu_map_view.dart';
import 'package:flutter/material.dart';

class MapStatusExample extends StatefulWidget {
  MapStatusExample(this.title, {Key key}) : super(key: key);

  final title;
  final mapViewKey = UniqueKey();

  @override
  createState() => _State();
}

class _State extends State<MapStatusExample> {
  static final status1 = MapStatus(
    center: LatLng(39.97837, 116.31363),
    zoom: 19,
    rotation: 45,
    overlook: -45,
  );

  static final status2 = MapStatus(
    center: LatLng(39.90864, 116.39745),
    zoom: 10,
    rotation: 0,
    overlook: 0,
  );

  var _status = status1;
  var _animated = false;
  BaiduMapViewController _controller;

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Row(children: [
            Text('Animated'),
            Switch(
              value: _animated,
              onChanged: (value) {
                _animated = value;
                setState(() {});
              },
            ),
          ]),
        ],
      ),
      body: Stack(
        children: [
          BaiduMapView(
            key: widget.mapViewKey,
            mapStatus: _status,
            onCreated: (controller) => _controller = controller,
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
                    if (_animated) {
                      _controller.setMapStatus(status1, duration: 4000);
                    } else {
                      _status = status1;
                      setState(() {});
                    }
                  },
                ),
                RaisedButton(
                  child: Text('Status 2'),
                  onPressed: () {
                    if (_animated) {
                      _controller.setMapStatus(status2, duration: 4000);
                    } else {
                      _status = status2;
                      setState(() {});
                    }
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
