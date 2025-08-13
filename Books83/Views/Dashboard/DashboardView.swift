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
                        selectedBookForLog = lastLoggedBook
                        showingQuickLog = true
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .sheet(isPresented: $showingQuickLog) {
            QuickLogSheet(preSelectedBook: selectedBookForLog)
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
            _ = calendar.date(byAdding: .day, value: 1, to: checkDate)!
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
    
    private var lastLoggedBook: Book? {
        readingLogs.sorted { $0.logDate > $1.logDate }.first?.book
    }
}

#Preview {
    DashboardView()
        .modelContainer(mockContainer())
}
