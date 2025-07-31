//
//  ToastView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 06.02.24.
//

import SwiftUI

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .padding()
            .background(Color.black.opacity(0.8))
            .cornerRadius(10)
            .padding()
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(message: "Profil erfolgreich aktualisiert!")
    }
}

