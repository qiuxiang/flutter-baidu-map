library baidu_map;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'types.dart';
part 'marker.dart';
part 'initializer.dart';

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
    this.compassEnabled,
    this.zoomControlsEnabled,
    this.scaleBarEnabled,
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

  /// 是否显示指南针
  final bool compassEnabled;

  /// 是否显示缩放按钮，默认显示
  final bool zoomControlsEnabled;

  /// 是否显示比例尺，默认显示
  final bool scaleBarEnabled;

  /// 点击地图时调用
  final void Function(LatLng) onTap;

  /// 点击地图兴趣点时调用
  final void Function(MapPoi) onTapPoi;

  /// 点击 Marker 时调用
  final void Function(Marker) onTapMarker;

  /// 地图状态改变时调用
  final void Function(MapStatus) onStatusChanged;

  @override
  createState() => _BaiduMapState();

  toMap() => {
        'mapType': mapType,
        'mapStatus': mapStatus?.toMap(),
        'trafficEnabled': trafficEnabled,
        'indoorEnabled': indoorEnabled,
        'buildingsEnabled': buildingsEnabled,
        'baiduHeatMapEnabled': baiduHeatMapEnabled,
        'compassEnabled': compassEnabled,
        'zoomControlsEnabled': zoomControlsEnabled,
        'scaleBarEnabled': scaleBarEnabled,
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
    if (_.compassEnabled != widget.compassEnabled) {
      _controller.setCompassEnabled(widget.compassEnabled);
    }
    if (_.zoomControlsEnabled != widget.zoomControlsEnabled) {
      _controller.setZoomControlsEnabled(widget.zoomControlsEnabled);
    }
    if (_.scaleBarEnabled != widget.scaleBarEnabled) {
      _controller.setScaleBarEnabled(widget.scaleBarEnabled);
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
          widget.onTap(LatLng.fromMap(call.arguments));
          break;
        case 'onTapPoi':
          widget.onTapPoi(MapPoi.fromMap(call.arguments));
          break;
        case 'onTapMarker':
          widget.onTapMarker(_markers[call.arguments]);
          break;
        case 'onStatusChanged':
          widget.onStatusChanged(MapStatus.fromMap(call.arguments));
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

  /// 设置是否显示指南针
  Future<void> setCompassEnabled(bool enabled) {
    return _channel.invokeMethod('setCompassEnabled', enabled);
  }

  /// 设置是否显示缩放按钮
  Future<void> setZoomControlsEnabled(bool enabled) {
    return _channel.invokeMethod('setZoomControlsEnabled', enabled);
  }

  /// 设置是否显示比例尺
  Future<void> setScaleBarEnabled(bool enabled) {
    return _channel.invokeMethod('setScaleBarEnabled', enabled);
  }

  Future<Marker> addMarker(MarkerOptions options) async {
    final id = await _channel.invokeMethod('addMarker', options.toMap());
    final marker = Marker(this, id);
    _markers[id] = marker;
    return marker;
  }
}
