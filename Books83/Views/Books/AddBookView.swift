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
    
    @State private var titleText = ""
    @State private var authorText = ""
    @State private var pagesText = ""
    @State private var searchResults: [BookInfo] = []
    @State private var selectedBook: BookInfo?
    @State private var isSearching = false
    @State private var searchError: String?
    @State private var searchTask: Task<Void, Never>?
    @FocusState private var titleFocused: Bool
    
    private var canSave: Bool {
        !titleText.isEmpty && !authorText.isEmpty && !pagesText.isEmpty && (Int(pagesText) ?? 0) > 0
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Form Section
                ScrollView {
                    VStack(spacing: 24) {
                        // Book Form
                        bookFormSection
                        
                        // Search Results (when typing in title)
                        if !titleText.isEmpty && selectedBook == nil {
                            searchResultsSection
                        }
                    }
                    .padding()
                }
                
                // Save Button at bottom
                saveButtonSection
            }
            .navigationTitle("Add Book")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.secondary)
                }
            }
        }
        .onChange(of: titleText) { _, newValue in
            searchTask?.cancel()
            if !newValue.isEmpty && selectedBook == nil {
                searchTask = Task {
                    try? await Task.sleep(for: .milliseconds(500))
                    if !Task.isCancelled {
                        await performSearch(newValue)
                    }
                }
            } else {
                searchResults = []
                isSearching = false
            }
        }
        .onDisappear {
            searchTask?.cancel()
        }
    }
    
    // MARK: - View Components
    
    private var bookFormSection: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Book Details")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(selectedBook != nil ? "Selected from search" : "Type title to search or add manually")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if selectedBook != nil {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.title2)
                }
            }
            
            // Book Preview Card (when book is selected)
            if let book = selectedBook {
                selectedBookCard(book)
            }
            
            // Form Fields
            VStack(spacing: 16) {
                // Title Field with Search
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label("Title", systemImage: "book.closed")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        if selectedBook != nil {
                            Button("Change Book") {
                                clearSelection()
                            }
                            .font(.caption)
                            .foregroundStyle(.blue)
                        }
                    }
                    
                    HStack {
                        TextField("Enter book title", text: $titleText)
                            .textFieldStyle(.plain)
                            .focused($titleFocused)
                            .disabled(selectedBook != nil)
                        
                        if isSearching {
                            ProgressView()
                                .scaleEffect(0.7)
                        } else if !titleText.isEmpty && selectedBook == nil {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(selectedBook != nil ? .green : .clear, lineWidth: 1)
                    )
                }
                
                // Author Field
                VStack(alignment: .leading, spacing: 8) {
                    Label("Author", systemImage: "person")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("Enter author name", text: $authorText)
                        .textFieldStyle(.plain)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                // Pages Field
                VStack(alignment: .leading, spacing: 8) {
                    Label("Total Pages", systemImage: "book.pages")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("Enter page count", text: $pagesText)
                        .textFieldStyle(.plain)
                        .keyboardType(.numberPad)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func selectedBookCard(_ book: BookInfo) -> some View {
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
            .frame(width: 50, height: 65)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 2)
            
            // Book info
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                Text(book.authorsText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                
                if book.pageCount > 0 {
                    Text("\(book.pageCount) pages")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
        }
        .padding()
        .background(.green.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.green.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var searchResultsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            if isSearching {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Searching books...")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else if let error = searchError {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                    Text("Search error: \(error)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else if searchResults.isEmpty && !titleText.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "book.closed")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    
                    Text("No books found")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text("Continue adding the book manually")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else if !searchResults.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Found \(searchResults.count) books")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    
                    LazyVStack(spacing: 8) {
                        ForEach(searchResults) { book in
                            BookSearchResultRow(book: book, isSelected: false) {
                                selectBook(book)
                            }
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
    
    private var saveButtonSection: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack {
                Button("Save Book") {
                    saveBook()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(canSave ? .blue : .gray.opacity(0.3))
                .foregroundStyle(canSave ? .white : .secondary)
                .fontWeight(.semibold)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .disabled(!canSave)
            }
            .padding()
            .background(.ultraThinMaterial)
        }
    }
    
    // MARK: - Methods
    
    private func performSearch(_ query: String) async {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            await MainActor.run {
                searchResults = []
                isSearching = false
            }
            return
        }
        
        await MainActor.run {
            isSearching = true
            searchError = nil
        }
        
        do {
            let results = try await searchService.searchBooks(query: query)
            
            if !Task.isCancelled {
                await MainActor.run {
                    searchResults = results
                    isSearching = false
                }
            }
        } catch is CancellationError {
            // Task was cancelled, do nothing
        } catch {
            if !Task.isCancelled {
                await MainActor.run {
                    searchError = error.localizedDescription
                    searchResults = []
                    isSearching = false
                }
            }
        }
    }
    
    private func selectBook(_ book: BookInfo) {
        selectedBook = book
        titleText = book.title
        authorText = book.primaryAuthor
        pagesText = book.pageCount > 0 ? String(book.pageCount) : ""
        searchResults = []
        titleFocused = false
    }
    
    private func clearSelection() {
        selectedBook = nil
        titleText = ""
        authorText = ""
        pagesText = ""
        searchResults = []
        titleFocused = true
    }
    
    private func saveBook() {
        guard let pageCount = Int(pagesText) else { return }
        
        let book = Book(
            title: titleText,
            author: authorText,
            totalPages: pageCount,
            imageName: selectedBook?.imageURL
        )
        
        modelContext.insert(book)
        dismiss()
    }
}

#Preview {
    AddBookView()
        .modelContainer(mockContainer())
}
