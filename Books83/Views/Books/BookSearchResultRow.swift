//
//  BookSearchResultRow.swift
//  Books83
//
//  Created by Quest76 on 09.08.2025.
//

import SwiftUI

struct BookSearchResultRow: View {
    let book: BookInfo
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Book cover
                AsyncImage(url: URL(string: book.imageURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .overlay(
                            Image(systemName: "book.closed")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                        )
                }
                .frame(width: 60, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 2)
                
                // Book details
                VStack(alignment: .leading, spacing: 6) {
                    Text(book.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text("by \(book.authorsText)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    
                    HStack {
                        if book.pageCount > 0 {
                            Label("\(book.pageCount) pages", systemImage: "book.pages")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        if let publishedDate = book.publishedDate {
                            Label(String(publishedDate.prefix(4)), systemImage: "calendar")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    // Categories
                    if let categories = book.categories, !categories.isEmpty {
                        Text(categories.prefix(2).joined(separator: " • "))
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                // Selection indicator
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.green)
                } else {
                    Image(systemName: "plus.circle")
                        .font(.title2)
                        .foregroundStyle(.blue)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .green.opacity(0.1) : .clear)
                    .stroke(isSelected ? .green : .clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 16) {
        BookSearchResultRow(
            book: BookInfo(
                id: "1",
                title: "The Great Gatsby",
                authors: ["F. Scott Fitzgerald"],
                pageCount: 180,
                imageURL: "https://covers.openlibrary.org/b/id/8225261-M.jpg",
                description: "A classic American novel",
                publishedDate: "1925",
                categories: ["Fiction", "Classic Literature"]
            ),
            isSelected: false
        ) {
            print("Book tapped")
        }
        
        BookSearchResultRow(
            book: BookInfo(
                id: "2",
                title: "To Kill a Mockingbird",
                authors: ["Harper Lee"],
                pageCount: 324,
                imageURL: "https://covers.openlibrary.org/b/id/8226442-M.jpg",
                description: "A novel about racial injustice",
                publishedDate: "1960",
                categories: ["Fiction", "Drama"]
            ),
            isSelected: true
        ) {
            print("Book tapped")
        }
    }
    .padding()
}
