//
//  APIService.swift
//  WhereTo
//
//  Created by Brian Ramos on 6/21/26.
//

import Foundation

final class APIService {
    static let shared = APIService()
    
    private init() {}
    
    func fetchDiscover(lat: Double, lng: Double) async throws -> DiscoverResponse {
        let urlString = "http://localhost:8080/api/v1/discover?lat=\(lat)&lng=\(lng)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(DiscoverResponse.self, from: data)
     }
}
