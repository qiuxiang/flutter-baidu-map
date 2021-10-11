package qxiang.flutter.baidu_map

import io.flutter.embedding.engine.plugins.FlutterPlugin

class BaiduMapPlugin : FlutterPlugin {
  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {}
  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    binding.platformViewRegistry.registerViewFactory(
      "BaiduMap", BaiduMapFactory(binding.binaryMessenger)
    )
    Pigeon.SdkApi.setup(binding.binaryMessenger, BaiduMapSdkApi(binding.applicationContext))
  }
}