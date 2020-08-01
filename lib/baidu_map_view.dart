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

class MapStatus {
  LatLng target;
  double overlook;
  double rotation;
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

class MapPoi {
  LatLng target;
  String name;
  String id;

  MapPoi({this.target, this.name, this.id});

  MapPoi.fromMap(map)
      : target = LatLng.fromMap(map['target']),
        name = map['name'],
        id = map['id'];
}

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

  final void Function(BaiduMapViewController) onCreated;
  final int mapType;
  final MapStatus mapStatus;
  final bool trafficEnabled;
  final bool indoorEnabled;
  final bool buildingsEnabled;
  final bool baiduHeatMapEnabled;
  final void Function(LatLng) onTap;
  final void Function(MapPoi) onTapPoi;
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

  Future<void> setMapType(int mapType) {
    return _channel.invokeMethod('setMapType', mapType);
  }

  Future<void> setMapStatus(MapStatus mapStatus, {int duration = 0}) {
    return _channel.invokeMethod('setMapStatus', [mapStatus.toMap(), duration]);
  }

  Future<void> setTrafficEnabled(bool enabled) {
    return _channel.invokeMethod('setTrafficEnabled', enabled);
  }

  Future<void> setIndoorEnabled(bool enabled) {
    return _channel.invokeMethod('setIndoorEnabled', enabled);
  }

  Future<void> setBuildingsEnabled(bool enabled) {
    return _channel.invokeMethod('setBuildingsEnabled', enabled);
  }

  Future<void> setBaiduHeatMapEnabled(bool enabled) {
    return _channel.invokeMethod('setBaiduHeatMapEnabled', enabled);
  }
}
