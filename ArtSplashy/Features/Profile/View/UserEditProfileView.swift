//
//  UserEditProfileView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 05.02.24.
//

import SwiftUI
import PhotosUI

struct UserEditProfileView: View {
    @ObservedObject var userViewModel: UserViewModel
    
    @State private var username: String = ""
    @State private var category: String = "Darstellende Kunst"
    @State private var profileDescription: String = ""
    @State private var selectedProfileImageData: Data?
    @State private var selectedProfileImage: PhotosPickerItem?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showConfirmationToast = false
    
    let categories = ["Darstellende Kunst",
                      "Handwerkskunst",
                      "Literatur",
                      "Musik",
                      "Tanz",
                      "Kochen",
                      "Architektur Kunst",
                      "Bau Kunst"].sorted(by: <)
    
    var body: some View {
        NavigationView {
            VStack {
                Group {
                    if let imageData = selectedProfileImageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.blue, lineWidth: 4))
                            .padding()
                    } else if let imageUrlString = userViewModel.profile?.profilephoto, let imageUrl = URL(string: imageUrlString) {
                        AsyncImage(url: imageUrl) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image.resizable()
                                     .aspectRatio(contentMode: .fill)
                                     .frame(width: 150, height: 150)
                                     .clipShape(Circle())
                                     .overlay(Circle().stroke(Color.blue, lineWidth: 4))
                            case .failure:
                                Image(systemName: "person.crop.circle.fill")
                                     .resizable()
                                     .scaledToFit()
                                     .frame(width: 150, height: 150)
                                     .clipShape(Circle())
                                     .overlay(Circle().stroke(Color.blue, lineWidth: 4))
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .padding()
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.blue, lineWidth: 4))
                            .padding()
                    }
                }

                
                Form {
                    Section(header: Text("Profil Details")) {
                        TextField("Username", text: $username)
                        Picker("Category", selection: $category) {
                            ForEach(categories, id: \.self) {
                                Text($0)
                            }
                        }
                        TextField("Profile Beschreibung", text: $profileDescription)
                    }
                    
                    Section(header: Text("Profil Bild")) {
                        PhotosPicker(selection: $selectedProfileImage, matching: .images, photoLibrary: .shared()) {
                            Label("Profilbild Wählen", systemImage: "photo")
                        }
                        .onChange(of: selectedProfileImage) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    selectedProfileImageData = data
                                }
                            }
                        }
                    }
                    
                    Button("Änderungen Speichern") {
                        userViewModel.saveProfileChanges(username: username, category: category, profileDescription: profileDescription, profileImageData: selectedProfileImageData)
                        withAnimation {
                            showConfirmationToast = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showConfirmationToast = false
                            }
                        }
                    }
                }
            }
            .navigationTitle("Profil Bearbeiten")
            .onAppear {
                self.username = userViewModel.profile?.username ?? ""
                self.category = userViewModel.profile?.category ?? "Darstellende Kunst"
                self.profileDescription = userViewModel.profile?.profiledesc ?? ""
            }
        }
        .overlay(
            Group {
                if showConfirmationToast {
                    ToastView(message: "Profil erfolgreich aktualisiert!")
                        .transition(.opacity)
                        .animation(.easeInOut, value: showConfirmationToast)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .background(Color.black.opacity(0.4).edgesIgnoringSafeArea(.all))
                }
            }
        )
    }
}


struct UserEditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserEditProfileView(userViewModel: UserViewModel())
    }
}
