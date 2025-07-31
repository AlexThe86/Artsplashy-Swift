//
//  AddPostView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 23.01.24.
//

import SwiftUI
import PhotosUI

struct AddPostView: View {
    @StateObject private var postViewModel = PostViewModel()
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedCategory: String = "Darstellende Kunst"
    @State private var selectedImageData: Data?
    @State private var selectedImage: PhotosPickerItem?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isShowingPhotoPicker = false
    
    let categories = ["Darstellende Kunst",
                      "Handwerkskunst",
                      "Literatur",
                      "Musik",
                      "Tanz",
                      "Kochen",
                      "Architektur Kunst",
                      "Bau Kunst"].sorted(by: <)
    
    let titleLimit = 50
    let descriptionLimit = 200
    
    var body: some View {
        NavigationView {
            VStack {
                if postViewModel.isUploading {
                    VStack {
                        ProgressView(value: postViewModel.uploadProgress, total: 1.0)
                            .progressViewStyle(LinearProgressViewStyle())
                            .scaleEffect(1.5)
                        Text("\(Int(postViewModel.uploadProgress * 100))%")
                            .font(.headline)
                    }
                } else {
                    if let imageData = postViewModel.selectedImageData, let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                            .padding()
                    }
                    
                    Form {
                        Section(header: Text("Post Details")) {
                            TextField("Title", text: $title)
                            if title.count > titleLimit {
                                Text("Die maximale Länge von \(titleLimit) Zeichen wurde überschritten.")
                                    .foregroundColor(.red)
                            }
                            ZStack(alignment: .topLeading) {
                                if description.isEmpty {
                                    Text("Beschreibung")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 4)
                                        .padding(.top, 8)
                                }
                                TextEditor(text: $description)
                                    .frame(minHeight: CGFloat(100))
                                    .padding(.leading, -4)
                            }
                            if description.count > descriptionLimit {
                                Text("Die maximale Länge von \(descriptionLimit) Zeichen wurde überschritten.")
                                    .foregroundColor(.red)
                            }
                            Picker("Kategorie", selection: $selectedCategory) {
                                ForEach(categories, id: \.self) {
                                    Text($0)
                                }
                            }
                        }
                        
                        Section(header: Text("Bild")) {
                            PhotosPicker(selection: $postViewModel.selectedImage, matching: .images, photoLibrary: .shared()) {
                                Label("Bild Auswählen", systemImage: "photo")
                            }
                            .onChange(of: postViewModel.selectedImage) { newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        postViewModel.selectedImageData = data
                                    }
                                }
                            }
                        }
                        Button("Veröffentlichen") {
                            if let imageData = postViewModel.selectedImageData, !title.isEmpty, !description.isEmpty, !selectedCategory.isEmpty {
                                let image = UIImage(data: imageData)!
                                let resizedImage = ImageUtils.resizeImage(image: image, targetSize: CGSize(width: 800, height: 600))
                                
                                if let compressedImageData = resizedImage.jpegData(compressionQuality: 0.5) {
                                    postViewModel.uploadImageSavePost(imageData: compressedImageData, title: title, description: description, category: selectedCategory)
                                    resetFields()
                                    
                                } else {
                                    alertMessage = "Fehler beim Komprimieren des Bildes."
                                    showAlert = true
                                }
                            } else {
                                alertMessage = "Bitte füllen Sie alle Felder aus und wählen Sie ein Bild aus, bevor Sie es veröffentlichen."
                                showAlert = true
                            }
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Fehlende Informationen"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        }
                    }
                }
            }
            .navigationTitle("Add Post")
        }
    }
    
    
    func resetFields() {
        title = ""
        description = ""
        selectedCategory = "Darstellende Kunst"
        selectedImageData = nil
        selectedImage = nil
        postViewModel.selectedImageData = nil
    }
}

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        AddPostView()
    }
}
