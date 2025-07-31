//
//  Comment.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 07.02.24.
//

import Foundation

struct Comment: Identifiable, Codable {
    var id: String
    var postId: String
    var userId: String
    var username: String
    var text: String
    var timestamp: TimeInterval
}
