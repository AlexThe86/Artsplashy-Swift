//
//  CommentInputView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 13.02.24.
//

import SwiftUI

struct CommentInputView: View {
    @Binding var commentText: String
    let addAction: () -> Void
    
    var body: some View {
        HStack {
            TextField("Kommentar hinzufügen...", text: $commentText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: addAction) {
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .foregroundColor(.blue)
            }
            .padding(.trailing)
            .disabled(commentText.isEmpty)
        }
    }
}

