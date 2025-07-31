//
//  FollowerView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 15.02.24.
//

import SwiftUI

struct FollowerView: View {
    @ObservedObject var viewModel = FollowerViewModel()
    
    var body: some View {
        Group {
            if viewModel.followers.isEmpty {
                Text("No Followers")
            } else {
                List(viewModel.followers, id: \.userId) { follower in
                    NavigationLink(destination: UserProfileView(userId: follower.userId)) {
                        VStack(alignment: .leading) {
                            Text(follower.username)
                        }
                    }
                }
            }
        }
        .navigationTitle("Followers")
        .onAppear {
            Task {
                if let userId = FirebaseManager.shared.userId {
                    let details = await viewModel.getFollowingDetails(userId: userId)
                    DispatchQueue.main.async {
                        viewModel.followers = details
                    }
                }
            }
        }
    }
}


struct FollowerView_Previews: PreviewProvider {
    static var previews: some View {
        FollowerView()
    }
}
