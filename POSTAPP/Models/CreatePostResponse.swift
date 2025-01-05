//
//  CreatePostResponse.swift
//  POSTAPP
//
//  Created by Jorge Jair Ramirez Gaston Zuloeta on 5/01/25.
//

import Foundation

struct CreatePostResponse: Codable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}
