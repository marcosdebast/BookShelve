//
//  EditAnnotationView.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 22/04/24.
//

import SwiftUI

private enum FocusedField: Hashable {
    case page, annotation
}

struct EditAnnotationView: View {
    @FocusState private var focused: FocusedField?

    @Environment(AnnotationViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    
    @State var annotation: Annotation
    
    @State private var date: Date = Date.now
    @State private var page: String = ""
    @State private var text: String = ""
    @State private var color: Color = .white
    @State private var fontStyle: FontStyle = .regular

    //MARK: Alerts -
    @State private var showValidationAlert: Bool = false

    var body: some View {
        let editValidation = AnnotationValidation.Edit.validate(date: date, page: page, text: text, book: viewModel.book)
        NavigationStack {
            List {
                Section("Date") {
                    DatePicker("", selection: $date)
                        .datePickerStyle(.wheel)
                }
                Section("Page") {
                    TextField("InformThePage", text: $page)
                        .keyboardType(.numberPad)
                        .focused($focused, equals: .page)
                        .onSubmit {
                            focused = .annotation
                        }
                }
                Section("Annotation") {
                    TextField("WriteTheNote", text: $text, axis: .vertical)
                        .focused($focused, equals: .annotation)
                        .submitLabel(.return)
                        .applyFontStyle(fontStyle)
                        .foregroundStyle(color)
                        .id(color)
                }
                Section("FontStyle") {
                    HStack(alignment: .center) {
                        ForEach(FontStyle.allCases, id: \.self) { style in
                            Rectangle()
                                .fill(.gray.opacity(style == fontStyle ? 0.5 : 0.2))
                                .overlay {
                                    VStack(alignment: .center, spacing: 5) {
                                        Text(style.title.localized)
                                            .fontWeight(style.weight)
                                            .applyFontStyle(style)
                                        Text(style.description.localized)
                                            .font(.system(size: 10, weight: .light))
                                    }
                                }
                                .frame(height: 50)
                                .clipShape(.rect(cornerRadius: 5))
                                .clipped()
                                .onTapGesture {
                                    fontStyle = style
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                Section("TextColor") {
                    ColorPickerView(selectedColor: $color)
                }
            }
            .scrollDismissesKeyboard(.immediately)
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
                        guard editValidation.validated else {
                            showValidationAlert.toggle()
                            return
                        }
                        do {
                            try editAnnotation()
                            dismiss()
                        } catch {
                            // TODO: Create error handling logic
                        }
                        
                    } label: {
                        Text("Save")
                    }
                }
            }
        }
        .alert(Text("Warning"), isPresented: $showValidationAlert) {
        } message: {
            Text(editValidation.message.localized)
        }
        .onAppear {
            do {
                try initializeData()
            } catch {
                // TODO: Create error handling logic
            }
        }
    }
    
    private func initializeData() throws {
        self.date = annotation.date
        self.page = try annotation.page.toString()
        self.text = annotation.text
        self.color = annotation.color
        self.fontStyle = annotation.fontStyle
    }
    
    private func editAnnotation() throws {
        let annotation = Annotation(
            id: annotation.id,
            text: text,
            date: date,
            page: try page.toInt(),
            color: color,
            fontStyle: fontStyle,
            bookId: viewModel.book.id!
        )
        try viewModel.annotationDataCoreData.updateOnStorage(annotation)
    }
}

#Preview {
    EditAnnotationView(annotation: AnnotationSampler.one)
}
