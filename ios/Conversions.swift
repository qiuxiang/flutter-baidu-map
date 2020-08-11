func toCoordinate(_ json: Any?) -> CLLocationCoordinate2D? {
    let json = json as? Dictionary<String, Any>
    if let latitude = json?["latitude"] as? CLLocationDegrees, let longitude = json?["longitude"] as? CLLocationDegrees {
        return CLLocationCoordinate2DMake(latitude, longitude)
    } else {
        return nil
    }
}
