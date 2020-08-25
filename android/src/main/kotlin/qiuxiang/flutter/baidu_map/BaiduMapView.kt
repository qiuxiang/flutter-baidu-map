package qiuxiang.flutter.baidu_map

import android.app.Activity
import android.view.View
import com.baidu.mapapi.map.*
import com.baidu.mapapi.model.LatLng
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class BaiduMapView(var messenger: BinaryMessenger, id: Int, args: HashMap<*, *>)
  : PlatformView, MethodChannel.MethodCallHandler {
  private val mapView = MapView(activity)
  val map: BaiduMap = mapView.map
  private val channel = MethodChannel(messenger, "BaiduMapView_$id")
  private val markers = HashMap<String, BaiduMapMarker>()

  companion object {
    lateinit var activity: Activity
  }

  init {
    channel.setMethodCallHandler(this)

    (args["mapType"] as? Int)?.let { map.mapType = it }
    (args["trafficEnabled"] as? Boolean)?.let { map.isTrafficEnabled = it }
    (args["indoorEnabled"] as? Boolean)?.let { map.setIndoorEnable(it) }
    (args["buildingsEnabled"] as? Boolean)?.let { map.isBuildingsEnabled = it }
    (args["baiduHeatMapEnabled"] as? Boolean)?.let { map.isBaiduHeatMapEnabled = it }

    setMapStatus(args["mapStatus"] as? HashMap<*, *>)

    map.setOnMapClickListener(object : BaiduMap.OnMapClickListener {
      override fun onMapPoiClick(poi: MapPoi) {
        channel.invokeMethod("onTapPoi", poi.toMap())
      }

      override fun onMapClick(latLng: LatLng) {
        channel.invokeMethod("onTap", latLng.toMap())
      }
    })

    map.setOnMapLongClickListener { latLng ->
      channel.invokeMethod("onLongPress", latLng.toMap())
    }

    map.setOnMapStatusChangeListener(object : BaiduMap.OnMapStatusChangeListener {
      override fun onMapStatusChangeStart(status: MapStatus) {}
      override fun onMapStatusChangeStart(status: MapStatus, reason: Int) {}
      override fun onMapStatusChange(status: MapStatus) {}
      override fun onMapStatusChangeFinish(status: MapStatus) {
        channel.invokeMethod("onStatusChanged", HashMap<String, Any>().apply {
          this["center"] = status.target.toMap()
          this["overlook"] = status.overlook
          this["rotation"] = status.rotate
          this["zoom"] = status.zoom
        })
      }
    })

    map.setOnMarkerClickListener { marker ->
      channel.invokeMethod("onTapMarker", marker.id)
      true
    }
  }

  private fun setMapStatus(status: HashMap<*, *>?, duration: Int = 0) {
    if (status == null) {
      return
    }

    val mapStatus = MapStatusUpdateFactory.newMapStatus(MapStatus.Builder().apply {
      target((status["center"] as? HashMap<*, *>)?.toLatLng())
      (status["overlook"] as? Double)?.toFloat()?.let { overlook(it) }
      (status["rotation"] as? Double)?.toFloat()?.let { rotate(it) }
      (status["zoom"] as? Double)?.toFloat()?.let { zoom(it) }
    }.build())

    if (duration > 0) {
      map.animateMapStatus(mapStatus, duration)
    } else {
      map.setMapStatus(mapStatus)
    }
  }

  override fun getView(): View {
    return mapView
  }

  override fun dispose() {
    mapView.onDestroy()
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "setMapType" -> {
        map.mapType = call.arguments as Int
        result.success(null)
      }
      "setMapStatus" -> {
        val arguments = call.arguments as ArrayList<*>
        setMapStatus(arguments[0] as HashMap<*, *>, arguments[1] as Int)
      }
      "setTrafficEnabled" -> {
        map.isTrafficEnabled = call.arguments as Boolean
        result.success(null)
      }
      "setIndoorEnabled" -> {
        map.setIndoorEnable(call.arguments as Boolean)
        result.success(null)
      }
      "setBuildingsEnabled" -> {
        map.isBuildingsEnabled = call.arguments as Boolean
        result.success(null)
      }
      "setBaiduHeatMapEnabled" -> {
        map.isBaiduHeatMapEnabled = call.arguments as Boolean
        result.success(null)
      }
      "addMarker" -> {
        val marker = BaiduMapMarker(this, call.arguments as HashMap<*, *>)
        markers[marker.id] = marker
        result.success(marker.id)
      }
      "removeMarker" -> {
        markers[call.arguments]?.remove()
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }
}
