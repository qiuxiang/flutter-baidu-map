package qiuxiang.flutter.baidu_map

import com.baidu.mapapi.map.MapStatus
import com.baidu.mapapi.model.LatLng

fun List<*>.toLatLng(): LatLng {
  return LatLng(this[0] as Double, this[1] as Double)
}

fun LatLng.toJson(): List<Double> {
  return listOf(this.latitude, this.longitude)
}

//fun MapPoi.toMap(): MutableMap<*, *> {
//  val map = HashMap<String, Any>()
//  map["position"] = this.position.toMap()
//  map["name"] = this.name
//  map["id"] = this.uid
//  return map
//}

fun Map<*, *>.toMapStatus(): MapStatus? {
  val it = this
  return MapStatus.Builder().apply {
    target((it["target"] as? List<*>)?.toLatLng())
    it["tilt"].toFloat()?.let { overlook(it) }
    it["bearing"].toFloat()?.let { rotate(it) }
    it["zoom"].toFloat()?.let { zoom(it) }
  }.build()
}

fun Any?.toFloat(): Float? {
  return (this as? Double)?.toFloat()
}