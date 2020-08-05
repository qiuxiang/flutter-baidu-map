package qiuxiang.flutter.baidu_map

import com.baidu.mapapi.map.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.view.FlutterMain

class BaiduMapMarker(map: BaiduMapView, args: HashMap<*, *>) : MethodCallHandler {
  private var marker: Marker
  private var channel: MethodChannel

  val id: String get() = marker.id

  companion object {
    val icon: BitmapDescriptor = BitmapDescriptorFactory.fromResource(R.drawable.marker)
  }

  init {
    val options = MarkerOptions()
    options.position((args["position"] as HashMap<*, *>).toLatLng())
    options.infoWindow(InfoWindow(icon, options.position, 0) {})
    val icon: BitmapDescriptor = getIcon(args) ?: icon
    options.icon(icon)
    marker = map.map.addOverlay(options) as Marker
    marker.hideInfoWindow()
    channel = MethodChannel(map.messenger, "BaiduMapMarker_$id")
    channel.setMethodCallHandler(this)
  }

  fun remove() {
    marker.remove()
  }

  private fun getIcon(args: HashMap<*, *>): BitmapDescriptor? {
    return if (args["asset"] != null) {
      BitmapDescriptorFactory.fromAsset(
        FlutterMain.getLookupKeyForAsset(args["asset"] as String))
    } else {
      null
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "remove" -> {
        marker.remove()
        result.success(null)
      }
      "update" -> {
        val args = call.arguments as HashMap<*, *>
        if (args["position"] != null) {
          marker.position = (args["position"] as HashMap<*, *>).toLatLng()
        }
        val icon = getIcon(args)
        if (icon != null) {
          marker.icon = icon
        }
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }
}