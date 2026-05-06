import CoreLocation
import Combine

/// Async wrapper around CLLocationManager.
/// Equivalent of Kotlin's getCurrentLocation() suspending function.
@MainActor
final class LocationHelper: NSObject, ObservableObject {

    private let manager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<CLLocation?, Never>?

    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var locationDenied = false

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        authorizationStatus = manager.authorizationStatus
    }

    /// Requests the current one-shot location.
    /// Returns nil if permission is denied or location fails.
    func requestCurrentLocation() async -> CLLocation? {
        switch manager.authorizationStatus {
        case .denied, .restricted:
            locationDenied = true
            return nil
        default:
            break
        }
        return await withCheckedContinuation { [weak self] continuation in
            self?.locationContinuation = continuation
            if self?.manager.authorizationStatus == .notDetermined {
                self?.manager.requestWhenInUseAuthorization()
            } else {
                self?.manager.requestLocation()
            }
        }
    }
}

extension LocationHelper: CLLocationManagerDelegate {
    nonisolated func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        Task { @MainActor [weak self] in
            self?.locationContinuation?.resume(returning: locations.first)
            self?.locationContinuation = nil
        }
    }

    nonisolated func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        Task { @MainActor [weak self] in
            self?.locationContinuation?.resume(returning: nil)
            self?.locationContinuation = nil
        }
    }

    nonisolated func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        Task { @MainActor in
            self.authorizationStatus = self.manager.authorizationStatus
            switch self.manager.authorizationStatus {
            case .denied, .restricted:
                self.locationDenied = true
                self.locationContinuation?.resume(returning: nil)
                self.locationContinuation = nil
            case .authorizedWhenInUse, .authorizedAlways:
                self.manager.requestLocation()
            default:
                break
            }
        }
    }
}
