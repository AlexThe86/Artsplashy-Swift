//
//  SortOptionPicker.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 29.02.24.
//

import SwiftUI

struct SortOptionPicker: View {
    //TODO:
    @Binding var selectedSortOption: String
    var body: some View {
        Picker("Sortieren nach:", selection: $selectedSortOption) {
            Text("Datum").tag("Datum")
            Text("Likes").tag("Likes")
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}
