//
//  FavoritesView.swift
//  WhereTo
//
//  Created by Alexis Gutierrez on 6/14/26.
//

import SwiftUI

struct FavoritesView: View {
    let favorites = [
        "Outdoor dining",
        "Visit a local park"
    ]

    var body: some View {
        List(favorites, id: \.self) { favorite in
            Text(favorite)
        }
        .navigationTitle("Favorites")
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
    }
}
