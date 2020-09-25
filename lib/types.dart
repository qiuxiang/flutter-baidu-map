part of baidu_map;

/// 普通模式
const MAP_TYPE_NORMAL = 1;

/// 卫星图模式
const MAP_TYPE_SATELLITE = 2;

/// 空白模式
const MAP_TYPE_NONE = 3;

/// 经纬度坐标
class LatLng {
  /// 纬度
  final double latitude;

  /// 经度
  final double longitude;

  const LatLng(this.latitude, this.longitude);

  LatLng.fromMap(map)
      : latitude = map['latitude'],
        longitude = map['longitude'];

  toMap() => {'latitude': latitude, 'longitude': longitude};

  @override
  bool operator ==(it) =>
      it is LatLng && it.latitude == latitude && it.longitude == longitude;

  @override
  get hashCode => latitude.hashCode ^ longitude.hashCode;
}

/// 地图状态
class MapStatus {
  /// 坐标
  final LatLng center;

  /// 地图俯仰角度 -45~0
  final double overlook;

  /// 地图旋转角度
  final double rotation;

  /// 地图缩放级别 4~21，室内图支持到 22
  final double zoom;

  const MapStatus({this.center, this.overlook, this.rotation, this.zoom});

  MapStatus.fromMap(map)
      : center = LatLng.fromMap(map['center']),
        overlook = map['overlook'],
        rotation = map['rotation'],
        zoom = map['zoom'];

  toMap() => {
        'center': center?.toMap(),
        'overlook': overlook,
        'rotation': rotation,
        'zoom': zoom,
      };

  @override
  bool operator ==(_) =>
      _ is MapStatus &&
      _.center == center &&
      _.overlook == overlook &&
      _.rotation == rotation &&
      _.zoom == zoom;

  @override
  get hashCode =>
      center.hashCode ^ overlook.hashCode ^ rotation.hashCode ^ zoom.hashCode;
}

/// 点击地图兴趣点时的描述数据
class MapPoi {
  /// 兴趣点的坐标
  final LatLng position;

  /// 兴趣点名称
  final String name;

  /// 兴趣点的 UID
  final String id;

  const MapPoi({this.position, this.name, this.id});

  MapPoi.fromMap(map)
      : position = LatLng.fromMap(map['position']),
        name = map['name'],
        id = map['id'];
}
