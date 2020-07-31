import 'package:flutter/material.dart';
import 'package:baidu_map/baidu_map_view.dart';

class MapTypeExample extends StatefulWidget {
  MapTypeExample({Key key, this.title}) : super(key: key);

  final title;
  final mapViewKey = UniqueKey();

  @override
  createState() => _State();
}

class MapType {
  final String name;
  final int value;

  MapType(this.name, this.value);

  static final normal = MapType('Normal', MAP_TYPE_NORMAL);
  static final satellite = MapType('Satellite', MAP_TYPE_SATELLITE);
  static final none = MapType('None', MAP_TYPE_NONE);
}

class _State extends State<MapTypeExample> {
  final _mapTypes = [MapType.normal, MapType.satellite, MapType.none];
  var _mapType = MapType.normal;

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          DropdownButton(
            value: _mapType,
            items: _mapTypes
                .map((mapType) =>
                    DropdownMenuItem(value: mapType, child: Text(mapType.name)))
                .toList(),
            onChanged: (value) {
              _mapType = value;
              setState(() {});
            },
          )
        ],
      ),
      body: BaiduMapView(key: widget.mapViewKey, mapType: _mapType.value),
    );
  }
}
