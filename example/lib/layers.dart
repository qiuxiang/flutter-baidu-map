import 'package:baidu_map/baidu_map.dart';
import 'package:flutter/material.dart';

class LayersExample extends StatefulWidget {
  LayersExample(this.title, {Key key}) : super(key: key);

  final title;
  final mapViewKey = UniqueKey();

  @override
  createState() => _State();
}

class Item {
  final String name;

  Item(this.name);
}

final traffic = Item('traffic');
final indoor = Item('indoor');
final buildings = Item('buildings');
final baiduHeatMap = Item('baiduHeatMap');

class _State extends State<LayersExample> {
  final _state = {buildings.name: true};
  final _items = [traffic, indoor, buildings, baiduHeatMap];

  @override
  build(context) {
    var items = _items.map(
      (it) => Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(it.name),
          ),
          Switch(
            value: _state[it.name] ?? false,
            onChanged: (value) {
              _state[it.name] = value;
              setState(() {});
            },
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: BaiduMap(
              key: widget.mapViewKey,
              mapStatus: MapStatus(
                  center: LatLng(39.9169, 116.3793), zoom: 19, overlook: -45),
              trafficEnabled: _state[traffic.name],
              indoorEnabled: _state[indoor.name],
              buildingsEnabled: _state[buildings.name],
              baiduHeatMapEnabled: _state[baiduHeatMap.name],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: items.toList(),
          ),
        ],
      ),
    );
  }
}
