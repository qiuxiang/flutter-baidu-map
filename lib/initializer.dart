part of baidu_map;

class Initializer {
  static const _channel = MethodChannel('BaiduMap');

  /// 百度地图 SDK 初始化，必须在显示地图前调用
  static Future<void> init({String iosApiKey = ''}) async {
    await _channel.invokeMethod('init', iosApiKey);
  }
}
