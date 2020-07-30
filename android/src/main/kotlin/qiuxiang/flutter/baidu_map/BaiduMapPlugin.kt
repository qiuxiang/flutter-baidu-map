package qiuxiang.flutter.baidu_map

import android.app.Activity
import com.baidu.mapapi.SDKInitializer
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class BaiduMapPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel: MethodChannel
  private lateinit var activity: Activity

  override fun onAttachedToEngine(binding: FlutterPluginBinding) {
    @Suppress("DEPRECATION")
    channel = MethodChannel(binding.flutterEngine.dartExecutor, "BaiduMap")
    channel.setMethodCallHandler(this)
    binding.platformViewRegistry.registerViewFactory(
      "BaiduMapView", BaiduMapViewFactory(binding.binaryMessenger))
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "init") {
      SDKInitializer.initialize(activity.applicationContext)
      result.success(null)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    BaiduMapView.activity = activity
  }

  override fun onDetachedFromActivity() {
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }
}
