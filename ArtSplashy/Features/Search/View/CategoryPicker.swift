//
//  CategoryPicker.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 29.02.24.
//

import SwiftUI

struct CategoryPicker: View {
    @Binding var selectedCategory: String
    var body: some View {
        Picker("Kategorie:", selection: $selectedCategory) {
            Text("Alle").tag("Alle")
            Section(header: Text("Kunst")) {
                Text("Darstellende Kunst").tag("Darstellende Kunst")
                Text("Handwerkskunst").tag("Handwerkskunst")
                Text("Literatur").tag("Literatur")
                Text("Musik").tag("Musik")
            }
            Section(header: Text("Hobbys")) {
                Text("Tanz").tag("Tanz")
                Text("Kochen").tag("Kochen")
            }
            Section(header: Text("Architektur")) {
                Text("Architektur Kunst").tag("Architektur Kunst")
                Text("Bau Kunst").tag("Bau Kunst")
            }
        }
        .pickerStyle(WheelPickerStyle())
    }
}
