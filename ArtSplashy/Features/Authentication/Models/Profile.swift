//
//  Profile.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 22.01.24.
//

import Foundation

struct Profile: Codable {
    var userId: String = ""
    var role: String = "User"
    var extra: String = ""
    var username: String = ""
    var category: String = ""
    var profiledesc: String = ""
    var profilephoto: String = ""
}

