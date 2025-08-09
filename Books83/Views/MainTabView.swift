//
//  MainTabView.swift
//  Books83
//
//  Created by Quest76 on 08.08.2025.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Dashboard")
                }
            
            BookListView()
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Books")
                }
        }
    }
}

#Preview {
    MainTabView()
        .modelContainer(mockContainer())
}
