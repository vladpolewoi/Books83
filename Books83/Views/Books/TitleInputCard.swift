import SwiftUI

struct TitleInputCard: View {
    @Binding var titleText: String
    @Binding var isSearching: Bool
    let searchResults: [BookInfo]
    let onBookSelected: (BookInfo) -> Void
    let onClearSelection: () -> Void
    let selectedBook: BookInfo?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with icon
            HStack {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(.green.opacity(0.15))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: selectedBook != nil ? "checkmark.circle.fill" : "book.closed")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(selectedBook != nil ? .green : .green)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Book Title")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text(selectedBook != nil ? "Selected from search" : "Type to search or add manually")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                if selectedBook != nil {
                    Button("Change") {
                        onClearSelection()
                    }
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.blue)
                }
            }
            .padding(.top, 24)
            .padding(.horizontal, 24)
            
            // Input Area
            VStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [.green.opacity(0.05), .mint.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .stroke(
                            LinearGradient(
                                colors: selectedBook != nil ? [.green.opacity(0.5), .mint.opacity(0.5)] : [.green.opacity(0.3), .mint.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: selectedBook != nil ? 2 : 1.5
                        )
                        .frame(minHeight: 50)
                    
                    HStack {
                        TextField("Enter book title", text: $titleText)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(.primary)
                            .disabled(selectedBook != nil)
                        
                        if isSearching {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else if !titleText.isEmpty && selectedBook == nil {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                
                // Selected Book Preview
                if let book = selectedBook {
                    selectedBookPreview(book)
                }
                
                // Search Results
                if !searchResults.isEmpty && selectedBook == nil {
                    searchResultsView
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
        }
        .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
    
    private func selectedBookPreview(_ book: BookInfo) -> some View {
        HStack(spacing: 12) {
            // Book cover
            AsyncImage(url: URL(string: book.imageURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.quaternary)
                    .overlay(
                        Image(systemName: "book.closed")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    )
            }
            .frame(width: 40, height: 52)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 2)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(book.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                Text(book.authorsText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
                .font(.title3)
        }
        .padding()
        .background(.green.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.green.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var searchResultsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Found \(searchResults.count) books")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)
            
            LazyVStack(spacing: 6) {
                ForEach(searchResults.prefix(3)) { book in
                    searchResultRow(book)
                }
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
    
    private func searchResultRow(_ book: BookInfo) -> some View {
        Button {
            onBookSelected(book)
        } label: {
            HStack(spacing: 10) {
                AsyncImage(url: URL(string: book.imageURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.quaternary)
                        .overlay(
                            Image(systemName: "book.closed")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        )
                }
                .frame(width: 24, height: 32)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                
                VStack(alignment: .leading, spacing: 1) {
                    Text(book.title)
                        .font(.caption)
                        .fontWeight(.medium)
                        .lineLimit(1)
                    
                    Text(book.authorsText)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Image(systemName: "plus.circle")
                    .font(.caption)
                    .foregroundStyle(.blue)
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .background(.clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
}

#Preview {
    VStack(spacing: 20) {
        TitleInputCard(
            titleText: .constant(""),
            isSearching: .constant(false),
            searchResults: [],
            onBookSelected: { _ in },
            onClearSelection: { },
            selectedBook: nil
        )
        
        TitleInputCard(
            titleText: .constant("The Great Gatsby"),
            isSearching: .constant(false),
            searchResults: [],
            onBookSelected: { _ in },
            onClearSelection: { },
            selectedBook: BookInfo(
                id: "1",
                title: "The Great Gatsby",
                authors: ["F. Scott Fitzgerald"],
                pageCount: 180,
                imageURL: nil,
                description: nil,
                publishedDate: "1925",
                categories: nil
            )
        )
    }
    .padding()
}
