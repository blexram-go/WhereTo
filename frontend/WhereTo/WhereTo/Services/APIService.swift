//
//  APIService.swift
//  WhereTo
//
//  Created by Brian Ramos on 6/21/26.
//

import Foundation

enum APIConfiguration {
    private static let defaultBaseURL = URL(string: "http://localhost:8080/api/v1")!

    static var baseURL: URL {
        if let override = UserDefaults.standard.string(forKey: "api_base_url"),
           let url = normalizedBaseURL(from: override) {
            return url
        }

        if let override = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String,
           let url = normalizedBaseURL(from: override) {
            return url
        }

        return defaultBaseURL
    }

    private static func normalizedBaseURL(from rawValue: String) -> URL? {
        let value = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !value.isEmpty else {
            return nil
        }

        return URL(string: value.trimmingCharacters(in: CharacterSet(charactersIn: "/")))
    }
}

final class APIService {
    static let shared = APIService()

    private let decoder = JSONDecoder()

    private init() {}

    func fetchWeather(lat: Double, lng: Double) async throws -> WeatherResponse {
        try await get(
            "/weather",
            queryItems: coordinateQueryItems(lat: lat, lng: lng)
        )
    }

    func fetchRecommendations(lat: Double, lng: Double) async throws -> RecommendationsResponse {
        try await get(
            "/recommendations",
            queryItems: coordinateQueryItems(lat: lat, lng: lng)
        )
    }

    func fetchPlaces(category: String) async throws -> [Place] {
        try await get(
            "/places",
            queryItems: [
                URLQueryItem(name: "category", value: category)
            ]
        )
    }

    func fetchDiscover(lat: Double, lng: Double) async throws -> DiscoverResponse {
        try await get(
            "/discover",
            queryItems: coordinateQueryItems(lat: lat, lng: lng)
        )
    }

    func fetchPopularPlaces(lat: Double, lng: Double) async throws -> PlacesResponse {
        try await get(
            "/popular-places",
            queryItems: coordinateQueryItems(lat: lat, lng: lng)
        )
    }

    private func get<T: Decodable>(
        _ endpoint: String,
        queryItems: [URLQueryItem] = []
    ) async throws -> T {
        let request = try makeRequest(endpoint: endpoint, queryItems: queryItems)
        let (data, response) = try await URLSession.shared.data(for: request)

        try validate(response: response, data: data, expectedStatusCodes: [200])

        return try decoder.decode(T.self, from: data)
    }

    private func makeRequest(
        endpoint: String,
        queryItems: [URLQueryItem]
    ) throws -> URLRequest {
        let endpoint = endpoint.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let url = APIConfiguration.baseURL.appendingPathComponent(endpoint)

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw URLError(.badURL)
        }

        components.queryItems = queryItems.isEmpty ? nil : queryItems

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let token = UserDefaults.standard.string(forKey: "jwt_token"),
           !token.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }

    private func coordinateQueryItems(lat: Double, lng: Double) -> [URLQueryItem] {
        [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lng", value: String(lng))
        ]
    }

    private func validate(
        response: URLResponse,
        data: Data,
        expectedStatusCodes: Set<Int>
    ) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard expectedStatusCodes.contains(httpResponse.statusCode) else {
            if let apiError = try? decoder.decode(APIError.self, from: data) {
                throw apiError
            }

            throw URLError(.badServerResponse)
        }
    }
}
