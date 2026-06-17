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
            VStack(spacing: 20) {

                Spacer()

                Text("WhereTo")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Find activities based on your location and weather")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)

                NavigationLink {
                    HomeView()
                } label: {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button("Register") {
                    print("Register tapped")
                }

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    LoginView()
}
