//
//  BookActionButtons.swift
//  Books83
//
//  Created by Quest76 on 13.08.2025.
//

import SwiftUI

struct BookActionButtons: View {
    @Binding var showingQuickLog: Bool
    @Binding var showingEditBook: Bool
    let book: Book
    
    var body: some View {
        VStack(spacing: 12) {
            // Primary action - Log Reading
            Button {
                showingQuickLog = true
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                    Text("Log Reading Session")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [.blue, .cyan],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    BookActionButtons(
        showingQuickLog: .constant(false),
        showingEditBook: .constant(false),
        book: Book.sampleBook
    )
    .padding()
}
