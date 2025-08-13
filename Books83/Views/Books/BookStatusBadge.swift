//
//  BookStatusBadge.swift
//  Books83
//
//  Created by Quest76 on 13.08.2025.
//

import SwiftUI

struct BookStatusBadge: View {
    let status: BookStatus
    
    private var badgeColor: Color {
        let colors = Color.readingStatusColors
        switch status {
        case .reading: return colors.reading
        case .completed: return colors.completed
        case .toRead: return colors.notStarted
        case .paused: return colors.paused
        }
    }
    
    private var statusText: String {
        switch status {
        case .reading: return "Reading"
        case .completed: return "Completed"
        case .toRead: return "To Read"
        case .paused: return "Paused"
        }
    }
    
    var body: some View {
        Text(statusText)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(badgeColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(badgeColor.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

#Preview {
    VStack(spacing: 8) {
        BookStatusBadge(status: .reading)
        BookStatusBadge(status: .completed)
        BookStatusBadge(status: .toRead)
        BookStatusBadge(status: .paused)
    }
    .padding()
    .background(Color.appBackground)
}
