//
//  CommentsViewModel.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 07.02.24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class CommentsViewModel: ObservableObject {
    @Published var comments = [Comment]()

    private var db = Firestore.firestore()

    var currentUserId: String? {
        return Auth.auth().currentUser?.uid
    }

    func getCommentsForPost(postId: String) {
        print("Versuche, Kommentare für PostID \(postId) zu laden...")
        db.collection("comments").whereField("postId", isEqualTo: postId).order(by: "timestamp").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Fehler beim Laden der Kommentare: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("Keine Dokumente gefunden für PostID \(postId)")
                return
            }
            
            self.comments = documents.compactMap { queryDocumentSnapshot in
                var comment = try? queryDocumentSnapshot.data(as: Comment.self)
                comment?.id = queryDocumentSnapshot.documentID
                return comment
            }
            print("Geladene Kommentare: \(self.comments.count) für UserID \(postId)")
        }
    }

    func addComment(comment: Comment) {
        print("Versuche, Kommentar hinzuzufügen: \(comment.text)")
        do {
            var newComment = comment
            let docRef = try db.collection("comments").addDocument(from: newComment)

            newComment.id = docRef.documentID
            self.comments.append(newComment)
            
            print("Kommentar erfolgreich hinzugefügt.")
        } catch {
            print("Fehler beim Hinzufügen des Kommentars: \(error.localizedDescription)")
        }
    }

    
    func deleteComment(commentId: String) {
        let commentsCollection = Firestore.firestore().collection("comments")
        
        let commentRef = commentsCollection.document(commentId)
        commentRef.delete { error in
            if let error = error {
                print("Fehler beim Löschen des Kommentars: \(error.localizedDescription)")
            } else {
                print("Kommentar erfolgreich gelöscht.")
            }
        }
    }
}
