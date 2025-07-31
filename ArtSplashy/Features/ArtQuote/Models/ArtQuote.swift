//
//  ArtQuote.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 26.01.24.
//

import Foundation

struct ArtQuote: Codable, Identifiable {
    var id: Int?
    let author: String
    let quote: String
}
