//
//  LoginView.swift
//  WhereTo
//
//  Created by Alexis Gutierrez on 6/14/26.
//

import SwiftUI

struct LoginView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var isLoggingIn = false
    @State private var errorMessage: String?
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.blue.opacity(0.28), Color.white],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer()

                    VStack(spacing: 12) {
                        Image("WhereToLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 125, height: 125)
                            .clipShape(RoundedRectangle(cornerRadius: 28))

                        Text("WhereTo")
                            .font(.system(size: 42, weight: .bold))

                        Text("Find activities based on live weather, location, and nearby places.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    VStack(spacing: 14) {
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundStyle(.secondary)

                            TextField("example@email.com", text: $email)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(14)
                        HStack {
                            Image(systemName: "lock")

                            SecureField("Password", text: $password)
                        }
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
                            login()
                        } label: {
                            if isLoggingIn {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                Text("Login")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                        }
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        .disabled(email.isEmpty || password.isEmpty || isLoggingIn)
                        .opacity(email.isEmpty || password.isEmpty ? 0.6 : 1)
                        
                        NavigationLink {
                            CreateAccountView()
                        } label: {
                            Text("Create an account")
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                        
                        Button("Forgot Password?") {

                        }
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(24)
                    .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 5)

                    Spacer()
                }
                .padding()
            }
        }
    }
    
    func login() {
        errorMessage = nil

        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter your email."
            return
        }

        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter a valid email address."
            return
        }

        guard !password.isEmpty else {
            errorMessage = "Please enter your password."
            return
        }

        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters."
            return
        }

        isLoggingIn = true

        Task {
            do {
                // waiting for POST /api/v1/login
                // let response = try await AuthService.shared.login(
                //     email: email,
                //     password: password
                // )

                try await Task.sleep(nanoseconds: 600_000_000)

                isLoggedIn = true
            } catch {
                errorMessage = "Login failed. Please try again."
            }

            isLoggingIn = false
        }    }
}

#Preview {
    LoginView()
}
