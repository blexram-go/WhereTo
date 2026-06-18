//
//  HomeView.swift
//  WhereTo
//
//  Created by Alexis Gutierrez on 6/14/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 20) {

            Text("WhereTo")
                .font(.largeTitle)
                .fontWeight(.bold)

            NavigationLink("Where To?") {
                LocationSearchView()
            }

            NavigationLink("What Can I Do In This Weather?") {
                RecommendationsView()
            }

            NavigationLink("Favorites") {
                FavoritesView()
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
