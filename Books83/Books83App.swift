//
//  Books83App.swift
//  Books83
//
//  Created by Quest76 on 08.08.2025.
//

import SwiftUI
import SwiftData

@main
struct Books83App: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.dark)
                .background(Color.appBackground)
                .tint(Color.accent)
        }
        .modelContainer(for: modelRegistry)
    }
}
