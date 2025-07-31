//
//  CommentsView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 07.02.24.
//

import SwiftUI

struct CommentsView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject var commentsViewModel = CommentsViewModel()
    
    var postId: String
    @State private var commentText = ""
    
    
    var body: some View {
        VStack {
            Text("Kommentare")
                .font(.subheadline)
                .bold()
                .padding()
            List {
                ForEach(commentsViewModel.comments) { comment in
                    CommentCardView(comment: comment, userViewModel: userViewModel) {
                        commentsViewModel.deleteComment(commentId: comment.id)
                    }
                }
            }
            .onAppear {
                commentsViewModel.getCommentsForPost(postId: postId)
                Task {
                    let userIds = Set(commentsViewModel.comments.map { $0.userId })
                    for userId in userIds {
                        await userViewModel.fetchProfileDetails(userId: userId)
                    }
                }
            }
            
            Divider()
            
            HStack {
                TextField("Kommentar hinzufügen...", text: $commentText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    addComment()
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .foregroundColor(.blue)
                }
                .padding(.trailing)
                .disabled(commentText.isEmpty)
            }
        }
        .navigationBarTitle("Kommentare", displayMode: .inline)
    }
    
    private func addComment() {
        if let profile = userViewModel.profile {
            let newComment = Comment(
                id: UUID().uuidString,
                postId: postId,
                userId: profile.userId,
                username: profile.username,
                text: commentText,
                timestamp: Date().timeIntervalSince1970
            )
            commentsViewModel.addComment(comment: newComment)
            commentText = ""
        } else {
            print("Fehler: Benutzer ist nicht angemeldet.")
        }
    }
}
extension Date {
    func formattedDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsView(postId: "examplePostId")
            .environmentObject(CommentsViewModel())
    }
}
