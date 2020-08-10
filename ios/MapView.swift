
class BaiduMapFactory: NSObject, FlutterPlatformViewFactory {
    let registrar: FlutterPluginRegistrar
    
    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return BaiduMapView(frame: frame, viewId: viewId, args: args)
    }
}

class BaiduMapView: NSObject, FlutterPlatformView {
    let mapView:BMKMapView
    
    init(frame: CGRect, viewId: Int64, args: Any?) {
        mapView = BMKMapView(frame: frame)
    }
    
    func view() -> UIView {
        return mapView
    }
}
