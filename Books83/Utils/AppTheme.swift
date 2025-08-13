//
//  AppTheme.swift
//  Books83
//
//  Created on 2025-08-13.
//

import SwiftUI
import Combine

// MARK: - Theme Protocol

/// Protocol defining the structure of an app theme
protocol AppTheme {
    var name: String { get }
    
    // Background colors
    var primaryBackground: Color { get }
    var secondaryBackground: Color { get }
    var tertiaryBackground: Color { get }
    
    // Text colors
    var primaryText: Color { get }
    var secondaryText: Color { get }
    var tertiaryText: Color { get }
    
    // Accent colors
    var accent: Color { get }
    var success: Color { get }
    var warning: Color { get }
    var error: Color { get }
    var info: Color { get }
    
    // UI element colors
    var separator: Color { get }
    var shadow: Color { get }
}

// MARK: - Catppuccin Mocha Theme

struct CatppuccinMochaTheme: AppTheme {
    let name = "Catppuccin Mocha"
    
    // Background colors
    var primaryBackground: Color { Color(red: 0.117, green: 0.117, blue: 0.169) } // #1e1e2e
    var secondaryBackground: Color { Color(red: 0.149, green: 0.149, blue: 0.196) } // #313244
    var tertiaryBackground: Color { Color(red: 0.176, green: 0.176, blue: 0.224) } // #45475a
    
    // Text colors
    var primaryText: Color { Color(red: 0.804, green: 0.843, blue: 0.922) } // #cdd6f4
    var secondaryText: Color { Color(red: 0.725, green: 0.769, blue: 0.847) } // #bac2de
    var tertiaryText: Color { Color(red: 0.651, green: 0.694, blue: 0.773) } // #a6adc8
    
    // Accent colors
    var accent: Color { Color(red: 0.537, green: 0.733, blue: 0.980) } // #89b4fa
    var success: Color { Color(red: 0.651, green: 0.886, blue: 0.631) } // #a6e3a1
    var warning: Color { Color(red: 0.976, green: 0.718, blue: 0.549) } // #fab387
    var error: Color { Color(red: 0.973, green: 0.475, blue: 0.647) } // #f38ba8
    var info: Color { Color(red: 0.537, green: 0.863, blue: 0.976) } // #89dceb
    
    // UI element colors
    var separator: Color { Color(red: 0.427, green: 0.459, blue: 0.537) } // #6c7086
    var shadow: Color { Color(red: 0.071, green: 0.071, blue: 0.129) } // #11111b
}

// MARK: - Solarized Dark Theme

struct SolarizedDarkTheme: AppTheme {
    let name = "Solarized Dark"
    
    // Background colors
    var primaryBackground: Color { Color(red: 0.0, green: 0.169, blue: 0.212) } // #002b36
    var secondaryBackground: Color { Color(red: 0.027, green: 0.212, blue: 0.259) } // #073642
    var tertiaryBackground: Color { Color(red: 0.345, green: 0.431, blue: 0.459) } // #586e75
    
    // Text colors
    var primaryText: Color { Color(red: 0.992, green: 0.965, blue: 0.890) } // #fdf6e3
    var secondaryText: Color { Color(red: 0.576, green: 0.631, blue: 0.631) } // #93a1a1
    var tertiaryText: Color { Color(red: 0.514, green: 0.580, blue: 0.588) } // #839496
    
    // Accent colors
    var accent: Color { Color(red: 0.149, green: 0.545, blue: 0.824) } // #268bd2
    var success: Color { Color(red: 0.522, green: 0.600, blue: 0.0) } // #859900
    var warning: Color { Color(red: 0.906, green: 0.435, blue: 0.133) } // #e76f22
    var error: Color { Color(red: 0.863, green: 0.196, blue: 0.184) } // #dc322f
    var info: Color { Color(red: 0.164, green: 0.631, blue: 0.596) } // #2aa198
    
    // UI element colors
    var separator: Color { Color(red: 0.345, green: 0.431, blue: 0.459) } // #586e75
    var shadow: Color { Color(red: 0.0, green: 0.169, blue: 0.212).opacity(0.5) }
}

// MARK: - Nord Theme

struct NordTheme: AppTheme {
    let name = "Nord"
    
    // Background colors
    var primaryBackground: Color { Color(red: 0.180, green: 0.204, blue: 0.251) } // #2e3440
    var secondaryBackground: Color { Color(red: 0.216, green: 0.251, blue: 0.314) } // #3b4252
    var tertiaryBackground: Color { Color(red: 0.263, green: 0.298, blue: 0.369) } // #434c5e
    
    // Text colors
    var primaryText: Color { Color(red: 0.922, green: 0.937, blue: 0.956) } // #eceff4
    var secondaryText: Color { Color(red: 0.898, green: 0.914, blue: 0.941) } // #e5e9f0
    var tertiaryText: Color { Color(red: 0.847, green: 0.871, blue: 0.914) } // #d8dee9
    
    // Accent colors
    var accent: Color { Color(red: 0.365, green: 0.506, blue: 0.675) } // #5e81ac
    var success: Color { Color(red: 0.639, green: 0.745, blue: 0.549) } // #a3be8c
    var warning: Color { Color(red: 0.922, green: 0.796, blue: 0.545) } // #ebcb8b
    var error: Color { Color(red: 0.749, green: 0.380, blue: 0.416) } // #bf616a
    var info: Color { Color(red: 0.533, green: 0.753, blue: 0.816) } // #88c0d0
    
    // UI element colors
    var separator: Color { Color(red: 0.298, green: 0.337, blue: 0.408) } // #4c566a
    var shadow: Color { Color(red: 0.180, green: 0.204, blue: 0.251).opacity(0.5) }
}

// MARK: - Theme Manager

class ThemeManager: ObservableObject {
    @Published private var currentThemeIndex: Int = 0
    
    var currentTheme: AppTheme {
        Self.availableThemes[currentThemeIndex]
    }
    
    static let shared = ThemeManager()
    
    private init() {}
    
    func setTheme(_ theme: AppTheme) {
        if let index = Self.availableThemes.firstIndex(where: { $0.name == theme.name }) {
            currentThemeIndex = index
        }
    }
    
    // Available themes
    static let availableThemes: [AppTheme] = [
        CatppuccinMochaTheme(),
        SolarizedDarkTheme(),
        NordTheme()
    ]
}

// MARK: - Color Extensions for Easy Access

extension Color {
    
    // MARK: - Theme-based Colors (using current theme)
    
    // Background colors
    static var appBackground: Color { 
        ThemeManager.shared.currentTheme.primaryBackground
    }
    static var cardBackground: Color { 
        ThemeManager.shared.currentTheme.secondaryBackground
    }
    static var surfaceBackground: Color { 
        ThemeManager.shared.currentTheme.tertiaryBackground
    }
    
    // Text colors
    static var primaryText: Color { 
        ThemeManager.shared.currentTheme.primaryText
    }
    static var secondaryText: Color { 
        ThemeManager.shared.currentTheme.secondaryText
    }
    static var tertiaryText: Color { 
        ThemeManager.shared.currentTheme.tertiaryText
    }
    
    // Accent colors
    static var accent: Color { 
        ThemeManager.shared.currentTheme.accent
    }
    static var success: Color { 
        ThemeManager.shared.currentTheme.success
    }
    static var warning: Color { 
        ThemeManager.shared.currentTheme.warning
    }
    static var error: Color { 
        ThemeManager.shared.currentTheme.error
    }
    static var info: Color { 
        ThemeManager.shared.currentTheme.info
    }
    
    // UI element colors
    static var separator: Color { 
        ThemeManager.shared.currentTheme.separator
    }
    static var shadow: Color { 
        ThemeManager.shared.currentTheme.shadow
    }
    
    // MARK: - Status-specific Colors
    
    static var readingStatusColors: (reading: Color, completed: Color, notStarted: Color, paused: Color) {
        let theme = ThemeManager.shared.currentTheme
        return (
            reading: theme.accent,
            completed: theme.success,
            notStarted: theme.tertiaryText,
            paused: theme.warning
        )
    }
}

// MARK: - Environment Key for Theme

struct ThemeEnvironmentKey: EnvironmentKey {
    static let defaultValue: AppTheme = CatppuccinMochaTheme()
}

extension EnvironmentValues {
    var appTheme: AppTheme {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
}

// MARK: - View Modifier for Theming

struct ThemedView: ViewModifier {
    @ObservedObject private var themeManager = ThemeManager.shared
    
    func body(content: Content) -> some View {
        content
            .environment(\.appTheme, themeManager.currentTheme)
            .preferredColorScheme(.dark)
    }
}

extension View {
    func themed() -> some View {
        modifier(ThemedView())
    }
}
