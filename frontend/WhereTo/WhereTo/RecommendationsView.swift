//
//  RecommendationsView.swift
//  WhereTo
//
//  Created by Alexis Gutierrez on 6/14/26.
//

import SwiftUI

struct RecommendationsView: View {
    @State private var weather: WeatherResponse?
    @State private var activities: [Activity] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if isLoading {
                ProgressView("Loading recommendations...")
                    .frame(maxWidth: .infinity, alignment: .center)
            } else if let errorMessage {
                Text("Could not load recommendations")
                    .font(.headline)

                Text(errorMessage)
                    .foregroundStyle(.secondary)
            } else {
                Text("Weather")
                    .font(.title2)
                    .fontWeight(.bold)

                if let weather {
                    Text("\(weather.condition) • \(weather.temperature)°")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                } else {
                    Text("No weather loaded yet")
                        .foregroundStyle(.secondary)
                }

                Text("Recommended Activities")
                    .font(.title2)
                    .fontWeight(.bold)

                List(activities) { activity in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(activity.name)
                            .font(.headline)

                        Text(activity.category)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text(activity.description)
                            .font(.body)
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Recommendations")
        .task {
            await loadData()
        }
    }

    func loadData() async {
        isLoading = true
        errorMessage = nil

        do {
            async let weatherResult = APIService.shared.fetchWeather()
            async let recommendationsResult = APIService.shared.fetchRecommendations()

            weather = try await weatherResult
            activities = try await recommendationsResult.activities
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

#Preview {
    NavigationStack {
        RecommendationsView()
    }
}
