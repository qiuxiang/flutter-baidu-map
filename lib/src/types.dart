import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

/// 坐标类型
class CoordinateType {
  /// google 地图、soso 地图、aliyun 地图、mapabc 地图和 amap 地图所用坐标
  static const gcj02 = 'gcj02';

  /// 百度经纬度
  static const bd09ll = 'bd09ll';
}

/// 地图类型
class MapType {
  /// 普通地图
  static const normal = 1;

  /// 卫星图
  static const satellite = 2;

  /// 空白地图
  static const none = 3;
}

/// 地图兴趣点
class MapPoi {
  const MapPoi({required this.id, required this.name, required this.position});

  /// 兴趣点 ID
  final String id;

  /// 兴趣点名称
  final String name;

  /// 兴趣点坐标
  final LatLng position;

  static MapPoi fromJson(Map json) {
    return MapPoi(
      id: json['id'],
      name: json['name'],
      position: LatLng.fromJson(json['position'])!,
    );
  }

  Object toJson() => {
        'position': position.toJson(),
        'name': name,
        'id': id,
      };

  @override
  String toString() => '${toJson()}';
}
