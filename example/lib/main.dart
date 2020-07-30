import 'package:flutter/material.dart';
import 'package:baidu_map/baidu_map.dart';

import 'traffic.dart';

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

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    BaiduMap.init('token');
  }

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(title: Text('Plugin example app')),
      body: ListView(children: [
        ListTile(
          title: Text('trafficEnabled'),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => TrafficEnabled()));
          },
        ),
      ]),
    );
  }
}
