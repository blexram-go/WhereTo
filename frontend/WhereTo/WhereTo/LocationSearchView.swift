//
//  LocationSearchView.swift
//  WhereTo
//
//  Created by Alexis Gutierrez on 6/17/26.
//

import SwiftUI
import CoreLocation

struct DestinationCoordinate: Identifiable, Hashable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
}

struct LocationSearchView: View {
    @State private var location = ""
    @State private var isSearching = false
    @State private var errorMessage: String?
    @State private var destinationCoordinate: DestinationCoordinate?

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.22), Color.white],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text("Search a destination or use your current location.")
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 16) {
                    TextField("Example: Los Angeles", text: $location)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.words)

                    Button {
                        Task {
                            await searchDestination()
                        }
                    } label: {
                        if isSearching {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text("Search Destination")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .background(location.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(14)
                    .disabled(location.isEmpty || isSearching)

                    NavigationLink {
                        RecommendationsView()
                    } label: {
                        Text("Use Current Location")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.85))
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)

                if let errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Where To?")

        .navigationDestination(item: $destinationCoordinate) { coordinate in
            PopularPlacesView(
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude
                )
        }
    }

    func searchDestination() async {
        isSearching = true
        errorMessage = nil

        do {
            let coordinate = try await GeocodingService.shared.coordinates(for: location)

            destinationCoordinate = DestinationCoordinate(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
        } catch {
            errorMessage = "Could not find that destination. Try another search."
        }

        isSearching = false
    }
}

#Preview {
    NavigationStack {
        LocationSearchView()
    }
}
