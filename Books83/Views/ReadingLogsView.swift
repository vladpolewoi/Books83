//
//  ReadingLogsView.swift
//  Books83
//
//  Created by Quest76 on 08.08.2025.
//

import SwiftUI
import SwiftData

struct ReadingLogsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ReadingLog.logDate, order: .reverse) private var logs: [ReadingLog]
    
    var body: some View {
        NavigationView {
            Group {
                if logs.isEmpty {
                    ContentUnavailableView(
                        "No Reading Logs",
                        systemImage: "book.pages",
                        description: Text("Start logging your reading sessions to track your progress")
                    )
                } else {
                    List {
                        // Stats section
                        Section {
                            HStack(spacing: 20) {
                                StatCard(title: "Total Pages", value: "\(totalPages)")
                                StatCard(title: "Sessions", value: "\(logs.count)")
                                StatCard(title: "Avg Pages", value: "\(averagePages)")
                            }
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets())
                        }
                        
                        // Logs section
                        Section("Recent Sessions") {
                            ForEach(logs) { log in
                                ReadingLogRow(log: log)
                            }
                            .onDelete(perform: deleteLogs)
                        }
                    }
                }
            }
            .navigationTitle("Reading Logs")
            .toolbar {
                if !logs.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
            }
        }
    }
    
    private var totalPages: Int {
        logs.reduce(0) { $0 + $1.pagesRead }
    }
    
    private var averagePages: Int {
        logs.isEmpty ? 0 : totalPages / logs.count
    }
    
    private func deleteLogs(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(logs[index])
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2.bold())
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct ReadingLogRow: View {
    let log: ReadingLog
    
    var body: some View {
        HStack(spacing: 12) {
            // Book cover
            AsyncImage(url: URL(string: log.book.imageName ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "book")
                            .foregroundColor(.gray)
                            .font(.caption)
                    )
            }
            .frame(width: 40, height: 56)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            
            // Log details
            VStack(alignment: .leading, spacing: 4) {
                Text(log.book.title)
                    .font(.headline)
                    .lineLimit(1)
                
                HStack(spacing: 12) {
                    Label("\(log.pagesRead) pages", systemImage: "book.pages")
                        .font(.caption)
                        .foregroundColor(.primary)
                    
                    if log.readingTimeMinutes != nil {
                        Label(log.readingTimeText, systemImage: "clock")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Text(log.formattedDate)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    ReadingLogsView()
        .modelContainer(mockContainer())
}
