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
                
                Spacer()
                
                Text("\(currentPages) / \(goalPages) pages")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: progress)
                .tint(.blue)
                .scaleEffect(y: 2.0)
        }
    }
}

#Preview {
    DailyGoalSection(currentPages: 75, goalPages: 100)
        .padding()
}
