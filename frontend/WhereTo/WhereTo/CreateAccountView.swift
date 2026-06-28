//
//  CreateAccountView.swift
//  WhereTo
//
//  Created by Alexis Gutierrez on 6/27/26.
//

import SwiftUI

struct CreateAccountView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.25), Color.white],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 18) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Start finding activities near you.")
                    .foregroundStyle(.secondary)

                VStack(spacing: 14) {
                    TextField("Name", text: $name)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(14)

                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(14)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(14)

                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(14)

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }

                    Button {
                        createAccount()
                    } label: {
                        Text("Create Account")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.75))
                .cornerRadius(24)
                .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 5)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Register")
    }

    func createAccount() {
        errorMessage = nil

        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter your name."
            return
        }

        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter a valid email."
            return
        }

        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters."
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        isLoggedIn = true
    }
}

#Preview {
    NavigationStack {
        CreateAccountView()
    }
}
