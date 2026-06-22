//
//  Place.swift
//  WhereTo
//

import Foundation

struct Place: Codable, Identifiable {
    let id = UUID()

    let name: String
    let address: String
    let rating: Double
    let category: String

    enum CodingKeys: String, CodingKey {
        case name
        case address
        case rating
        case category
    }
}