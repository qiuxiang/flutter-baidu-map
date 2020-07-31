package qiuxiang.flutter.baidu_map

import android.app.Activity
import android.view.View
import com.baidu.mapapi.map.BaiduMap.MAP_TYPE_NONE
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

    if (args["mapType"] != null) {
      view.map.mapType = args["mapType"] as Int
      MAP_TYPE_NONE;
    }

    if (args["trafficEnabled"] != null) {
      view.map.isTrafficEnabled = args["trafficEnabled"] as Boolean
    }

    if (args["indoorEnabled"] != null) {
      view.map.setIndoorEnable(args["indoorEnabled"] as Boolean)
    }

    if (args["buildingsEnabled"] != null) {
      view.map.isBuildingsEnabled = args["buildingsEnabled"] as Boolean
    }

    if (args["baiduHeatMapEnabled"] != null) {
      view.map.isBaiduHeatMapEnabled = args["baiduHeatMapEnabled"] as Boolean
    }
  }

  override fun getView(): View {
    return view
  }

  override fun dispose() {
    view.onDestroy()
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "setMapType" -> view.map.mapType = call.arguments as Int
      "setTrafficEnabled" -> view.map.isTrafficEnabled = call.arguments as Boolean
      "setIndoorEnabled" -> view.map.setIndoorEnable(call.arguments as Boolean)
      "setBuildingsEnabled" -> view.map.isBuildingsEnabled = call.arguments as Boolean
      "setBaiduHeatMapEnabled" -> view.map.isBaiduHeatMapEnabled = call.arguments as Boolean
      else -> result.notImplemented()
    }
  }
}
