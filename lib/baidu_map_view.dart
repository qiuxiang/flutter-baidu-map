import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaiduMapView extends StatefulWidget {
  const BaiduMapView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BaiduMapViewState();
}

class _BaiduMapViewState extends State<BaiduMapView> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'BaiduMapView',
      );
    }
    return Text('$defaultTargetPlatform is not yet supported');
  }
}
