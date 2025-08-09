import SwiftUI

struct PagesInputCard: View {
    @Binding var pagesRead: String
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with icon
            HStack {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(.blue.opacity(0.15))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "book.pages")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.blue)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Pages Read")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("How many pages did you read?")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
            }
            .padding(.top, 24)
            .padding(.horizontal, 24)
            
            // Large Input Area
            VStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [.blue.opacity(0.05), .cyan.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .stroke(
                            LinearGradient(
                                colors: [.blue.opacity(0.3), .cyan.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                        .frame(height: 80)
                    
                    HStack {
                        TextField("0", text: $pagesRead)
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(.primary)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                        
                        Text("pages")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                            .padding(.trailing, 8)
                    }
                    .padding(.horizontal, 20)
                }
                
                // Quick add buttons
                HStack(spacing: 12) {
                    ForEach([1, 5, 10], id: \.self) { value in
                        Button("+\(value)") {
                            let current = Int(pagesRead) ?? 0
                            pagesRead = "\(current + value)"
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.blue)
                        .frame(width: 50, height: 32)
                        .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.blue.opacity(0.3), lineWidth: 1)
                        )
                    }
                    
                    Spacer()
                    
                    if !pagesRead.isEmpty && Int(pagesRead) ?? 0 > 0 {
                        Button("Clear") {
                            pagesRead = ""
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.red)
                        .padding(.horizontal, 16)
                        .frame(height: 32)
                        .background(.red.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
                    }
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
        PagesInputCard(pagesRead: .constant(""))
        PagesInputCard(pagesRead: .constant("25"))
    }
    .padding()
}
