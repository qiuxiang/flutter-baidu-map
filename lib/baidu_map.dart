import 'dart:async';

import 'package:flutter/services.dart';

class BaiduMap {
  static const MethodChannel _channel =
      const MethodChannel('baidu_map');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
