package qiuxiang.flutter.baidu_map

import com.baidu.mapapi.map.MapPoi
import com.baidu.mapapi.map.MapStatus
import com.baidu.mapapi.model.LatLng

fun List<*>.toLatLng(): LatLng {
  return LatLng(this[0] as Double, this[1] as Double)
}

fun LatLng.toJson(): List<Double> {
  return listOf(this.latitude, this.longitude)
}

fun MapPoi.toJson(): Map<Any, Any> {
  return mapOf("position" to position.toJson(), "name" to name, "id" to uid)
}

fun Map<*, *>.toMapStatus(): MapStatus? {
  val map = this
  return MapStatus.Builder().apply {
    target((map["target"] as? List<*>)?.toLatLng())
    map["tilt"].toFloat()?.let { overlook(it) }
    map["bearing"].toFloat()?.let { rotate(it) }
    map["zoom"].toFloat()?.let { zoom(it) }
  }.build()
}

fun MapStatus.toJson(): Map<Any, Any> {
  return mapOf("target" to target.toJson(), "tilt" to overlook, "bearing" to rotate, "zoom" to zoom)
}

fun Any?.toFloat(): Float? {
  return (this as? Double)?.toFloat()
}