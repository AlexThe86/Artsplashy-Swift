//
//  SearchView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 22.01.24.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel = PostViewModel()
    
    @State private var selectedCategory = "Alle"
    @State private var selectedSortOption = "Datum"
    @State private var searchText = ""
    
    
    @State private var isShowingDetailView = false
    @State private var selectedPostId: String?
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Category")
                    .font(.subheadline)
                CategoryPicker(selectedCategory: $selectedCategory)
                SortOptionPicker(selectedSortOption: $selectedSortOption)
                List(viewModel.searchResults, id: \.id) { result in
                    Button(action: {
                        self.selectedPostId = result.id
                        self.isShowingDetailView = true
                    }) {
                        SearchResultsRow(result: result)
                    }
                }
            }
            .navigationTitle("Search")
            .navigationViewStyle(.stack)
            .searchable(text: $viewModel.searchText)
            .onChange(of: selectedCategory) { _ in
                viewModel.searchCoreDataPosts(searchText: viewModel.searchText, selectedCategory: selectedCategory)
            }
            .onSubmit(of: .search) {
                viewModel.searchCoreDataPosts(searchText: viewModel.searchText, selectedCategory: selectedCategory)
            }

            .background(
                NavigationLink(destination: PostDetailView(viewModel: viewModel, postId: selectedPostId ?? ""),isActive: $isShowingDetailView) {
                    EmptyView()
                }
                    .hidden()
            )
            .onAppear {
                viewModel.searchCoreDataPosts(searchText: searchText, selectedCategory: "Alle")
            }
        }
    }
}

#Preview {
    SearchView()
}
