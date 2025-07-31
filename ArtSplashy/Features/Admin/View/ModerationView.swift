//
//  ModerationView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 01.02.24.
//

import SwiftUI

struct ModerationView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var selectedProfile: Profile?
    
    var body: some View {
        VStack {
            Text("Moderation")
                .font(.subheadline)
                .padding()
            
            if !userViewModel.profiles.isEmpty {
                List(userViewModel.profiles, id: \.userId) { profile in
                    HStack {
                        Text(profile.username)
                        Spacer()
                        Button(action: {
                            // TODO:
                        }) {
                            Image(systemName: "bolt.shield.fill")
                        }
                        Button(action: {
                            // TODO:
                        }) {
                            Image(systemName: "xmark.shield.fill")
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
            Task {
                await userViewModel.fetchAllProfilesWithoutID()
            }
        }
    }
}

struct ModerationView_Previews: PreviewProvider {
    static var previews: some View {
        ModerationView()
            .environmentObject(UserViewModel())
    }
}

