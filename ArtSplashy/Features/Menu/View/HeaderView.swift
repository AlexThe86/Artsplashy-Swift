//
//  HeaderView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 28.01.24.
//

import SwiftUI

struct HeaderView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    var body: some View {
        HStack {
            if let imageUrlString = userViewModel.profile?.profilephoto, let imageUrl = URL(string: imageUrlString) {
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                             .aspectRatio(contentMode: .fill)
                             .frame(width: 60, height: 60)
                             .clipShape(Circle())
                    case .failure:
                        Image(systemName: "person.crop.circle.fill")
                             .resizable()
                             .aspectRatio(contentMode: .fill)
                             .frame(width: 60, height: 60)
                             .clipShape(Circle())
                    @unknown default:
                        EmptyView()
                    }
                }
                .padding(.horizontal, 10)
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            }
            VStack(alignment: .leading) {
                Text("Hallo")
                    .font(.headline)
                    .foregroundColor(.white)
                Text(userViewModel.profile?.username ?? "Benutzer")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding(.leading, 10)
            .padding(.top, 30)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 30)
    }
}

struct HeaderView_Previews: PreviewProvider {
    
    static var previews: some View {
        HeaderView()
            .environmentObject(UserViewModel())
    }
}
