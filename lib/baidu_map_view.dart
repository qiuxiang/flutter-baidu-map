import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const MAP_TYPE_NORMAL = 1;
const MAP_TYPE_SATELLITE = 2;
const MAP_TYPE_NONE = 3;

class LatLng {
  double latitude;
  double longitude;
  LatLng(this.latitude, this.longitude);
  toMap() => {'latitude': latitude, 'longitude': longitude};
}

class MapStatus {
  LatLng target;
  double overlook;
  double rotation;
  double zoom;

  MapStatus({this.target, this.overlook, this.rotation, this.zoom});

  toMap() => {
        'target': target.toMap(),
        'overlook': overlook,
        'rotation': rotation,
        'zoom': zoom,
      };
}

class BaiduMapView extends StatefulWidget {
  BaiduMapView({
    Key key,
    this.onCreated,
    this.mapType,
    this.mapStatus,
    this.trafficEnabled,
    this.indoorEnabled,
    this.baiduHeatMapEnabled,
  }) : super(key: key);

  final void Function(BaiduMapViewController) onCreated;
  final int mapType;
  final MapStatus mapStatus;
  final bool trafficEnabled;
  final bool indoorEnabled;
  final bool baiduHeatMapEnabled;

  @override
  createState() => _BaiduMapViewState();

  toMap() => {
        'mapType': mapType,
        'mapStatus': mapStatus == null ? null : mapStatus.toMap(),
        'trafficEnabled': trafficEnabled,
        'indoorEnabled': indoorEnabled,
        'baiduHeatMapEnabled': baiduHeatMapEnabled,
      };
}

class _BaiduMapViewState extends State<BaiduMapView> {
  BaiduMapViewController _controller;

  @override
  Widget build(context) {
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
    if (widget.mapStatus != null) {
      _controller.setMapStatus(widget.mapStatus);
    }
    if (_.trafficEnabled != widget.trafficEnabled) {
      _controller.setTrafficEnabled(widget.trafficEnabled);
    }
    if (_.indoorEnabled != widget.indoorEnabled) {
      _controller.setIndoorEnabled(widget.indoorEnabled);
    }
    if (_.baiduHeatMapEnabled != widget.baiduHeatMapEnabled) {
      _controller.setBaiduHeatMapEnabled(widget.baiduHeatMapEnabled);
    }
  }

  _onPlatformViewCreated(int id) {
    _controller = BaiduMapViewController(id);
    if (widget.onCreated != null) {
      widget.onCreated(_controller);
    }
  }
}

class BaiduMapViewController {
  final MethodChannel _channel;

  BaiduMapViewController(int id) : _channel = MethodChannel('BaiduMapView_$id');

  Future<void> setMapType(int mapType) async {
    return _channel.invokeMethod('setMapType', mapType);
  }

  Future<void> setMapStatus(MapStatus mapStatus) async {
    return _channel.invokeMethod('setMapStatus', mapStatus.toMap());
  }

  Future<void> setTrafficEnabled(bool enabled) async {
    return _channel.invokeMethod('setTrafficEnabled', enabled);
  }

  Future<void> setIndoorEnabled(bool enabled) async {
    return _channel.invokeMethod('setIndoorEnabled', enabled);
  }

  Future<void> setBaiduHeatMapEnabled(bool enabled) async {
    return _channel.invokeMethod('setBaiduHeatMapEnabled', enabled);
  }
}
