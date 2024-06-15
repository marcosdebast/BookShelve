//
//  MainView.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 03/04/24.
//

import SwiftUI

struct LibraryView: View {
    
    //MARK: ViewModel
    @State private var viewModel = BooksViewModel()
    
    //MARK: Attributes
    @State private var fetchType: FetchType = .all
    @State private var openSearchView = false

    var body: some View {
        NavigationStack {
            GeometryReader { _ in
                switch viewModel.fetchStatus {
                case .success:
                    ScrollView(.vertical) {
                        LazyVStack(spacing: 30) {
                            Picker("", selection: $fetchType) {
                                ForEach(Array(FetchType.allCases.enumerated()), id: \.element) { index, type in
                                    Text(type.description.localized).tag(index)
                                }
                            }
                            .pickerStyle(.segmented)
                            .padding(.horizontal)
                            
                            switch fetchType {
                            case .all:
                                AllBooksView()
                            case .inProgress:
                                InProgressBooks()
                            case .finished:
                                FinishedBooksView()
                            case .recentlyAdded:
                                RecentlyAddedBooksView()
                            }
                        }
                        .padding(.top, 25)
                    }
                case .loading:
                    VStack {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .error(let error):
                    Text(error.localizedDescription)
                }
            }
            .toolbar {
                Button {
                    openSearchView.toggle()
                } label: {
                    Image(systemName: "plus.magnifyingglass")
                        .fontWeight(.semibold)
                }
            }
            .navigationTitle("AppTitle")
            .scrollContentBackground(.hidden)
            .background(Color.background)
            .navigationDestination(for: Book.self) { book in
                let _ = self.viewModel.setBookSelected(book)
                BookDetailView()
            }
            .sheet(isPresented: $openSearchView) {
                SearchView()
            }
        }
        .environment(viewModel)
    }
}

#Preview {
    LibraryView()
}
