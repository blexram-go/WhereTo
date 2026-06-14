//
//  ContentView.swift
//  WhereTo
//
//  Created by Alexis Gutierrez on 6/12/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                Text("WhereTo")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Find activities based on your location and weather.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                VStack(spacing: 16) {
                    NavigationLink {
                        Text("Location Search Screen")
                    } label: {
                        HomeButton(title: "Where To?", icon: "location.fill")
                    }

                    NavigationLink {
                        Text("Weather Recommendations Screen")
                    } label: {
                        HomeButton(title: "What Can I Do In This Weather?", icon: "cloud.sun.fill")
                    }

                    NavigationLink {
                        Text("Favorites Screen")
                    } label: {
                        HomeButton(title: "Favorites", icon: "heart.fill")
                    }
                }

                Spacer()
            }
            .padding()
        }
    }
}

struct HomeButton: View {
    let title: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(title)
                .fontWeight(.semibold)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.blue.opacity(0.15))
        .cornerRadius(12)
    }
}

#Preview {
    ContentView()
}
