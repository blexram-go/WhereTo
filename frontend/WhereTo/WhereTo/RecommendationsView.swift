//
//  RecommendationsView.swift
//  WhereTo
//
//  Created by Alexis Gutierrez on 6/14/26.
//

import SwiftUI
import Combine

struct RecommendationsView: View {
    let initialLatitude: Double?
    let initialLongitude: Double?

    init(initialLatitude: Double? = nil, initialLongitude: Double? = nil) {
        self.initialLatitude = initialLatitude
        self.initialLongitude = initialLongitude
    }

    @StateObject private var viewModel = RecommendationsViewModel()
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.18), Color.white],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            if viewModel.isLoading {
                ProgressView("Finding things to do...")
            } else if let error = viewModel.errorMessage {
                ErrorView(message: error)
            } else {
                ScrollView {

                    VStack(alignment: .leading, spacing: 20) {
                        if let weather = viewModel.weather {
                            WeatherCard(weather: weather)
                        }

                        SectionHeader(title: "Recommended Activities")

                        ForEach(viewModel.activities) { activity in
                            ActivityCard(activity: activity)
                        }

                        SectionHeader(title: "Nearby Places")

                        ForEach(viewModel.places) { place in
                            PlaceCard(place: place)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Recommendations")
        .task {
            if let lat = initialLatitude, let lng = initialLongitude {
                await viewModel.loadRecommendations(lat: lat, lng: lng)
            } else {
                locationManager.requestLocation()
            }
        }
        .onReceive(locationManager.$latitude.combineLatest(locationManager.$longitude)) { lat, lng in
            guard initialLatitude == nil,
                  initialLongitude == nil,
                  let lat,
                  let lng else { return }

            Task {
                await viewModel.loadRecommendations(lat: lat, lng: lng)
            }
        }
        .refreshable {
            locationManager.requestLocation()
        }
    }
}

struct WeatherCard: View {
    let weather: Weather

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("📍 \(weather.city)")
                .font(.title2)
                .fontWeight(.bold)

            Text(weather.condition)
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("\(Int(weather.temperature))°F")
                .font(.system(size: 44, weight: .bold))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.bold)
    }
}

struct ActivityCard: View {
    let activity: Activity

    @StateObject private var favoritesStore = FavoritesStore.shared

    var favoriteItem: FavoriteItem {
        FavoriteItem(
            id: "activity-\(activity.name)",
            title: activity.name,
            subtitle: activity.description,
            type: .activity
        )
    }

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: "sparkles")
                .foregroundColor(.blue)
                .font(.title2)

            VStack(alignment: .leading, spacing: 6) {
                Text(activity.name)
                    .font(.headline)

                Text(activity.category)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(activity.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {
                if favoritesStore.isFavorite(favoriteItem) {
                    favoritesStore.removeFavorite(favoriteItem)
                } else {
                    favoritesStore.addFavorite(favoriteItem)
                }
            } label: {
                Image(
                    systemName: favoritesStore.isFavorite(favoriteItem)
                    ? "heart.fill"
                    : "heart"
                )
                .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(18)
        .shadow(
            color: Color.black.opacity(0.06),
            radius: 6,
            x: 0,
            y: 3
        )
    }
}

struct PlaceCard: View {
    let place: Place

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(place.name)
                    .font(.headline)

                Spacer()

                Text("⭐ \(place.rating, specifier: "%.1f")")
                    .font(.caption)
            }

            Text(place.category)
                .font(.caption)
                .foregroundColor(.blue)

            Text(place.address)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
    }
}

struct ErrorView: View {
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundColor(.orange)

            Text("Something went wrong")
                .font(.headline)

            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        RecommendationsView()
    }
}
