//
//  RecommendationsView.swift
//  WhereTo
//
//  Created by Alexis Gutierrez on 6/14/26.
//

import SwiftUI

struct RecommendationsView: View {
    let activities = [
        "Hiking at a nearby trail",
        "Visit a local park",
        "Outdoor dining",
        "Coffee shop study session"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weather")
                .font(.title2)
                .fontWeight(.bold)

            Text("Sunny • 82°")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("Recommended Activities")
                .font(.title2)
                .fontWeight(.bold)

            List(activities, id: \.self) { activity in
                Text(activity)
            }
        }
        .padding()
        .navigationTitle("Recommendations")
    }
}

#Preview {
    NavigationStack {
        RecommendationsView()
    }
}
