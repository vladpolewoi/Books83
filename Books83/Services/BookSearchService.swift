//
//  BookSearchService.swift
//  Books83
//
//  Created by Quest76 on 09.08.2025.
//

import Foundation

// MARK: - API Models

struct GoogleBooksResponse: Codable {
    let items: [GoogleBookItem]?
}

struct GoogleBookItem: Codable {
    let id: String
    let volumeInfo: GoogleBookVolumeInfo
    
    var bookInfo: BookInfo {
        BookInfo(
            id: id,
            title: volumeInfo.title ?? "Unknown Title",
            authors: volumeInfo.authors ?? ["Unknown Author"],
            pageCount: volumeInfo.pageCount ?? 0,
            imageURL: volumeInfo.imageLinks?.thumbnail,
            description: volumeInfo.description,
            publishedDate: volumeInfo.publishedDate,
            categories: volumeInfo.categories
        )
    }
}

struct GoogleBookVolumeInfo: Codable {
    let title: String?
    let authors: [String]?
    let pageCount: Int?
    let description: String?
    let publishedDate: String?
    let categories: [String]?
    let imageLinks: GoogleBookImageLinks?
}

struct GoogleBookImageLinks: Codable {
    let thumbnail: String?
    let small: String?
    let medium: String?
    let large: String?
}

// MARK: - App Models

struct BookInfo: Identifiable {
    let id: String
    let title: String
    let authors: [String]
    let pageCount: Int
    let imageURL: String?
    let description: String?
    let publishedDate: String?
    let categories: [String]?
    
    var primaryAuthor: String {
        authors.first ?? "Unknown Author"
    }
    
    var authorsText: String {
        authors.joined(separator: ", ")
    }
}

// MARK: - Service

@MainActor
class BookSearchService: ObservableObject {
    private let baseURL = "https://www.googleapis.com/books/v1/volumes"
    private let session = URLSession.shared
    
    func searchBooks(query: String) async throws -> [BookInfo] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return []
        }
        
        // Encode the query for URL
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)?q=\(encodedQuery)&maxResults=10&printType=books") else {
            throw BookSearchError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw BookSearchError.serverError
        }
        
        let decoder = JSONDecoder()
        let googleResponse = try decoder.decode(GoogleBooksResponse.self, from: data)
        
        return googleResponse.items?.map { $0.bookInfo } ?? []
    }
}

// MARK: - Errors

enum BookSearchError: LocalizedError {
    case invalidURL
    case serverError
    case decodingError
    case noResults
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid search URL"
        case .serverError:
            return "Server error occurred"
        case .decodingError:
            return "Failed to decode response"
        case .noResults:
            return "No books found"
        }
    }
}
