//
//  TabItem.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 24.01.24.
//

import Foundation

enum TabItem {
    case home, add, favorites
    var title: String {
        switch self {
        case .home: return "Home"
        case .add: return "Add"
        case .favorites: return "Favorites"
        }
    }
    var icon: String {
        switch self {
        case .home: return "house"
        case .add: return "plus"
        case .favorites: return "star.fill"
        }
    }
}
