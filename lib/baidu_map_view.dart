import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const MAP_TYPE_NORMAL = 1;
const MAP_TYPE_SATELLITE = 2;
const MAP_TYPE_NONE = 3;

class BaiduMapView extends StatefulWidget {
  BaiduMapView({
    Key key,
    this.onCreated,
    this.mapType,
    this.trafficEnabled,
    this.indoorEnabled,
    this.baiduHeatMapEnabled,
  }) : super(key: key);

  final void Function(BaiduMapViewController) onCreated;
  final int mapType;
  final bool trafficEnabled;
  final bool indoorEnabled;
  final bool baiduHeatMapEnabled;

  @override
  createState() => _BaiduMapViewState();
}

class _BaiduMapViewState extends State<BaiduMapView> {
  BaiduMapViewController _controller;

  @override
  Widget build(context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'BaiduMapView',
        creationParams: {
          'mapType': widget.mapType,
          'trafficEnabled': widget.trafficEnabled,
          'indoorEnabled': widget.indoorEnabled,
          'baiduHeatMapEnabled': widget.baiduHeatMapEnabled,
        },
        creationParamsCodec: new StandardMessageCodec(),
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
