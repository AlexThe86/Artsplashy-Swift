//
//  PostsData.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 22.01.24.
//

import Foundation

struct PostsData: Identifiable, Decodable {
    var id: String
    var title: String
    var description: String
    var imageUrl: String
    var likeCount: Int
    var isLiked: Bool
    var userId: String
    var creatorName: String
    var category: String
    var createdAt: Date
}
