package qxiang.flutter.baidu_map

import com.baidu.mapapi.map.MapStatusUpdateFactory

class BaiduMapApi(baiduMap: BaiduMap) : Pigeon.BaiduMapApi {
  private val map = baiduMap.map
  private val mapView = baiduMap.mapView

  override fun setMapType(type: Long) {
    map.mapType = type.toInt()
  }

  override fun setCompassEnabled(enabled: Boolean) {
    map.setCompassEnable(enabled)
  }

  override fun setRotateGesturesEnabled(enabled: Boolean) {
    map.uiSettings.isRotateGesturesEnabled = enabled
  }

  override fun setScrollGesturesEnabled(enabled: Boolean) {
    map.uiSettings.isScrollGesturesEnabled = enabled
  }

  override fun setZoomControlsEnabled(enabled: Boolean) {
    mapView.showZoomControls(enabled)
  }

  override fun setZoomGesturesEnabled(enabled: Boolean) {
    map.uiSettings.isZoomGesturesEnabled = enabled
  }

  override fun setTiltGesturesEnabled(enabled: Boolean) {
    map.uiSettings.isOverlookingGesturesEnabled = enabled
  }

  override fun setIndoorViewEnabled(enabled: Boolean) {
    map.setIndoorEnable(enabled)
  }

  override fun setTrafficEnabled(enabled: Boolean) {
    map.isTrafficEnabled = enabled
  }

  override fun setBuildingsEnabled(enabled: Boolean) {
    map.isBuildingsEnabled = enabled
  }

  override fun setScaleControlsEnabled(enabled: Boolean) {
    mapView.showScaleControl(enabled)
  }

  override fun moveCamera(status: MutableMap<Any, Any>, duration: Long) {
    val mapStatus = MapStatusUpdateFactory.newMapStatus(status.toMapStatus())
    if (duration > 0) {
      map.animateMapStatus(mapStatus, duration.toInt())
    } else {
      map.setMapStatus(mapStatus)
    }
  }
}