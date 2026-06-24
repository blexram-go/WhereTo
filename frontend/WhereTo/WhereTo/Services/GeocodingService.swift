//
//  GeocodingService.swift
//  WhereTo
//
//  Created by Alexis Gutierrez on 6/24/26.
//

import Foundation
import CoreLocation

final class GeocodingService {
    static let shared = GeocodingService()

    private let geocoder = CLGeocoder()

    private init() {}

    func coordinates(for location: String) async throws -> CLLocationCoordinate2D {
        let placemarks = try await geocoder.geocodeAddressString(location)

        guard let coordinate = placemarks.first?.location?.coordinate else {
            throw URLError(.cannotFindHost)
        }

        return coordinate
    }
}
