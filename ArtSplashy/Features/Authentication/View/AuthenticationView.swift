//
//  AuthenticationView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 22.01.24.
//

import SwiftUI

struct AuthenticationView: View {
    
    @EnvironmentObject private var userViewModel: UserViewModel
    
    @State private var mode: AuthenticationMode = .login
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 48) {
            Spacer()
            VStack(spacing: 12) {
                ZStack(alignment: .bottom) {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: 36)
                        .padding(5)
                        .cornerRadius(8)
                    Divider()
                }
                ZStack(alignment: .bottom) {
                    SecureField("Passwort", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(.black)
                        .frame(minHeight: 36)
                        .padding(5)
                        .cornerRadius(8)
                    Divider()
                }
            }
            .font(.headline)
            .textInputAutocapitalization(.never)
            
            PrimaryButton(title: mode.title, action: authenticate)
                .disabled(disableAuthentication)
            
            TextButton(title: mode.alternativeTitle, action: switchAuthenticationMode)
        }
        .padding(48)
        .background(Image("artsplashy_bg_new1"))
    }
    
    private var disableAuthentication: Bool {
        email.isEmpty || password.isEmpty
    }
    
    private func switchAuthenticationMode() {
        mode = mode == .login ? .register : .login
    }
    
    private func authenticate() {
        switch mode {
        case .login:
            userViewModel.login(email: email, password: password)
        case .register:
            userViewModel.register(email: email, password: password)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
