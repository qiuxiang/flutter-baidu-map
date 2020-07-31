import 'package:flutter/material.dart';
import 'package:baidu_map/baidu_map_view.dart';

import 'example.dart';

class MapTypeExample extends StatefulWidget {
  MapTypeExample({Key key, this.title}) : super(key: key);

  final title;

  @override
  createState() => _State();
}

class _MapType {
  final String name;
  final int value;

  _MapType(this.name, this.value);

  static final normal = _MapType('Normal', MAP_TYPE_NORMAL);
  static final satellite = _MapType('Satellite', MAP_TYPE_SATELLITE);
  static final none = _MapType('None', MAP_TYPE_NONE);
}

class _State extends State<MapTypeExample> {
  final _mapTypes = [_MapType.normal, _MapType.satellite, _MapType.none];
  var _mapType = _MapType.normal;

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
      body: BaiduMapView(mapType: _mapType.value),
    );
  }
}
