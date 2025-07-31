//
//  SettingsView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 01.02.24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        Form {
            Section(header: Text("Allgemeine Einstellungen")) {
                Toggle(isOn: $isDarkMode) {
                    Text("Dark Mode")
                }
            }
        }
        .navigationTitle("Einstellungen")
        .onChange(of: isDarkMode) { newValue in
            updateAppearance()
        }
        .onChange(of: scenePhase) { _ in
            updateAppearance()
        }
        .onAppear {
            updateAppearance()
        }
    }
    
    private func updateAppearance() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        }
    }
}
#Preview {
    SettingsView()
}
