//
//  EditBookView.swift
//  Books83
//
//  Created by Quest76 on 13.08.2025.
//

import SwiftUI
import SwiftData

struct EditBookView: View {
    let book: Book
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var title: String
    @State private var author: String
    @State private var totalPages: String
    @State private var currentPage: String
    @State private var status: BookStatus
    @State private var imageName: String
    
    private var canSave: Bool {
        !title.isEmpty && 
        !author.isEmpty && 
        !totalPages.isEmpty &&
        !currentPage.isEmpty &&
        Int(totalPages) != nil &&
        Int(currentPage) != nil &&
        Int(totalPages)! > 0 &&
        Int(currentPage)! >= 0 &&
        Int(currentPage)! <= Int(totalPages)!
    }
    
    init(book: Book) {
        self.book = book
        _title = State(initialValue: book.title)
        _author = State(initialValue: book.author)
        _totalPages = State(initialValue: "\(book.totalPages)")
        _currentPage = State(initialValue: "\(book.currentPage)")
        _status = State(initialValue: book.status)
        _imageName = State(initialValue: book.imageName ?? "")
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.systemGray6).opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Title input
                        EditInputCard(
                            title: "Book Title",
                            text: $title,
                            placeholder: "Enter book title",
                            icon: "book.closed",
                            color: .blue
                        )
                        
                        // Author input
                        EditInputCard(
                            title: "Author",
                            text: $author,
                            placeholder: "Enter author name",
                            icon: "person",
                            color: .orange
                        )
                        
                        // Pages input
                        EditPagesCard(
                            totalPages: $totalPages,
                            currentPage: $currentPage
                        )
                        
                        // Status selection
                        StatusSelectionCard(status: $status)
                        
                        // Image URL input
                        ImageInputCard(imageName: $imageName)
                        
                        Spacer(minLength: 60)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Edit Book")
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
    }
    
    private func saveBook() {
        book.title = title
        book.author = author
        book.totalPages = Int(totalPages) ?? 0
        book.currentPage = min(Int(currentPage) ?? 0, book.totalPages)
        book.status = status
        book.imageName = imageName.isEmpty ? nil : imageName
        
        dismiss()
    }
}

// MARK: - Status Selection Card
struct StatusSelectionCard: View {
    @Binding var status: BookStatus
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Reading Status")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(BookStatus.allCases, id: \.self) { bookStatus in
                    Button {
                        status = bookStatus
                    } label: {
                        HStack {
                            Text(bookStatus.displayName)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Spacer()
                            if status == bookStatus {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(12)
                        .background(
                            status == bookStatus ? 
                            Color.blue.opacity(0.1) : Color(.systemGray6)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .foregroundColor(.primary)
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Image Input Card
struct ImageInputCard: View {
    @Binding var imageName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Book Cover (Optional)")
                .font(.headline)
                .fontWeight(.semibold)
            
            TextField("Enter image URL", text: $imageName)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.URL)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            if !imageName.isEmpty {
                Text("Preview:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                AsyncImage(url: URL(string: imageName)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            ProgressView()
                        )
                }
                .frame(width: 60, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - BookStatus Extension
extension BookStatus {
    var displayName: String {
        switch self {
        case .reading: return "Reading"
        case .completed: return "Completed"
        case .toRead: return "To Read"
        case .paused: return "Paused"
        }
    }
}

#Preview {
    EditBookView(book: Book.sampleBook)
        .modelContainer(mockContainer())
}
