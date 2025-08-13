//
//  EditInputCard.swift
//  Books83
//
//  Created by Quest76 on 13.08.2025.
//

import SwiftUI

struct EditInputCard: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 24)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            TextField(placeholder, text: $text)
                .textFieldStyle(.roundedBorder)
                .font(.body)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    VStack(spacing: 16) {
        EditInputCard(
            title: "Book Title",
            text: .constant(""),
            placeholder: "Enter book title",
            icon: "book.closed",
            color: .blue
        )
        
        EditInputCard(
            title: "Author",
            text: .constant("F. Scott Fitzgerald"),
            placeholder: "Enter author name",
            icon: "person",
            color: .orange
        )
    }
    .padding()
}
