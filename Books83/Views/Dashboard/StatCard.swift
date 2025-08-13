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
                .foregroundColor(.primaryText)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondaryText)
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(Color.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.separator, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
        StatCard(title: "This Week", value: "124", subtitle: "pages", color: .accent)
        StatCard(title: "This Year", value: "8", subtitle: "books", color: .success)
        StatCard(title: "Streak", value: "3", subtitle: "days", color: .warning)
    }
    .padding()
    .background(Color.appBackground)
}
