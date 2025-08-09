//
//  QuickLogView.swift
//  Books83
//
//  Created by Quest76 on 08.08.2025.
//

import SwiftUI
import SwiftData

struct QuickLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var books: [Book]
    
    @State private var selectedBook: Book?
    
    @State private var pagesRead: String = ""
    @State private var readingTimeMinutes: String = ""
    @State private var includeTime = false
    @State private var showingTimeOptions = false
    
    // Quick time options in minutes
    private let quickTimeOptions = [15, 30, 45, 60, 90, 120]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Book selection
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select Book")
                        .font(.headline)
                    
                    Picker("Book", selection: $selectedBook) {
                        Text("Choose a book...").tag(Book?.none)
                        ForEach(books, id: \.id) { book in
                            Text(book.title).tag(book as Book?)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Book info (when selected)
                if let book = selectedBook {
                    HStack(spacing: 12) {
                        AsyncImage(url: URL(string: book.imageName ?? "")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.3))
                                .overlay(
                                    Image(systemName: "book")
                                        .foregroundColor(.gray)
                                )
                        }
                        .frame(width: 50, height: 70)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(book.title)
                                .font(.headline)
                                .lineLimit(2)
                            
                            Text("by \(book.author)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                // Pages input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Pages Read")
                        .font(.headline)
                    
                    HStack {
                        TextField("0", text: $pagesRead)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .font(.title2)
                            .frame(width: 80)
                        
                        Text("pages")
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        // Quick page buttons
                        HStack(spacing: 8) {
                            ForEach([5, 10, 20, 30], id: \.self) { pages in
                                Button("+\(pages)") {
                                    let currentPages = Int(pagesRead) ?? 0
                                    pagesRead = String(currentPages + pages)
                                }
                                .buttonStyle(.bordered)
                                .font(.caption)
                            }
                        }
                    }
                }
                
                // Time tracking toggle
                Toggle("Track reading time", isOn: $includeTime)
                    .font(.headline)
                
                // Time input (when enabled)
                if includeTime {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Reading Time")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        // Quick time buttons
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                            ForEach(quickTimeOptions, id: \.self) { minutes in
                                Button {
                                    readingTimeMinutes = String(minutes)
                                } label: {
                                    Text(formatTime(minutes))
                                        .font(.system(.body, design: .rounded))
                                        .foregroundColor(readingTimeMinutes == String(minutes) ? .white : .primary)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(readingTimeMinutes == String(minutes) ? .blue : Color.gray.opacity(0.2))
                                        )
                                }
                            }
                        }
                        
                        // Custom time input
                        HStack {
                            TextField("Custom", text: $readingTimeMinutes)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.numberPad)
                                .frame(width: 80)
                            
                            Text("minutes")
                                .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
                
                Spacer()
                
                // Log button
                Button {
                    logReading()
                } label: {
                    Text("Log Reading")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(canLog ? .blue : .gray)
                        )
                }
                .disabled(!canLog)
            }
            .padding()
            .navigationTitle("Quick Log")
            .navigationBarTitleDisplayMode(.inline)
        }
        .animation(.easeInOut, value: includeTime)
    }
    
    private var canLog: Bool {
        guard selectedBook != nil else { return false }
        guard let pages = Int(pagesRead), pages > 0 else { return false }
        if includeTime {
            return Int(readingTimeMinutes) != nil && !readingTimeMinutes.isEmpty
        }
        return true
    }
    
    private func formatTime(_ minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes)m"
        } else {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            if remainingMinutes == 0 {
                return "\(hours)h"
            } else {
                return "\(hours)h \(remainingMinutes)m"
            }
        }
    }
    
    private func logReading() {
        guard let book = selectedBook else { return }
        guard let pages = Int(pagesRead), pages > 0 else { return }
        
        let timeMinutes: Int? = includeTime ? Int(readingTimeMinutes) : nil
        let log = ReadingLog(book: book, pagesRead: pages, readingTimeMinutes: timeMinutes)
        
        modelContext.insert(log)
        
        // Reset form after successful log
        pagesRead = ""
        readingTimeMinutes = ""
        includeTime = false
    }
}

#Preview {
    QuickLogView()
        .modelContainer(mockContainer())
}
