//
//  FeedView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 22.01.24.
//

import SwiftUI

struct FeedView: View {
    @ObservedObject var viewModel = PostViewModel()
    @EnvironmentObject private var userViewModel: UserViewModel
    @State private var isMenuOpen: Bool = false
    @State private var displayedPostCount = 9
    
    private var menuOffset: CGFloat {
        isMenuOpen ? 0 : -menuWidth
    }
    
    private var menuWidth: CGFloat {
        UIScreen.main.bounds.width / 1
    }
    
    private var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.postsDataList.indices.prefix(displayedPostCount), id: \.self) { index in
                            let post = viewModel.postsDataList[index]
                            NavigationLink(destination: PostDetailView(viewModel: viewModel, postId: post.id)) {
                                PostView(post: post)
                                    .padding(0)
                                    .scaledToFit()
                            }
                            .onAppear {
                                if index == displayedPostCount - 1 && displayedPostCount < viewModel.postsDataList.count {
                                    print("Das letzte angezeigte Element (\(index)) ist erreicht.")
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  
                                        // Verzögerung von 0,5 Sekunden
                                        let previousPostCount = displayedPostCount
                                        displayedPostCount = min(displayedPostCount + 9, viewModel.postsDataList.count)
                                        print("Lade mehr Posts... Vorher: \(previousPostCount), Nachher: \(displayedPostCount)")
                                    }
                                }
                            }
                        }
                    }
                }
                .refreshable {
                    viewModel.loadInitialData()
                }
                .navigationBarTitle("Feed", displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        withAnimation {
                            isMenuOpen.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                    },
                    trailing: HStack {
                        NavigationLink(destination: SearchView()) {
                            Image(systemName: "magnifyingglass")
                        }
                    }
                )
                if isMenuOpen {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                isMenuOpen = false
                            }
                        }
                }
                SideMenuView(isMenuOpen: $isMenuOpen)
                    .frame(maxWidth: .infinity)
                    .offset(x: menuOffset)
                    .environmentObject(userViewModel)
                    .transition(.move(edge: .leading))
            }
        }
        .onAppear {
            if viewModel.postsDataList.isEmpty {
                viewModel.loadInitialData()
            }
        }
        .onDisappear {
            viewModel.removeListener()
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
            .environmentObject(PostViewModel())
            .environmentObject(UserViewModel())
    }
}
