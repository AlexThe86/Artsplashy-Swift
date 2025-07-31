//
//  ArtSplashyApp.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 22.01.24.
//

import SwiftUI
import Firebase

@main
struct ArtSplashyApp: App {
    @StateObject private var userViewModel = UserViewModel()
    
    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if userViewModel.userIsLoggedIn {
                MainTabView()
                    .environmentObject(userViewModel)
            } else {
                AuthenticationView()
                    .environmentObject(userViewModel)
            }
        }
    }
}
