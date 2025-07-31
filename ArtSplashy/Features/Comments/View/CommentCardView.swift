//
//  CommentCardView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 13.02.24.
//

import SwiftUI

struct CommentCardView: View {
    let comment: Comment
    let userViewModel: UserViewModel
    let deleteAction: () -> Void
    
    var body: some View {
        HStack {
            if let profile = userViewModel.profiles.first(where: { $0.userId == comment.userId }) {
                AsyncImage(url: URL(string: profile.profilephoto)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    case .failure:
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    @unknown default:
                        EmptyView()
                    }
                }
                .padding(.trailing, 10)
            }
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(comment.username)
                        .font(.headline)
                    Spacer()
                    Text(Date(timeIntervalSince1970: comment.timestamp).formattedDateString())
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Text(comment.text)
                    .font(.subheadline)
            }
            .padding(.vertical)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .contextMenu {
            // Prüfen, ob der Benutzer der Ersteller des Kommentars ist
            if comment.userId == userViewModel.profile?.userId {
                Button(action: deleteAction) {
                    Label("Löschen", systemImage: "trash")
                }
            }
        }
    }
}
