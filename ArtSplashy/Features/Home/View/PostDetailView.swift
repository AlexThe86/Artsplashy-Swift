//
//  DetailView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 23.01.24.
//

import SwiftUI

struct PostDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: PostViewModel
    
    let postId: String
    let currentUserID = FirebaseManager.shared.userId
    
    @State private var displayedPostCount = 3
    @State private var selectedPostId: String?
    
    @State private var showingComments = false
    @State private var showingEditPostView = false
    @State private var showingAlert = false
    
    @StateObject private var commentsViewModel = CommentsViewModel()
    @EnvironmentObject var userViewModel: UserViewModel
    
    var post: PostsData? {
        viewModel.postsDataList.first { $0.id == postId }
    }
    
    var selectedPost: PostsData? {
        if let selectedPostId = selectedPostId {
            return viewModel.postsDataList.first { $0.id == selectedPostId }
        }
        return nil
    }
    
    var displayedPost: PostsData? {
        selectedPost ?? post
    }
    
    func loadComments(postId: String) {
        commentsViewModel.getCommentsForPost(postId: postId)
    }
    
    var body: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView {
                if let displayedPost = displayedPost {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack{
                            Text(displayedPost.title)
                                .font(.title)
                            Spacer()
                            if currentUserID == displayedPost.userId {
                                Button(action: {}) {
                                    Image(systemName: "gear")
                                        .rotationEffect(.degrees(90))
                                        .imageScale(.large)
                                }
                                .padding(.trailing, 8)
                                .contextMenu {
                                    Button {
                                        self.showingEditPostView = true
                                    } label: {
                                        Label("Edit Post", systemImage: "pencil")
                                    }
                                    Button {
                                        // Zeige den Alert anstatt direkt zu löschen
                                        self.showingAlert = true
                                    } label: {
                                        Label("Delete Post", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        
                        
                        NavigationLink(destination: PostEditView(viewModel: viewModel, post: displayedPost), isActive: $showingEditPostView) {
                            EmptyView()
                        }
                        .hidden()
                        
                        NavigationLink(destination: UserProfileView(userId: displayedPost.userId)) {
                            Text("By \(displayedPost.creatorName)")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        
                        Text(displayedPost.createdAt.formattedDate())
                            .font(.caption)
                            .foregroundColor(.gray)
                        AsyncImage(url: URL(string: displayedPost.imageUrl)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(10)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(10)
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .id("mainImage")
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        Text(displayedPost.description)
                            .font(.body)
                        Divider()
                        
                        // ab hier werden die letzten 3 kommentare angezeigt.
                        VStack {
                            if commentsViewModel.comments.isEmpty {
                                HStack {
                                    Text("Keine Kommentare vorhanden")
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Button(action: {
                                        showingComments.toggle()
                                    }) {
                                        Image(systemName: "pencil")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 18, height: 18)
                                    }
                                    .padding(.horizontal)
                                }
                                .padding()
                            } else {
                                ForEach(commentsViewModel.comments.suffix(3)) { comment in
                                    HStack(spacing: 8) {
                                        if let profile = userViewModel.profiles.first(where: { $0.userId == comment.userId }) {
                                            let imageUrl = URL(string: profile.profilephoto)
                                            if let imageUrl = imageUrl {
                                                AsyncImage(url: imageUrl) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        ProgressView()
                                                    case .success(let image):
                                                        image.resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 25, height: 25)
                                                            .clipShape(Circle())
                                                    case .failure:
                                                        Image(systemName: "person.crop.circle.fill")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 25, height: 25)
                                                            .clipShape(Circle())
                                                    @unknown default:
                                                        EmptyView()
                                                    }
                                                }
                                            }
                                        }
                                        Text(comment.text)
                                            .font(.footnote)
                                            .padding(10)
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(10)
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                Button("Mehr Kommentare anzeigen") {
                                    showingComments.toggle()
                                }
                            }
                        }
                        Text("Weitere Beiträge von \(displayedPost.creatorName)")
                            .font(.headline)
                            .padding()
                        let columnCount = min(3, viewModel.userPosts.count)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columnCount), spacing: 10) {
                            ForEach(viewModel.userPosts.indices.prefix(displayedPostCount), id: \.self) { index in
                                let userPost = viewModel.userPosts[index]
                                Button(action: {
                                    selectedPostId = userPost.id
                                    // Aktualisiert die ID des ausgewählten Posts
                                    withAnimation {
                                        scrollViewProxy.scrollTo("mainImage", anchor: .top)
                                    }
                                }) {
                                    if let imageUrl = URL(string: userPost.imageUrl) {
                                        AsyncImage(url: imageUrl) { image in
                                            image.resizable()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 110, height: 110)
                                        .cornerRadius(8)
                                    }
                                }
                                .onAppear {
                                    if index == displayedPostCount - 1 {
                                        print("Das letzte angezeigte Element (\(index)) ist erreicht.")
                                        if displayedPostCount < viewModel.userPosts.count {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                let previousPostCount = displayedPostCount
                                                displayedPostCount = min(displayedPostCount + 3, viewModel.userPosts.count)
                                                print("Lade mehr Posts... Vorher: \(previousPostCount), Nachher: \(displayedPostCount)")
                                            }
                                        } else {
                                            print("Keine weiteren Posts zum Laden. Gesamtanzahl der Posts: \(viewModel.userPosts.count)")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                } else {
                    Text("Laden...")
                }
            }
            .navigationTitle("Post Details")
            .onAppear {
                if viewModel.postsDataList.isEmpty {
                    viewModel.loadInitialData()
                }
                if let userId = displayedPost?.userId {
                    viewModel.loadUserPosts(userId: userId)
                    Task {
                        await userViewModel.fetchProfileDetails(userId: userId)
                    }
                }
                if let postId = displayedPost?.id {
                    commentsViewModel.getCommentsForPost(postId: postId)
                }
            }
            .onChange(of: selectedPostId) { newPostId in
                if let newPostId = newPostId {
                    loadComments(postId: newPostId)
                }
            }
            .sheet(isPresented: $showingComments) {
                if let postId = displayedPost?.id {
                    CommentsView(postId: postId)
                        .environmentObject(UserViewModel())
                } else {
                    Text("Wähle einen Post aus um kommentare zu sehen.")
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Delete Post"),
                    message: Text("Are you sure you want to delete this post?"),
                    primaryButton: .destructive(Text("Delete")) {
                        // Führe die Löschaktion aus, wenn bestätigt.
                        if let post = displayedPost {
                            viewModel.deletePost(post: post)
                            presentationMode.wrappedValue.dismiss()
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
}

/*struct PostDetailView_Previews: PreviewProvider {
 static var previews: some View {
 let exampleViewModel = PostViewModel()
 
 PostDetailView(viewModel: exampleViewModel, postId: "examplePostId")
 .environmentObject(UserViewModel())
 }
 }*/
