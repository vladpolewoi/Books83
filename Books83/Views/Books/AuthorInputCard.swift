import SwiftUI

struct AuthorInputCard: View {
    @Binding var authorText: String
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with icon
            HStack {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(.orange.opacity(0.15))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "person")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.orange)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Author")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Who wrote this book?")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
            }
            .padding(.top, 24)
            .padding(.horizontal, 24)
            
            // Input Area
            VStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [.orange.opacity(0.05), .yellow.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .stroke(
                            LinearGradient(
                                colors: [.orange.opacity(0.3), .yellow.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                        .frame(minHeight: 50)
                    
                    HStack {
                        TextField("Enter author name", text: $authorText)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(.primary)
                        
                        if !authorText.isEmpty {
                            Button {
                                authorText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                                    .font(.system(size: 16))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
        }
        .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
}

#Preview {
    VStack(spacing: 20) {
        AuthorInputCard(authorText: .constant(""))
        AuthorInputCard(authorText: .constant("F. Scott Fitzgerald"))
    }
    .padding()
}
