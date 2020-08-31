import 'package:baidu_map/baidu_map.dart';
import 'package:flutter/material.dart';

import 'controls.dart';
import 'events.dart';
import 'layers.dart';
import 'map_status.dart';
import 'map_type.dart';
import 'marker-asset.dart';
import 'marker.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  createState() => _State();
}

class Example {
  Example(this.title, this.builder);

  final String title;
  final Widget Function(String) builder;

  open(context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => builder(title)));
  }
}

class _State extends State {
  final _examples = [
    Example('地图类型', (_) => MapTypeExample(_)),
    Example('地图状态切换，支持动画过度', (_) => MapStatusExample(_)),
    Example('图层：交通、室内、3D 建筑', (_) => LayersExample(_)),
    Example('控件：比例尺、缩放按钮、指南针', (_) => ControlsExample(_)),
    Example('地图事件', (_) => EventsExample(_)),
    Example('动态添加/移除标记', (_) => MarkerExample(_)),
    Example('自定义 Marker 图标', (_) => MarkerAssetExample(_)),
  ];

  @override
  void initState() {
    super.initState();
    Initializer.init(iosApiKey: '3rfXjBG7eCzn2B0Eh8bTFjfaFnDGM2CZ');
  }

  @override
  build(context) {
    return Scaffold(
        appBar: AppBar(title: Text('Examples')),
        body: ListView(
          children: _examples
              .map(((example) => ListTile(
                  title: Text(example.title),
                  onTap: () => example.open(context))))
              .toList(),
        ));
  }
}
