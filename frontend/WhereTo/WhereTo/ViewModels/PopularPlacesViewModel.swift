//
//  PopularPlacesViewModel.swift
//  WhereTo
//
//  Created by Brian Ramos on 6/26/26.
//

import Foundation
import Combine

@MainActor
final class PopularPlacesViewModel: ObservableObject {

    @Published var places: [Place] = []

    @Published var isLoading = false

    @Published var errorMessage: String?

    func loadPopularPlaces(
        lat: Double,
        lng: Double
    ) async {

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {

            let response =
                try await APIService.shared.fetchPopularPlaces(
                    lat: lat,
                    lng: lng
                )

            places = response.places

        } catch {

            errorMessage = error.localizedDescription

        }
    }
}
