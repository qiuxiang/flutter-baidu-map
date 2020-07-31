package qiuxiang.flutter.baidu_map

import android.app.Activity
import android.view.View
import com.baidu.mapapi.map.BaiduMap.MAP_TYPE_NONE
import com.baidu.mapapi.map.MapStatus
import com.baidu.mapapi.map.MapStatusUpdateFactory
import com.baidu.mapapi.map.MapView
import com.baidu.mapapi.model.LatLng
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class BaiduMapView(messenger: BinaryMessenger, id: Int, args: HashMap<*, *>)
  : PlatformView, MethodChannel.MethodCallHandler {
  private val view = MapView(activity)
  private val channel = MethodChannel(messenger, "BaiduMapView_$id")

  companion object {
    lateinit var activity: Activity
  }

  init {
    channel.setMethodCallHandler(this)

    if (args["mapType"] != null) {
      view.map.mapType = args["mapType"] as Int
    }

    if (args["mapStatus"] != null) {
      val mapStatus = args["mapStatus"] as HashMap<*, *>
      val mapStatusBuilder = MapStatus.Builder()

      if (mapStatus["target"] != null) {
        val target = mapStatus["target"] as HashMap<*, *>
        mapStatusBuilder.target(LatLng(target["latitude"] as Double, target["longitude"] as Double))
      }

      if (mapStatus["overlook"] != null) {
        mapStatusBuilder.overlook((mapStatus["overlook"] as Double).toFloat())
      }

      if (mapStatus["rotation"] != null) {
        mapStatusBuilder.rotate((mapStatus["rotation"] as Double).toFloat())
      }

      if (mapStatus["zoom"] != null) {
        mapStatusBuilder.zoom((mapStatus["zoom"] as Double).toFloat())
      }

      view.map.setMapStatus(MapStatusUpdateFactory.newMapStatus(mapStatusBuilder.build()))
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

  fun setMapStatus(mapStatus: HashMap<*, *>) {
    val mapStatusBuilder = MapStatus.Builder()

    if (mapStatus["target"] != null) {
      val target = mapStatus["target"] as HashMap<*, *>
      mapStatusBuilder.target(LatLng(target["latitude"] as Double, target["longitude"] as Double))
    }

    if (mapStatus["overlook"] != null) {
      mapStatusBuilder.overlook((mapStatus["overlook"] as Double).toFloat())
    }

    if (mapStatus["rotation"] != null) {
      mapStatusBuilder.rotate((mapStatus["rotation"] as Double).toFloat())
    }

    if (mapStatus["zoom"] != null) {
      mapStatusBuilder.zoom((mapStatus["zoom"] as Double).toFloat())
    }

    view.map.setMapStatus(MapStatusUpdateFactory.newMapStatus(mapStatusBuilder.build()))
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
      "setMapStatus" -> setMapStatus(call.arguments as HashMap<*, *>)
      "setTrafficEnabled" -> view.map.isTrafficEnabled = call.arguments as Boolean
      "setIndoorEnabled" -> view.map.setIndoorEnable(call.arguments as Boolean)
      "setBuildingsEnabled" -> view.map.isBuildingsEnabled = call.arguments as Boolean
      "setBaiduHeatMapEnabled" -> view.map.isBaiduHeatMapEnabled = call.arguments as Boolean
      else -> result.notImplemented()
    }
  }
}
