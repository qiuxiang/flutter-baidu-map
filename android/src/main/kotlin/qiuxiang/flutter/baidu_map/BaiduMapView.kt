package qiuxiang.flutter.baidu_map

import android.content.Context
import android.view.View
import com.baidu.mapapi.map.MapView
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class BaiduMapView(context: Context) : PlatformView, MethodChannel.MethodCallHandler {
    private val view = MapView(context)

    override fun getView(): View {
        return view
    }

    override fun dispose() {
        view.onDestroy();
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        TODO("Not yet implemented")
    }
}
