//
//  EditPagesCard.swift
//  Books83
//
//  Created by Quest76 on 13.08.2025.
//

import SwiftUI

struct EditPagesCard: View {
    @Binding var totalPages: String
    @Binding var currentPage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "book.pages")
                    .font(.title3)
                    .foregroundColor(.purple)
                    .frame(width: 24)
                
                Text("Pages")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Current Page")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextField("0", text: $currentPage)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Total Pages")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextField("0", text: $totalPages)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                }
            }
            
            if !totalPages.isEmpty && !currentPage.isEmpty,
               let total = Int(totalPages),
               let current = Int(currentPage),
               total > 0 {
                let progress = Double(current) / Double(total)
                
                VStack(spacing: 8) {
                    HStack {
                        Text("Progress")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(Int(progress * 100))%")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.purple)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemGray5))
                                .frame(height: 8)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.purple)
                                .frame(width: geometry.size.width * progress, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: progress)
                        }
                    }
                    .frame(height: 8)
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    VStack(spacing: 16) {
        EditPagesCard(
            totalPages: .constant(""),
            currentPage: .constant("")
        )
        
        EditPagesCard(
            totalPages: .constant("300"),
            currentPage: .constant("180")
        )
    }
    .padding()
}
