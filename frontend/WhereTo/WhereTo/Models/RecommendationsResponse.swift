//
//  RecommendationsResponse.swift
//  WhereTo
//
//  Created by Alexis Gutierrez on 6/17/26.
//

import Foundation

struct RecommendationsResponse: Codable {
    let weather: String
    let activities: [Activity]
}
