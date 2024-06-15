//
//  ModalModifier.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 17/04/24.
//

import SwiftUI

enum ModalType {
    case sheet
    case fullScreen
    case formSheet
    
    static func defaultTypeByUserInterfaceIdiom() -> ModalType {
        return UIDevice.current.userInterfaceIdiom == .pad ? .sheet : .fullScreen
    }
}

struct Modal<ModalContent: View>: ViewModifier {
    @State var type: ModalType
    @Binding var isPresented: Bool
    @ViewBuilder let modalContent: ModalContent
    
    func body(content: Content) -> some View {
        switch type {
        case .sheet:
            content
                .sheet(isPresented: $isPresented) {
                    modalContent
                }
        case .fullScreen:
            content
                .fullScreenCover(isPresented: $isPresented) {
                    modalContent
                }
        case .formSheet:
            content
                .formSheet(isPresented: $isPresented) {
                    modalContent
                }
        }
    }
}

extension View {
    func modal<Content: View>(isPresented: Binding<Bool>, type: ModalType = ModalType.defaultTypeByUserInterfaceIdiom(), @ViewBuilder content: @escaping () -> Content) -> some View {
        return modifier(Modal(type: type, isPresented: isPresented, modalContent: content))
    }
}
