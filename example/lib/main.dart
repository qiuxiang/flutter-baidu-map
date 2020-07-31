import 'package:baidu_map/baidu_map.dart';
import 'package:flutter/material.dart';

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
  createState() => _HomeState();
}

class _Example {
  _Example(this.title, this.builder);

  final String title;
  final Widget Function(String) builder;

  open(context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => builder(title)));
  }
}

class _HomeState extends State<Home> {
  final _examples = [
    _Example('mapType', (title) => MapTypeExample(title: title)),
    _Example('mapStatus', (title) => MapStatusExample(title: title)),
    _Example('layers', (title) => Layers(title: title)),
  ];

  @override
  void initState() {
    super.initState();
    BaiduMap.init('token');
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
