//
//  FollowSectionView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 15.02.24.
//

import SwiftUI

struct FollowSectionView: View {
    @StateObject var followViewModel = FollowerViewModel()
    
    @Binding var isFollowing: Bool
    @Binding var followerCount: Int
    
    var toggleFollow: () -> Void
    var sendMessage: () -> Void
    
    var userId: String
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: toggleFollow) {
                    Label(isFollowing ? "Unfollow" : "Follow", systemImage: "person.badge.plus")
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .background(isFollowing ? Color.red : Color.blue)
                        .cornerRadius(8)
                }
                Button(action: sendMessage) {
                    Label("Nachricht", systemImage: "envelope.open.fill")
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            
            Text("Followers: \(followerCount)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
    }
}
