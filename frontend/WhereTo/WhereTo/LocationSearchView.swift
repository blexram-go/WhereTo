//
//  LocationSearchView.swift
//  WhereTo
//
//  Created by Alexis Gutierrez on 6/17/26.
//

import SwiftUI

struct LocationSearchView: View {
    @State private var location = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Where To?")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Enter a destination or use current location to find nearby activities.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            TextField("Example: Los Angeles", text: $location)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.words)
            
            NavigationLink {
                RecommendationsView()
            } label: {
                Text("Use Current Location")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.opacity(0.85))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Where To?")
    }
}

#Preview {
    NavigationStack {
        LocationSearchView()
    }
}
