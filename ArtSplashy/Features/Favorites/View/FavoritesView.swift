//
//  FavoritesView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 23.01.24.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel = PostViewModel()

    var body: some View {
        NavigationView {
            if viewModel.favoritePosts.isEmpty {
                Text("Keine Favoriten vorhanden.")
                    .font(.headline)
                    .padding()
            } else {
                List(viewModel.favoritePosts, id: \.id) { post in
                    NavigationLink(destination: PostDetailView(viewModel: viewModel, postId: post.id)) {
                        PostView(post: post)
                    }
                }
                .navigationBarTitle("Favoriten")
            }
        }
        .onAppear {
            viewModel.loadFavoritePosts()
        }
    }
}

#Preview {
    FavoritesView()
}
