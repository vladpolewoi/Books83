//
//  ReadingLog.swift
//  Books83
//
//  Created by Quest76 on 08.08.2025.
//

import Foundation
import SwiftData

@Model
final class ReadingLog {
    var book: Book
    var pagesRead: Int
    var readingTimeMinutes: Int?
    var logDate: Date
    var notes: String?
    
    init(book: Book, pagesRead: Int, readingTimeMinutes: Int? = nil, notes: String? = nil) {
        self.book = book
        self.pagesRead = pagesRead
        self.readingTimeMinutes = readingTimeMinutes
        self.logDate = Date()
        self.notes = notes
    }
}

// MARK: - Computed Properties
extension ReadingLog {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: logDate)
    }
    
    var readingTimeText: String {
        guard let minutes = readingTimeMinutes else { return "Time not logged" }
        if minutes < 60 {
            return "\(minutes) min"
        } else {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            if remainingMinutes == 0 {
                return "\(hours)h"
            } else {
                return "\(hours)h \(remainingMinutes)m"
            }
        }
    }
}

// MARK: - Mock Data
extension ReadingLog {
    static var mockLogs: [ReadingLog] {
        let mockBooks = Book.mockBooks
        return [
            ReadingLog(book: mockBooks[0], pagesRead: 25, readingTimeMinutes: 45),
            ReadingLog(book: mockBooks[1], pagesRead: 18, readingTimeMinutes: 30),
            ReadingLog(book: mockBooks[2], pagesRead: 32, readingTimeMinutes: nil),
        ]
    }
}
