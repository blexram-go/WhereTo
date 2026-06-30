//
//  AuthService.swift
//  WhereTo
//
//  Created by Alexis Gutierrez on 6/28/26.
//

import Foundation

struct AuthUser: Codable {
    let id: String
    let name: String
    let email: String
}

struct AuthResponse: Codable {
    let token: String
    let user: AuthUser
}

final class AuthService {
    static let shared = AuthService()

    private let baseURL = "http://localhost:8080/api/v1"

    private init() {}

    func login(email: String, password: String) async throws -> AuthResponse {
        let body = [
            "email": email,
            "password": password
        ]

        return try await sendAuthRequest(
            endpoint: "/login",
            body: body
        )
    }

    func register(name: String, email: String, password: String) async throws -> AuthResponse {
        let body = [
            "username": name,
            "email": email,
            "password": password
        ]

        return try await sendAuthRequest(
            endpoint: "/register",
            body: body
        )
    }

    private func sendAuthRequest(
        endpoint: String,
        body: [String: String]
    ) async throws -> AuthResponse {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(AuthResponse.self, from: data)
    }
}
