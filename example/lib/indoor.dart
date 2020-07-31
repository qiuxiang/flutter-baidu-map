import 'package:flutter/material.dart';
import 'package:baidu_map/baidu_map_view.dart';

import 'example.dart';

class IndoorEnabled extends Example {
  IndoorEnabled({Key key, this.title}) : super(key: key);

  final title;

  @override
  createState() => _State();
}

class _State extends SwitchExampleState {
  @override
  buildMapView() =>
      BaiduMapView(key: widget.mapViewKey, indoorEnabled: enabled);
}
