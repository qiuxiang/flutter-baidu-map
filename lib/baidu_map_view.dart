import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaiduMapView extends StatefulWidget {
  BaiduMapView({Key key, this.onCreated, this.trafficEnabled})
      : super(key: key);

  final void Function(BaiduMapViewController) onCreated;
  final bool trafficEnabled;

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
        creationParams: {'trafficEnabled': widget.trafficEnabled},
        creationParamsCodec: new StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    return Text('$defaultTargetPlatform is not yet supported');
  }

  @override
  didUpdateWidget(_) {
    super.didUpdateWidget(_);
    if (_.trafficEnabled != widget.trafficEnabled) {
      _controller.setTrafficEnabled(widget.trafficEnabled);
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

  Future<void> setTrafficEnabled(bool enabled) async {
    return _channel.invokeMethod('setTrafficEnabled', enabled);
  }
}
