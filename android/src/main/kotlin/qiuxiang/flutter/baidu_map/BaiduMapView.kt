package qiuxiang.flutter.baidu_map

import android.app.Activity
import android.view.View
import com.baidu.mapapi.map.MapView
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class BaiduMapView : PlatformView, MethodChannel.MethodCallHandler {
    private val view = MapView(activity)
    companion object {
        lateinit var activity: Activity
    }

    override fun getView(): View {
        return view
    }

    override fun dispose() {
        view.onDestroy()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        TODO("Not yet implemented")
    }
}
