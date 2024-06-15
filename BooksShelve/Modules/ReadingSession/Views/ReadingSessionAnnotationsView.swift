//
//  ReadingSessionAnnotationsView.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 30/04/24.
//

import SwiftUI

struct ReadingSessionAnnotationsView: View {
    @Environment(\.dismiss) private var dismiss

    private let dummyText: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam."
    
    //MARK: Attributes
    @State private var openAddNote: Bool = false

    var body: some View {
        NavigationStack {
            List {
                Section("Página 1") {
                    ForEach(0..<1) { _ in
                        Text(dummyText)
                    }
                }
                Section("Página 4") {
                    ForEach(0..<2) { _ in
                        Text(dummyText)
                            .foregroundStyle(.yellow)
                    }
                }
                Section("Página 10") {
                    ForEach(0..<3) { _ in
                        Text(dummyText)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("SessionAnnotations")
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
                        openAddNote.toggle()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .modal(isPresented: $openAddNote, type: .sheet) {
            AddAnnotationView()
        }
    }
}

#Preview {
    ReadingSessionAnnotationsView()
}
