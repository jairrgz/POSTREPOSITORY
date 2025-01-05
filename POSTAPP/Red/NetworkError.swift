//
//  NetworkError.swift
//  POSTAPP
//
//  Created by Jorge Jair Ramirez Gaston Zuloeta on 5/01/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(String)
}
