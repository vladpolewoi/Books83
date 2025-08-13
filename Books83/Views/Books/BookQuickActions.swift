//
//  BookQuickActions.swift
//  Books83
//
//  Created by Quest76 on 13.08.2025.
//

import SwiftUI

struct BookQuickActions: View {
    let book: Book
    let onBookUpdate: () -> Void
    
    private var canMarkComplete: Bool {
        book.status != .completed && book.currentPage < book.totalPages
    }
    
    private var canResume: Bool {
        book.status == .paused
    }
    
    var body: some View {
        if canMarkComplete || canResume {
            VStack(spacing: 8) {
                Text("Quick Actions")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    if canMarkComplete {
                        QuickActionButton(
                            title: "Mark Complete",
                            icon: "checkmark.circle",
                            color: .green
                        ) {
                            markBookAsComplete()
                        }
                    }
                    
                    if canResume {
                        QuickActionButton(
                            title: "Resume Reading",
                            icon: "play.circle",
                            color: .blue
                        ) {
                            resumeReading()
                        }
                    }
                    
                    if book.status != .paused {
                        QuickActionButton(
                            title: "Pause Reading",
                            icon: "pause.circle",
                            color: .orange
                        ) {
                            pauseReading()
                        }
                    }
                    
                    QuickActionButton(
                        title: "Reset Progress",
                        icon: "arrow.counterclockwise",
                        color: .red
                    ) {
                        resetProgress()
                    }
                    
                    QuickActionButton(
                        title: "Set Goal",
                        icon: "target",
                        color: .purple
                    ) {
                        setReadingGoal()
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    private func markBookAsComplete() {
        book.currentPage = book.totalPages
        book.status = .completed
        onBookUpdate()
    }
    
    private func resumeReading() {
        book.status = .reading
        onBookUpdate()
    }
    
    private func pauseReading() {
        book.status = .paused
        onBookUpdate()
    }
    
    private func resetProgress() {
        book.currentPage = 0
        book.status = .toRead
        onBookUpdate()
    }
    
    private func setReadingGoal() {
        // TODO: Implement reading goal functionality
        onBookUpdate()
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(color.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        BookQuickActions(book: Book.sampleBook) {
            print("Book updated")
        }
        
        BookQuickActions(book: Book(title: "Test", author: "Author", totalPages: 200, currentPage: 0, status: .paused)) {
            print("Paused book updated")
        }
    }
    .padding()
}
