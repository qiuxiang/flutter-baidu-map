class BaiduMapFactory: NSObject, FlutterPlatformViewFactory {
    let registrar: FlutterPluginRegistrar
    
    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        let view = BaiduMapView(frame, viewId: viewId, messenger: registrar.messenger())
        view.initMapView(args)
        view.initMethodCallHandler()
        return view
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

class BaiduMapView: NSObject, FlutterPlatformView, BMKMapViewDelegate {
    let mapView: BMKMapView
    let channel: FlutterMethodChannel
    
    init(_ frame: CGRect, viewId: Int64, messenger: FlutterBinaryMessenger) {
        mapView = BMKMapView(frame: frame)
        channel = FlutterMethodChannel(name: "BaiduMapView_" + String(viewId), binaryMessenger: messenger)
    }
    
    func initMethodCallHandler() {
        channel.setMethodCallHandler(handle)
    }
    
    func initMapView(_ args: Any?) {
        mapView.delegate = self
        let args = args as? Dictionary<String, Any>
        setMapType(args?["mapType"])
        setMapStatus(args?["mapStatus"])
        setTrafficEnabled(args?["trafficEnabled"])
        setIndoorEnabled(args?["indoorEnabled"])
        setBuildingsEnabled(args?["buildingsEnabled"])
        setBaiduHeatMapEnabled(args?["baiduHeatMapEnabled"])
    }
    
    func setMapType(_ type: Any?) {
        switch (type as? Int) {
        case 1: mapView.mapType = BMKMapType.standard
        case 2: mapView.mapType = BMKMapType.satellite
        case 3: mapView.mapType = BMKMapType.none
        default: ()
        }
    }
    
    func setMapStatus(_ status: Any?, duration: Any? = 0) {
        let duration = duration as? Int32 ?? 0
        let status = status as? Dictionary<String, Any>
        let mapStatus = BMKMapStatus()
        if let it = toCoordinate(status?["center"]) { mapStatus.targetGeoPt = it }
        if let it = status?["zoom"] as? Float { mapStatus.fLevel = it }
        if let it = status?["overlook"] as? Float { mapStatus.fOverlooking = it }
        if let it = status?["rotation"] as? Float { mapStatus.fRotation = it }
        if (duration > 0) {
            mapView.setMapStatus(mapStatus, withAnimation: true, withAnimationTime: duration)
        } else {
            mapView.setMapStatus(mapStatus)
        }
    }
    
    func setTrafficEnabled(_ enabled: Any?) {
        if let it = enabled as? Bool { mapView.isTrafficEnabled = it }
    }
    
    func setIndoorEnabled(_ enabled: Any?) {
        if let it = enabled as? Bool { mapView.baseIndoorMapEnabled = it }
    }
    
    func setBuildingsEnabled(_ enabled: Any?) {
        if let it = enabled as? Bool { mapView.isBuildingsEnabled = it }
    }
    
    func setBaiduHeatMapEnabled(_ enabled: Any?) {
        if let it = enabled as? Bool { mapView.isBaiduHeatMapEnabled = it }
    }
    
    func handle(call: FlutterMethodCall, result: FlutterResult) {
        switch call.method {
        case "setMapType":
            setMapType(call.arguments)
            result(nil)
        case "setMapStatus":
            let args = call.arguments as? Array<Any>
            setMapStatus(args?[0], duration: args?[1])
            result(nil)
        case "setTrafficEnabled":
            setTrafficEnabled(call.arguments)
            result(nil)
        case "setIndoorEnabled":
            setIndoorEnabled(call.arguments)
            result(nil)
        case "setBuildingsEnabled":
            setBuildingsEnabled(call.arguments)
            result(nil)
        case "setBaiduHeatMapEnabled":
            setBaiduHeatMapEnabled(call.arguments)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func view() -> UIView {
        return mapView
    }
    
    func mapView(_ mapView: BMKMapView, onClickedMapBlank coordinate: CLLocationCoordinate2D) {
        channel.invokeMethod("onTap", arguments: toJson(coordinate))
    }
    
    func mapView(_ mapView: BMKMapView, onClickedMapPoi mapPoi: BMKMapPoi) {
        channel.invokeMethod("onTapPoi", arguments: toJson(mapPoi))
    }
    
    func mapView(_ mapView: BMKMapView, regionDidChangeAnimated animated: Bool, reason: BMKRegionChangeReason) {
        channel.invokeMethod("onStatusChanged", arguments: [
            "center": toJson(mapView.centerCoordinate),
            "zoom": mapView.zoomLevel,
            "overlook": Double(mapView.overlooking),
            "rotation": Double(mapView.rotation),
        ])
    }
}
