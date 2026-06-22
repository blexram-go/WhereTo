//
//  DiscoverResponse.swift
//  WhereTo
//

import Foundation

struct DiscoverResponse: Codable {
    let weather: Weather
    let activities: [Activity]
    let places: [Place]
}