//
//  UserViewModel.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 22.01.24.
//

import Foundation
import FirebaseAuth

@MainActor
class UserViewModel: ObservableObject {
    
    private let firebaseManager = FirebaseManager.shared
    @Published var registrationStatus: String = ""
    
    @Published var profile: Profile?
    @Published var profiles: [Profile] = []
    @Published var currentUserId: String? = nil
    
    init() {
        checkAuth()
    }
    
    var userIsLoggedIn: Bool {
        Auth.auth().currentUser != nil
    }
    
    var email: String {
        Auth.auth().currentUser?.email ?? ""
    }
    
    private func checkAuth() {
        guard let currentUser = Auth.auth().currentUser else {
            print("Not logged in")
            return
        }
        self.fetchProfile(with: currentUser.uid)
    }
    
    func generateArtToolUsername() -> String {
        let artTools = ["Brush", "Palette", "Easel", "Canvas", "Chisel"]
        let adjectives = ["Creative", "Majestic", "Elegant", "Vivid", "Timeless"]
        
        let randomNumber = Int.random(in: 1000...9999)
        return "\(adjectives.randomElement()!)\(artTools.randomElement()!)\(randomNumber)"
    }
    
    func login(email: String, password: String) {
        firebaseManager.auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                print("Login failed:", error.localizedDescription)
                return
            }
            
            guard let uid = authResult?.user.uid else { return }
            print("User with email '\(email)' is logged in with id '\(uid)'")
            
            self?.fetchProfile(with: uid)
        }
    }
    
    func register(email: String, password: String) {
        let generatedName = generateArtToolUsername()
        
        firebaseManager.auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                print("Registration failed:", error.localizedDescription)
                self?.registrationStatus = "Registrierung fehlgeschlagen: \(error.localizedDescription)"
                return
            }
            guard let uid = authResult?.user.uid else { return }
            print("User with email '\(email)' and '\(generatedName)' is registered with id '\(uid)'")
            let newUserProfile = Profile(userId: uid, username: generatedName, category: "", profiledesc: "Deine Beschreibung")
            self?.createProfile(newUserProfile, with: uid)
            self?.login(email: email, password: password)
        }
    }
    
    func logout() {
        do {
            try firebaseManager.auth.signOut()
            self.profile = nil
            
            print("User wurde abgemeldet!")
        } catch {
            print("Error signing out: ", error.localizedDescription)
        }
    }
}

extension UserViewModel {
    
    private func createProfile(_ profile: Profile, with id: String) {
        do {
            try firebaseManager.database.collection("profile").document(id).setData(from: profile)
        } catch let error {
            print("Fehler beim Speichern des Profils: \(error)")
        }
    }
    
    func fetchProfile(with id: String) {
        firebaseManager.database.collection("profile").document(id).getDocument { [weak self] document, error in
            if let error = error {
                print("Fetching profile failed:", error.localizedDescription)
                return
            }
            guard let document, let profile = try? document.data(as: Profile.self) else {
                print("Profil-Dokument existiert nicht oder ist ungültig!")
                return
            }
            self?.profile = profile
        }
    }
    
    func fetchProfileDetails(userId: String) async {
        let profileRef = firebaseManager.database.collection("profile").document(userId)
        
        do {
            let documentSnapshot = try await profileRef.getDocument()
            if documentSnapshot.exists {
                if let data = documentSnapshot.data() {
                    let username = data["username"] as? String ?? ""
                    let category = data["category"] as? String ?? ""
                    let profiledesc = data["profiledesc"] as? String ?? ""
                    let profilephoto = data["profilephoto"] as? String ?? ""
                    let profile = Profile(userId: userId, username: username, category: category, profiledesc: profiledesc, profilephoto: profilephoto)
                    profiles.append(profile)
                }
            } else {
                print("Profile does not exist")
            }
        } catch {
            print("Error fetching profile:", error.localizedDescription)
        }
    }
    
    func saveProfileChanges(username: String, category: String, profileDescription: String, profileImageData: Data?) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User is not logged in.")
            return
        }
        
        var dataToUpdate: [String: Any] = [
            "username": username,
            "category": category,
            "profiledesc": profileDescription
        ]
        
        if let imageData = profileImageData {
            uploadProfileImage(userId: userId, imageData: imageData) { [weak self] imageUrl, error in
                if let error = error {
                    print("Error uploading profile image: \(error.localizedDescription)")
                    return
                }
                if let imageUrl = imageUrl {
                    dataToUpdate["profilephoto"] = imageUrl
                }
                self?.updateUserProfile(userId: userId, dataToUpdate: dataToUpdate)
            }
        } else {
            updateUserProfile(userId: userId, dataToUpdate: dataToUpdate)
        }
    }
    
    private func updateUserProfile(userId: String, dataToUpdate: [String: Any]) {
        firebaseManager.database.collection("profile").document(userId).updateData(dataToUpdate) { error in
            if let error = error {
                print("Error updating profile: \(error.localizedDescription)")
            } else {
                print("Profile successfully updated.")
            }
        }
    }
    
    private func uploadProfileImage(userId: String, imageData: Data, completion: @escaping (String?, Error?) -> Void) {
        firebaseManager.uploadProfileImage(userId: userId, imageData: imageData) { imageUrl, error in
            if let error = error {
                print("Error uploading profile image: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            completion(imageUrl, nil)
        }
    }
    
    func fetchAllProfilesWithoutID() async {
        do {
            let querySnapshot = try await firebaseManager.database.collection("profile").getDocuments()
            for document in querySnapshot.documents {
                let userId = document.documentID
                if !profiles.contains(where: { $0.userId == userId }) {
                    if let profile = try? document.data(as: Profile.self) {
                        profiles.append(profile)
                    }
                }
            }
        } catch {
            print("Error fetching profiles without ID:", error.localizedDescription)
        }
    }
}
