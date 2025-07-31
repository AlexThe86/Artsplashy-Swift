//
//  Chat.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 25.02.24.
//

import Foundation

struct Chat: Identifiable, Codable {
    var id: String
    var partnerName: String
    var lastMessage: String
    var timestamp: TimeInterval
    var messages: [Message]
}
