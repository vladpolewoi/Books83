import SwiftUI
import SwiftData

struct QuickLogSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let preSelectedBook: Book?

    @State private var selectedBook: Book?
    @Query private var books: [Book]

    @State private var pagesRead: String = ""
    @State private var trackTime = false {
        didSet {
            if trackTime && readingMinutes.isEmpty {
                readingMinutes = "25"
            }
        }
    }
    @State private var readingMinutes: String = ""
    @State private var notes: String = ""
    @State private var showingBookPicker = false
    
    private var canSave: Bool {
        selectedBook != nil && !pagesRead.isEmpty && (Int(pagesRead) ?? 0) > 0
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
                    VStack(spacing: 16) {
                        // Hero Book Selection Card (keeping as requested)
                        BookSelectionCard(
                            selectedBook: selectedBook,
                            showingBookPicker: $showingBookPicker
                        )
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
                        
                        // Reading Progress Card - Modern Design
                        PagesInputCard(pagesRead: $pagesRead)
                        
                        // Time Tracking Card - Redesigned
                        TimeTrackingCard(
                            trackTime: $trackTime,
                            readingMinutes: $readingMinutes
                        )
                        
                        // Notes Card - Completely Redesigned
                        NotesInputCard(notes: $notes)
                        
                        Spacer(minLength: 60)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
            }
            .navigationTitle("📖 Reading Log")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.body)
                    .foregroundStyle(.secondary)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", action: saveReading)
                        .fontWeight(.semibold)
                        .disabled(!canSave)
                }
            }
        }
        .sheet(isPresented: $showingBookPicker) {
            ModernBookPicker(selectedBook: $selectedBook)
        }
        .onAppear {
            if selectedBook == nil {
                selectedBook = preSelectedBook
            }
        }
    }
    
    private func saveReading() {
        guard let book = selectedBook,
              let pages = Int(pagesRead), pages > 0 else { return }
        
        // Calculate reading time: use tracked time or estimate 2 minutes per page
        let timeToLog: Int?
        if trackTime {
            timeToLog = Int(readingMinutes)
        } else {
            // Default: 2 minutes per page
            timeToLog = pages * 2
        }
        
        let log = ReadingLog(
            book: book,
            pagesRead: pages,
            readingTimeMinutes: timeToLog,
            notes: notes.isEmpty ? nil : notes
        )
        
        // Update book progress and status
        let oldCurrentPage = book.currentPage
        let newCurrentPage = min(book.currentPage + pages, book.totalPages)
        book.currentPage = newCurrentPage
        
        // Update status based on progress
        if newCurrentPage >= book.totalPages {
            book.status = .completed
        } else if book.status == .toRead {
            book.status = .reading
        }
        
        modelContext.insert(log)
        
        // Save changes to ensure persistence
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
        
        dismiss()
    }
}

#Preview {
    QuickLogSheet(preSelectedBook: nil)
        .modelContainer(mockContainer())
}
