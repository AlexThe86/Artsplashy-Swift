//
//  MessageViewModel.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 22.02.24.
//

import Firebase
import FirebaseFirestoreSwift

class MessageViewModel: ObservableObject {
    
    private let db = Firestore.firestore()
    @Published var messages: [Message] = []
    
    init(messages: [Message]) {
        self.messages = messages
    }
    
    func getChatDocumentReference(chatIdentifier: String) -> DocumentReference? {
        return db.collection("chats").document(chatIdentifier)
    }
    
    func fetchChatsForUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("chats")
            .whereField("user1", isEqualTo: userId)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error getting chats: \(error)")
                    return
                } else {
                    var fetchedChats: [Message] = []
                    for document in querySnapshot!.documents {
                        do {
                            if let chat = try document.data(as: Message?.self) {
                                fetchedChats.append(chat)
                            }
                        } catch {
                            print("Error decoding chat: \(error)")
                        }
                    }
                    self.messages = fetchedChats
                }
            }
    }
    
    func fetchMessagesForChat(chatId: String) {
        db.collection("chats").document(chatId).collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("No documents in 'messages'")
                    return
                }
                self.messages = documents.compactMap { documentSnapshot -> Message? in
                    try? documentSnapshot.data(as: Message.self)
                }
            }
    }
    
    
    func createChatRoom(otherUserId: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let chatId = "\(currentUserId)-\(otherUserId)"
        let chatRef = db.collection("chats").document(chatId)
        
        chatRef.getDocument { document, error in
            if let document = document, document.exists {
                // Der Chatraum existiert bereits.//
                print("Chat room already exists with ID: \(chatId)")
            } else {
                chatRef.setData(["user1": currentUserId, "user2": otherUserId]) { error in
                    if let error = error {
                        print("Error creating chat room: \(error)")
                    } else {
                        print("Chat room created successfully with ID: \(chatId)")
                    }
                }
            }
        }
    }
    
    func addMessageToChat(chatIdentifier: String, message: Message) {
        let messageData: [String: Any] = [
            "id": message.id,
            "senderUid": message.senderUid,
            "username": message.username,
            "content": message.content,
            "timestamp": message.timestamp
        ]
        
        db.collection("chats").document(chatIdentifier)
            .collection("messages")
            .addDocument(data: messageData) { error in
                if let error = error {
                    print("Error adding message to chat: \(error)")
                } else {
                    print("Message added successfully to chat: \(chatIdentifier)")
                }
            }
    }
    
    func deleteMessageFromChat(chatIdentifier: String, messageId: String) {
        db.collection("chats").document(chatIdentifier)
            .collection("messages")
            .document(messageId)
            .delete { error in
                if let error = error {
                    print("Error deleting message from chat: \(error)")
                } else {
                    print("Message deleted successfully from chat: \(chatIdentifier)")
                }
            }
    }
}

