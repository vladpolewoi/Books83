import SwiftUI

struct SearchResultsCard: View {
    let searchResults: [BookInfo]
    let onBookSelected: (BookInfo) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(.blue.opacity(0.15))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.blue)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Search Results")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Found \(searchResults.count) matching books")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                Text("\(searchResults.count)")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
            }
            .padding(.top, 24)
            .padding(.horizontal, 24)
            
            // Results List
            VStack(spacing: 8) {
                ForEach(searchResults.prefix(5)) { book in
                    searchResultRow(book)
                }
                
                if searchResults.count > 5 {
                    Text("+ \(searchResults.count - 5) more results")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 8)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
        .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
    
    private func searchResultRow(_ book: BookInfo) -> some View {
        Button {
            onBookSelected(book)
        } label: {
            HStack(spacing: 12) {
                // Book cover
                AsyncImage(url: URL(string: book.imageURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.quaternary)
                        .overlay(
                            Image(systemName: "book.closed")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        )
                }
                .frame(width: 32, height: 42)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .shadow(radius: 1)
                
                // Book info
                VStack(alignment: .leading, spacing: 3) {
                    Text(book.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text("by \(book.authorsText)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    
                    if book.pageCount > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "book.pages")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                            Text("\(book.pageCount) pages")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
                
                Spacer()
                
                // Add button
                ZStack {
                    Circle()
                        .fill(.blue.opacity(0.1))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.blue)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(.clear)
            .contentShape(Rectangle())
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.clear)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.clear)
                    )
            )
        }
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.regularMaterial.opacity(0.5))
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        SearchResultsCard(
            searchResults: [
                BookInfo(
                    id: "1",
                    title: "The Great Gatsby",
                    authors: ["F. Scott Fitzgerald"],
                    pageCount: 180,
                    imageURL: nil,
                    description: nil,
                    publishedDate: "1925",
                    categories: nil
                ),
                BookInfo(
                    id: "2",
                    title: "To Kill a Mockingbird",
                    authors: ["Harper Lee"],
                    pageCount: 324,
                    imageURL: nil,
                    description: nil,
                    publishedDate: "1960",
                    categories: nil
                )
            ],
            onBookSelected: { _ in }
        )
    }
    .padding()
}
