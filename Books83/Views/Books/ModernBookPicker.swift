import SwiftUI
import SwiftData

struct ModernBookPicker: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedBook: Book?
    @Query private var books: [Book]
    @State private var searchText = ""
    
    private var filteredBooks: [Book] {
        if searchText.isEmpty {
            return books
        } else {
            return books.filter { book in
                book.title.localizedCaseInsensitiveContains(searchText) ||
                book.author.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredBooks) { book in
                    ModernBookRow(book: book) {
                        selectedBook = book
                        dismiss()
                    }
                }
            }
            .listStyle(.insetGrouped)
            .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Search your library...")
            .navigationTitle("Choose Book")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .fontWeight(.medium)
                }
            }
        }
    }
}

#Preview {
    ModernBookPicker(selectedBook: .constant(nil))
        .modelContainer(mockContainer())
}
