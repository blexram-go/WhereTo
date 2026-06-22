//
//  RecommendationsViewModel.swift
//  WhereTo
//
//  Created by Brian Ramos on 6/21/26.
//

import Foundation
import Combine

@MainActor
final class RecommendationsViewModel: ObservableObject {
    @Published var weather: Weather?
    @Published var activities: [Activity] = []
    @Published var places: [Place] = []
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadRecommendations(lat: Double, lng: Double) async {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            let response = try await APIService.shared.fetchDiscover(lat: lat, lng: lng)
            
            weather = response.weather
            activities = response.activities
            places = response.places
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
