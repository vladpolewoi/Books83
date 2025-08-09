//
//  AddBookView.swift
//  Books83
//
//  Created by Quest76 on 09.08.2025.
//

import SwiftUI
import SwiftData

struct AddBookView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var searchService = BookSearchService()
    
    @State private var searchText = ""
    @State private var searchResults: [BookInfo] = []
    @State private var selectedBook: BookInfo?
    @State private var isSearching = false
    @State private var searchError: String?
    
    // Manual entry fields (shown when no book is selected or for editing)
    @State private var manualTitle = ""
    @State private var manualAuthor = ""
    @State private var manualPages = ""
    @State private var showingManualEntry = false
    
    private var canSave: Bool {
        if let book = selectedBook {
            return !book.title.isEmpty && !book.primaryAuthor.isEmpty && book.pageCount > 0
        } else {
            return !manualTitle.isEmpty && !manualAuthor.isEmpty && !manualPages.isEmpty && (Int(manualPages) ?? 0) > 0
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Search Section
                    searchSection
                    
                    // Search Results or Selected Book
                    if isSearching {
                        searchingIndicator
                    } else if let error = searchError {
                        errorView(error)
                    } else if let selected = selectedBook {
                        selectedBookView(selected)
                    } else if !searchResults.isEmpty {
                        searchResultsList
                    } else if !searchText.isEmpty {
                        noResultsView
                    }
                    
                    // Manual Entry Toggle
                    if selectedBook == nil {
                        manualEntryToggle
                    }
                    
                    // Manual Entry Form
                    if showingManualEntry && selectedBook == nil {
                        manualEntryForm
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding()
            }
            .navigationTitle("Add Book")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveBook()
                    }
                    .fontWeight(.semibold)
                    .disabled(!canSave)
                }
            }
        }
        .task(id: searchText) {
            await performSearch()
        }
    }
    
    // MARK: - View Components
    
    private var searchSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Search for a book")
                .font(.headline)
                .foregroundStyle(.primary)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                
                TextField("Enter book title, author, or ISBN", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.search)
                    .onSubmit {
                        Task {
                            await performSearch()
                        }
                    }
                
                if !searchText.isEmpty {
                    Button("Clear") {
                        searchText = ""
                        searchResults = []
                        selectedBook = nil
                        searchError = nil
                    }
                    .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
    
    private var searchingIndicator: some View {
        HStack {
            ProgressView()
                .scaleEffect(0.8)
            Text("Searching...")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
    
    private func errorView(_ error: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle")
                .foregroundStyle(.orange)
            Text(error)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
    
    private var noResultsView: some View {
        VStack(spacing: 12) {
            Image(systemName: "book.closed")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            
            Text("No books found")
                .font(.headline)
            
            Text("Try a different search term or add the book manually")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
    
    private func selectedBookView(_ book: BookInfo) -> some View {
        VStack(spacing: 16) {
            HStack {
                Text("Selected Book")
                    .font(.headline)
                    .foregroundStyle(.green)
                
                Spacer()
                
                Button("Change") {
                    selectedBook = nil
                }
                .foregroundStyle(.blue)
            }
            
            BookSearchResultRow(book: book, isSelected: true) {
                // Already selected
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.green, lineWidth: 2)
        )
    }
    
    private var searchResultsList: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Search Results")
                .font(.headline)
                .padding(.horizontal)
            
            LazyVStack(spacing: 12) {
                ForEach(searchResults) { book in
                    BookSearchResultRow(book: book, isSelected: false) {
                        selectedBook = book
                        showingManualEntry = false
                    }
                }
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
    
    private var manualEntryToggle: some View {
        Button {
            showingManualEntry.toggle()
        } label: {
            HStack {
                Image(systemName: showingManualEntry ? "chevron.down" : "chevron.right")
                Text("Add book manually")
                Spacer()
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
        .foregroundStyle(.primary)
    }
    
    private var manualEntryForm: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Title")
                    .font(.headline)
                TextField("Enter book title", text: $manualTitle)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Author")
                    .font(.headline)
                TextField("Enter author name", text: $manualAuthor)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Total Pages")
                    .font(.headline)
                TextField("Enter page count", text: $manualPages)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Methods
    
    private func performSearch() async {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            searchResults = []
            return
        }
        
        isSearching = true
        searchError = nil
        
        do {
            // Add a small delay to avoid too many requests
            try await Task.sleep(for: .milliseconds(300))
            let results = try await searchService.searchBooks(query: searchText)
            
            await MainActor.run {
                searchResults = results
                isSearching = false
            }
        } catch {
            await MainActor.run {
                searchError = error.localizedDescription
                searchResults = []
                isSearching = false
            }
        }
    }
    
    private func saveBook() {
        let book: Book
        
        if let selectedBook = selectedBook {
            // Create book from API result
            book = Book(
                title: selectedBook.title,
                author: selectedBook.primaryAuthor,
                totalPages: selectedBook.pageCount,
                imageName: selectedBook.imageURL
            )
        } else {
            // Create book from manual entry
            guard let pageCount = Int(manualPages) else { return }
            book = Book(
                title: manualTitle,
                author: manualAuthor,
                totalPages: pageCount
            )
        }
        
        modelContext.insert(book)
        dismiss()
    }
}

#Preview {
    AddBookView()
        .modelContainer(mockContainer())
}
