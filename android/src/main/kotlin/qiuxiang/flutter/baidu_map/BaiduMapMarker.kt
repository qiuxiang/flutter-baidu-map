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
    options.icon(getIcon(args) ?: icon)
    marker = map.map.addOverlay(options) as Marker
    marker.hideInfoWindow()
    channel = MethodChannel(map.messenger, "BaiduMapMarker_$id")
    channel.setMethodCallHandler(this)
  }

  fun remove() {
    marker.remove()
  }

  private fun getIcon(args: HashMap<*, *>): BitmapDescriptor? {
    return BitmapDescriptorFactory.fromAsset(
      (args["asset"] as? String)?.let { FlutterMain.getLookupKeyForAsset(it) })
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "remove" -> {
        marker.remove()
        result.success(null)
      }
      "update" -> {
        val args = call.arguments as HashMap<*, *>
        marker.position = (args["position"] as HashMap<*, *>).toLatLng()
        marker.icon = getIcon(args)
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }
}