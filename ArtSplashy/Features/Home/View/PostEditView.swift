//
//  PostEditView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 14.02.24.
//

import SwiftUI

struct PostEditView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: PostViewModel
    
    var post: PostsData
    @State private var title: String
    @State private var description: String
    
    let titleLimit = 50
    let descriptionLimit = 200
    
    init(viewModel: PostViewModel, post: PostsData) {
        self.viewModel = viewModel
        self.post = post
        _title = State(initialValue: post.title)
        _description = State(initialValue: post.description)
    }
    
    private var isLimited: Bool {
        title.count > titleLimit || description.count > descriptionLimit
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Title", text: $title)
                    if title.count > titleLimit {
                        Text("Die maximale Länge von \(titleLimit) Zeichen wurde überschritten.")
                            .foregroundColor(.red)
                    }
                }
                
                Section(header: Text("Beschreibung")) {
                    TextEditor(text: $description)
                        .padding(.horizontal, -5)
                        .frame(minHeight: CGFloat(100))
                    if description.count > descriptionLimit {
                        Text("Die maximale Länge von \(descriptionLimit) Zeichen wurde überschritten.")
                            .foregroundColor(.red)
                    }
                }
                
                Section {
                    Button("Änderungen Speichern") {
                        viewModel.updatePost(post: post, newTitle: title, newDescription: description)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(isLimited)
                }
            }
            .navigationTitle("Beitrag Bearbeiten")
            .navigationBarItems(trailing: Button("Abbrechen") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
