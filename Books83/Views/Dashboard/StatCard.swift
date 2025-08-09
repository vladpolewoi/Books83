import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(color)

            Text(subtitle)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
        StatCard(title: "This Week", value: "124", subtitle: "pages", color: .blue)
        StatCard(title: "This Year", value: "8", subtitle: "books", color: .green)
        StatCard(title: "Streak", value: "3", subtitle: "days", color: .orange)
    }
    .padding()
}
