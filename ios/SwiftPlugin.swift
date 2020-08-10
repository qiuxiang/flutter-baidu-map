public class SwiftPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "BaiduMap", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(SwiftPlugin(), channel: channel)
        registrar.register(BaiduMapFactory(registrar: registrar), withId: "BaiduMapView")
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "init":
            let manager = BMKMapManager()
            if (manager.start(call.arguments as? String, generalDelegate: nil)) {
                result(nil)
            } else {
                result(FlutterError(code: "授权失败", message: nil, details: nil))
            }
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
}
