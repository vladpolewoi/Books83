import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query private var books: [Book]
    @Query private var readingLogs: [ReadingLog]
    @State private var showingQuickLog = false
    @State private var selectedBookForLog: Book?
    
    private let dailyGoal = 100 // Hardcoded goal
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Daily Goal Section
                    DailyGoalSection(
                        currentPages: todayPages,
                        goalPages: dailyGoal
                    )
                    
                    // Stats Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        StatCard(title: "This Week", value: "\(pagesThisWeek)", subtitle: "pages", color: .blue)
                        StatCard(title: "This Year", value: "\(booksThisYear)", subtitle: "books", color: .green)
                        StatCard(title: "Streak", value: "\(currentStreak)", subtitle: "days", color: .orange)
                    }
                    
                    // Recently Read Books Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recently Read")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        if recentBooks.isEmpty {
                            ContentUnavailableView(
                                "No Recent Activity",
                                systemImage: "book.closed",
                                description: Text("Start reading to see your recent books here")
                            )
                            .frame(height: 200)
                        } else {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                ForEach(recentBooks.prefix(3), id: \.id) { book in
                                    RecentBookCard(book: book) {
                                        selectedBookForLog = book
                                        showingQuickLog = true
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Today")
            .navigationSubtitle(formattedDate)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingQuickLog = true
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .sheet(isPresented: $showingQuickLog) {
            QuickLogSheet(selectedBook: selectedBookForLog)
        }
    }
    
    // MARK: - Computed Properties
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: Date())
    }
    
    private var pagesThisWeek: Int {
        let calendar = Calendar.current
        let weekStart = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
        return readingLogs.filter { $0.logDate >= weekStart }
            .reduce(0) { $0 + $1.pagesRead }
    }
    
    private var booksThisYear: Int {
        let calendar = Calendar.current
        let yearStart = calendar.dateInterval(of: .year, for: Date())?.start ?? Date()
        return readingLogs.filter { $0.logDate >= yearStart }
            .map { $0.book.id }
            .removingDuplicates()
            .count
    }
    
    private var todayPages: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        return readingLogs.filter { $0.logDate >= today && $0.logDate < tomorrow }
            .reduce(0) { $0 + $1.pagesRead }
    }
    
    private var currentStreak: Int {
        let calendar = Calendar.current
        var streak = 0
        var checkDate = calendar.startOfDay(for: Date())
        
        while true {
            let nextDay = calendar.date(byAdding: .day, value: 1, to: checkDate)!
            let hasReadingOnDate = readingLogs.contains { log in
                calendar.isDate(log.logDate, inSameDayAs: checkDate)
            }
            
            if hasReadingOnDate {
                streak += 1
                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
            } else {
                break
            }
        }
        
        return streak
    }
    
    private var recentBooks: [Book] {
        let uniqueBookIds = Set(readingLogs.sorted { $0.logDate > $1.logDate }
            .prefix(10).map { $0.book.id })
        return books.filter { uniqueBookIds.contains($0.id) }
    }
    
    private var weeklyTrend: TrendDirection {
        let calendar = Calendar.current
        let thisWeekStart = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
        let lastWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: thisWeekStart) ?? Date()
        
        let thisWeekPages = readingLogs.filter { $0.logDate >= thisWeekStart }.reduce(0) { $0 + $1.pagesRead }
        let lastWeekPages = readingLogs.filter { $0.logDate >= lastWeekStart && $0.logDate < thisWeekStart }.reduce(0) { $0 + $1.pagesRead }
        
        if thisWeekPages > lastWeekPages { return .up }
        if thisWeekPages < lastWeekPages { return .down }
        return .neutral
    }
    
    private var yearlyTrend: TrendDirection {
        let calendar = Calendar.current
        let thisYear = calendar.component(.year, from: Date())
        let lastYear = thisYear - 1
        
        let thisYearBooks = readingLogs.filter { calendar.component(.year, from: $0.logDate) == thisYear }
            .map { $0.book.id }.removingDuplicates().count
        let lastYearBooks = readingLogs.filter { calendar.component(.year, from: $0.logDate) == lastYear }
            .map { $0.book.id }.removingDuplicates().count
            
        if thisYearBooks > lastYearBooks { return .up }
        if thisYearBooks < lastYearBooks { return .down }
        return .neutral
    }
}

struct ModernStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    var progress: Double? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                Spacer()
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            
            Text(value)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if let progress = progress {
                ProgressView(value: progress)
                    .tint(color)
            } else {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct RecentBookCard: View {
    let book: Book
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    // Book-like shadow
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.black.opacity(0.2))
                        .frame(width: 80, height: 120)
                        .offset(x: 3, y: 3)
                        .blur(radius: 2.5)

                    // Book Cover Image
                    AsyncImage(url: URL(string: book.imageName ?? "")) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray.opacity(0.1)
                            .overlay(Image(systemName: "book.closed").font(.largeTitle).foregroundColor(.gray))
                    }
                    .frame(width: 80, height: 120)
                    .clipped()
                    .cornerRadius(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4).stroke(Color.black.opacity(0.1), lineWidth: 1)
                    )
                }

                Text(book.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(width: 80)
            }
        }
        .buttonStyle(.plain)
    }
}

struct QuickLogSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let selectedBook: Book?
    @Query private var books: [Book]
    
    @State private var bookToLog: Book?
    @State private var pagesRead: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                if selectedBook == nil {
                    Picker("Book", selection: $bookToLog) {
                        Text("Choose a book...").tag(Book?.none)
                        ForEach(books, id: \.id) { book in
                            Text(book.title).tag(book as Book?)
                        }
                    }
                } else {
                    Text(selectedBook!.title)
                        .font(.headline)
                }
                
                TextField("Pages Read", text: $pagesRead)
                    .keyboardType(.numberPad)
                
                Button("Log Reading") {
                    logReading()
                }
                .disabled(bookToLog == nil || pagesRead.isEmpty)
            }
            .navigationTitle("Quick Log")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .onAppear {
            if let selectedBook = selectedBook {
                bookToLog = selectedBook
            }
        }
    }
    
    private func logReading() {
        guard let book = bookToLog, let pages = Int(pagesRead), pages > 0 else { return }
        let log = ReadingLog(book: book, pagesRead: pages)
        modelContext.insert(log)
        dismiss()
    }
}

// MARK: - Supporting Types

enum TrendDirection {
    case up, down, neutral
    
    var icon: String {
        switch self {
        case .up: return "arrow.up.right"
        case .down: return "arrow.down.right"
        case .neutral: return "minus"
        }
    }
    
    var color: Color {
        switch self {
        case .up: return .green
        case .down: return .red
        case .neutral: return .secondary
        }
    }
}

// MARK: - Daily Goal Hero Card

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

// MARK: - Modern Stat Card

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

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
}

#Preview {
    DashboardView()
        .modelContainer(mockContainer())
}
