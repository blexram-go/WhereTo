//
//  APIService.swift
//  WhereTo
//
//  Created by Alexis Gutierrez on 6/17/26.
//

import Foundation

struct WeatherResponse: Codable {
    let temperature: Int
    let condition: String
    let city: String
}

struct Activity: Codable, Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case name
        case category
        case description
    }
}

struct RecommendationsResponse: Codable {
    let weather: String
    let activities: [Activity]
}

class APIService {
    static let shared = APIService()

    private let baseURL = "http://localhost:8080/api/v1"

    private init() {}

    func fetchWeather() async throws -> WeatherResponse {
        guard let url = URL(string: "\(baseURL)/weather") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }

    func fetchRecommendations() async throws -> RecommendationsResponse {
        guard let url = URL(string: "\(baseURL)/recommendations") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(RecommendationsResponse.self, from: data)
    }
}
