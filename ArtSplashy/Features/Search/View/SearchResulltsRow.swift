//
//  SearchResulltsRow.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 01.03.24.
//

import SwiftUI

struct SearchResultsRow: View {
    let result: PostsData
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
             if let url = URL(string: result.imageUrl) {
                 AsyncImage(url: url) { phase in
                     if let image = phase.image {
                         image
                             .resizable()
                             .aspectRatio(contentMode: .fill)
                             .frame(width: 100, height: 100)
                             .cornerRadius(10)
                     } else {
                         Image(systemName: "photo.artframe")
                             .resizable()
                             .aspectRatio(contentMode: .fit)
                             .frame(width: 100, height: 100)
                             .foregroundColor(.black)
                             .cornerRadius(10)
                     }
                 }
             }
            Spacer()
             VStack(alignment: .trailing, spacing: 5) {
                 Text(result.title)
                     .font(.headline)
                     .lineLimit(2)
             }
         }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
// Erweiterung für dummydaten.//
extension PostsData {
    static var previewData: PostsData {
        PostsData(id: UUID().uuidString,
                  title: "Beispielpost",
                  description: "Dies ist eine Beschreibung für den Beispielpost.",
                  imageUrl: "https://www.com/image.jpg",
                  likeCount: 38,
                  isLiked: false,
                  userId: "user123",
                  creatorName: "Admin",
                  category: "Kunst",
                  createdAt: Date())
    }
}

struct SearchResultsRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsRow(result: PostsData.previewData)
    }
}
