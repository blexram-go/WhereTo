//
//  GeocodingService.swift
//  WhereTo
//
//  Created by Alexis Gutierrez on 6/24/26.
//

import Foundation
import CoreLocation
import MapKit

final class GeocodingService {
    static let shared = GeocodingService()

    private init() {}

    func coordinates(for location: String) async throws -> CLLocationCoordinate2D {
        guard let request = MKGeocodingRequest(addressString: location) else {
            throw URLError(.badURL)
        }

        let mapItems = try await request.mapItems

        guard let coordinate = mapItems.first?.location.coordinate else {
            throw URLError(.cannotFindHost)
        }

        return coordinate
    }
}
