//
//  MessageView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 22.02.24.
//

import SwiftUI
import Foundation

struct MessageView: View {
    @ObservedObject var viewModel: MessageViewModel
    @ObservedObject var userViewModel: UserViewModel

    var chatId: String
    @State private var newMessageText = ""

    var body: some View {
        VStack {
            if viewModel.messages.isEmpty {
                Text("Keine Nachrichten vorhanden. Beginne die Unterhaltung!")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(viewModel.messages) { message in
                    MessageRow(message: message, isCurrentUser: message.senderUid == FirebaseManager.shared.userId)
                }
            }
            Divider()
            HStack {
                TextField("Nachricht...", text: $newMessageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: sendMessage) {
                    Text("Send")
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchMessagesForChat(chatId: chatId)
        }
    }
    
    private func sendMessage() {
        guard !newMessageText.isEmpty, let userId = FirebaseManager.shared.userId else { return }
        let username = userViewModel.profile?.username ?? "Unbekannter Benutzer"
        
        let newMessage = Message(id: UUID().uuidString,
                                 senderUid: userId,
                                 username: username,
                                 content: newMessageText,
                                 timestamp: Date().timeIntervalSince1970)
        viewModel.addMessageToChat(chatIdentifier: chatId, message: newMessage)
        newMessageText = ""
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        let dummyMessages = [
            Message(id: "1", senderUid: "sender1", username: "User 1", content: "Hallo!", timestamp: Date().timeIntervalSince1970),
            Message(id: "2", senderUid: "sender2", username: "User 2", content: "Test!", timestamp: Date().timeIntervalSince1970)
        ]
        let dummyViewModel = MessageViewModel(messages: dummyMessages)
        let exampleChatId = "123"
        let userViewModel = UserViewModel()
        return MessageView(viewModel: dummyViewModel, userViewModel: userViewModel, chatId: exampleChatId)
    }
}
