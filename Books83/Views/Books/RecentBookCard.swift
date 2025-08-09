import SwiftUI

struct RecentBookCard: View {
    let book: Book
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    // Book-like shadow
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.black.opacity(0.2))
                        .frame(width: 80, height: 120)
                        .offset(x: 3, y: 3)
                        .blur(radius: 2.5)

                    // Book Cover Image
                    AsyncImage(url: URL(string: book.imageName ?? "")) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray.opacity(0.1)
                            .overlay(Image(systemName: "book.closed").font(.largeTitle).foregroundColor(.gray))
                    }
                    .frame(width: 80, height: 120)
                    .clipped()
                    .cornerRadius(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4).stroke(Color.black.opacity(0.1), lineWidth: 1)
                    )
                }

                Text(book.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(width: 80)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
        RecentBookCard(book: Book(title: "The Great Gatsby", author: "F. Scott Fitzgerald", totalPages: 180, imageName: nil)) {
            print("Book tapped")
        }
        RecentBookCard(book: Book(title: "To Kill a Mockingbird", author: "Harper Lee", totalPages: 324, imageName: nil)) {
            print("Book tapped")
        }
        RecentBookCard(book: Book(title: "1984", author: "George Orwell", totalPages: 328, imageName: nil)) {
            print("Book tapped")
        }
    }
    .padding()
}
