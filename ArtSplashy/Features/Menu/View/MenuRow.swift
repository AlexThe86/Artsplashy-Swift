//
//  MenuRow.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 28.01.24.
//

import SwiftUI

struct MenuRow: View {
    var title: String
    var icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
                .imageScale(.large)
                .padding(15)

            Text(title)
                .foregroundColor(.white)
                .font(.headline)
                .padding(15)
            
            Spacer()
        }
    }
}

struct MenuRow_Previews: PreviewProvider {
    static var previews: some View {
        MenuRow(title: "KunstFakten", icon: "paintbrush")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
