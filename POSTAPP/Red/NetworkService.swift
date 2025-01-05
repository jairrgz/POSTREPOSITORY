//
//  NetworkService.swift
//  POSTAPP
//
//  Created by Jorge Jair Ramirez Gaston Zuloeta on 5/01/25.
//

import Foundation


class NetworkService {
    static let shared = NetworkService()
    private let baseURL = "https://jsonplaceholder.typicode.com"
    
    // Para activar/desactivar mocks
    var isMockEnabled: Bool = false
    
    func createPost(_ post: Post) async throws -> CreatePostResponse {
        // Si los mocks están activados, retorna datos simulados
        if isMockEnabled {
            return try await mockCreatePost(post)
        }
        
        guard let url = URL(string: "\(baseURL)/posts") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(post)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        return try JSONDecoder().decode(CreatePostResponse.self, from: data)
    }
    
    // Función de mock
    private func mockCreatePost(_ post: Post) async throws -> CreatePostResponse {
        // Simulamos delay de red
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        return CreatePostResponse(
            id: Int.random(in: 100...1000),
            title: post.title,
            body: post.body,
            userId: post.userId
        )
    }
    
    func getRandomPost() async throws -> CreatePostResponse {
        if isMockEnabled {
            return try await mockRandomPost()
        }
        
        guard let url = URL(string: "\(baseURL)/posts/\(Int.random(in: 1...100))") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        return try JSONDecoder().decode(CreatePostResponse.self, from: data)
    }
    
    private func mockRandomPost() async throws -> CreatePostResponse {
        // Simulamos delay de red
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let mockPosts = [
            CreatePostResponse(id: 1, title: "¿Qué historia quieres contar hoy?", body: "", userId: 1),
            CreatePostResponse(id: 2, title: "Comparte tu próxima aventura", body: "", userId: 1),
            CreatePostResponse(id: 3, title: "El mundo espera tu historia", body: "", userId: 1)
        ]
        
        return mockPosts.randomElement()!
    }
    
    
    
    
}
