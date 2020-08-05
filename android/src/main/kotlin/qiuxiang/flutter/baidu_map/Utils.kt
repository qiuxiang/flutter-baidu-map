package qiuxiang.flutter.baidu_map

import com.baidu.mapapi.map.MapPoi
import com.baidu.mapapi.model.LatLng

fun HashMap<*, *>.toLatLng(): LatLng {
  return LatLng(this["latitude"] as Double, this["longitude"] as Double)
}

fun LatLng.toMap(): HashMap<*, *> {
  val map = HashMap<String, Any>()
  map["latitude"] = this.latitude
  map["longitude"] = this.longitude
  return map
}

fun MapPoi.toMap(): HashMap<*, *> {
  val map = HashMap<String, Any>()
  map["position"] = this.position.toMap()
  map["name"] = this.name
  map["id"] = this.uid
  return map
}
