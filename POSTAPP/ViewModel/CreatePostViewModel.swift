//
//  CreatePostViewModel.swift
//  POSTAPP
//
//  Created by Jorge Jair Ramirez Gaston Zuloeta on 5/01/25.
//

import Foundation

@MainActor
class CreatePostViewModel: ObservableObject {
    @Published var title = ""
    @Published var body = ""
    @Published var isLoading = false
    @Published var error: String?
    @Published var successMessage: String?
    @Published var randomTitle: String = ""
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func createPost() async {
        isLoading = true
        do {
            let post = Post(id: 0, title: title, body: body, userId: 1)
            _ = try await networkService.createPost(post)
            successMessage = "¡Publicación creada exitosamente!"
            title = ""
            body = ""
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
    
    func fetchRandomTitle() async {
        do {
            let randomPost = try await networkService.getRandomPost()
            self.randomTitle = randomPost.title
        } catch {
            self.randomTitle = "Crear nueva publicación"
            print("Error fetching random title: \(error)")
        }
    }
    
    
}
