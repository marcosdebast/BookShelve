//
//  BookDetailView.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 15/04/24.
//

import SwiftUI

struct BookDetailView: View {
    //MARK: ViewModel
    @Environment(BooksViewModel.self) private var viewModel

    //MARK: Attributes
    @State private var openReadingView: Bool = false
    @State private var showDescription: Bool = false
    @State private var showEditBook: Bool = false
    @State private var showRemoveBookAlert: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical) {
                LazyVStack(spacing: 20) {
                    Group {
                        if let imageURL = viewModel.bookSelected.imageLinks?.thumbnail, !imageURL.isEmpty, let url = URL(string: imageURL) {
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
                                .clipShape(.rect(cornerRadius: (proxy.size.width * 0.7)/5))
                                .frame(width: (proxy.size.width * 0.7), height: (proxy.size.width * 0.7))
                        }
                        if let descriptionText = viewModel.bookSelected.descriptionText {
                            Text(descriptionText)
                                .foregroundStyle(.accent)
                                .opacity(0.5)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                                .lineLimit(showDescription ? nil : 5)
                                .frame(maxWidth: .infinity, alignment: .center)
                            Button {
                                withAnimation(.none) {
                                    showDescription = !showDescription
                                }
                            } label: {
                                Text(showDescription ? "SeeLess" : "SeeMore")
                                    .foregroundStyle(.accent)
                                    .font(.subheadline)
                                    .fontWeight(.regular)
                            }
                        }
                        
                        if let pages = viewModel.bookSelected.pages {
                            HStack(spacing: 50) {
                                VStack(alignment: .center) {
                                    Text("\(pages)")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                        .multilineTextAlignment(.center)
                                    Text("Pages")
                                        .font(.subheadline)
                                }
                                .frame(width: 100)
                                if let publishedDate = viewModel.bookSelected.publishedDate?.formatted(.iso8601.year()) {
                                    VStack(alignment: .center) {
                                        //Text(viewModel.bookSelected.publishedDate.formatted(.iso8601.year()))
                                        Text(publishedDate)
                                            .font(.title2)
                                            .fontWeight(.medium)
                                            .multilineTextAlignment(.center)
                                        Text("Released")
                                            .font(.subheadline)
                                    }
                                    .frame(width: 100)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    if let startedDate = viewModel.bookSelected.startedDate {
                        //CustomSection("Details") {
                        HStack(alignment: .center, spacing: 50) {
                            VStack(alignment: .center) {
                                Text(startedDate.formatted(date: .numeric, time: .omitted))
                                    .font(.system(size: 16, weight: .medium))
                                    .multilineTextAlignment(.center)
                                Text("Started")
                                    .font(.subheadline)
                            }
                            .frame(width: 100)
                            if let endedDate = viewModel.bookSelected.endedDate {
                                VStack(alignment: .center) {
                                    Text(endedDate.formatted(date: .numeric, time: .omitted))
                                        .font(.system(size: 16, weight: .medium))
                                        .multilineTextAlignment(.center)
                                    Text("Ended")
                                        .font(.subheadline)
                                }
                                .frame(width: 100)
                            }
                        }
                        /*VStack(spacing: 5) {
                         HStack {
                         Text("Started:")
                         .font(.system(size: 16, weight: .regular))
                         .opacity(0.6)
                         Text(startedDate.formatted(date: .numeric, time: .omitted))
                         .font(.system(size: 16, weight: .medium))
                         }
                         .frame(maxWidth: .infinity, alignment: .leading)
                         
                         if let endedDate = viewModel.bookSelected.endedDate {
                         HStack {
                         Text("Ended:")
                         .font(.system(size: 16, weight: .regular))
                         .opacity(0.6)
                         Text(endedDate.formatted(date: .numeric, time: .omitted))
                         .font(.system(size: 16, weight: .medium))
                         }
                         .frame(maxWidth: .infinity, alignment: .leading)
                         }
                         }*/
                        //}
                    }
                    
                    Divider()
                        .padding(.horizontal)
                    
                    //TODO: - Solve layout issue
                    if viewModel.userLibraryContainsBook(viewModel.bookSelected) {
                        if viewModel.bookSelected.started {
                            CustomSection("SessionInProgress") {
                                VStack(alignment: .center, spacing: 5) {
                                    if let pages = viewModel.bookSelected.pages, let progress = viewModel.bookSelected.progress {
                                        Group {
                                            ProgressView(value: progress)
                                                .tint(.white)
                                                .background(.clear)
                                                .padding(.top, 10)
                                            Group {
                                                Text("\(viewModel.bookSelected.currentPage)")
                                                    .foregroundStyle(.mint)
                                                    .fontWeight(.medium)
                                                +
                                                Text(" of \(pages) pages read")
                                            }
                                            .foregroundStyle(.accent)
                                            .opacity(0.5)
                                            .font(.subheadline)
                                        }
                                        .padding(.bottom, 10)
                                    }
                                    ActionButton(action: {
                                        openReadingView.toggle()
                                    }, label: viewModel.bookSelected.isFinished ? "ReadingDetails" : "ContinueReading")
                                    .centerModifier()
                                    .padding(.top, 5)
                                }
                            }
                        } else {
                            ActionButton(action: {
                                openReadingView.toggle()
                            }, label: "StartReading")
                            
                        }
                    }
                    Spacer(minLength: 5)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .alert("Warning", isPresented: $showRemoveBookAlert) {
                Button("Remove", role: .destructive, action: {
                    withAnimation {
                        deleteBook(book: viewModel.bookSelected)
                    }
                })
            } message: {
                Text("DoYouWantToRemoveThisBookFromYourLibrary")
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(viewModel.bookSelected.title)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text(viewModel.bookSelected.authorsDescription)
                        .font(.caption)
                }
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                let userLibraryContainsBook = viewModel.userLibraryContainsBook(viewModel.bookSelected)
                Button {
                    if !userLibraryContainsBook {
                        saveBook(book: viewModel.bookSelected)
                    } else {
                        showRemoveBookAlert.toggle()
                    }
                } label: {
                    Image(systemName: userLibraryContainsBook ? "heart.fill" : "heart")
                        .font(.system(size: 18, weight: .bold))
                }
                
                if (userLibraryContainsBook) {
                    Button {
                        showEditBook.toggle()
                    } label: {
                        Text("Edit")
                        //Image(systemName: "pencil.and.scribble")
                        //.font(.system(size: 16, weight: .medium))
                    }
                    /*Menu {
                        Button {
                            showEditBook.toggle()
                        } label: {
                            HStack {
                                Text("EditBook")
                                Image(systemName: "pencil.and.scribble")
                                    .font(.system(size: 18, weight: .bold))
                            }
                        }
                        
                        Button {
                            showDescription = !showDescription
                        } label: {
                            HStack {
                                Text(showDescription ? "HideDescription" : "ShowDescription")
                                Image(systemName: showDescription ? "eye.slash" : "eye")
                                    .font(.system(size: 18, weight: .bold))
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.circle")
                            .font(.system(size: 18, weight: .medium))
                    }
                    .menuActionDismissBehavior(.disabled)*/
                }
            }
        }
        .sheet(isPresented: $openReadingView) {
            ReadingSessionView()
        }
        .sheet(isPresented: $showEditBook) {
            EditBookView()
        }
        .scrollContentBackground(.hidden)
        .background(Color.background)
        .onAppear {
            showDescription = !viewModel.bookSelected.started
        }
    }
    
    private func saveBook(book: Book) {
        do {
            try viewModel.bookDataCoreData.saveToStorage(viewModel.bookSelected)
        } catch {
            // TODO: Create error handling logic
        }
    }
    
    private func deleteBook(book: Book) {
        do {
            try viewModel.bookDataCoreData.removeFromStorage(book)
        } catch {
            // TODO: Create error handling logic
        }
    }
}

/*#Preview {
    BookDetailView(Boo)
}*/
