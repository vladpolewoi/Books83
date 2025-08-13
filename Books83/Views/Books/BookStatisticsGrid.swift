//
//  BookStatisticsGrid.swift
//  Books83
//
//  Created by Quest76 on 13.08.2025.
//

import SwiftUI

struct BookStatisticsGrid: View {
    let stats: BookStats
    let averageSpeed: Double
    
    private var formattedReadingTime: String {
        if stats.totalReadingTime < 60 {
            return "\(stats.totalReadingTime)m"
        } else {
            let hours = stats.totalReadingTime / 60
            let minutes = stats.totalReadingTime % 60
            if minutes == 0 {
                return "\(hours)h"
            } else {
                return "\(hours)h \(minutes)m"
            }
        }
    }
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                StatCard(
                    title: "Pages Read",
                    value: "\(stats.totalPagesRead)",
                    subtitle: "total",
                    color: .blue
                )
                
                StatCard(
                    title: "Reading Time",
                    value: formattedReadingTime,
                    subtitle: "logged",
                    color: .green
                )
                
                StatCard(
                    title: "Avg Speed",
                    value: averageSpeed > 0 ? "\(Int(averageSpeed))" : "N/A",
                    subtitle: "pages/hour",
                    color: .orange
                )
                
                StatCard(
                    title: "Reading Sessions",
                    value: "\(stats.logCount)",
                    subtitle: "logged",
                    color: .purple
                )
            }
            .padding(.horizontal, 16)
    }
}

#Preview {
    BookStatisticsGrid(
        stats: BookStats(
            totalPagesRead: 245,
            totalReadingTime: 180, // 3 hours
            logCount: 8
        ),
        averageSpeed: 45.5
    )
    .padding()
}
