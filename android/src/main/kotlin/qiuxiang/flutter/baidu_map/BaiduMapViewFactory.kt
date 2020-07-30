package qiuxiang.flutter.baidu_map

import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec.INSTANCE
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class BaiduMapViewFactory(private val messenger: BinaryMessenger)
  : PlatformViewFactory(INSTANCE) {
  override fun create(context: Context, id: Int, args: Any): PlatformView {
    @Suppress("UNCHECKED_CAST")
    return BaiduMapView(messenger, id, args as HashMap<String, Any>)
  }
}