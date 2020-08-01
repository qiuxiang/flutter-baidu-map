import 'dart:async';

import 'package:flutter/services.dart';

class BaiduMap {
  static const _channel = MethodChannel('BaiduMap');

  static Future<void> init({String iosApiKey = ''}) async {
    await _channel.invokeMethod('init', iosApiKey);
  }
}
