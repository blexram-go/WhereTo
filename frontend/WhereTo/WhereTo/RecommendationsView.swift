//
//  RecommendationsView.swift
//  WhereTo
//
//  Created by Alexis Gutierrez on 6/14/26.
//

import SwiftUI
import Combine

struct RecommendationsView: View {

    @StateObject
    private var viewModel = RecommendationsViewModel()
    
    @StateObject
    private var locationManager = LocationManager()

    var body: some View {

        VStack(alignment: .leading) {

            if viewModel.isLoading {

                VStack(spacing: 12) {

                    ProgressView()

                    Text("Loading recommendations...")
                        .foregroundColor(.secondary)
                }

                Spacer()

            } else if let error = viewModel.errorMessage {

                VStack {

                    Text(error)
                        .foregroundColor(.red)
                        .padding()

                    Spacer()
                }

            } else {

                if let weather = viewModel.weather {

                    VStack(alignment: .leading, spacing: 8) {

                        Text("📍 \(weather.city)")
                            .font(.title)
                            .fontWeight(.bold)

                        Text(weather.condition)
                            .font(.headline)

                        Text("\(Int(weather.temperature))°F")
                            .font(.largeTitle)
                            .fontWeight(.semibold)

                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }

                List {

                    Section("Recommended Activities") {

                        ForEach(viewModel.activities) { activity in

                            VStack(
                                alignment: .leading,
                                spacing: 4
                            ) {

                                Text(activity.name)
                                    .font(.headline)

                                Text(activity.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }

                    Section("Places") {

                        ForEach(viewModel.places) { place in

                            VStack(
                                alignment: .leading,
                                spacing: 4
                            ) {

                                Text(place.name)
                                    .font(.headline)

                                Text(place.category)
                                    .font(.caption2)
                                    .foregroundColor(.blue)

                                Text(place.address)
                                    .font(.caption)
                                    .foregroundColor(.secondary)

                                Text("⭐ \(place.rating, specifier: "%.1f")")
                                    .font(.caption)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
        .task {
            locationManager.requestLocation()
        }
        .onReceive(locationManager.$latitude.combineLatest(locationManager.$longitude)) { lat, lng in
            
            guard let lat = lat,
                  let lng = lng else { return }
            
            Task {
                await viewModel.loadRecommendations(lat: lat, lng: lng)
            }
        }
        .refreshable {
            locationManager.requestLocation()
        }
        .navigationTitle("Recommendations")
    }
}

#Preview {
    NavigationStack {
        RecommendationsView()
    }
}
