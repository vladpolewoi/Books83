//
//  SettingsView.swift
//  Books83
//
//  Created on 2025-08-13.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var showingThemePicker = false
    
    var body: some View {
        NavigationView {
            List {
                // Appearance Section
                Section("Appearance") {
                    HStack {
                        Label("Theme", systemImage: "paintpalette")
                            .foregroundColor(.primaryText)
                        
                        Spacer()
                        
                        Text(themeManager.currentTheme.name)
                            .foregroundColor(.secondaryText)
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.tertiaryText)
                            .font(.caption)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showingThemePicker = true
                    }
                }
                
                // About Section
                Section("About") {
                    HStack {
                        Label("Version", systemImage: "info.circle")
                            .foregroundColor(.primaryText)
                        
                        Spacer()
                        
                        Text("1.0.0")
                            .foregroundColor(.secondaryText)
                    }
                    
                    HStack {
                        Label("Build", systemImage: "hammer")
                            .foregroundColor(.primaryText)
                        
                        Spacer()
                        
                        Text("83")
                            .foregroundColor(.secondaryText)
                    }
                }
                
                // Reading Section
                Section("Reading") {
                    HStack {
                        Label("Daily Goal", systemImage: "target")
                            .foregroundColor(.primaryText)
                        
                        Spacer()
                        
                        Text("100 pages")
                            .foregroundColor(.secondaryText)
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.tertiaryText)
                            .font(.caption)
                    }
                    
                    HStack {
                        Label("Notifications", systemImage: "bell")
                            .foregroundColor(.primaryText)
                        
                        Spacer()
                        
                        Toggle("", isOn: .constant(false))
                    }
                }
            }
            .navigationTitle("Settings")
            .background(Color.appBackground)
        }
        .sheet(isPresented: $showingThemePicker) {
            ThemePickerView()
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    SettingsView()
}
