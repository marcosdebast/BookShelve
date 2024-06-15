//
//  SmoothAsyncImage.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 16/04/24.
//

import SwiftUI
import func AVFoundation.AVMakeRect

// Drop-in replacement for AsyncImage that inflates the UIImage
// on a background thread to avoid scroll jank.
// Inspired by https://talk.objc.io/episodes/S01E258-asyncimage
struct SmoothAsyncImage<Content>: View where Content: View {
    private let url: URL
    private let scale: CGFloat
    private let shouldResize: Bool
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    
    @State private var phase = AsyncImagePhase.empty
    
    public init(url: URL, scale: CGFloat = 10, shouldResize: Bool? = true, transaction: Transaction = Transaction(),
                @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.scale = scale
        self.shouldResize = shouldResize ?? true
        self.transaction = transaction
        self.content = content
    }
    
    var body: some View {
        if let cached = ImageCache[url] {
            content(.success(Image(uiImage: cached)))
                .id(url) // The view's identity is defined by the URL.
        } else {
            GeometryReader { proxy in
                let targetSize = proxy.size
                content(phase)
                    .task (id: url) {
                        if let cached = ImageCache[url] {
                            phase = .success(Image(uiImage:cached))
                        } else {
                            do {
                                let uiImage = try await ImageLoader.shared.load(url:url, scale:scale, shouldResize: shouldResize, targetSize:targetSize)
                                ImageCache[url] = uiImage
                                withTransaction(transaction) {
                                    phase = .success(Image(uiImage:uiImage))
                                }
                            } catch {
                                withTransaction(transaction) {
                                    phase = .failure(error)
                                }
                            }
                        }
                    }
            }
            .id(url) // The view's identity is defined by the URL.
        }
    }
}

actor ImageLoader {
  static let shared = ImageLoader()

  enum ImageLoaderError : Error {
    /// The curent Task was canceled.
    case canceled
    /// The image could not be decoded.
    case undecodable
  }

  /// Load an image asynchronously. The resulting image is "inflated" (decoded to pixels)
  /// before being returned. This means it will render very quickly.
    func load(url: URL, scale: CGFloat = 1, shouldResize: Bool, targetSize: CGSize?) async throws -> UIImage {
    let (data, _) = try await URLSession.shared.data(from: url)
    guard !Task.isCancelled else { throw ImageLoaderError.canceled }
    guard var uiImage = UIImage(data: data, scale: scale) else {
      throw ImageLoaderError.undecodable
    }
    guard !Task.isCancelled else { throw ImageLoaderError.canceled }
    if let targetSize = targetSize,
       uiImage.size.width > targetSize.width
        || uiImage.size.height > targetSize.height {
        if (shouldResize) {
            if let resizedImage = resizedImage(
              uiImage: uiImage,
              scale: scale,
              targetSize: targetSize) {
              uiImage = resizedImage
            }
        }
      guard !Task.isCancelled else { throw ImageLoaderError.canceled }
    }
    // This is an undocumented way of inflating the UIImage.
    // https://developer.apple.com/forums/thread/653738
    _ = uiImage.cgImage?.dataProvider?.data
    return uiImage
  }

  // https://nshipster.com/image-resizing/
  // Technique #1
  private func resizedImage(uiImage: UIImage,
                            scale: CGFloat,
                            targetSize: CGSize) -> UIImage? {
    let scaledBounds = AVMakeRect(
      aspectRatio: uiImage.size,
      insideRect: CGRect(origin: .zero, size: targetSize)
    )
    let format = UIGraphicsImageRendererFormat()
    format.scale = scale
    let renderer = UIGraphicsImageRenderer(bounds:scaledBounds,
                                           format: format)
    return renderer.image { (context) in
      uiImage.draw(in: scaledBounds)
    }
  }
}

fileprivate class ImageCache {
    static private var cache: [URL: UIImage] = [:]
    static subscript(url: URL) -> UIImage? {
        get {
            ImageCache.cache[url]
        }
        set {
            ImageCache.cache[url] = newValue
        }
    }
}

