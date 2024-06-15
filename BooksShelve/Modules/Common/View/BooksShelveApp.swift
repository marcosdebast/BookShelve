//
//  BooksShelveApp.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 03/04/24.
//

import SwiftUI

@main
struct BooksShelveApp: App {
    
    init() {
        //setupAppearence()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                /*.onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification), perform: { output in
                    ReadingSessionViewModel.shared.endSession(page: BooksViewModel.shared.bookSelected.currentPage)
                    BooksViewModel.shared.updateOnStorage(BooksViewModel.shared.bookSelected)
                })*/
        }
    }
    
    private func setupAppearence() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.background], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
}
