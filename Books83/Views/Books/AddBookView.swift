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
    @ObservedObject private var themeManager = ThemeManager.shared
    
    @StateObject private var searchService = BookSearchService()
    
    @State private var titleText = ""
    @State private var authorText = ""
    @State private var pagesText = ""
    @State private var searchResults: [BookInfo] = []
    @State private var selectedBook: BookInfo?
    @State private var isSearching = false
    @State private var searchError: String?
    @State private var searchTask: Task<Void, Never>?
    
    private var canSave: Bool {
        !titleText.isEmpty && !authorText.isEmpty && !pagesText.isEmpty && (Int(pagesText) ?? 0) > 0
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Title Input Card with Search
                        TitleInputCard(
                            titleText: $titleText,
                            isSearching: $isSearching,
                            searchResults: searchResults,
                            onBookSelected: selectBook,
                            onClearSelection: clearSelection,
                            selectedBook: selectedBook
                        )
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
                        
                        // Search Results Card (directly under title input)
                        if !searchResults.isEmpty && selectedBook == nil {
                            SearchResultsCard(
                                searchResults: searchResults,
                                onBookSelected: selectBook
                            )
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
                        }
                        
                        // Author Input Card
                        AuthorInputCard(authorText: $authorText)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
                        
                        // Pages Input Card
                        BookPagesInputCard(pagesText: $pagesText)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
                        
                        // Search Error State
                        if let error = searchError {
                            errorCard(error)
                        }
                        
                        // No Results State
                        if !titleText.isEmpty && searchResults.isEmpty && !isSearching && selectedBook == nil && searchError == nil {
                            noResultsCard()
                        }
                        
                        Spacer(minLength: 60)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
            }
            .navigationTitle("📚 Add Book")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.body)
                    .foregroundColor(.secondaryText)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", action: saveBook)
                        .fontWeight(.semibold)
                        .disabled(!canSave)
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
                searchError = nil
            }
        }
        .onDisappear {
            searchTask?.cancel()
        }
    }
    
    // MARK: - Card Components
    
    private func errorCard(_ error: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title2)
                .foregroundColor(.warning)
            
            Text("Search Error")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primaryText)
            
            Text(error)
                .font(.subheadline)
                .foregroundColor(.secondaryText)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
                searchError = nil
                if !titleText.isEmpty {
                    Task {
                        await performSearch(titleText)
                    }
                }
            }
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.warning)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(Color.warning.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
    
    private func noResultsCard() -> some View {
        VStack(spacing: 16) {
            Image(systemName: "book.closed")
                .font(.title)
                .foregroundColor(.secondaryText)
            
            Text("No books found")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primaryText)
            
            Text("Continue adding \"\(titleText)\" manually by filling in the details below")
                .font(.subheadline)
                .foregroundColor(.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
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
        searchError = nil
    }
    
    private func clearSelection() {
        selectedBook = nil
        titleText = ""
        authorText = ""
        pagesText = ""
        searchResults = []
        searchError = nil
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
