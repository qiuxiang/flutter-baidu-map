package qiuxiang.flutter.baidu_map

import android.app.Activity
import android.view.View
import com.baidu.mapapi.map.MapView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class BaiduMapView(messenger: BinaryMessenger, id: Int, args: HashMap<String, Any>) : PlatformView, MethodChannel.MethodCallHandler {
  private val view = MapView(activity)
  private val channel = MethodChannel(messenger, "BaiduMapView_$id")

  companion object {
    lateinit var activity: Activity
  }

  init {
    channel.setMethodCallHandler(this)
    view.map.isTrafficEnabled = args["trafficEnabled"] as Boolean
  }

  override fun getView(): View {
    return view
  }

  override fun dispose() {
    view.onDestroy()
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "setTrafficEnabled" -> view.map.isTrafficEnabled = call.arguments as Boolean
      else -> result.notImplemented()
    }
  }
}
