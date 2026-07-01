//
//  LocationManager.swift
//  WhereTo
//
//  Created by Brian Ramos on 6/21/26.
//

import Foundation
import CoreLocation
import Combine

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    @Published var latitude: Double?
    @Published var longitude: Double?
    @Published var errorMessage: String?

    private let manager = CLLocationManager()

    override init() {
        super.init()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        errorMessage = nil

        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied:
            errorMessage = "Location permission is turned off. Search for a destination instead."
        case .restricted:
            errorMessage = "Location access is restricted on this device. Search for a destination instead."
        default:
            errorMessage = "Unable to request your current location."
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        errorMessage = nil
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = "Unable to get your current location. Search for a destination instead."
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            errorMessage = nil
            manager.requestLocation()
        case .denied:
            errorMessage = "Location permission is turned off. Search for a destination instead."
        case .restricted:
            errorMessage = "Location access is restricted on this device. Search for a destination instead."
        case .notDetermined:
            errorMessage = nil
        default:
            errorMessage = "Unable to request your current location."
            break
        }
    }
}
