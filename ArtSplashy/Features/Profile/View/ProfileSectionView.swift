//
//  ProfileSectionView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 15.02.24.
//

import SwiftUI

struct ProfileSectionView: View {
    var profile: Profile
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: profile.profilephoto)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                default:
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 100, height: 100)
                        .overlay(Text("Künstler").foregroundColor(.white))
                }
            }
            VStack(alignment: .leading) {
                Text(profile.username).font(.title2).bold()
                Text(profile.category).font(.headline).foregroundColor(.secondary)
                Text(profile.profiledesc).font(.caption).lineLimit(3)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 2)
    }
}

