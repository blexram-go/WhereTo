//
//  FavoritesStore.swift
//  WhereTo
//
//  Created by Alexis Gutierrez on 6/24/26.
//

import Foundation
import Combine

@MainActor
final class FavoritesStore: ObservableObject {
    static let shared = FavoritesStore()

    @Published private(set) var favorites: [FavoriteItem] = []

    private let storageKey = "favorite_items"

    private init() {
        loadFavorites()
    }

    func addFavorite(_ item: FavoriteItem) {
        guard !favorites.contains(where: { $0.id == item.id }) else { return }

        favorites.append(item)
        saveFavorites()
    }

    func removeFavorite(_ item: FavoriteItem) {
        favorites.removeAll { $0.id == item.id }
        saveFavorites()
    }

    func isFavorite(_ item: FavoriteItem) -> Bool {
        favorites.contains { $0.id == item.id }
    }

    private func saveFavorites() {
        do {
            let data = try JSONEncoder().encode(favorites)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Failed to save favorites:", error)
        }
    }

    private func loadFavorites() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }

        do {
            favorites = try JSONDecoder().decode([FavoriteItem].self, from: data)
        } catch {
            print("Failed to load favorites:", error)
        }
    }
}

struct FavoriteItem: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let type: FavoriteType
}

enum FavoriteType: String, Codable {
    case activity
    case place
}
