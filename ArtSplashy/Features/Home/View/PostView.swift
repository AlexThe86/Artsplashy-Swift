//
//  PostView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 22.01.24.
//

import SwiftUI

struct PostView: View {
    @ObservedObject var viewModel = PostViewModel()
    var post: PostsData
    @State private var isLiked: Bool

    init(post: PostsData) {
        self.post = post
        _isLiked = State(initialValue: post.isLiked)
    }

    var body: some View {
        VStack {
            ZStack {
                AsyncImage(url: URL(string: post.imageUrl)) { phase in
                    if let image = phase.image {
                        image.resizable()
                            .cornerRadius(10)
                            .aspectRatio(contentMode: .fit)
                            .scaledToFill()
                            .frame(width: 180, height: 200, alignment: .center)
                    } else {
                        Image(systemName: "photo.artframe")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(10)

                // Kategorie-Text mit halbtransparentem Hintergrund
                VStack {
                    HStack {
                        Text(post.category.uppercased())
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(5)
                            .padding(.top, 10)
                            .padding(.leading, 10)
                        Spacer()
                    }
                    Spacer()
                }

                // Stern und Like-Anzahl unten rechts
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("\(post.likeCount)")
                            .font(.caption)
                            .foregroundColor(.yellow)
                            .bold()
                            .padding(.trailing, 5)
                        Button(action: {
                            toggleLike()
                        }) {
                            Image(systemName: isLiked ? "star.fill" : "star")
                                .foregroundColor(isLiked ? .yellow : .gray)
                                .padding(5)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.bottom, 10)
                    .padding(.trailing, 10)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(.horizontal)
    }

    func toggleLike() {
        isLiked.toggle()
        viewModel.toggleLikeForPost(post: post)
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePost = PostsData(
            id: "1",
            title: "Sample Title",
            description: "This is a sample description.",
            imageUrl: "https://image.png",
            likeCount: 10,
            isLiked: false,
            userId: "user123",
            creatorName: "Sample Creator",
            category: "Darstellende Kunst",
            createdAt: Date()
        )
        PostView(post: samplePost)
            .environmentObject(PostViewModel())
    }
}


