//
//  ReadingProgressCard.swift
//  Books83
//
//  Created by Quest76 on 13.08.2025.
//

import SwiftUI

struct ReadingProgressCard: View {
    let book: Book
    let progress: Double
    let estimatedTime: String
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Reading Progress")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Text("\(book.currentPage) / \(book.totalPages)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray5))
                        .frame(height: 12)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [.blue, .cyan],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 12)
                        .animation(.easeInOut(duration: 0.5), value: progress)
                }
            }
            .frame(height: 12)
            
            HStack {
                Text("\(Int(progress * 100))% complete")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if estimatedTime != "Completed" && estimatedTime != "Unknown" {
                    Text("~\(estimatedTime) left")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text(estimatedTime)
                        .font(.caption)
                        .foregroundColor(estimatedTime == "Completed" ? .green : .secondary)
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    VStack(spacing: 16) {
        ReadingProgressCard(
            book: Book.sampleBook,
            progress: 0.6,
            estimatedTime: "2.5h"
        )
        
        ReadingProgressCard(
            book: Book(title: "Sample", author: "Author", totalPages: 300, currentPage: 300, status: .completed),
            progress: 1.0,
            estimatedTime: "Completed"
        )
    }
    .padding()
}
