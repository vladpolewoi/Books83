//
//  BookReadingLogRow.swift
//  Books83
//
//  Created by Quest76 on 13.08.2025.
//

import SwiftUI
import SwiftData

struct BookReadingLogRow: View {
    let log: ReadingLog
    
    private var dateText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: log.logDate)
    }
    
    private var timeText: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: log.logDate)
    }
    
    private var relativeTimeText: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: log.logDate, relativeTo: Date())
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "book.pages")
                        .font(.title3)
                        .foregroundColor(.blue)
                )
            
            // Log details
            VStack(alignment: .leading, spacing: 6) {
                // Main info row
                HStack {
                    Text("\(log.pagesRead) pages")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    if log.readingTimeMinutes != nil {
                        Text("• \(log.readingTimeText)")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                }
                
                // Date and time row
                HStack {
                    Label(dateText, systemImage: "calendar")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Label(timeText, systemImage: "clock")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                
                // Notes
                if let notes = log.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .padding(.top, 2)
                }
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    VStack(spacing: 8) {
        ForEach(ReadingLog.mockLogs.prefix(3), id: \.id) { log in
            BookReadingLogRow(log: log)
        }
    }
    .padding()
    .modelContainer(mockContainer())
}
