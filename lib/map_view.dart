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
  double latitude;

  /// 经度
  double longitude;

  LatLng(this.latitude, this.longitude);

  LatLng.fromMap(map)
      : latitude = map['latitude'],
        longitude = map['longitude'];

  toMap() => {'latitude': latitude, 'longitude': longitude};

  @override
  bool operator ==(_) =>
      _ is LatLng && _.latitude == latitude && _.longitude == longitude;

  @override
  get hashCode => latitude.hashCode ^ longitude.hashCode;
}

/// 地图状态
class MapStatus {
  /// 坐标
  LatLng center;

  /// 地图俯仰角度 -45~0
  double overlook;

  /// 地图旋转角度
  double rotation;

  /// 地图缩放级别 4~21，室内图支持到 22
  double zoom;

  MapStatus({this.center, this.overlook, this.rotation, this.zoom});

  MapStatus.fromMap(map)
      : center = LatLng.fromMap(map['center']),
        overlook = map['overlook'],
        rotation = map['rotation'],
        zoom = map['zoom'];

  toMap() => {
        'center': center.toMap(),
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
  LatLng position;

  /// 兴趣点名称
  String name;

  /// 兴趣点的 UID
  String id;

  MapPoi({this.position, this.name, this.id});

  MapPoi.fromMap(map)
      : position = LatLng.fromMap(map['position']),
        name = map['name'],
        id = map['id'];
}

/// 百度地图组件
class BaiduMap extends StatefulWidget {
  BaiduMap({
    Key key,
    this.onCreated,
    this.mapType,
    this.mapStatus,
    this.trafficEnabled,
    this.indoorEnabled,
    this.buildingsEnabled,
    this.baiduHeatMapEnabled,
    this.onTap,
    this.onTapPoi,
    this.onTapMarker,
    this.onStatusChanged,
  }) : super(key: key);

  /// 地图创建完成时调用
  ///
  /// 可以使用参数 [BaiduMapViewController] 控制地图
  final void Function(BaiduMapViewController) onCreated;

  /// 地图模式
  final int mapType;

  /// 地图状态，包括中心坐标、旋转角度、俯仰角度、缩放级别
  final MapStatus mapStatus;

  /// 是否显示交通图层
  final bool trafficEnabled;

  /// 是否显示室内地图
  final bool indoorEnabled;

  /// 是否启用 3D 建筑
  final bool buildingsEnabled;

  /// 是否显示百度热力图图层（百度自有数据图层）
  ///
  /// 地图层级大于 11 时可显示热力图
  final bool baiduHeatMapEnabled;

  /// 点击地图时调用
  final void Function(LatLng) onTap;

  /// 点击地图兴趣点时调用
  final void Function(MapPoi) onTapPoi;

  final void Function(Marker) onTapMarker;

  /// 地图状态改变时调用
  final void Function(MapStatus) onStatusChanged;

  @override
  createState() => _BaiduMapState();

  toMap() => {
        'mapType': mapType,
        'mapStatus': mapStatus == null ? null : mapStatus.toMap(),
        'trafficEnabled': trafficEnabled,
        'indoorEnabled': indoorEnabled,
        'buildingsEnabled': buildingsEnabled,
        'baiduHeatMapEnabled': baiduHeatMapEnabled,
      };
}

class _BaiduMapState extends State<BaiduMap> {
  BaiduMapViewController _controller;

  @override
  build(context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidView(
          viewType: 'BaiduMapView',
          creationParams: widget.toMap(),
          creationParamsCodec: StandardMessageCodec(),
          onPlatformViewCreated: _onPlatformViewCreated,
        );
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: 'BaiduMapView',
          creationParams: widget.toMap(),
          creationParamsCodec: StandardMessageCodec(),
          onPlatformViewCreated: _onPlatformViewCreated,
        );
      default:
        return Text('$defaultTargetPlatform is not yet supported');
    }
  }

  @override
  didUpdateWidget(_) {
    super.didUpdateWidget(_);
    if (_.mapType != widget.mapType) {
      _controller.setMapType(widget.mapType);
    }
    if (_.mapStatus != widget.mapStatus) {
      _controller.setMapStatus(widget.mapStatus);
    }
    if (_.trafficEnabled != widget.trafficEnabled) {
      _controller.setTrafficEnabled(widget.trafficEnabled);
    }
    if (_.indoorEnabled != widget.indoorEnabled) {
      _controller.setIndoorEnabled(widget.indoorEnabled);
    }
    if (_.buildingsEnabled != widget.buildingsEnabled) {
      _controller.setBuildingsEnabled(widget.buildingsEnabled);
    }
    if (_.baiduHeatMapEnabled != widget.baiduHeatMapEnabled) {
      _controller.setBaiduHeatMapEnabled(widget.baiduHeatMapEnabled);
    }
  }

  _onPlatformViewCreated(int id) {
    _controller = BaiduMapViewController(id, this);
    if (widget.onCreated != null) {
      widget.onCreated(_controller);
    }
  }
}

/// 地图控制器，提供地图控制接口
class BaiduMapViewController {
  final MethodChannel _channel;
  final _BaiduMapState _state;
  final _markers = Map<String, Marker>();

  BaiduMapViewController(int id, this._state)
      : _channel = MethodChannel('BaiduMapView_$id') {
    _channel.setMethodCallHandler((call) {
      final widget = _state.widget;
      switch (call.method) {
        case 'onTap':
          if (widget.onTap != null) {
            widget.onTap(LatLng.fromMap(call.arguments));
          }
          break;
        case 'onTapPoi':
          if (widget.onTapPoi != null) {
            widget.onTapPoi(MapPoi.fromMap(call.arguments));
          }
          break;
        case 'onTapMarker':
          if (widget.onTapMarker != null) {
            widget.onTapMarker(_markers[call.arguments]);
          }
          break;
        case 'onStatusChanged':
          if (widget.onStatusChanged != null) {
            widget.onStatusChanged(MapStatus.fromMap(call.arguments));
          }
          break;
      }
      return;
    });
  }

  /// 设置地图类型
  Future<void> setMapType(int mapType) {
    return _channel.invokeMethod('setMapType', mapType);
  }

  /// 设置地图状态，支持动画过度
  Future<void> setMapStatus(MapStatus mapStatus, {int duration = 0}) {
    return _channel.invokeMethod('setMapStatus', [mapStatus.toMap(), duration]);
  }

  /// 设置是否显示交通图层
  Future<void> setTrafficEnabled(bool enabled) {
    return _channel.invokeMethod('setTrafficEnabled', enabled);
  }

  /// 设置是否显示室内地图
  Future<void> setIndoorEnabled(bool enabled) {
    return _channel.invokeMethod('setIndoorEnabled', enabled);
  }

  /// 设置是否显示 3D 建筑
  Future<void> setBuildingsEnabled(bool enabled) {
    return _channel.invokeMethod('setBuildingsEnabled', enabled);
  }

  /// 设置是否显示百度热力图图层
  Future<void> setBaiduHeatMapEnabled(bool enabled) {
    return _channel.invokeMethod('setBaiduHeatMapEnabled', enabled);
  }

  Future<Marker> addMarker(MarkerOptions options) async {
    final id = await _channel.invokeMethod('addMarker', options.toMap());
    final marker = Marker(this, id);
    _markers[id] = marker;
    return marker;
  }
}

/// 地图标记覆盖物
class MarkerOptions {
  MarkerOptions({this.position, this.asset});

  /// 标记坐标
  final LatLng position;

  final String asset;

  toMap() => {
        'position': position.toMap(),
        'asset': asset,
      };
}

/// 地图标记覆盖物
class Marker {
  Marker(this._controller, this._id)
      : _channel = MethodChannel('BaiduMapMarker_$_id');

  final BaiduMapViewController _controller;
  final MethodChannel _channel;

  String _id;

  get id => _id;

  Future<void> remove() {
    _controller._markers.remove(id);
    return _channel.invokeMethod('remove');
  }

  Future<void> update(MarkerOptions options) {
    return _channel.invokeMethod('update', options.toMap());
  }
}
