//
//  RecentLogsSection.swift
//  Books83
//
//  Created by Quest76 on 13.08.2025.
//

import SwiftUI
import SwiftData

struct RecentLogsSection: View {
    let logs: [ReadingLog]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Reading Logs")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                if logs.count > 5 {
                    Button("View All") {
                        // TODO: Navigate to full logs view
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 16)
            
            if logs.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "book.closed")
                        .font(.title2)
                        .foregroundColor(.gray)
                    Text("No reading logs yet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("Start logging your reading progress!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(32)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 16)
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(logs, id: \.id) { log in
                        BookReadingLogRow(log: log)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        // With logs
        RecentLogsSection(logs: ReadingLog.mockLogs)
        
        // Empty state
        RecentLogsSection(logs: [])
    }
    .padding()
    .modelContainer(mockContainer())
}
