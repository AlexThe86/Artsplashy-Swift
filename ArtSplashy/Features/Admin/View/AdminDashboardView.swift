//
//  AdminDashboardView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 01.02.24.
//

import SwiftUI

struct AdminDashboardView: View {
    @ObservedObject var userViewModel = UserViewModel()
    @ObservedObject var postViewModel = PostViewModel()
    
    @State private var selectedTab: DashboardTab = .user
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Auswählen:", selection: $selectedTab) {
                    ForEach(DashboardTab.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                selectedTab.tabView(userViewModel: userViewModel,postviewmodel: postViewModel)
                Spacer()
            }
            .navigationTitle("Admin Dashboard")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AdminDashboardView()
}
