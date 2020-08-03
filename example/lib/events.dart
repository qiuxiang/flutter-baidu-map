import 'package:baidu_map/baidu_map_view.dart';
import 'package:flutter/material.dart';

class EventsExample extends StatefulWidget {
  EventsExample(this.title, {Key key}) : super(key: key);

  final title;
  final mapViewKey = UniqueKey();

  @override
  createState() => _State();
}

class _State extends State<EventsExample> {
  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: BaiduMapView(
        key: widget.mapViewKey,
        onTap: (latLng) {
          print(latLng.toMap());
        },
        onTapPoi: (poi) {
          print({'position': poi.position.toMap(), 'name': poi.name, 'id': poi.id});
        },
        onStatusChanged: (status) {
          print(status.toMap());
        },
      ),
    );
  }
}
