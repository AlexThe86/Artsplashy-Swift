//
//  QuotesViewModel.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 26.01.24.
//

import Foundation

@MainActor
class QuotesViewModel: ObservableObject {
    @Published var quotes: [ArtQuote] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    init() {
        fetchQuotes()
    }

    func fetchQuotes() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                quotes = try await QuotesAPI.shared.getQuotes()
            } catch {
                errorMessage = "Fehler beim Laden der Zitate: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }
}
