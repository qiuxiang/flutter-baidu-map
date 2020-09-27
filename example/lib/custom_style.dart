import 'package:baidu_map/baidu_map.dart';
import 'package:flutter/material.dart';

class CustomStyle {
  final String name;
  final String asset;

  const CustomStyle(this.name, this.asset);
}

class CustomStyleExample extends StatefulWidget {
  CustomStyleExample(this.title, {Key key}) : super(key: key);

  final title;
  final mapViewKey = UniqueKey();

  @override
  createState() => _State();
}

class _State extends State<CustomStyleExample> {
  static const _styles = [
    CustomStyle('茶田', 'styles/7271bb55da29d3ec22c35b1760c1ab6c.sty'),
    CustomStyle('绿野仙踪', 'styles/081e6d594545b73aa0733c09a4509c45.sty'),
    CustomStyle('一蓑烟雨', 'styles/8e77901507dedef802869499006206b7.sty'),
  ];

  var _style = _styles[0];

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          DropdownButton(
            value: _style,
            items: _styles
                .map((it) => DropdownMenuItem(value: it, child: Text(it.name)))
                .toList(),
            onChanged: (value) => setState(() => _style = value),
          )
        ],
      ),
      body: BaiduMap(key: widget.mapViewKey, customStyle: _style.asset),
    );
  }
}
