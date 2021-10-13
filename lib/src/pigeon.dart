import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/pigeon.g.dart',
    javaOut: 'android/src/main/java/qiuxiang/flutter/baidu_map/Pigeon.java',
    javaOptions: JavaOptions(package: 'qiuxiang.flutter.baidu_map'),
  ),
)
@HostApi()
abstract class SdkApi {
  @async
  String getCoordinateType();
  void setCoordinateType(String type);
  @async
  void init(String apiKey);
}

@HostApi()
abstract class BaiduMapApi {
  void setMapType(int type);
  void setCompassEnabled(bool enabled);
  void setScaleControlsEnabled(bool enabled);
  void setRotateGesturesEnabled(bool enabled);
  void setScrollGesturesEnabled(bool enabled);
  void setZoomControlsEnabled(bool enabled);
  void setZoomGesturesEnabled(bool enabled);
  void setTiltGesturesEnabled(bool enabled);
  void setIndoorViewEnabled(bool enabled);
  void setTrafficEnabled(bool enabled);
  void setBuildingsEnabled(bool enabled);
  void moveCamera(Map position, int duration);
}

@FlutterApi()
abstract class BaiduMapHandler {
  void onTap(List latLng);
  void onTapPoi(Map poi);
  void onLongPress(List latLng);
  void onCameraMoveStarted(Map cameraPosition);
  void onCameraMove(Map cameraPosition);
  void onCameraIdle(Map cameraPosition);
}
