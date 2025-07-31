//
//  QuotesAPI.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 26.01.24.
//

import Foundation

class QuotesAPI {
    static let shared = QuotesAPI()
    private let baseURL = URL(string: "https://api.api-ninjas.com/v1/quotes?category=art")
    private let apiKey = APIKeys.ArtQuoteAPIKey

    func getQuotes() async throws -> [ArtQuote] {
        guard let url = baseURL else {
            print("QuotesAPI: Invalid URL")
            throw HTTPError.invalidURL
        }

        print("QuotesAPI: Making request to \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        request.addValue("api.api-ninjas.com", forHTTPHeaderField: "X-RapidAPI-Host")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                print("QuotesAPI: Invalid response")
                throw HTTPError.invalidURL
            }

            print("QuotesAPI: Received HTTP status code: \(httpResponse.statusCode)")
            if httpResponse.statusCode != 200 {
                throw HTTPError.invalidURL
            }

            guard !data.isEmpty else {
                print("QuotesAPI: No data received")
                throw HTTPError.missingData
            }

            print("QuotesAPI: Successfully received data")
            return try JSONDecoder().decode([ArtQuote].self, from: data)
        } catch {
            print("QuotesAPI: Error during request - \(error)")
            throw error
        }
    }
}



