//
//  ContentView.swift
//  Books83
//
//  Created by Quest76 on 08.08.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query private var books: [Book]

    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    VStack(alignment: .leading) {
                        Text(book.title)
                            .font(.headline)
                        Text(book.author)
                            .font(.subheadline)
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("Books")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add", action: addBook)
                }
            }
        }
    }

    private func addBook() {
        let book = Book(title: "New Book", author: "Anonymous")
        context.insert(book)
    }

    private func deleteBooks(at offsets: IndexSet) {
        for index in offsets {
            context.delete(books[index])
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Book.self)
}
