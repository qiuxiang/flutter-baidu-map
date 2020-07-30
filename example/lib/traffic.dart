import 'package:flutter/material.dart';

import 'package:baidu_map/baidu_map_view.dart';

class TrafficEnabled extends StatefulWidget {
  TrafficEnabled({Key key}) : super(key: key);

  @override
  createState() => _TrafficEnabledState();
}

class _TrafficEnabledState extends State<TrafficEnabled> {
  var enabled = true;

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('trafficEnabled'),
        actions: <Widget>[
          Switch(
            value: enabled,
            onChanged: (value) {
              enabled = value;
              setState(() {});
            },
          ),
        ],
      ),
      body: BaiduMapView(trafficEnabled: enabled),
    );
  }
}
