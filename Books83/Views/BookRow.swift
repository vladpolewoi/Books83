//
//  BookRow.swift
//  Books83
//
//  Created by Quest76 on 08.08.2025.
//

import SwiftUI

struct BookRow: View {
    let book: Book
    @State private var showingQuickLog = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Book cover image
            AsyncImage(url: URL(string: book.imageName ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "book")
                            .foregroundColor(.gray)
                            .font(.title2)
                    )
            }
            .frame(width: 60, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Book details
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text("by \(book.author)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Text("\(book.totalPages) pages")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Quick log button
            Button {
                showingQuickLog = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
        .sheet(isPresented: $showingQuickLog) {
            QuickLogView()
        }
    }
}

#Preview {
    BookRow(book: Book.sampleBook)
        .padding()
}
