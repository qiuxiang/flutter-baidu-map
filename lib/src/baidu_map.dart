import 'package:baidu_map/src/types.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart'
    hide MapType;

import 'pigeon.g.dart';

final _sdkApi = SdkApi();

/// 百度地图组件
class BaiduMap extends StatefulWidget {
  const BaiduMap({
    Key? key,
    this.onMapCreated,
    this.compassEnabled = true,
    this.zoomControlsEnabled = true,
    this.scaleControlsEnabled = true,
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.tiltGesturesEnabled = true,
    this.trafficEnabled = false,
    this.indoorViewEnabled = false,
    this.buildingsEnabled = true,
    this.mapType = MapType.normal,
  }) : super(key: key);

  /// 地图类型 [MapType]
  final int mapType;

  /// 指南针是否显示
  final bool compassEnabled;

  /// 是否显示缩放控件
  final bool zoomControlsEnabled;

  /// 是否显示比例尺控件
  final bool scaleControlsEnabled;

  /// 指南针是否显示
  final bool rotateGesturesEnabled;

  /// 是否允许拖拽手势
  final bool scrollGesturesEnabled;

  /// 是否允许俯视手势
  final bool tiltGesturesEnabled;

  /// 是否打开交通图层
  final bool trafficEnabled;

  /// 是否显示室内图
  ///
  /// 室内图只有在缩放级别 [17， 22] 范围才生效，但是在18级之上（包含18级）才会有楼层边条显示。
  final bool indoorViewEnabled;

  /// 是否允许楼块效果
  final bool buildingsEnabled;

  /// 地图创建完成时调用
  ///
  /// 可以使用参数 [BaiduMapController] 控制地图
  final void Function(BaiduMapController)? onMapCreated;

  @override
  createState() => _BaiduMapState();

  /// 初始化地图 SDK，需要在显示地图前调用
  static Future<void> init(String apiKey) {
    return _sdkApi.init(apiKey);
  }

  /// 获取使用的坐标类型，支持 GCJ02 和 BD09LL 两种坐标的输入输出，默认是 BD09LL 坐标
  static Future<String> getCoordinateType() {
    return _sdkApi.getCoordinateType();
  }

  /// 设置使用的坐标类型，支持 GCJ02 和 BD09LL 两种坐标的输入输出，默认是 BD09LL 坐标
  ///
  /// 参数 [type] 可以使用 [CoordinateType]
  static void setCoordinateType(String type) {
    _sdkApi.setCoordinateType(type);
  }
}

class _BaiduMapState extends State<BaiduMap> {
  final _api = BaiduMapApi();
  late BaiduMapController _controller;

  @override
  build(context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidView(
          viewType: 'BaiduMap',
          onPlatformViewCreated: _onPlatformViewCreated,
        );
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: 'BaiduMap',
          onPlatformViewCreated: _onPlatformViewCreated,
        );
      default:
        return Text('$defaultTargetPlatform is not yet supported');
    }
  }

  @override
  didUpdateWidget(old) {
    super.didUpdateWidget(old);
    if (widget.mapType != old.mapType) {
      _api.setMapType(widget.mapType);
    }
    if (widget.compassEnabled != old.compassEnabled) {
      _api.setCompassEnabled(widget.compassEnabled);
    }
    if (widget.zoomControlsEnabled != old.zoomControlsEnabled) {
      _api.setZoomControlsEnabled(widget.zoomControlsEnabled);
    }
    if (widget.scaleControlsEnabled != old.scaleControlsEnabled) {
      _api.setScaleControlsEnabled(widget.scaleControlsEnabled);
    }
    if (widget.tiltGesturesEnabled != old.tiltGesturesEnabled) {
      _api.setTiltGesturesEnabled(widget.tiltGesturesEnabled);
    }
    if (widget.scrollGesturesEnabled != old.scrollGesturesEnabled) {
      _api.setScrollGesturesEnabled(widget.scrollGesturesEnabled);
    }
    if (widget.rotateGesturesEnabled != old.rotateGesturesEnabled) {
      _api.setRotateGesturesEnabled(widget.rotateGesturesEnabled);
    }
    if (widget.trafficEnabled != old.trafficEnabled) {
      _api.setTrafficEnabled(widget.trafficEnabled);
    }
    if (widget.indoorViewEnabled != old.indoorViewEnabled) {
      _api.setIndoorViewEnabled(widget.indoorViewEnabled);
    }
    if (widget.buildingsEnabled != old.buildingsEnabled) {
      _api.setBuildingsEnabled(widget.buildingsEnabled);
    }
  }

  _onPlatformViewCreated(int id) {
    _controller = BaiduMapController(id, _api);
    widget.onMapCreated?.call(_controller);
    didUpdateWidget(const BaiduMap());
  }
}

/// 地图控制器，提供地图控制接口
class BaiduMapController {
  BaiduMapController(int id, this._api);

  final BaiduMapApi _api;

  void moveCamera(CameraPosition position, [Duration? duration]) {
    _api.moveCamera(position.toMap() as Map, duration?.inMilliseconds ?? 0);
  }
}
