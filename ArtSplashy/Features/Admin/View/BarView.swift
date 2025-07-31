//
//  BarView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 27.02.24.
//

import SwiftUI

struct BarView: View {
    var label: String
    var value: CGFloat
    var maxValue: CGFloat

    var body: some View {
        VStack {
            Spacer()
            Rectangle()
                .fill(Color.blue)
                .frame(width: 50, height: max((value / maxValue) * 200, 0))
            Text(label)
                .font(.caption)
        }
    }
}
