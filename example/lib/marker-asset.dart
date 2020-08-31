import 'package:baidu_map/baidu_map.dart';
import 'package:flutter/material.dart';

class MarkerAssetExample extends StatefulWidget {
  MarkerAssetExample(this.title, {Key key}) : super(key: key);

  final title;
  final mapViewKey = UniqueKey();

  @override
  createState() => _State();
}

class _State extends State<MarkerAssetExample> {
  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: BaiduMap(
        key: widget.mapViewKey,
        onCreated: (controller) {
          controller.addMarker(MarkerOptions(
            position: LatLng(39.9169, 116.3793),
            asset: 'images/marker.png',
          ));
        },
      ),
    );
  }
}
