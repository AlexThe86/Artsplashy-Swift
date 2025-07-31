//
//  DashboardTab.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 01.02.24.
//

import Foundation
import SwiftUI

enum DashboardTab: String, CaseIterable {
    case user = "User"
    case content = "Posts"
    case analytics = "Analytik"
    case moderation = "Moderation"

    @ViewBuilder
    func tabView(userViewModel: UserViewModel,postviewmodel: PostViewModel) -> some View {
        switch self {
        case .user:
            UserManagementView(viewModel: userViewModel)
        case .content:
            ContentManagementView(viewModel: postviewmodel)
        case .analytics:
            AnalyticsView()
        case .moderation:
            ModerationView()
        }
    }
}
