//
//  BookRow.swift
//  Books83
//
//  Created by Quest76 on 08.08.2025.
//

import SwiftUI

struct BookRow: View {
    let book: Book
    let showPlusButton: Bool
    @State private var showingQuickLog = false
    
    init(book: Book, showPlusButton: Bool = true) {
        self.book = book
        self.showPlusButton = showPlusButton
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Book cover image
            AsyncImage(url: URL(string: book.imageName ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.cardBackground)
                    .overlay(
                        Image(systemName: "book")
                            .foregroundColor(.secondaryText)
                            .font(.title2)
                    )
            }
            .frame(width: 60, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Book details
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.headline)
                    .foregroundColor(.primaryText)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text("by \(book.author)")
                    .font(.subheadline)
                    .foregroundColor(.secondaryText)
                    .lineLimit(1)
                
                Text("\(book.totalPages) pages")
                    .font(.caption)
                    .foregroundColor(.secondaryText)
            }
            
            Spacer()
            
            // Quick log button
            if showPlusButton {
                Button {
                    showingQuickLog = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.accent)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 4)
        .sheet(isPresented: $showingQuickLog) {
            if showPlusButton {
                QuickLogSheet(preSelectedBook: book)
            }
        }
    }
}

#Preview {
    BookRow(book: Book.sampleBook)
        .padding()
        .background(Color.appBackground)
}
