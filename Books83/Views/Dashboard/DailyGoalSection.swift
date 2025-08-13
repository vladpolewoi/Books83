import SwiftUI

struct DailyGoalSection: View {
    let currentPages: Int
    let goalPages: Int
    
    private var progress: Double {
        min(1.0, Double(currentPages) / Double(goalPages))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Daily Goal")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primaryText)
                
                Spacer()
                
                Text("\(currentPages) / \(goalPages) pages")
                    .font(.subheadline)
                    .foregroundColor(.secondaryText)
            }
            
            ProgressView(value: progress)
                .tint(.accent)
                .scaleEffect(y: 2.0)
        }
    }
}

#Preview {
    DailyGoalSection(currentPages: 75, goalPages: 100)
        .padding()
        .background(Color.appBackground)
}
