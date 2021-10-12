package qiuxiang.flutter.baidu_map

import android.content.Context
import com.baidu.mapapi.CoordType
import com.baidu.mapapi.SDKInitializer

class BaiduMapSdkApi(private val context: Context) :
  Pigeon.SdkApi {
  override fun getCoordinateType(result: Pigeon.Result<String>) {
    result.success(SDKInitializer.getCoordType().name)
  }

  override fun setCoordinateType(type: String) {
    SDKInitializer.setCoordType(CoordType.valueOf(type))
  }

  override fun init(apiKey: String, result: Pigeon.Result<Void>) {
    SDKInitializer.setApiKey(apiKey)
    SDKInitializer.initialize(context)
    result.success(null)
  }
}