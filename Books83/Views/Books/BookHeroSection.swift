//
//  BookHeroSection.swift
//  Books83
//
//  Created by Quest76 on 13.08.2025.
//

import SwiftUI

struct BookHeroSection: View {
    let book: Book
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                // Book cover
                AsyncImage(url: URL(string: book.imageName ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "book")
                                .foregroundColor(.gray)
                                .font(.system(size: 30))
                        )
                }
                .frame(width: 80, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                
                // Book info
                VStack(alignment: .leading, spacing: 8) {
                    Text(book.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    
                    Text("by \(book.author)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("\(book.totalPages) pages")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    // Status badge
                    BookStatusBadge(status: book.status)
                }
                
                Spacer()
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    BookHeroSection(book: Book.sampleBook)
        .padding()
}
