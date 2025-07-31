//
//  PostViewModel.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 22.01.24.
//
import CoreData
import Foundation
import FirebaseFirestore
import FirebaseStorage
import SwiftUI
import PhotosUI

@MainActor
class PostViewModel: ObservableObject {
    
    @Published var postsDataList: [PostsData] = []
    @Published var userPosts: [PostsData] = []
    @Published var favoritePosts: [PostsData] = []
    
    @Published var uploadProgress: Double = 0
    @Published var isUploading: Bool = false
    
    private var isDataLoaded = false
    private let coreDataManager = CoreDataManager.shared

    private let firestore = Firestore.firestore()
    private let storage = Storage.storage().reference()
    private let container = PersistentStore.shared
    
    private var listener: ListenerRegistration?
    
    @Published var selectedImageData: Data?
    @Published var selectedImage: PhotosPickerItem?
    
    @Published var searchText = ""
    @Published var searchResults: [PostsData] = []
    
    init() {
        loadInitialData()
    }
    
    func loadInitialData() {
        let cachedPosts = coreDataManager.loadCachedPosts()
        if !cachedPosts.isEmpty {
            self.postsDataList = cachedPosts
            print("Posts wurden aus CoreData geladen.")
        }
       setupListener()
    }
    
    func setupListener() {
        listener = firestore.collection("posts").addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }
            guard let snapshot = querySnapshot, error == nil else {
                print("Fehler beim Abrufen der Snapshots: \(error!.localizedDescription)")
                return
            }
            self.processDocumentChanges(snapshot.documentChanges)
        }
    }
    
    func removeListener() {
        postsDataList.removeAll()
        listener?.remove()
        print("Listener entfernt")
    }
    
    private func processDocumentChanges(_ changes: [DocumentChange]) {
        for change in changes {
            let data = change.document.data()
            let postId = change.document.documentID
            let post = PostsData(
                id: postId,
                title: data["title"] as? String ?? "",
                description: data["description"] as? String ?? "",
                imageUrl: data["imageUrl"] as? String ?? "",
                likeCount: data["likeCount"] as? Int ?? 0,
                isLiked: data["isLiked"] as? Bool ?? false,
                userId: data["userId"] as? String ?? "",
                creatorName: data["creatorName"] as? String ?? "",
                category: data["category"] as? String ?? "", 
                createdAt: data["createdAt"] as? Date ?? Date()
            )
            
            switch change.type {
            case .added:
                if !self.postsDataList.contains(where: { $0.id == postId }) {
                    self.postsDataList.append(post)
                    self.coreDataManager.addPost(post)
                }
            case .modified:
                if let index = self.postsDataList.firstIndex(where: { $0.id == postId }) {
                    self.postsDataList[index] = post
                    self.coreDataManager.updatePost(post)
                } else {
                    self.postsDataList.append(post)
                    self.coreDataManager.addPost(post)
                }
            case .removed:
                if let index = self.postsDataList.firstIndex(where: { $0.id == postId }) {
                    self.postsDataList.remove(at: index)
                    self.coreDataManager.deletePost(postId)
                }
            }
        }
    }

    
    func loadUserPosts(userId: String) {
        print("loadUserPosts: Lade Beiträge für userId: \(userId)")
        FirebaseManager.shared.loadUserPosts(userId: userId) { loadedPosts in
            DispatchQueue.main.async {
                self.userPosts = loadedPosts
                print("Geladene Beiträge: \(self.postsDataList.count)")
            }
        }
    }
    
    
    func uploadImageSavePost(imageData: Data, title: String, description: String, category: String) {
        isUploading = true
        uploadProgress = 0
        
        FirebaseManager.shared.uploadImageToFirebaseStorage(imageData: imageData, title: title, description: description, category: category) { progress in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { 
                // Verzögert die Aktualisierung
                self.uploadProgress = progress
                if progress >= 1.0 {
                    self.isUploading = false
                }
            }
        }
    }
    
    func toggleLikeForPost(post: PostsData) {
        guard let userId = FirebaseManager.shared.userId else {
            print("Benutzer ist nicht angemeldet.")
            return
        }
        
        FirebaseManager.shared.toggleLikeForPost(post: post) { success in
            if success {
                DispatchQueue.main.async {
                    if let index = self.postsDataList.firstIndex(where: { $0.id == post.id }) {
                        var updatedPost = post
                        updatedPost.isLiked.toggle()
                        self.postsDataList[index] = updatedPost
                        self.objectWillChange.send()

                    }
                }
            } else {
                print("Fehler beim Aktualisieren des Like-Status")
            }
        }
    }
    
    func searchCoreDataPosts(searchText: String, selectedCategory: String) {
        let allPosts = coreDataManager.loadCachedPosts()

        let filteredPosts = allPosts.filter { post in
            let matchesCategory = selectedCategory == "Alle" || post.category == selectedCategory
            let matchesSearchText = searchText.isEmpty || post.title.localizedCaseInsensitiveContains(searchText)
                || post.description.localizedCaseInsensitiveContains(searchText)
                || post.creatorName.localizedCaseInsensitiveContains(searchText)
            
            return matchesCategory && matchesSearchText
        }
        
        self.searchResults = filteredPosts.sorted { $0.title < $1.title }
    }

    
    func loadFavoritePosts() {
        let allPosts = coreDataManager.loadCachedPosts()
        let favoritePosts = allPosts.filter { $0.isLiked }
        self.favoritePosts = favoritePosts
        print("Anzahl der geladenen Favoriten: \(favoritePosts.count).")
    }

}
extension PostViewModel {
    
    func updatePost(post: PostsData, newTitle: String, newDescription: String) {
        FirebaseManager.shared.updatePost(postId: post.id, newTitle: newTitle, newDescription: newDescription) { success in
            if success {
                if let index = self.postsDataList.firstIndex(where: { $0.id == post.id }) {
                    var updatedPost = post
                    updatedPost.title = newTitle
                    updatedPost.description = newDescription
                    DispatchQueue.main.async {
                        self.postsDataList[index] = updatedPost
                        self.coreDataManager.updatePost(updatedPost)
                    }
                }
            }
        }
    }
    
    func deletePost(post: PostsData) {
        FirebaseManager.shared.deletePost(postId: post.id) { success in
            if success {
                DispatchQueue.main.async {
                    if let index = self.postsDataList.firstIndex(where: { $0.id == post.id }) {
                        self.postsDataList.remove(at: index)
                        self.coreDataManager.deletePost(post.id)
                    }
                }
            }
        }
    }
}
