//
//  MainTabView.swift
//  Books83
//
//  Created by Quest76 on 08.08.2025.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    
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
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .background(Color.appBackground)
        .toolbarBackground(Color.cardBackground, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .tint(Color.accent)
    }
}

#Preview {
    MainTabView()
        .modelContainer(mockContainer())
}
