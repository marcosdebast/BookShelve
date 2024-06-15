//
//  AllAnnotationsView.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 30/04/24.
//

import SwiftUI

struct AllAnnotationsView: View {
    @Environment(\.dismiss) private var dismiss
    
    //MARK: ViewModel
    @State private(set) var viewModel: AnnotationViewModel
    
    //MARK: Attributes
    @State private var openAddAnnotation: Bool = false
    @State private var openEditAnnotation: Bool = false
    @State private var annotationSelected: Annotation?
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.getSections(), id: \.date) { section in
                    Section(section.date.formatted(date: .long, time: .omitted)) {
                        ForEach(section.annotations) { annotation in
                            NoteItem(annotation: annotation)
                                .swipeActions(edge: .trailing) {
                                    Button("Delete", role: .destructive) {
                                        withAnimation {
                                           deleteAnnotation(annotation: annotation)
                                        }
                                    }
                                    Button("Edit") {
                                        annotationSelected = annotation
                                        openEditAnnotation.toggle()
                                    }
                                }
                        }
                    }
                }
            }
            .id(viewModel.id)
            .emptyPlaceholder(viewModel.getSections()) {
                CustomContentUnavailableView(label: "NoAnnotations",
                                             image: "doc.richtext.fill",
                                             text: "UseThisAreaToAnnotateInsightsOfYourReading")
            }
            .navigationTitle("Annotations")
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
                        openAddAnnotation.toggle()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .modal(isPresented: $openAddAnnotation, type: .sheet) {
            AddAnnotationView()
        }
        .modal(isPresented: $openEditAnnotation, type: .sheet) {
            if let annotationSelected {
                EditAnnotationView(annotation: annotationSelected)
            }
        }
        .onAppear {
            viewModel.refreshData()
        }
        .environment(viewModel)
    }
    
    private func deleteAnnotation(annotation: Annotation) {
        do {
            try viewModel.deleteAnnotation(annotation: annotation)
        } catch {
            // TODO: Create error handling logic
        }
    }
}

private struct NoteItem: View {
    @State var annotation: Annotation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Page: \(annotation.page)")
                Spacer()
                Text(annotation.date.formatted(date: .omitted, time: .shortened))
            }
            .opacity(0.6)
            Text(annotation.text)
                .foregroundStyle(annotation.color)
                .applyFontStyle(annotation.fontStyle)
        }
    }
}
