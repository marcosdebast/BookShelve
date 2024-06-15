//
//  ContentView.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 03/04/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Group {
                LibraryView()
                    .tabItem {
                        Image(systemName: "book.pages")
                            .renderingMode(.template)
                        Text("Library")
                    }
                SettingsView()
                    .tabItem {
                        Image(systemName: "gear")
                            .renderingMode(.template)
                        Text("Settings")
                    }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.background)
    }
}

#Preview {
    ContentView()
}
