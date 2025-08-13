//
//  Preview+MockData.swift
//  Books83
//
//  Created by Quest76 on 09.08.2025.
//

import Foundation
import SwiftData

@MainActor func mockContainer() -> ModelContainer {
    let container = try! ModelContainer(
        for: Book.self, ReadingLog.self,
        configurations: .init(isStoredInMemoryOnly: true)
    )
    let context = container.mainContext
    
    // Insert sample books with diverse statuses and realistic progress
    let book1 = Book(title: "To Kill a Mockingbird", author: "Harper Lee", totalPages: 324, currentPage: 55, status: .reading, imageName: "https://covers.openlibrary.org/b/id/8226442-M.jpg")
    let book2 = Book(title: "1984", author: "George Orwell", totalPages: 328, currentPage: 40, status: .reading, imageName: "https://covers.openlibrary.org/b/id/7222246-M.jpg")
    let book3 = Book(title: "Pride and Prejudice", author: "Jane Austen", totalPages: 279, currentPage: 32, status: .paused, imageName: "https://covers.openlibrary.org/b/id/8091016-M.jpg")
    let book4 = Book(title: "The Great Gatsby", author: "F. Scott Fitzgerald", totalPages: 180, currentPage: 180, status: .completed, imageName: "https://covers.openlibrary.org/b/id/8225261-M.jpg")
    let book5 = Book(title: "The Catcher in the Rye", author: "J.D. Salinger", totalPages: 277, currentPage: 40, status: .reading, imageName: "https://covers.openlibrary.org/b/id/8225262-M.jpg")
    let book6 = Book(title: "Brave New World", author: "Aldous Huxley", totalPages: 268, currentPage: 0, status: .toRead, imageName: "https://covers.openlibrary.org/b/id/8091017-M.jpg")
    let book7 = Book(title: "Lord of the Flies", author: "William Golding", totalPages: 224, currentPage: 0, status: .toRead, imageName: "https://covers.openlibrary.org/b/id/8091018-M.jpg")
    
    context.insert(book1)
    context.insert(book2)
    context.insert(book3)
    context.insert(book4)
    context.insert(book5)
    context.insert(book6)
    context.insert(book7)
    
    // Insert sample reading logs
    context.insert(ReadingLog(book: book1, pagesRead: 25, readingTimeMinutes: 45, notes: "Great opening chapter"))
    context.insert(ReadingLog(book: book1, pagesRead: 30, readingTimeMinutes: 50, notes: "Character development is excellent"))
    context.insert(ReadingLog(book: book2, pagesRead: 18, readingTimeMinutes: 30))
    context.insert(ReadingLog(book: book2, pagesRead: 22, readingTimeMinutes: 35, notes: "Winston's struggle begins"))
    context.insert(ReadingLog(book: book3, pagesRead: 32, readingTimeMinutes: nil, notes: "Elizabeth's wit is delightful"))
    context.insert(ReadingLog(book: book4, pagesRead: 15, readingTimeMinutes: 25))
    context.insert(ReadingLog(book: book5, pagesRead: 40, readingTimeMinutes: 60, notes: "Holden's voice is so distinctive"))
    
    return container
}
