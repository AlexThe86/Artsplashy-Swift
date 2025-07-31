//
//  AuthenticationMode.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 22.01.24.
//

import Foundation

enum AuthenticationMode {
    case login, register
    
    var title: String {
        switch self {
        case .login: return "Anmelden"
        case .register: return "Registrieren"
        }
    }
    
    var alternativeTitle: String {
        switch self {
        case .login: return "Noch kein Konto? Registrieren →"
        case .register: return "Schon registriert? Anmelden →"
        }
    }
}
