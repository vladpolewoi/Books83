import SwiftUI

struct BookSelectionCard: View {
    let selectedBook: Book?
    @Binding var showingBookPicker: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: { showingBookPicker = true }) {
                if let book = selectedBook {
                    // Selected book display
                    HStack(spacing: 16) {
                        AsyncImage(url: URL(string: book.imageName ?? "")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    Image(systemName: "book.closed")
                                        .foregroundStyle(.secondary)
                                        .font(.title2)
                                )
                        }
                        .frame(width: 70, height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(radius: 3)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(book.title)
                                .font(.title3)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                            
                            Text("by \(book.author)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                            
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                Text("Book selected")
                                    .font(.caption)
                                    .foregroundStyle(.green)
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right.circle.fill")
                            .foregroundStyle(.blue)
                            .font(.title2)
                    }
                    .padding(20)
                } else {
                    // Simple, clean empty state
                    VStack(spacing: 16) {
                        Text("📚 Select Your Book")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        
                        Text("Choose from your library to start logging")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .padding(.horizontal, 20)
                }
            }
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(selectedBook != nil ? .blue : .clear, lineWidth: 2)
            )
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        BookSelectionCard(
            selectedBook: nil,
            showingBookPicker: .constant(false)
        )
        
        BookSelectionCard(
            selectedBook: Book(title: "The Great Gatsby", author: "F. Scott Fitzgerald", totalPages: 180, imageName: nil),
            showingBookPicker: .constant(false)
        )
    }
    .padding()
}
