import SwiftUI

struct TimeTrackingCard: View {
    @Binding var trackTime: Bool
    @Binding var readingMinutes: String
    
    var body: some View {
        VStack(spacing: 0) {
            TimeTrackingHeader(trackTime: $trackTime)
            
            if trackTime {
                TimeInputSection(readingMinutes: $readingMinutes)
            }
        }
        .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: trackTime)
    }
}

// MARK: - Header Component
struct TimeTrackingHeader: View {
    @Binding var trackTime: Bool
    
    var body: some View {
        HStack {
            TimeTrackingIcon()
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Reading Time")
                    .font(.headline)
                    .fontWeight(.bold)
                Text("Track your session duration")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $trackTime)
                .scaleEffect(0.9)
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 24)
    }
}

// MARK: - Icon Component
struct TimeTrackingIcon: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(.orange.opacity(0.15))
                .frame(width: 40, height: 40)
            
            Image(systemName: "clock")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.orange)
        }
    }
}

// MARK: - Input Section Component
struct TimeInputSection: View {
    @Binding var readingMinutes: String
    
    var body: some View {
        VStack(spacing: 16) {
            TimeInputField(readingMinutes: $readingMinutes)
            TimeButtonsRow(readingMinutes: $readingMinutes)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
        .transition(.opacity.combined(with: .scale(scale: 0.95)).combined(with: .offset(y: -10)))
    }
}

// MARK: - Input Field Component
struct TimeInputField: View {
    @Binding var readingMinutes: String
    
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [.orange.opacity(0.05), .red.opacity(0.05)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var strokeGradient: LinearGradient {
        LinearGradient(
            colors: [.orange.opacity(0.3), .red.opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundGradient)
                .stroke(strokeGradient, lineWidth: 1.5)
                .frame(height: 80)
            
            HStack {
                TextField("0", text: $readingMinutes)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                
                Text("min")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    .padding(.trailing, 8)
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Buttons Row Component
struct TimeButtonsRow: View {
    @Binding var readingMinutes: String
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach([1, 5, 15], id: \.self) { value in
                TimeIncrementButton(
                    value: value,
                    readingMinutes: $readingMinutes
                )
            }
            
            Spacer()
            
            if !readingMinutes.isEmpty && Int(readingMinutes) ?? 0 > 0 {
                TimeClearButton(readingMinutes: $readingMinutes)
            }
        }
    }
}

// MARK: - Increment Button Component
struct TimeIncrementButton: View {
    let value: Int
    @Binding var readingMinutes: String
    
    var body: some View {
        Button("+\(value)") {
            let current = Int(readingMinutes) ?? 0
            readingMinutes = "\(current + value)"
        }
        .font(.system(size: 14, weight: .semibold))
        .foregroundStyle(.orange)
        .frame(width: 50, height: 32)
        .background(.orange.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.orange.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Clear Button Component
struct TimeClearButton: View {
    @Binding var readingMinutes: String
    
    var body: some View {
        Button("Clear") {
            readingMinutes = ""
        }
        .font(.system(size: 14, weight: .medium))
        .foregroundStyle(.red)
        .padding(.horizontal, 16)
        .frame(height: 32)
        .background(.red.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    VStack(spacing: 20) {
        TimeTrackingCard(
            trackTime: .constant(false),
            readingMinutes: .constant("")
        )
        
        TimeTrackingCard(
            trackTime: .constant(true),
            readingMinutes: .constant("25")
        )
    }
    .padding()
}
