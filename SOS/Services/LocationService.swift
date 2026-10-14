import CoreLocation

import Observation

@Observable
final class LocationService: NSObject, CLLocationManagerDelegate {
    private(set) var location: CLLocation?
    private(set) var address: String?
    private(set) var authorization: CLAuthorizationStatus

    @ObservationIgnored private let manager = CLLocationManager()
    @ObservationIgnored private let geocoder = CLGeocoder()
    @ObservationIgnored private var lastGeocoded: CLLocation?

    override init() {
        authorization = manager.authorizationStatus
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 5
    }

    var isAuthorized: Bool {
        authorization == .authorizedWhenInUse || authorization == .authorizedAlways
    }

    var isDenied: Bool {
        authorization == .denied || authorization == .restricted
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func start() {
        if authorization == .notDetermined {
            requestPermission()
        } else if isAuthorized {
            manager.startUpdatingLocation()
        }
    }

    // MARK: - Formattazione

    var coordinateText: String? {
        guard let c = location?.coordinate else { return nil }
        return String(format: "%.6f, %.6f", c.latitude, c.longitude)
    }

    var accuracyText: String? {
        guard let acc = location?.horizontalAccuracy, acc >= 0 else { return nil }
        return "±\(Int(acc.rounded())) m"
    }

    var mapsURL: URL? {
        guard let c = location?.coordinate else { return nil }
        return URL(string: String(format: "https://maps.google.com/?q=%.6f,%.6f", c.latitude, c.longitude))
    }

    // MARK: - CLLocationManagerDelegate

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorization = manager.authorizationStatus
        if isAuthorized { manager.startUpdatingLocation() }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.last, latest.horizontalAccuracy >= 0 else { return }
        location = latest
        if lastGeocoded.map({ $0.distance(from: latest) > 25 }) ?? true {
            reverseGeocode(latest)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Errori temporanei (es. kCLErrorLocationUnknown): il manager continua a riprovare.
    }

    private func reverseGeocode(_ location: CLLocation) {
        guard !geocoder.isGeocoding else { return }
        lastGeocoded = location
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            guard let self, let placemark = placemarks?.first else { return }
            DispatchQueue.main.async {
                self.address = Self.format(placemark)
            }
        }
    }

    private static func format(_ placemark: CLPlacemark) -> String? {
        let street = [placemark.thoroughfare, placemark.subThoroughfare].compactMap { $0 }.joined(separator: " ")
        let city = [placemark.postalCode, placemark.locality].compactMap { $0 }.joined(separator: " ")
        let parts = [street.isEmpty ? placemark.name : street, city.isEmpty ? nil : city, placemark.country]
        let text = parts.compactMap { $0 }.filter { !$0.isEmpty }.joined(separator: ", ")
        return text.isEmpty ? nil : text
    }
}
