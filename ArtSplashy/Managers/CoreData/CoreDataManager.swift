//
//  CoreDataManager.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 29.01.24.
//

import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    private let container = PersistentStore.shared
    
    func addPost(_ postData: PostsData) {
        let request: NSFetchRequest<Post> = Post.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", postData.id)
        
        do {
            let existingPosts = try container.context.fetch(request)
            if let existingPost = existingPosts.first {
                existingPost.likeCount = Int16(postData.likeCount)
                print("Updating post \(postData.id) in Core Data")
            } else {
                let newPost = Post(context: container.context)
                newPost.id = postData.id
                newPost.title = postData.title
                newPost.descriptionText = postData.description
                newPost.imageUrl = postData.imageUrl
                newPost.likeCount = Int16(postData.likeCount)
                newPost.isLiked = postData.isLiked
                newPost.userId = postData.userId
                newPost.creatorName = postData.creatorName
                newPost.category = postData.category
                print("Adding new post \(postData.id) to Core Data")
            }
            try container.context.save()
            print("Post \(postData.id) successfully saved in Core Data")
        } catch {
            print("Error saving context for post \(postData.id): \(error)")
        }
    }
    
    func updatePost(_ postData: PostsData) {
        let request: NSFetchRequest<Post> = Post.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", postData.id)
        
        do {
            let posts = try container.context.fetch(request)
            if let postToUpdate = posts.first {
                postToUpdate.title = postData.title
                postToUpdate.descriptionText = postData.description
                postToUpdate.imageUrl = postData.imageUrl
                postToUpdate.likeCount = Int16(postData.likeCount)
                postToUpdate.isLiked = postData.isLiked
                postToUpdate.userId = postData.userId
                postToUpdate.creatorName = postData.creatorName
                postToUpdate.category = postData.category
                
                try container.context.save()
                print("Post \(postData.id) successfully updated in Core Data")
            }
        } catch let error as NSError {
            print("Error updating post in Core Data: \(error), \(error.userInfo)")
        }
    }
    
    func deletePost(_ postId: String) {
        let request: NSFetchRequest<Post> = Post.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", postId)
        
        do {
            let posts = try container.context.fetch(request)
            if let postToDelete = posts.first {
                container.context.delete(postToDelete)
                
                try container.context.save()
                print("Post \(postId) successfully deleted from Core Data")
            }
        } catch let error as NSError {
            print("Error deleting post from Core Data: \(error), \(error.userInfo)")
        }
    }
    
    func loadCachedPosts() -> [PostsData] {
        let request: NSFetchRequest<Post> = Post.fetchRequest()
        
        do {
            let fetchedPosts = try container.context.fetch(request)
            return fetchedPosts.map { fetchedPost in
                PostsData(
                    id: fetchedPost.id ?? UUID().uuidString,
                    title: fetchedPost.title ?? "",
                    description: fetchedPost.descriptionText ?? "",
                    imageUrl: fetchedPost.imageUrl ?? "",
                    likeCount: Int(fetchedPost.likeCount),
                    isLiked: fetchedPost.isLiked,
                    userId: fetchedPost.userId ?? "",
                    creatorName: fetchedPost.creatorName ?? "",
                    category: fetchedPost.category ?? "",
                    createdAt: fetchedPost.createdAt ?? Date()
                )
            }
        } catch {
            print("Error loading posts: \(error)")
            return []
        }
    }
    
    func setLikeStatusForPost(_ post: PostsData, isLiked: Bool) {
        let request: NSFetchRequest<Post> = Post.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", post.id)
        
        do {
            let existingPosts = try container.context.fetch(request)
            if let existingPost = existingPosts.first {
                existingPost.isLiked = isLiked
                try container.context.save()
            }
        } catch {
            print("Fehler beim Aktualisieren des Like-Status in Core Data: \(error.localizedDescription)")
        }
    }
}

