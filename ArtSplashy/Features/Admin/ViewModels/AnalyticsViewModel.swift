//
//  AnalyticsViewModel.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 12.02.24.
//

import Foundation
import Firebase

@MainActor
class AnalyticsViewModel: ObservableObject {
    @Published var postingsCount = 0
    @Published var usersCount = 0
    @Published var commentsCount = 0

    private var db = Firestore.firestore()

    func countDocuments() async {
        do {
            let postingsSnapshot = try await db.collection("posts").getDocuments()
            self.postingsCount = postingsSnapshot.documents.count
            
            let profileSnapshot = try await db.collection("profile").getDocuments()
            self.usersCount = profileSnapshot.documents.count
            
            let commentSnapshot = try await db.collection("comments").getDocuments()
            self.commentsCount = commentSnapshot.documents.count
        } catch {
            print("Error getting document counts: \(error)")
        }
    }
}

