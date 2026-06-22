//
//  Weather.swift
//  WhereTo
//

import Foundation

struct Weather: Codable {
    let temperature: Double
    let condition: String
    let city: String
}