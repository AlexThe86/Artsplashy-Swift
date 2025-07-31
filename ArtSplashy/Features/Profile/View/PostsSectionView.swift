//
//  PostsSectionView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 15.02.24.
//

import SwiftUI

struct PostsSectionView: View {
    
    var posts: [PostsData]
    var userId: String
    
    @Binding var displayedPostCount: Int
    var postViewModel: PostViewModel
    
    var body: some View {
        let userPosts = posts.filter { $0.userId == userId }
        
        if !userPosts.isEmpty {
            Text("Beiträge \(userPosts.count)")
                .font(.headline)
                .padding()

            let columnCount = min(3, userPosts.count)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columnCount), spacing: 10) {
                ForEach(Array(userPosts.prefix(displayedPostCount).enumerated()), id: \.element.id) { index, post in
                    NavigationLink(destination: PostDetailView(viewModel: postViewModel, postId: post.id)) {
                        AsyncImage(url: URL(string: post.imageUrl)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 125, height: 125)
                        .cornerRadius(8)
                    }
                    .onAppear {
                        if index == displayedPostCount - 1 && displayedPostCount < userPosts.count {
                            displayedPostCount = min(displayedPostCount + 3, userPosts.count)
                        }
                    }
                }
            }
        } else {
            Text("Keine Beiträge vorhanden.").padding()
        }
    }
}
