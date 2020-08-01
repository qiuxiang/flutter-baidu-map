import 'package:baidu_map/baidu_map_view.dart';
import 'package:flutter/material.dart';

class MapTypeExample extends StatefulWidget {
  MapTypeExample(this.title, {Key key}) : super(key: key);

  final title;
  final mapViewKey = UniqueKey();

  @override
  createState() => _State();
}

class MapType {
  final String name;
  final int value;

  MapType(this.name, this.value);
}

final normal = MapType('Normal', MAP_TYPE_NORMAL);
final satellite = MapType('Satellite', MAP_TYPE_SATELLITE);
final none = MapType('None', MAP_TYPE_NONE);

class _State extends State<MapTypeExample> {
  final _mapTypes = [normal, satellite, none];
  var _mapType = normal;

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
