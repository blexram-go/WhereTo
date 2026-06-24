//
//  LoginView.swift
//  WhereTo
//
//  Created by Alexis Gutierrez on 6/14/26.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.blue.opacity(0.25), Color.white],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 22) {
                    Spacer()

                    Image("WhereToLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                    
                    Text("WhereTo")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Find activities based on your location and weather.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    VStack(spacing: 14) {
                        TextField("Email", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)

                        SecureField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                    }

                    NavigationLink {
                        HomeView()
                    } label: {
                        Text("Login")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }

                    Button("Register") {
                        print("Register tapped")
                    }
                    .foregroundColor(.blue)

                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    LoginView()
}
