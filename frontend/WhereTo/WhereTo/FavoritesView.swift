//
//  FavoritesView.swift
//  WhereTo
//
//  Created by Alexis Gutierrez on 6/14/26.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoritesStore = FavoritesStore.shared

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.red.opacity(0.14), Color.white],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            if favoritesStore.favorites.isEmpty {
                VStack(spacing: 14) {
                    Image(systemName: "heart")
                        .font(.system(size: 56))
                        .foregroundColor(.red)

                    Text("No Favorites Yet")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("Save activities from the recommendations screen and they’ll appear here.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {

                        ForEach(favoritesStore.favorites) { item in
                            FavoriteCard(item: item)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Favorites")
    }
}

struct FavoriteCard: View {
    let item: FavoriteItem
    @StateObject private var favoritesStore = FavoritesStore.shared

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: item.type == .activity ? "sparkles" : "mappin.circle.fill")
                .foregroundColor(item.type == .activity ? .blue : .red)
                .font(.title2)

            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.headline)

                Text(item.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(item.type.rawValue.capitalized)
                    .font(.caption)
                    .foregroundColor(.blue)
            }

            Spacer()

            Button {
                favoritesStore.removeFavorite(item)
            } label: {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
    }
}
