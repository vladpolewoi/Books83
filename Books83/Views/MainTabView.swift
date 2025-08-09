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
            BookListView()
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Books")
                }
            
            ReadingLogsView()
                .tabItem {
                    Image(systemName: "book.pages")
                    Text("Reading Logs")
                }
        }
    }
}

#Preview {
    MainTabView()
        .modelContainer(mockContainer())
}
