//
//  TextButton.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 22.01.24.
//

import SwiftUI

struct TextButton: View {
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
        }
    }
    let title: String
    let action: () -> Void
}

struct TextButton_Previews: PreviewProvider {
    static var previews: some View {
        TextButton(title: "Anmelden") { }
    }
}
