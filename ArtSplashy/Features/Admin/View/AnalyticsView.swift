//
//  AnalyticsView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 01.02.24.
//

import SwiftUI

struct AnalyticsView: View {
    @ObservedObject var viewModel = AnalyticsViewModel()

    let scaleMarks: [String] = ["100", "75", "50", "25", "0"]

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            VStack {
                ForEach(scaleMarks, id: \.self) { mark in
                    Spacer()
                    Text(mark)
                }
            }
            VStack {
                HStack(alignment: .bottom, spacing: 20) {
                    BarView(label: "\(viewModel.postingsCount) Posts", value: CGFloat(viewModel.postingsCount), maxValue: 100)
                        .animation(.default, value: viewModel.postingsCount)
                    
                    BarView(label: "\(viewModel.usersCount) Users", value: CGFloat(viewModel.usersCount), maxValue: 100)
                        .animation(.default, value: viewModel.usersCount)
                    
                    BarView(label: "\(viewModel.commentsCount) Co", value: CGFloat(viewModel.commentsCount), maxValue: 100)
                        .animation(.default, value: viewModel.commentsCount)
                }
                .frame(height: 220)
                .padding([.horizontal, .bottom])

                Button("Daten aktualisieren") {
                    Task {
                        await viewModel.countDocuments()
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.countDocuments()
            }
        }
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
