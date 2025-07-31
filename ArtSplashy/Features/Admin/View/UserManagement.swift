//
//  UserManagement.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 01.02.24.
//

import SwiftUI

struct UserManagementView: View {
    
    @ObservedObject var viewModel: UserViewModel
    
    var body: some View {
        VStack {
            Text("Benutzermanagement")
                .font(.subheadline)
                .padding()
            if !viewModel.profiles.isEmpty {
                List(viewModel.profiles, id: \.userId) { profile in
                    HStack {
                        Text(profile.username)
                        Spacer()
                        Button(action: {
                            // TODO: Person deaktivieren
                        }) {
                            Image(systemName: "person.2.slash")
                        }
                        
                        Button(action: {
                            // TODO: Person entfernen
                            removeUser(profile: profile)
                        }) {
                            Image(systemName: "person.crop.circle.badge.minus")
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
                await viewModel.fetchAllProfilesWithoutID()
            }
        }
    }
    
    private func removeUser(profile: Profile) {
        //TODO:
    }
}

