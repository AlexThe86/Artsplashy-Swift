//
//  MainTabView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 23.01.24.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem {
                    Label("Home", systemImage: TabItem.home.icon)
                }
                .tag(TabItem.home)
            AddPostView()
                .tabItem {
                    Label("Add Post", systemImage: TabItem.add.icon)
                }
                .tag(TabItem.add)
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: TabItem.favorites.icon)
                }
                .tag(TabItem.favorites)
        }
    }
}

#Preview {
    MainTabView()
}
