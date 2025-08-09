//
//  Book.swift
//  Books83
//
//  Created by Quest76 on 08.08.2025.
//

import Foundation
import SwiftData

@Model
final class Book {
    var title: String
    var author: String
    var totalPages: Int
    var imageName: String?
    var createdAt: Date
    
    init(title: String, author: String, totalPages: Int, imageName: String? = nil) {
        self.title = title
        self.author = author
        self.totalPages = totalPages
        self.imageName = imageName
        self.createdAt = Date()
    }
}

// MARK: - Mock Data
extension Book {
    static var mockBooks: [Book] {
        [
            Book(title: "To Kill a Mockingbird", author: "Harper Lee", totalPages: 324, imageName: "https://covers.openlibrary.org/b/id/8226442-M.jpg"),
            Book(title: "1984", author: "George Orwell", totalPages: 328, imageName: "https://covers.openlibrary.org/b/id/7222246-M.jpg"),
            Book(title: "Pride and Prejudice", author: "Jane Austen", totalPages: 279, imageName: "https://covers.openlibrary.org/b/id/8091016-M.jpg"),
            Book(title: "The Great Gatsby", author: "F. Scott Fitzgerald", totalPages: 180, imageName: "https://covers.openlibrary.org/b/id/8225261-M.jpg"),
            Book(title: "The Catcher in the Rye", author: "J.D. Salinger", totalPages: 277, imageName: "https://covers.openlibrary.org/b/id/8225262-M.jpg"),
            Book(title: "Brave New World", author: "Aldous Huxley", totalPages: 268, imageName: "https://covers.openlibrary.org/b/id/8091017-M.jpg"),
            Book(title: "Lord of the Flies", author: "William Golding", totalPages: 224, imageName: "https://covers.openlibrary.org/b/id/8091018-M.jpg")
        ]
    }
    
    static var sampleBook: Book {
        mockBooks.randomElement() ?? Book(title: "Sample Book", author: "Sample Author", totalPages: 200)
    }
}
