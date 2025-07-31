//
//  UserProfileView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 01.02.24.
//

import SwiftUI
import Firebase

struct UserProfileView: View {
    
    @StateObject var viewModel = UserViewModel()
    @StateObject var postViewModel = PostViewModel()
    
    @ObservedObject var followViewModel = FollowerViewModel()
    @ObservedObject var messageViewModel = MessageViewModel(messages: [])
    
    @State private var isFollowing = false
    @State private var followerCount = 0
    
    @State private var isLoading = true
    @State private var displayedPostCount = 3
    
    @State private var navigateToMessageView = false
    
    var userId: String
    
    init(userId: String) {
        self.userId = userId
        print("UserProfileView init mit userId: \(userId)")
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if let profile = viewModel.profiles.first(where: { $0.userId == userId }) {
                    ProfileSectionView(profile: profile)
                }
                if isLoading {
                    ProgressView()
                } else {
                    FollowSectionView(isFollowing: $isFollowing, followerCount: $followerCount, toggleFollow: toggleFollow, sendMessage: toggleMessage, userId: userId)
                    PostsSectionView(posts: postViewModel.postsDataList, userId: userId, displayedPostCount: $displayedPostCount, postViewModel: postViewModel)
                }
            }
        }
        .onAppear {
            Task{
                await followViewModel.getFollowerCount(userId: userId)
                followerCount = followViewModel.followerCount
                print("Task ausgeführt: Geladener Follower \(followerCount)")
                await checkFollowingStatus()
                isFollowing = followViewModel.isFollowing
            }
            fetchProfileDetails()
            postViewModel.loadUserPosts(userId: userId)
        }
        .background(
            NavigationLink(
                destination: MessageView(viewModel: messageViewModel, userViewModel: viewModel, chatId: userId),
                isActive: $navigateToMessageView,
                label: { EmptyView() }
            )
        )
    }
    
    private func fetchProfileDetails() {
        isLoading = true
        Task {
            await viewModel.fetchProfileDetails(userId: userId)
            DispatchQueue.main.async {
                if let profile = viewModel.profiles.first(where: { $0.userId == userId }) {
                    print("Profile loaded: \(profile.username)")
                    isLoading = false
                } else {
                    print("Profile not found or error occurred.")
                    isLoading = false
                }
            }
        }
    }
    
    private func toggleFollow() {
        if isFollowing {
            followViewModel.unfollowUser(followerId: Auth.auth().currentUser?.uid ?? "", followingId: userId)
        } else {
            followViewModel.followUser(followerId: Auth.auth().currentUser?.uid ?? "", followingId: userId)
        }
        isFollowing.toggle()
    }
    
    
    private func toggleMessage() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        messageViewModel.createChatRoom(otherUserId: userId)
        navigateToMessageView = true
    }

    
    private func checkFollowingStatus() async {
        await followViewModel.isFollowing(followerId: Auth.auth().currentUser?.uid ?? "", followingId: userId)
    }
    
    struct UserProfileView_Previews: PreviewProvider {
        static var previews: some View {
            UserProfileView(userId: "id")
        }
    }
}
