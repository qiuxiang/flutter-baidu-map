import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  LatLng target;

  /// 地图俯仰角度 -45~0
  double overlook;

  /// 地图旋转角度
  double rotation;

  /// 地图缩放级别 4~21，室内图支持到 22
  double zoom;

  MapStatus({this.target, this.overlook, this.rotation, this.zoom});

  MapStatus.fromMap(map)
      : target = LatLng.fromMap(map['target']),
        overlook = map['overlook'],
        rotation = map['rotation'],
        zoom = map['zoom'];

  toMap() => {
        'target': target.toMap(),
        'overlook': overlook,
        'rotation': rotation,
        'zoom': zoom,
      };

  @override
  bool operator ==(_) =>
      _ is MapStatus &&
      _.target == target &&
      _.overlook == overlook &&
      _.rotation == rotation &&
      _.zoom == zoom;

  @override
  get hashCode =>
      target.hashCode ^ overlook.hashCode ^ rotation.hashCode ^ zoom.hashCode;
}

/// 点击地图兴趣点时的描述数据
class MapPoi {
  /// 兴趣点的坐标
  LatLng target;

  /// 兴趣点名称
  String name;

  /// 兴趣点的 UID
  String id;

  MapPoi({this.target, this.name, this.id});

  MapPoi.fromMap(map)
      : target = LatLng.fromMap(map['target']),
        name = map['name'],
        id = map['id'];
}

/// 百度地图组件
class BaiduMapView extends StatefulWidget {
  BaiduMapView({
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

  /// 地图状态改变时调用
  final void Function(MapStatus) onStatusChanged;

  @override
  createState() => _BaiduMapViewState();

  toMap() => {
        'mapType': mapType,
        'mapStatus': mapStatus == null ? null : mapStatus.toMap(),
        'trafficEnabled': trafficEnabled,
        'indoorEnabled': indoorEnabled,
        'buildingsEnabled': buildingsEnabled,
        'baiduHeatMapEnabled': baiduHeatMapEnabled,
      };
}

class _BaiduMapViewState extends State<BaiduMapView> {
  BaiduMapViewController _controller;

  @override
  build(context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'BaiduMapView',
        creationParams: widget.toMap(),
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    return Text('$defaultTargetPlatform is not yet supported');
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
  final _BaiduMapViewState _state;

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
}
