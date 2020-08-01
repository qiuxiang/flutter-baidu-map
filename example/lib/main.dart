import 'package:baidu_map/baidu_map.dart';
import 'package:flutter/material.dart';

import 'events.dart';
import 'layers.dart';
import 'map_status.dart';
import 'map_type.dart';

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
    Example('mapType', (title) => MapTypeExample(title)),
    Example('mapStatus', (title) => MapStatusExample(title)),
    Example('layers: traffic, indoor, buildings...',
        (title) => LayersExample(title)),
    Example('events', (title) => EventsExample(title)),
  ];

  @override
  void initState() {
    super.initState();
    BaiduMap.init();
  }

  @override
  build(context) {
    return Scaffold(
        appBar: AppBar(title: Text('Plugin examples')),
        body: ListView(
          children: _examples
              .map(((example) => ListTile(
                  title: Text(example.title),
                  onTap: () => example.open(context))))
              .toList(),
        ));
  }
}
