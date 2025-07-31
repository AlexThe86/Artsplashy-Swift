//
//  FollowerViewModel.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 15.02.24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import SwiftUI

@MainActor
class FollowerViewModel: ObservableObject {
    
    private var firestore = Firestore.firestore()
    private var userId: String?
    
    @Published var followerCount: Int = 0
    @Published var followingCount: Int = 0
    
    @Published var isFollowing: Bool = false
    
    @Published var followers: [Profile] = []
    @Published var followingDetails: [Profile] = []
    
    func refreshData() async {
        if let userId = userId {
            await getFollowerCount(userId: userId)
            //getFollowingCount(userId: userId)
        } else {
            print("Error: userId is nil")
        }
    }
    
    func isFollowing(followerId: String, followingId: String) async {
        let query = firestore.collection("Followers")
            .whereField("followerId", isEqualTo: followerId)
            .whereField("followingId", isEqualTo: followingId)
        
        do {
            let snapshot = try await query.getDocuments()
            isFollowing = !snapshot.isEmpty
            print("isFollowing: \(isFollowing)")
        } catch {
            print("Error checking if following: \(error.localizedDescription)")
        }
    }
    
    func getFollowerCount(userId: String) async {
        let query = firestore.collection("Followers").whereField("followingId", isEqualTo: userId)
        
        do {
            let snapshot = try await query.getDocuments()
            followerCount = snapshot.documents.count
            print("Anzahl geladener Follower: \(followerCount)")
        } catch {
            print("Fehler beim Abrufen der Follower-Anzahl: \(error.localizedDescription)")
        }
    }
    
    func getFollowingCount(userId: String) {
        let query = firestore.collection("Followers").whereField("followerId", isEqualTo: userId)
        
        query.getDocuments { snapshot, error in
            if let error = error {
                print("Error getting following count: \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                self.followingCount = snapshot.documents.count
            }
        }
    }
    
    func followUser(followerId: String, followingId: String) {
        let data: [String: Any] = [
            "followerId": followerId,
            "followingId": followingId
        ]
        
        firestore.collection("Followers").addDocument(data: data) { error in
            if let error = error {
                print("Error while trying to follow: \(error.localizedDescription)")
            } else {
                print("User \(followerId) follows \(followingId)")
            }
        }
    }
    
    func unfollowUser(followerId: String, followingId: String) {
        let query = firestore.collection("Followers").whereField("followerId", isEqualTo: followerId).whereField("followingId", isEqualTo: followingId)
        
        query.getDocuments { snapshot, error in
            if let error = error {
                print("Error while trying to unfollow: \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    document.reference.delete()
                }
            }
        }
    }
    
    private func getUsernameFromId(userId: String) async -> String? {
        let docRef = firestore.collection("profile").document(userId)
        do {
            let document = try await docRef.getDocument()
            if let username = document.get("username") as? String, !username.isEmpty {
                print("Username retrieved for ID \(userId): \(username)")
                return username
            } else {
                print("Username for ID \(userId) does not exist")
                return nil
            }
        } catch {
            print("Error getting username for ID \(userId): \(error.localizedDescription)")
            return nil
        }
    }

    
    func getFollowingUsers(userId: String) async -> [String] {
        let query = firestore.collection("Followers").whereField("followerId", isEqualTo: userId)
        do {
            let snapshot = try await query.getDocuments()
            let followingIds = snapshot.documents.compactMap { $0.get("followingId") as? String }
            return followingIds
        } catch {
            print("Error getting users: \(error.localizedDescription)")
            return []
        }
    }

    func getFollowingDetails(userId: String) async -> [Profile] {
        let followingIds = await getFollowingUsers(userId: userId)
        var profiles: [Profile] = []

        for followingId in followingIds {
            if let username = await getUsernameFromId(userId: followingId) {
                let profile = Profile(userId: followingId, username: username)
                profiles.append(profile)
            }
        }
        return profiles
    }
}
