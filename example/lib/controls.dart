import 'package:baidu_map/baidu_map.dart';
import 'package:flutter/material.dart';

class ControlsExample extends StatefulWidget {
  ControlsExample(this.title, {Key key}) : super(key: key);

  final title;
  final mapViewKey = UniqueKey();

  @override
  createState() => _State();
}

class Item {
  final String name;

  Item(this.name);
}

final compass = Item('compass');
final zoomControls = Item('zoomControls');
final scaleBar = Item('scaleBar');

class _State extends State<ControlsExample> {
  final _items = [compass, zoomControls, scaleBar];
  final _state = {scaleBar.name: true, zoomControls.name: true};

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
              mapStatus: MapStatus(rotate: 45),
              compassEnabled: _state[compass.name],
              zoomControlsEnabled: _state[zoomControls.name],
              scaleBarEnabled: _state[scaleBar.name],
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
