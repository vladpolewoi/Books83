import SwiftUI

struct NotesInputCard: View {
    @Binding var notes: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(.purple.opacity(0.15))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "text.quote")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.purple)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Session Notes")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("Optional thoughts & reflections")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
            }
            .padding(.top, 24)
            .padding(.horizontal, 24)
            
            VStack(spacing: 0) {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [.purple.opacity(0.03), .pink.opacity(0.03)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .stroke(.purple.opacity(0.15), lineWidth: 1)
                        .frame(minHeight: 100)
                    
                    if notes.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("How was your reading session?")
                                .font(.body)
                                .foregroundStyle(.tertiary)
                            Text("Share your thoughts, favorite quotes, or key insights...")
                                .font(.caption)
                                .foregroundStyle(.quaternary)
                        }
                        .padding(16)
                        .allowsHitTesting(false)
                    }
                    
                    TextField("", text: $notes, axis: .vertical)
                        .font(.body)
                        .textFieldStyle(.plain)
                        .lineLimit(3...8)
                        .padding(16)
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
        NotesInputCard(notes: .constant(""))
        NotesInputCard(notes: .constant("Great chapter about character development. The author's use of metaphors was particularly striking."))
    }
    .padding()
}
