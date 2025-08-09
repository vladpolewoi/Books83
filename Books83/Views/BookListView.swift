//
//  BookListView.swift
//  Books83
//
//  Created by Quest76 on 08.08.2025.
//

import SwiftUI
import SwiftData

struct BookListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var books: [Book]
    @State private var showingQuickLog = false
    @State private var selectedBook: Book?
    
    var body: some View {
        NavigationView {
            Group {
                if books.isEmpty {
                    ContentUnavailableView(
                        "No Books Yet",
                        systemImage: "books.vertical",
                        description: Text("Add your first book to get started")
                    )
                } else {
                    List {
                        ForEach(books) { book in
                            Button {
                                selectedBook = book
                                showingQuickLog = true
                            } label: {
                                BookRow(book: book, showPlusButton: false)
                            }
                            .buttonStyle(.plain)
                        }
                        .onDelete(perform: deleteBooks)
                    }
                }
            }
            .navigationTitle("My Books")
            .sheet(isPresented: $showingQuickLog) {
                if let book = selectedBook {
                    QuickLogSheet(preSelectedBook: book)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addSampleBook()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                if !books.isEmpty {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                }
            }
        }
    }
    
    private func deleteBooks(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(books[index])
            }
        }
    }
    
    private func addSampleBook() {
        withAnimation {
            modelContext.insert(Book.sampleBook)
        }
    }
}

#Preview {
    BookListView()
        .modelContainer(mockContainer())
}
