//
//  ArtQuotesView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 26.01.24.
//

import SwiftUI

struct ArtQuotesView: View {
    @StateObject var viewModel = QuotesViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List {
                        ForEach(viewModel.quotes, id: \.id) { quote in
                            VStack(alignment: .leading) {
                                Text(quote.quote)
                                    .font(.body)
                                    .italic()
                                Text("- \(quote.author)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding(.top, 2)
                            }
                            .contextMenu {
                                Button(action: {
                                    copyToClipboard(quote.quote)
                                }) {
                                    Text("Kopieren")
                                    Image(systemName: "doc.on.doc")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Kunstzitate")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.fetchQuotes()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .refreshable {
                viewModel.fetchQuotes()
            }
            .listStyle(.plain)
            .onAppear {
                if viewModel.quotes.isEmpty {
                    viewModel.fetchQuotes()
                }
            }
        }
    }

    private func copyToClipboard(_ text: String) {
        UIPasteboard.general.string = text
    }
}

struct ArtQuotesView_Previews: PreviewProvider {
    static var previews: some View {
        ArtQuotesView()
    }
}

