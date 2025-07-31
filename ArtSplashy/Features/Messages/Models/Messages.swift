//
//  Messages.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 22.02.24.
//

import Foundation
import SwiftUI

struct Messages: Codable, Identifiable {
    var id: String?
    var chatId: String
    var partnerName: String
    var lastMessage: String
    var timestamp: TimeInterval
    var messages: [Message]
}

struct Message: Codable, Identifiable {
    var id: String
    var senderUid: String
    var username: String
    var content: String
    var timestamp: TimeInterval
}
