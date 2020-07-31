import 'package:flutter/material.dart';

abstract class Example extends StatefulWidget {
  Example({Key key, this.title}) : super(key: key);
  final String title;
}

abstract class SwitchExampleState extends State<Example> {
  var enabled = true;

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Switch(
            value: enabled,
            onChanged: (value) {
              enabled = value;
              setState(() {});
            },
          ),
        ],
      ),
      body: buildMapView(),
    );
  }

  Widget buildMapView();
}
