//
//  MessageListView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 22.02.24.
//

import SwiftUI

struct MessageListView: View {
    @ObservedObject var viewModel: MessageViewModel
    @ObservedObject var userViewModel: UserViewModel
    
    var chatId: String

    var body: some View {
        List {
            ForEach(viewModel.messages, id: \.id) { message in
                MessageView(viewModel: viewModel, userViewModel: userViewModel, chatId: chatId)
            }
        }
        .onAppear {
            viewModel.fetchChatsForUser()
        }
    }
}
