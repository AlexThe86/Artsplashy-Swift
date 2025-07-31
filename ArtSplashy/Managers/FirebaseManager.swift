//
//  FirebaseManager.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 22.01.24.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseManager {
    
    static let shared = FirebaseManager()
    private let storage = Storage.storage().reference()
    
    let auth = Auth.auth()
    let database = Firestore.firestore()
    var userPosts: [PostsData] = []
    
    var userId: String? {
        auth.currentUser?.uid
    }
    
    func loadUserPosts(userId: String, completion: @escaping ([PostsData]) -> Void) {
        database.collection("posts").whereField("userId", isEqualTo: userId)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Fehler beim Laden der Benutzerposts: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("Keine Dokumente für den Benutzer \(userId)")
                    completion([])
                    return
                }
                
                let posts = documents.map { doc -> PostsData in
                    let data = doc.data()
                    let createdAtTimestamp = data["createdAt"] as? Timestamp
                    let createdAtDate = createdAtTimestamp?.dateValue() ?? Date()
                    
                    let post = PostsData(
                        id: doc.documentID,
                        title: data["title"] as? String ?? "",
                        description: data["description"] as? String ?? "",
                        imageUrl: data["imageUrl"] as? String ?? "",
                        likeCount: data["likeCount"] as? Int ?? 0,
                        isLiked: data["isLiked"] as? Bool ?? false,
                        userId: data["userId"] as? String ?? "",
                        creatorName: data["creatorName"] as? String ?? "",
                        category: data["category"] as? String ?? "",
                        createdAt: createdAtDate
                    )
                    //print("Post geladen: \(post)")
                    return post
                }
                print("Alle Posts für Benutzer \(userId) wurden geladen: \(posts.count)")
                completion(posts)
            }
    }
    
    
    func uploadImageToFirebaseStorage(imageData: Data, title: String, description: String, category: String, progressHandler: @escaping (Double) -> Void) {
        let imageId = UUID().uuidString
        let imageRef = storage.child("images/\(imageId).jpg")
        
        let uploadTask = imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Fehler beim Hochladen des Bildes: \(error.localizedDescription)")
                return
            }
            
            imageRef.downloadURL { url, error in
                if let error = error {
                    print("Fehler beim Abrufen der URL: \(error.localizedDescription)")
                    return
                }
                
                guard let downloadURL = url else {
                    print("Fehler: URL konnte nicht abgerufen werden.")
                    return
                }
                
                self.getCreatorNameAndSavePost(title: title, description: description, imageUrl: downloadURL.absoluteString, category: category)
            }
        }
        
        uploadTask.observe(.progress) { snapshot in
            guard let progress = snapshot.progress else { return }
            progressHandler(progress.fractionCompleted)
        }
    }
    
    func uploadProfileImage(userId: String, imageData: Data, completion: @escaping (String?, Error?) -> Void) {
        let imageRef = storage.child("profilephoto/\(userId).jpg")
        
        let uploadTask = imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Fehler beim Hochladen des Profilbildes: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            imageRef.downloadURL { url, error in
                if let error = error {
                    print("Fehler beim Abrufen der Profilbild-URL: \(error.localizedDescription)")
                    completion(nil, error)
                    return
                }
                
                guard let downloadURL = url else {
                    print("Fehler: Profilbild-URL konnte nicht abgerufen werden.")
                    completion(nil, nil)
                    return
                }
                
                completion(downloadURL.absoluteString, nil)
            }
        }
    }
    
    func getCreatorNameAndSavePost(title: String, description: String, imageUrl: String, category: String) {
        guard let userId = self.userId else {
            print("Benutzer ist nicht angemeldet.")
            return
        }
        
        let profileRef = database.collection("profile").document(userId)
        profileRef.getDocument { document, error in
            if let error = error {
                print("Fehler beim Abrufen des Profils: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists, let data = document.data() else {
                print("Fehler: Profil konnte nicht abgerufen werden.")
                return
            }
            
            let creatorName = data["username"] as? String ?? "Unbekannter Benutzer"
            self.savePost(title: title, description: description, imageUrl: imageUrl, category: category, creatorName: creatorName)
        }
    }
    
    func savePost(title: String, description: String, imageUrl: String, category: String, creatorName: String) {
        guard let userId = self.userId else {
            print("Benutzer ist nicht angemeldet.")
            return
        }
        
        let postId = UUID().uuidString
        let currentTime = Date()
        
        let newPost = [
            "id": postId,
            "title": title,
            "description": description,
            "imageUrl": imageUrl,
            "likeCount": 0,
            "userId": userId,
            "creatorName": creatorName,
            "category": category,
            "createdAt": currentTime
        ] as [String : Any]
        
        database.collection("posts").document(postId).setData(newPost) { error in
            if let error = error {
                print("Fehler beim Speichern des Posts: \(error.localizedDescription)")
            } else {
                print("Post erfolgreich gespeichert.")
            }
        }
    }
    
    func toggleLikeForPost(post: PostsData, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Benutzer ist nicht authentifiziert.")
            completion(false)
            return
        }
        
        let userLikeRef = database.collection("likeData").document(userId).collection("likes").document(post.id)
        let postRef = database.collection("posts").document(post.id)
        
        userLikeRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let likeData = document.data()
                let currentLikeStatus = likeData?["isLiked"] as? Bool ?? false
                let newLikeStatus = !currentLikeStatus
                let incrementValue = newLikeStatus ? 1 : -1
                
                userLikeRef.updateData(["isLiked": newLikeStatus]) { error in
                    if let error = error {
                        print("Fehler beim Aktualisieren des Likes: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        postRef.updateData(["likeCount": FieldValue.increment(Int64(incrementValue))]) { error in
                            if let error = error {
                                print("Fehler beim Aktualisieren des Like-Counts: \(error.localizedDescription)")
                                completion(false)
                            } else {
                                print("Like-Status erfolgreich aktualisiert und Like-Count aktualisiert.")
                                CoreDataManager.shared.setLikeStatusForPost(post, isLiked: newLikeStatus)
                                completion(true)
                            }
                        }
                    }
                }
            } else {
                let likeData = LikeData(userId: userId, postId: post.id, isLiked: true)
                let likeDataDictionary = ["userId": likeData.userId, "postId": likeData.postId, "isLiked": likeData.isLiked]
                
                userLikeRef.setData(likeDataDictionary) { error in
                    if let error = error {
                        print("Fehler beim Setzen des neuen Likes: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        postRef.updateData(["likeCount": FieldValue.increment(Int64(1))]) { error in
                            if let error = error {
                                print("Fehler beim Erhöhen des Like-Counts: \(error.localizedDescription)")
                                completion(false)
                            } else {
                                print("Like-Count erfolgreich erhöht.")
                                CoreDataManager.shared.setLikeStatusForPost(post, isLiked: true)
                                completion(true)
                            }
                        }
                    }
                }
            }
        }
    }
    func updatePost(postId: String, newTitle: String, newDescription: String, completion: @escaping (Bool) -> Void) {
        let postRef = database.collection("posts").document(postId)
        postRef.updateData([
            "title": newTitle,
            "description": newDescription
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
                completion(false)
            } else {
                print("Document successfully updated")
                completion(true)
            }
        }
    }
    
    func deletePost(postId: String, completion: @escaping (Bool) -> Void) {
        let postRef = database.collection("posts").document(postId)
        postRef.delete() { error in
            if let error = error {
                print("Error removing document: \(error)")
                completion(false)
            } else {
                print("Document successfully removed")
                completion(true)
            }
        }
    }
}
