//
//  SettingsView.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 22/04/24.
//

import SwiftUI
import PhotosUI

struct SettingsView: View {
    @State private var item: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var loadingImage: Bool = false
    
    private let dependencies: [String] = [
        "https://github.com/simibac/ConfettiSwiftUI.git",
        "https://github.com/twostraws/CodeScanner",
        "https://github.com/marcosdebast/GoogleTranslateSwift",
    ]
    
    private let design: String = "https://dribbble.com/shots/23011906-E-book-App-UI"
    
    var body: some View {
        NavigationStack {
            Form {
                Group {
                    Group {
                        HStack(alignment: .center) {
                            Spacer()
                            VStack {
                                ZStack {
                                    (selectedImage ?? Image(systemName: "person.crop.circle"))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100, alignment: .center)
                                        .clipShape(.circle)
                                        .opacity(loadingImage ? 0 : 1)
                                    
                                    PhotosPicker("", selection: $item, matching: .images)
                                    if (loadingImage) {
                                        ProgressView()
                                            .controlSize(.large)
                                            .progressViewStyle(
                                                CircularProgressViewStyle(tint: .white)
                                            )
                                    }
                                }
                                Text("Marcos Debastiani")
                                    .font(.title)
                                Text("marcosdebgodoi@gmail.com")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding()
                    }
                    
                    Section("Content") {
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundStyle(.red)
                            Text("Favorites")
                        }
                        
                        HStack {
                            Image(systemName: "arrow.down.circle")
                                .foregroundStyle(.green)
                            Text("Manage storage")
                        }
                    }
                    
                    Section {
                        ForEach(dependencies, id: \.self) { dependency in
                            Button {
                                if let url = URL(string: dependency) {
                                    UIApplication.shared.open(url)
                                }
                            } label: {
                                Text(dependency)
                                    .foregroundStyle(.blue)
                            }
                        }
                    } header: {
                        Text("Dependencies")
                    } footer: {
                        Text("DependenciesShowcaseText")
                    }
                    
                    Section("DesignInspiration") {
                        Button {
                            if let url = URL(string: design) {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Text(design)
                                .foregroundStyle(.blue)
                        }
                    }
                }
                .listRowBackground(Color.gray.opacity(0.1))
            }
            .navigationTitle("Settings")
            .scrollContentBackground(.hidden)
            .background(Color.background)
            .onChange(of: item) {
                Task {
                    loadingImage = true
                    if let loadedImage = try await item?.loadTransferable(type: Data.self),
                       let uiImaage = UIImage(data: loadedImage) {
                        selectedImage = Image(uiImage: uiImaage)
                    }
                    loadingImage = false
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
