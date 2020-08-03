import 'package:baidu_map/baidu_map_view.dart';
import 'package:flutter/material.dart';

class MarkerExample extends StatefulWidget {
  MarkerExample(this.title, {Key key}) : super(key: key);

  final title;
  final mapViewKey = UniqueKey();

  @override
  createState() => _State();
}

class _State extends State<MarkerExample> {
  BaiduMapViewController _controller;

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: BaiduMapView(
        key: widget.mapViewKey,
        onCreated: (controller) {
          _controller = controller;
        },
        onTap: (position) {
          _controller.addMarker(MarkerOptions(
            position: position,
            icon: "images/marker.png",
          ));
        },
        onTapMarker: (marker) {
          marker.remove();
        },
      ),
    );
  }
}
