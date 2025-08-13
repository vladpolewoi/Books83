//
//  ThemePickerView.swift
//  Books83
//
//  Created on 2025-08-13.
//

import SwiftUI

struct ThemePickerView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Available Themes")) {
                    ForEach(ThemeManager.availableThemes, id: \.name) { theme in
                        ThemeRow(
                            theme: theme,
                            isSelected: theme.name == themeManager.currentTheme.name
                        ) {
                            themeManager.setTheme(theme)
                        }
                    }
                }
            }
            .navigationTitle("Themes")
            .navigationBarTitleDisplayMode(.large)
            .background(Color.appBackground)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ThemeRow: View {
    let theme: AppTheme
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(theme.name)
                        .font(.headline)
                        .foregroundColor(.primaryText)
                    
                    // Theme color preview
                    HStack(spacing: 4) {
                        Circle()
                            .fill(theme.primaryBackground)
                            .frame(width: 12, height: 12)
                        Circle()
                            .fill(theme.accent)
                            .frame(width: 12, height: 12)
                        Circle()
                            .fill(theme.success)
                            .frame(width: 12, height: 12)
                        Circle()
                            .fill(theme.warning)
                            .frame(width: 12, height: 12)
                        Circle()
                            .fill(theme.error)
                            .frame(width: 12, height: 12)
                    }
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accent)
                        .fontWeight(.semibold)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ThemePickerView()
}
