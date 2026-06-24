//
//  HomeView.swift
//  WhereTo
//
//  Created by Alexis Gutierrez on 6/14/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.blue.opacity(0.25), Color.white],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 24) {

                    VStack(spacing: 16) {
                        NavigationLink {
                            LocationSearchView()
                        } label: {
                            FeatureCard(
                                title: "Where To?",
                                subtitle: "Search by destination or current location",
                                icon: "location.fill",
                                color: .blue
                            )
                        }

                        NavigationLink {
                            RecommendationsView()
                        } label: {
                            FeatureCard(
                                title: "Weather Activities",
                                subtitle: "Get ideas based on today's weather",
                                icon: "cloud.sun.fill",
                                color: .orange
                            )
                        }

                        NavigationLink {
                            FavoritesView()
                        } label: {
                            FeatureCard(
                                title: "Favorites",
                                subtitle: "View saved activities",
                                icon: "heart.fill",
                                color: .red
                            )
                        }
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Home")
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct FeatureCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.18))
                    .frame(width: 52, height: 52)

                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    HomeView()
}
