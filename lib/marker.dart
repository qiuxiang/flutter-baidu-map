part of baidu_map;

/// 地图标记覆盖物
class MarkerOptions {
  const MarkerOptions({@required this.position, this.asset});

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
