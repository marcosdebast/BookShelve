//
//  ReadingSessionView.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 16/04/24.
//

import SwiftUI
import ConfettiSwiftUI

struct ReadingSessionView: View {
    @Environment(BooksViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
        
    //MARK: Attributes
    @State private var openDetail: Bool = false
    @State private var openAllBookAnnotations: Bool = false
    @State private var sessionSelected: ReadingSession!
    @State private var userFinishedBook: Bool = false
    @State private var confettiCounter: Int = 0
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 30) {
                    ProgressViewInfo()
                        .confettiCannon(counter: $confettiCounter, num: 100, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
                    
                    if viewModel.ongoingSession == nil && !viewModel.bookSelected.isFinished {
                        ActionButton(action: {
                            withAnimation {
                                viewModel.createSession()
                            }
                        }, label: "StartReadingSession")
                    }
                    /*if let pages = viewModel.bookSelected.pages {
                     CustomSection("CurrentPage") {
                     Stepper(value: $viewModel.bookSelected.currentPage, in: 0...pages) {
                     Text("\(viewModel.bookSelected.currentPage) of \(pages)")
                     .applyIf(viewModel.bookSelected.currentPage == pages,
                     transformOnTrue: { originalView in // Apply color
                     originalView.foregroundStyle(Color.green)
                     }, transformOnFalse: { originalView in // Don't apply color
                     originalView
                     })
                     .font(.title3)
                     .fontWeight(.bold)
                     }
                     }
                     }*/
                    
                    if let readingSessions = viewModel.bookSelected.readingSessions, !readingSessions.isEmpty {
                        let sessionsInProgress = readingSessions.filter(\.isInProgress == true)
                        if !sessionsInProgress.isEmpty {
                            CustomSection("SessionInProgress") {
                                ForEach(sessionsInProgress) { sessionInProgress in
                                    SessionItem(readingSession: sessionInProgress)
                                        .onTapGesture {
                                            sessionSelected = sessionInProgress
                                            openDetail.toggle()
                                        }
                                }
                            }
                        }
                        
                        /*CustomSection("DailyReadingActivity") {
                            ReadingSessionChart(readingSessions: ReadingSession.generateDummyData())
                        }*/
                        
                        Button {
                            openAllBookAnnotations.toggle()
                        } label: {
                            ActionItemView(text: "Annotations", image: "note.text")
                        }
                        .padding(.horizontal)
                        
                        let historicSessions = readingSessions.filter(\.endDate != nil)
                        if !historicSessions.isEmpty {
                            CustomSection("ReadingHistory") {
                                ForEach(historicSessions) { readingSession in
                                    SessionItem(readingSession: readingSession)
                                        .onTapGesture {
                                            sessionSelected = readingSession
                                            openDetail.toggle()
                                        }
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .fontWeight(.bold)
                    }
                }
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(viewModel.bookSelected.title)
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Text(viewModel.bookSelected.authorsDescription)
                            .font(.caption)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.background)
        }
        .onAppear {
            //TODO: - FIX THIS CODE LATER
            //sessionViewModel.refreshData()
        }
//        .onChange(of: sessionSelected) {
//            guard sessionSelected != nil else {
//                return
//            }
//            openDetail.toggle()
//        }
        .modal(isPresented: $openDetail, type: .sheet) {
            ReadingSessionDetailView(sessionSelected: $sessionSelected, userFinishedBook: $userFinishedBook)
                .presentationDetents([.height(600)])
                .presentationDragIndicator(.visible)
        }
        .modal(isPresented: $openAllBookAnnotations, type: .sheet) {
            AllAnnotationsView(
                viewModel: AnnotationViewModel(book: viewModel.bookSelected)
            )
        }
        .onChange(of: userFinishedBook) {
            confettiCounter+=1
        }
        .alert("Congratulations", isPresented: $userFinishedBook) {
            Button("OK", action: {})
        } message: {
            Text("YouHaveFinishedYourBook")
        }
    }
    
    private struct Constants {
        static let imageSize: CGFloat = 100
    }
}

private struct ProgressViewInfo: View {
    @Environment(BooksViewModel.self) private var viewModel
    
    var body: some View {
        VStack {
            VStack(spacing: 10) {
                Rectangle()
                    .fill(.gray.opacity(0.5))
                    .overlay {
                        if let imageURL = viewModel.bookSelected.imageLinks?.thumbnail, !imageURL.isEmpty, let url = URL(string: imageURL) {
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
                    }
                    .clipShape(.rect(cornerRadius: Constants.imageSize/5))
                    .frame(width: Constants.imageSize, height: Constants.imageSize)
                VStack {
                    Group {
                        Text(viewModel.bookSelected.title)
                            .font(.system(size: 20, weight: .bold))
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.4)
                            .frame(height: 20)
                        Text(viewModel.bookSelected.authorsDescription)
                            .font(.system(size: 16, weight: .light))
                    }
                    .foregroundStyle(.accent)
                    .multilineTextAlignment(.leading)
                    HStack {
                        let progress = viewModel.bookSelected.progress ?? 0
                        ProgressView(value: progress)
                            .tint(.white)
                            .background(.clear)
                            .layoutPriority(0)
                        Text(progress, format: .percent(decimals: 0))
                            .font(.system(size: 12, weight: .heavy))
                            .layoutPriority(1)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
            .background(.gray.opacity(0.1))
            .clipShape(.rect(cornerRadius: Constants.imageSize/5))
        }
        .padding(.horizontal)
    }
    
    private struct Constants {
        static let imageSize: CGFloat = 150
    }
}
