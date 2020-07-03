import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:baidu_map/baidu_map.dart';

void main() {
  const MethodChannel channel = MethodChannel('baidu_map');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await BaiduMap.platformVersion, '42');
  });
}
