//
//  MessageRow.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 27.02.24.
//

import SwiftUI

struct MessageRow: View {
    
    var message: Message
    var isCurrentUser: Bool
    
    var body: some View {
        VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
            HStack {
                if isCurrentUser {
                    Spacer()
                    Text("\(message.username): \(message.content)")
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                } else {
                    Text("\(message.username): \(message.content)")
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                    Spacer()
                }
            }
            Text(formattedTimestamp(timestamp: message.timestamp))
                .font(.caption)
                .foregroundColor(.gray)
                .padding(isCurrentUser ? .trailing : .leading, isCurrentUser ? 0 : 16)
        }
    }
    
    private func formattedTimestamp(timestamp: TimeInterval) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let date = Date(timeIntervalSince1970: timestamp)
        return dateFormatter.string(from: date)
    }
}
