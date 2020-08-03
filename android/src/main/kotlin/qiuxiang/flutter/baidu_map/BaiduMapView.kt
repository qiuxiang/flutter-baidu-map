package qiuxiang.flutter.baidu_map

import android.app.Activity
import android.view.View
import com.baidu.mapapi.map.*
import com.baidu.mapapi.model.LatLng
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import io.flutter.view.FlutterMain


class BaiduMapView(messenger: BinaryMessenger, id: Int, args: HashMap<*, *>)
  : PlatformView, MethodChannel.MethodCallHandler {
  private val mapView = MapView(activity)
  private val map = mapView.map
  private val channel = MethodChannel(messenger, "BaiduMapView_$id")
  private val markers = HashMap<String, Marker>()

  companion object {
    lateinit var activity: Activity
  }

  init {
    channel.setMethodCallHandler(this)

    if (args["mapType"] != null) {
      map.mapType = args["mapType"] as Int
    }

    if (args["mapStatus"] != null) {
      val mapStatus = args["mapStatus"] as HashMap<*, *>
      val mapStatusBuilder = MapStatus.Builder()

      if (mapStatus["center"] != null) {
        mapStatusBuilder.target((mapStatus["center"] as HashMap<*, *>).toLatLng())
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

      map.setMapStatus(MapStatusUpdateFactory.newMapStatus(mapStatusBuilder.build()))
    }

    if (args["trafficEnabled"] != null) {
      map.isTrafficEnabled = args["trafficEnabled"] as Boolean
    }

    if (args["indoorEnabled"] != null) {
      map.setIndoorEnable(args["indoorEnabled"] as Boolean)
    }

    if (args["buildingsEnabled"] != null) {
      map.isBuildingsEnabled = args["buildingsEnabled"] as Boolean
    }

    if (args["baiduHeatMapEnabled"] != null) {
      map.isBaiduHeatMapEnabled = args["baiduHeatMapEnabled"] as Boolean
    }

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
        val map = HashMap<String, Any>()
        map["center"] = status.target.toMap()
        map["overlook"] = status.overlook
        map["rotation"] = status.rotate
        map["zoom"] = status.zoom
        channel.invokeMethod("onStatusChanged", map)
      }
    })

    map.setOnMarkerClickListener { marker ->
      channel.invokeMethod("onTapMarker", marker.id)
      true
    }
  }

  private fun setMapStatus(status: HashMap<*, *>, duration: Int = 0) {
    val builder = MapStatus.Builder()

    if (status["center"] != null) {
      builder.target((status["center"] as HashMap<*, *>).toLatLng())
    }

    if (status["overlook"] != null) {
      builder.overlook((status["overlook"] as Double).toFloat())
    }

    if (status["rotation"] != null) {
      builder.rotate((status["rotation"] as Double).toFloat())
    }

    if (status["zoom"] != null) {
      builder.zoom((status["zoom"] as Double).toFloat())
    }

    val mapStatus = MapStatusUpdateFactory.newMapStatus(builder.build())

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
        val data = call.arguments as HashMap<*, *>
        val options = MarkerOptions()
        options.position((data["position"] as HashMap<*, *>).toLatLng())
        var icon: BitmapDescriptor? = null
        if (data["icon"] != null) {
          icon = BitmapDescriptorFactory.fromAsset(
            FlutterMain.getLookupKeyForAsset(data["icon"] as String))
        }
        options.icon(icon)
        val marker = map.addOverlay(options) as Marker
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

private fun HashMap<*, *>.toLatLng(): LatLng {
  return LatLng(this["latitude"] as Double, this["longitude"] as Double)
}

fun LatLng.toMap(): HashMap<*, *> {
  val map = HashMap<String, Any>()
  map["latitude"] = this.latitude
  map["longitude"] = this.longitude
  return map
}

private fun MapPoi.toMap(): HashMap<*, *> {
  val map = HashMap<String, Any>()
  map["position"] = this.position.toMap()
  map["name"] = this.name
  map["id"] = this.uid
  return map
}
