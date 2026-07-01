import Foundation

struct AuthUser: Codable {
    let id: Int64
    let username: String
    let email: String
}

struct AuthResponse: Codable {
    let token: String
    let expiresIn: Int64
    let user: AuthUser

    enum CodingKeys: String, CodingKey {
        case token
        case expiresIn = "expires_in"
        case user
    }
}

struct APIError: Codable, Error, LocalizedError {
    let error: String

    var errorDescription: String? {
        error
    }
}

final class AuthService {
    static let shared = AuthService()

    private let decoder = JSONDecoder()

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

    func register(username: String, email: String, password: String) async throws {
        let body = [
            "username": username,
            "email": email,
            "password": password
        ]

        try await sendRegisterRequest(
            endpoint: "/register",
            body: body
        )
    }

    private func sendRegisterRequest(
        endpoint: String,
        body: [String: String]
    ) async throws {
        var request = try makeJSONRequest(endpoint: endpoint)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard httpResponse.statusCode == 201 else {
            if let apiError = try? decoder.decode(APIError.self, from: data) {
                throw apiError
            }

            throw URLError(.badServerResponse)
        }
    }

    private func sendAuthRequest(
        endpoint: String,
        body: [String: String]
    ) async throws -> AuthResponse {
        var request = try makeJSONRequest(endpoint: endpoint)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
            if let apiError = try? decoder.decode(APIError.self, from: data) {
                throw apiError
            }

            throw URLError(.badServerResponse)
        }

        return try decoder.decode(AuthResponse.self, from: data)
    }

    private func makeJSONRequest(endpoint: String) throws -> URLRequest {
        let endpoint = endpoint.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let url = APIConfiguration.baseURL.appendingPathComponent(endpoint)
        var request = URLRequest(url: url)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        return request
    }
}
