//
//  ContentManagementView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 01.02.24.
//

import SwiftUI

struct ContentManagementView: View {
    @ObservedObject var viewModel: PostViewModel
    
    var body: some View {
        VStack {
            Text("Inhaltsverwaltung")
                .font(.subheadline)
                .padding()
            
            if !viewModel.postsDataList.isEmpty {
                List(viewModel.postsDataList, id: \.id) { post in
                    HStack {
                        Text(post.title)
                        Spacer()
                        Button(action: {
                            // TODO:
                        }) {
                            Image(systemName: "eye.slash")
                                .foregroundColor(.gray)
                        }
                        
                        Button(action: {
                            // TODO:
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.vertical, 4)
                }
            } else {
                ProgressView()
                    .padding()
            }
        }
        .onAppear {
            viewModel.loadInitialData()
        }
    }
}
