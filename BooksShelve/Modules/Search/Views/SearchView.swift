//
//  SearchView.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 16/04/24.
//

import SwiftUI

struct SearchView: View {
    @Environment(BooksViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    
    //MARK: Search
    @MainActor @State var searchResults: [Book] = []
    @State private var searchText = ""
    @State var searchTask: Task<[Book], Error>?
    
    //MARK: Attributes
    @State private var openScanner: Bool = false
    @State private var isPresentingScanner = false
    @State private var scannedCode: String = ""
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView(.vertical) {
                LazyVStack(spacing: 30) {
                    ForEach(searchResults) { book in
                        NavigationLink(value: book) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(book.title)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Text(book.authorsDescription)
                                        .font(.subheadline)
                                }
                                Spacer(minLength: 25)
                                if let imageURL = book.imageLinks?.thumbnail, !imageURL.isEmpty, let url = URL(string: imageURL) {
                                    Rectangle()
                                        .fill(.gray.opacity(0.5))
                                        .overlay {
                                            SmoothAsyncImage(url: url, shouldResize: false) { phase in
                                                switch phase {
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                default:
                                                    Color.clear
                                                }
                                            }
                                        }
                                        .frame(width: Constants.imageSize, height: Constants.imageSize)
                                        .clipShape(.rect(cornerRadius: Constants.imageSize/5))
                                        .clipped()
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .emptyPlaceholder(searchResults) {
                    CustomContentUnavailableView(label: "",
                                                 image: "magnifyingglass",
                                                 text: "SearchBookOrScanDescription")
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.background)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .fontWeight(.bold)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        openScanner.toggle()
                    } label: {
                        Image(systemName: "barcode.viewfinder")
                            .fontWeight(.bold)
                    }
                }
            }
            .navigationDestination(for: Book.self) { book in
                let _ = self.viewModel.setBookSelected(book)
                BookDetailView()
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onChange(of: searchText) {
            if searchText.isEmpty {
                searchResults = []
            }
            Task {
                searchTask?.cancel()
                let task = Task.detached {
                    try await Task.sleep(for: .seconds(0.5)) // debounce; if you don't want debouncing, remove this, but it can eliminate annoying updates of the UI while the user is typing
                    return await viewModel.fetchQuery(searchText)
                }
                searchTask = task
                searchResults = try await task.value
            }
        }
        .onChange(of: scannedCode) {
            Task {
                guard !scannedCode.isEmpty else {
                    return
                }
                searchResults.removeAll()
                try await Task.sleep(seconds: 1)
                isPresentingScanner.toggle()
                if let book = await viewModel.fetchISBN(scannedCode) {
                    searchResults = [book]
                    path.append(book)
                }
                scannedCode = .emptyString
            }
        }
        .onSubmit(of: .search, runSearch)
        .modal(isPresented: $openScanner, type: UIDevice.current.userInterfaceIdiom == .pad ? .formSheet : .sheet) {
            BarcodeScannerView(isPresentingScanner: $isPresentingScanner, scannedCode: $scannedCode)
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.visible)
        }
    }
    
    func runSearch() {
        print("run search")
    }
    
    private struct Constants {
        static let imageSize: CGFloat = 100
    }
}

#Preview {
    SearchView()
}
