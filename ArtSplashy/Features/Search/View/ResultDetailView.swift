//
//  ResultDetailView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 30.01.24.
//

import SwiftUI
import Foundation

struct ResultDetailView: View {
    let result: PostsData

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if let url = URL(string: result.imageUrl) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                    } else {
                        Image(systemName: "photo.artframe")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                }
            } else {
                Image(systemName: "photo.artframe")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
            
            Text(result.title)
                .font(.headline)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .navigationBarTitle("Ergebnis")
    }
}

