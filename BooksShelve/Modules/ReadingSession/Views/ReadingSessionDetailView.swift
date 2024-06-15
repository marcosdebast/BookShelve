//
//  ReadingSessionDetailView.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 22/04/24.
//

import SwiftUI

struct ReadingSessionDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    //MARK: ViewModel
    @Environment(BooksViewModel.self) private var viewModel

    //MARK: Attributes
    @Binding var sessionSelected: ReadingSession?
    @State private var showingAlert: Bool = false
    @State private var errorAlert: Bool = false
    @State private var pages: String = ""
    @State private var openTranslator: Bool = false
    @State private var openSessionAnnotations: Bool = false
    @State private var openAddNote: Bool = false
    
    @Binding var userFinishedBook: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    if let sessionSelected {
                        VStack(spacing: 15) {
                            TimerView(sessionSelected: sessionSelected)
                            if sessionSelected.isInProgress {
                                ActionButton(textColor: .white, fillColor: .red, action: {
                                    showingAlert.toggle()
                                }, label: "EndReadingSession")
                            } else {
                                SessionItem(readingSession: sessionSelected)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    
                    CustomSection("Options") {
                        Button {
                            openTranslator.toggle()
                        } label: {
                            ActionItemView(text: "Translator", image: "textformat.abc")
                        }
                        Button {
                            openSessionAnnotations.toggle()
                        } label: {
                            ActionItemView(text: "SessionAnnotations", image: "note.text")
                        }
                        /*Button {
                            openAddNote.toggle()
                        } label: {
                            ActionItemView(text: "AddNote", image: "pencil.tip.crop.circle.badge.plus")
                        }*/
                    }
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismissView()
                    } label: {
                        Image(systemName: "xmark")
                            .fontWeight(.bold)
                    }
                }
                /*ToolbarItem(placement: .principal) {
                    Text("Details")
                        .font(.subheadline)
                        .fontWeight(.bold)
                }*/
                if let sessionSelected, !sessionSelected.isInProgress {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            withAnimation {
                                viewModel.readingSessionCoreData.removeFromStorage(sessionSelected)
                                dismissView()
                            }
                        } label: {
                            Image(systemName: "trash")
                                .font(.system(size: 16, weight: .medium))
                        }
                    }
                }
              
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            //.scrollContentBackground(.hidden)
            //.background(Color.background)
            .alert("WhichPageDidYouStop?", isPresented: $showingAlert) {
                TextField("Page", text: $pages)
                    .keyboardType(.numberPad)
                Button("Cancel", action: {})
                Button("Save", action: {
                    withAnimation {
                        guard
                            let currentPage = Int(pages),
                             currentPage >= viewModel.bookSelected.currentPage,
                            currentPage <= (viewModel.bookSelected.pages ?? 0)
                        else {
                            pages = .emptyString
                            errorAlert.toggle()
                            return
                        }
                        viewModel.endSession(page: currentPage)
                        viewModel.setCurrentPage(String(currentPage))
                        if let progress = viewModel.bookSelected.progress, progress == 1 {
                            //USER FINISHED BOOK
                            viewModel.setEndedDate(Date())
                            userFinishedBook.toggle()
                        }
                        editBook()
                        dismissView()
                    }
                })
            } message: {
                Text("YourBookContain \(viewModel.bookSelected.pages ?? 0) \(viewModel.bookSelected.currentPage)")
            }
            .alert("PleaseInformValidPage", isPresented: $errorAlert) {
                Button("OK", action: {})
            } message: {
                Text("YourBookContain \(viewModel.bookSelected.pages ?? 0) \(viewModel.bookSelected.currentPage)")
            }
            .modal(isPresented: $openTranslator, type: .sheet) {
                TranslatorView()
                    .presentationDetents([.height(600)])
                    .presentationDragIndicator(.visible)
            }
            .modal(isPresented: $openSessionAnnotations, type: .sheet) {
                ReadingSessionAnnotationsView()
            }
            .modal(isPresented: $openAddNote, type: .sheet) {
                AddAnnotationView()
            }
        }
    }
    
    private func editBook() {
        do {
            try viewModel.bookDataCoreData.updateOnStorage(viewModel.bookSelected)
        } catch {
            // TODO: Create error handling logic
        }
    }
    
    private func dismissView() {
        self.sessionSelected = nil
        dismiss()
    }
}
