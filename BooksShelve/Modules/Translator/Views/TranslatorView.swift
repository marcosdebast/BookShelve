//
//  TranslatorView.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 03/04/24.
//

import SwiftUI
import GoogleTranslateSwift

struct TranslatorView: View {
    private enum FocusedField: Hashable {
        case enterText
    }
    
    @FocusState private var focused: FocusedField?

    @State var text: String = ""
    @State var translated: String?
    @State var translating: Bool = false
    
    var body: some View {
        //NavigationStack {
        ScrollView {
            LazyVStack(spacing: 0) {
                HStack {
                    Group {
                        Text(Language.english.rawValue)
                        Text(verbatim: "->")
                        Text(Language.brazilianPortuguese.rawValue)
                    }
                    .font(.system(size: 18, weight: .bold))
                }
                .padding(.top, 50)
                Group {
                    TextField("EnterText", text: $text)
                        .textFieldStyle(MyTextFieldStyle())
                        .bold()
                        .submitLabel(.done)
                        .focused($focused, equals: .enterText)
                        .onSubmit {
                            translate()
                        }
                }
                .frame(height: 200)
                
                Group {
                    if let translated {
                        Text(translated)
                            .foregroundStyle(.white)
                    } else {
                        Text("Translated")
                            .foregroundStyle(.gray.opacity(0.5))
                    }
                }
                .bold()
                .multilineTextAlignment(.leading)
                .frame(height: 100)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1.5))
              
                Button {
                    translate()
                } label: {
                    Group {
                        if (translating) {
                            ProgressView()
                                .progressViewStyle(
                                    CircularProgressViewStyle(tint: .white)
                                )
                        } else {
                            Text("Translate")
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                }
                .tint(.blue)
                .buttonStyle(.borderedProminent)
                .padding(.top, 40)
            }
            .padding(.horizontal)
        }
        .scrollDismissesKeyboard(.immediately)
        //.navigationTitle("Translator")
        //.scrollContentBackground(.hidden)
        //.background(Color.background)
        //}
    }
    
    private func translate() {
        translating.toggle()
        Task {
            do {
                let result = try await GoogleTranslateService.shared.translate(text: text, source: .english, target: .brazilianPortuguese)
                translated = result.translation
            } catch let error {
                print(error)
            }
            translating = false
        }
    }
}

struct MyTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(height: 100)
            .padding(.horizontal)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1.5)
            )
    }
}

extension UITextField
{
    open override var textInputMode: UITextInputMode?
    {
        let locale = Locale(identifier: "en-US")
        return UITextInputMode.activeInputModes.first(where: { $0.primaryLanguage == locale.identifier }) ?? super.textInputMode
    }
}



#Preview {
    TranslatorView()
}
