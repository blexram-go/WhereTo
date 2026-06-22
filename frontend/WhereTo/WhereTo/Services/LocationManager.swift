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
    
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        print("Requesting location authorization...")
        manager.requestWhenInUseAuthorization()
        
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            print("Already authorized")
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        print(
                "Location received:",
                location.coordinate.latitude,
                location.coordinate.longitude
            )
        
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error:", error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(
                "Authorization changed:",
                manager.authorizationStatus.rawValue
            )
        
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location authorized")
            manager.requestLocation()
        case .denied:
            print("Location denied")
        case .restricted:
            print("Location restricted")
        case .notDetermined:
            print("Location not determined")
        default:
            break
        }
    }
}
