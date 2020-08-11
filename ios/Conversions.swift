func toCoordinate(_ json: Any?) -> CLLocationCoordinate2D? {
    let json = json as? Dictionary<String, Any>
    if let latitude = json?["latitude"] as? CLLocationDegrees, let longitude = json?["longitude"] as? CLLocationDegrees {
        return CLLocationCoordinate2DMake(latitude, longitude)
    } else {
        return nil
    }
}

func toJson(_ coordinate: CLLocationCoordinate2D) -> Dictionary<String, Any> {
    return [ "latitude": coordinate.latitude, "longitude": coordinate.longitude ]
}

func toJson(_ mapPoi: BMKMapPoi) -> Dictionary<String, Any?> {
    return [ "id": mapPoi.uid, "name": mapPoi.text, "position": toJson(mapPoi.pt) ]
}
