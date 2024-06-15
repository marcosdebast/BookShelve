//
//  EditBookView.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 24/04/24.
//

import PhotosUI
import SwiftUI

private enum FocusedField: Hashable {
    case title, description, authors, pages, currentPage
}

struct EditBookView: View {
    @FocusState private var focused: FocusedField?

    @Environment(BooksViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    
    //MARK: Attributes -
    @State private var title: String = ""
    @State private var descriptionText: String = ""
    @State private var authors: [String] = []
    @State private var pages: String = ""
    @State private var currentPage: String = ""
    @State private var startedDate: Date?
    @State private var endedDate: Date?

    @State private var coverArtItem: PhotosPickerItem?
    @State private var coverArtImage: Image?

    //MARK: Alerts -
    @State private var showValidationAlert: Bool = false

    var body: some View {
        let updateValidation = BookValidation.Update.validate(title: title, pages: pages, currentPage: currentPage)
        NavigationStack {
            List {
                Section("CoverArt") {
                    VStack(alignment: .center) {
                        if let imageURL = viewModel.bookSelected.imageLinks?.thumbnail, !imageURL.isEmpty, let url = URL(string: imageURL) {
                            Rectangle()
                                .fill(.clear)
                                .overlay {
                                    VStack(spacing: 10) {
                                        if let coverArtImage {
                                            coverArtImage
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 120, height: 175)
                                                .clipShape(.rect(cornerRadius: 15))
                                                .clipped()
                                        } else {
                                            SmoothAsyncImage(url: url, shouldResize: false) { phase in
                                                switch phase {
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 120, height: 175)
                                                        .clipShape(.rect(cornerRadius: 15))
                                                        .clipped()
                                                default:
                                                    Color.clear
                                                }
                                            }
                                        }
                                        PhotosPicker("TapToSelectACoverArt", selection: $coverArtItem, matching: .images)
                                            .font(.callout)
                                            .opacity(0.6)
                                    }
                                }
                                .onChange(of: coverArtItem) {
                                    Task {
                                        if let loaded = try? await coverArtItem?.loadTransferable(type: Image.self) {
                                            coverArtImage = loaded
                                        } else {
                                            print("Failed")
                                        }
                                    }
                                }
                            
                        }
                    }
                    .frame(height: 200)
                }
                
                Section("Title") {
                    TextField("BookTitle", text: $title)
                        .focused($focused, equals: .title)
                        .onSubmit {
                            focused = .authors
                        }
                }
                Section("Description") {
                    TextField("BookDescription", text: $descriptionText, axis: .vertical)
                        .focused($focused, equals: .description)
                        .onSubmit {
                            focused = .authors
                        }
                }
                Section("Authors") {
                    ForEach(authors.indices, id: \.self) { index in
                        TextField("AuthorName", text: Binding(
                            get: {
                                self.authors[index]
                            },
                            set: { newValue in
                                self.authors[index] = newValue
                            }
                        ))
                        .focused($focused, equals: .authors)
                        .onSubmit {
                            if index == self.authors.count - 1 {
                                focused = .pages
                            } else {
                                focused = .authors
                            }
                        }
                    }
                    .onDelete(perform: deleteAuthor)
                    Button("AddAuthor") {
                        authors.append(.emptyString)
                    }
                    .tint(.blue)
                }
                Section("Pages") {
                    TextField("BookPages", text: $pages)
                        .keyboardType(.numberPad)
                        .focused($focused, equals: .pages)
                        .onSubmit {
                            focused = .currentPage
                        }
                }
                Section("CurrentPage") {
                    TextField("CurrentPage", text: $currentPage)
                        .keyboardType(.numberPad)
                        .focused($focused, equals: .currentPage)
                        .submitLabel(.done)
                        .onSubmit {
                            focused = nil
                        }
                }
                
                Section("ReadingStartDate") {
                    if let startedDate {
                        DatePicker(
                            "Start Date",
                            selection: Binding<Date>(get: {startedDate}, set: {self.startedDate = $0}),
                            in: ...Date(),
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.wheel)
                        Button("RemoveDate") {
                            self.startedDate = nil
                            self.endedDate = nil
                        }
                        .tint(.red)
                    } else {
                        Button("SelectDate") {
                            startedDate = Date()
                        }
                        .tint(.blue)
                    }
                }
                
                Section("ReadingEndDate") {
                    if let startedDate, let endedDate {
                        DatePicker(
                            "End Date",
                            selection: Binding<Date>(get: {endedDate}, set: {self.endedDate = $0}),
                            in: startedDate...Date(),
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.wheel)
                        Button("RemoveDate") {
                            self.endedDate = nil
                        }
                        .tint(.red)
                    } else {
                        Button("SelectDate") {
                            endedDate = Date()
                        }
                        .tint(.blue)
                    }
                }
            }
            .navigationTitle("EditBook")
            .navigationBarTitleDisplayMode(.inline)
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
                        guard updateValidation.validated else {
                            showValidationAlert.toggle()
                            return
                        }
                        updateBook()
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                }
            }
            //.scrollContentBackground(.hidden)
            //.background(Color.background)
        }
        .scrollDismissesKeyboard(.immediately)
        .onAppear {
           setupData()
        }
        .alert(Text("Warning"), isPresented: $showValidationAlert) {
        } message: {
            Text(updateValidation.message.localized)
        }
    }
    
    private func deleteAuthor(at offsets: IndexSet) {
        authors.remove(atOffsets: offsets)
    }
    
    private func setupData() {
        title = viewModel.bookSelected.title
        descriptionText = viewModel.bookSelected.descriptionText.orEmpty
        authors = viewModel.bookSelected.authors
        if let intPages = viewModel.bookSelected.pages {
            pages = String(intPages)
        }
        currentPage = String(viewModel.bookSelected.currentPage)
        startedDate = viewModel.bookSelected.startedDate
        endedDate = viewModel.bookSelected.endedDate
    }
    
    private func updateBook() {
        viewModel.setTitle(title)
        viewModel.setDescriptionText(descriptionText)
        viewModel.setAuthors(authors)
        viewModel.setPages(pages)
        viewModel.setCurrentPage(currentPage)
        if let startedDate {
            viewModel.setStartedDate(startedDate)
        }
        if let endedDate {
            viewModel.setEndedDate(endedDate)
        }
        do {
            try viewModel.bookDataCoreData.updateOnStorage(viewModel.bookSelected)
        } catch {
            // TODO: Create error handling logic
        }
    }
}
