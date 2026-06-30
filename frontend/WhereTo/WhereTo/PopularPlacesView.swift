//
//  PopularPlacesView.swift
//  WhereTo
//
//  Created by Brian Ramos on 6/26/26.
//

import SwiftUI

struct PopularPlacesView: View {

    let latitude: Double
    let longitude: Double

    @StateObject
    private var viewModel = PopularPlacesViewModel()

    var body: some View {

        Group {

            if viewModel.isLoading {

                ProgressView("Loading...")

            } else if let error = viewModel.errorMessage {

                Text(error)

            } else {

                List(viewModel.places) { place in

                    VStack(alignment: .leading) {

                        Text(place.name)
                            .font(.headline)

                        Text(place.address)
                            .font(.caption)

                        Text("⭐ \(place.rating, specifier: "%.1f")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Popular Places")
        .task {

            await viewModel.loadPopularPlaces(
                lat: latitude,
                lng: longitude
            )
        }
    }
}

#Preview {

    NavigationStack {

        PopularPlacesView(
            latitude: 34.0522,
            longitude: -118.2437
        )
    }
}
