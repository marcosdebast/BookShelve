//
//  FormsheetWrapper.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 17/04/24.
//

import SwiftUI

class FormSheetWrapper<Content: View>: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var content: () -> Content
    var onDismiss: (() -> Void)?
    
    private var hostVC: UIHostingController<Content>?
    
    required init?(coder: NSCoder) { fatalError("") }
    
    init(content: @escaping () -> Content) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }
    
    func show() {
        guard hostVC == nil else { return }
        let vc = UIHostingController(rootView: content())
        
        vc.view.sizeToFit()
        vc.preferredContentSize = CGSize(width: 500, height: 400)
        
        vc.modalPresentationStyle = .formSheet
        vc.presentationController?.delegate = self
        hostVC = vc
        self.present(vc, animated: true, completion: nil)
    }
    
    func hide() {
        guard let vc = self.hostVC, !vc.isBeingDismissed else { return }
        dismiss(animated: true, completion: nil)
        hostVC = nil
    }
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        hostVC = nil
        self.onDismiss?()
    }
}

struct FormSheet<Content: View> : UIViewControllerRepresentable {
    @Binding var show: Bool
    
    let content: () -> Content
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<FormSheet<Content>>) -> FormSheetWrapper<Content> {
        let vc = FormSheetWrapper(content: content)
        vc.onDismiss = { self.show = false }
        return vc
    }
    
    func updateUIViewController(_ uiViewController: FormSheetWrapper<Content>, context: UIViewControllerRepresentableContext<FormSheet<Content>>) {
        if show {
            uiViewController.content = content
            uiViewController.show()
        } else {
            uiViewController.hide()
        }
    }
}

extension View {
    public func formSheet<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        self.background(FormSheet(show: isPresented, content: content))
    }
}
