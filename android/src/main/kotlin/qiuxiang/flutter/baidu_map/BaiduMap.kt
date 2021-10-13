package qiuxiang.flutter.baidu_map

import android.content.Context
import android.os.Handler
import android.view.View
import com.baidu.mapapi.map.MapPoi
import com.baidu.mapapi.map.MapStatus
import com.baidu.mapapi.map.MapView
import com.baidu.mapapi.model.LatLng
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import com.baidu.mapapi.map.BaiduMap as Map

class BaiduMap(messenger: BinaryMessenger, context: Context) : PlatformView {
  private val flutter = Pigeon.BaiduMapHandler(messenger)
  val mapView = MapView(context)
  val map: Map = mapView.map
  val handler = Handler(context.mainLooper)

  init {
    Pigeon.BaiduMapApi.setup(messenger, BaiduMapApi(this))
    map.setCompassEnable(true)
    map.setOnMapClickListener(object : Map.OnMapClickListener {
      override fun onMapPoiClick(poi: MapPoi) {
        flutter.onTapPoi(poi.toJson()) {}
      }

      override fun onMapClick(latLng: LatLng) {
        flutter.onTap(latLng.toJson()) {}
      }
    })
    map.setOnMapLongClickListener { latLng -> flutter.onLongPress(latLng.toJson()) {} }
    map.setOnMapStatusChangeListener(object : Map.OnMapStatusChangeListener {
      override fun onMapStatusChangeStart(status: MapStatus) {}
      override fun onMapStatusChangeStart(status: MapStatus, reason: Int) {
        flutter.onCameraMoveStarted(status.toJson()) {}
      }

      override fun onMapStatusChange(status: MapStatus) {
        handler.post { flutter.onCameraMove(status.toJson()) {} }
      }

      override fun onMapStatusChangeFinish(status: MapStatus) {
        flutter.onCameraIdle(status.toJson()) {}
      }
    })
//    map.setOnMarkerClickListener { marker ->
//      channel.invokeMethod("onTapMarker", marker.id)
//      true
//    }
  }

  override fun getView(): View {
    return mapView
  }

  override fun dispose() {
    mapView.onDestroy()
  }
}