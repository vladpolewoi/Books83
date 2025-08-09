import SwiftUI

struct ModernBookRow: View {
    let book: Book
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                AsyncImage(url: URL(string: book.imageName ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .overlay(
                            Image(systemName: "book.closed")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                        )
                }
                .frame(width: 50, height: 65)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .shadow(radius: 2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(book.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text("by \(book.author)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    List {
        ModernBookRow(book: Book(title: "The Great Gatsby", author: "F. Scott Fitzgerald", totalPages: 180, imageName: nil)) {
            print("Book tapped")
        }
        ModernBookRow(book: Book(title: "To Kill a Mockingbird", author: "Harper Lee", totalPages: 324, imageName: nil)) {
            print("Book tapped")
        }
        ModernBookRow(book: Book(title: "1984", author: "George Orwell", totalPages: 328, imageName: nil)) {
            print("Book tapped")
        }
    }
}
