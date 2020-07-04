package qiuxiang.flutter.baidu_map

import android.content.Context
import com.baidu.mapapi.SDKInitializer
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class BaiduMapFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        SDKInitializer.initialize(context.applicationContext)
        return BaiduMapView(context)
    }
}