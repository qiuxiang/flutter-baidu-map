package qiuxiang.flutter.baidu_map

import android.content.Context
import android.view.View
import com.baidu.mapapi.map.MapPoi
import com.baidu.mapapi.map.MapStatus
import com.baidu.mapapi.map.MapView
import com.baidu.mapapi.model.LatLng
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import com.baidu.mapapi.map.BaiduMap as Map

class BaiduMap(messenger: BinaryMessenger, context: Context) : PlatformView {
  val mapView = MapView(context)
  val map: Map = mapView.map

  init {
    Pigeon.BaiduMapApi.setup(messenger, BaiduMapApi(this))
    map.setCompassEnable(true)

    map.setOnMapClickListener(object : Map.OnMapClickListener {
      override fun onMapPoiClick(poi: MapPoi) {
//        channel.invokeMethod("onTapPoi", poi.toMap())
      }

      override fun onMapClick(latLng: LatLng) {
//        channel.invokeMethod("onTap", latLng.toMap())
      }
    })

    map.setOnMapLongClickListener { latLng ->
//      channel.invokeMethod("onLongPress", latLng.toMap())
    }

    map.setOnMapStatusChangeListener(object : Map.OnMapStatusChangeListener {
      override fun onMapStatusChangeStart(status: MapStatus) {}
      override fun onMapStatusChangeStart(status: MapStatus, reason: Int) {}
      override fun onMapStatusChange(status: MapStatus) {}
      override fun onMapStatusChangeFinish(status: MapStatus) {
//        channel.invokeMethod("onStatusChanged", HashMap<String, Any>().apply {
//          this["center"] = status.target.toMap()
//          this["overlook"] = status.overlook
//          this["rotate"] = status.rotate
//          this["zoom"] = status.zoom
//        })
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