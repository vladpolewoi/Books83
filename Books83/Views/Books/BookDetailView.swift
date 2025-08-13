//
//  BookDetailView.swift
//  Books83
//
//  Created by Quest76 on 13.08.2025.
//

import SwiftUI
import SwiftData

struct BookDetailView: View {
    let book: Book
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query private var allReadingLogs: [ReadingLog]
    @State private var showingQuickLog = false
    @State private var showingEditBook = false
    @State private var showingDeleteAlert = false
    
    private var bookLogs: [ReadingLog] {
        allReadingLogs.filter { $0.book.id == book.id }
            .sorted { $0.logDate > $1.logDate }
    }
    
    private var readingProgress: Double {
        guard book.totalPages > 0 else { return 0 }
        return Double(book.currentPage) / Double(book.totalPages)
    }
    
    private var bookStats: BookStats {
        BookStats(
            totalPagesRead: bookLogs.reduce(0) { $0 + $1.pagesRead },
            totalReadingTime: bookLogs.compactMap(\.readingTimeMinutes).reduce(0, +),
            logCount: bookLogs.count
        )
    }
    
    private var averageReadingSpeed: Double {
        guard bookStats.totalReadingTime > 0 && bookStats.totalPagesRead > 0 else { return 0 }
        return Double(bookStats.totalPagesRead) / (Double(bookStats.totalReadingTime) / 60.0) // pages per hour
    }
    
    private var estimatedTimeToFinish: String {
        guard averageReadingSpeed > 0 && book.currentPage < book.totalPages else {
            return book.status == .completed ? "Completed" : "Unknown"
        }
        
        let remainingPages = book.totalPages - book.currentPage
        let hoursNeeded = Double(remainingPages) / averageReadingSpeed
        
        if hoursNeeded < 1 {
            return "\(Int(hoursNeeded * 60))m"
        } else if hoursNeeded < 24 {
            return "\(String(format: "%.1f", hoursNeeded))h"
        } else {
            let days = Int(hoursNeeded / 24)
            return "\(days)d"
        }
    }
    
    var body: some View {
        ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.systemGray6).opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Hero section with book cover and basic info
                        BookHeroSection(book: book)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
                        
                        // Reading progress section
                        ReadingProgressCard(
                            book: book,
                            progress: readingProgress,
                            estimatedTime: estimatedTimeToFinish
                        )
                        
                        // Statistics grid
                        BookStatisticsGrid(
                            stats: bookStats,
                            averageSpeed: averageReadingSpeed
                        )
                        
                        // Recent reading logs
                        RecentLogsSection(logs: Array(bookLogs.prefix(5)))
                        
                        // Action buttons
                        BookActionButtons(
                            showingQuickLog: $showingQuickLog,
                            showingEditBook: $showingEditBook,
                            book: book
                        )
                        
                        // Quick actions at bottom
                        BookQuickActions(book: book) {
                            // SwiftData will automatically update the view
                        }
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
        }
        .navigationTitle("Book Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Edit Book", systemImage: "pencil") {
                        showingEditBook = true
                    }
                    
                    Button("Delete Book", systemImage: "trash", role: .destructive) {
                        showingDeleteAlert = true
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingQuickLog) {
            QuickLogSheet(preSelectedBook: book)
        }
        .sheet(isPresented: $showingEditBook) {
            EditBookView(book: book)
        }
        .alert("Delete Book", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteBook()
            }
        } message: {
            Text("Are you sure you want to delete this book? This will also delete all reading logs associated with it.")
        }
    }
    
    private func deleteBook() {
        // Delete all logs for this book first
        for log in bookLogs {
            modelContext.delete(log)
        }
        
        // Delete the book
        modelContext.delete(book)
        
        dismiss()
    }
}

// MARK: - Supporting Types
struct BookStats {
    let totalPagesRead: Int
    let totalReadingTime: Int
    let logCount: Int
}

#Preview {
    BookDetailView(book: Book.sampleBook)
        .modelContainer(mockContainer())
}
