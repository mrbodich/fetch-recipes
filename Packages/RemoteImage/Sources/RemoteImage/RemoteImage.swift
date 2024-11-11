//
//  RemoteImage.swift
//  Networking
//
//  Created by Bogdan Chornobryvets on 11/8/24.
//

import Foundation
import SwiftUI
import UIKit

public struct RemoteImage<LabelView: View>: View, @unchecked Sendable {
    @Environment(\.imageFetcher) var imageFetcher
    @State private var image: UIImage?
    @State private var latestURL: String = ""
    
    private let urlStr: String
    private let placeholder: PlaceholderType
    private let resizeMethod: ResizeMethod
    private let quality: Quality
    private let label: (_ image: ModifiedContent<Image, _AspectRatioLayout>) -> LabelView
    
    public init(
        urlStr: String,
        resizeMethod: ResizeMethod,
        quality: Quality = .high,
        placeholder: PlaceholderType = .none
    ) where LabelView == ModifiedContent<Image, _AspectRatioLayout> {
        self.urlStr = urlStr
        self.placeholder = placeholder
        self.resizeMethod = resizeMethod
        self.quality = quality
        label = { $0 }
    }
    
    public init(
        urlStr: String,
        resizeMethod: ResizeMethod,
        quality: Quality = .high,
        placeholder: PlaceholderType = .none,
        @ViewBuilder
        label: @escaping (_ image: ModifiedContent<Image, _AspectRatioLayout>) -> LabelView
    ) {
        self.urlStr = urlStr
        self.placeholder = placeholder
        self.resizeMethod = resizeMethod
        self.quality = quality
        self.label = label
    }
    
    public var body: some View {
        GeometryReader { geo in
            Color.clear.overlay {
                switch (image, placeholder) {
                case let (.some(image), _):         label(buildImage(from: image))
                case let (.none, .image(image)):    buildImage(from: image)
                case let (.none, .color(color)):    color
                case (.none, .none):                Color.clear
                }
            }
            .task {
                updateImage(size: geo.size)
            }
            .onChange(of: urlStr) { newValue in
                updateImage(urlStr: newValue, size: geo.size, method: resizeMethod, quality: quality)
            }
        }
    }
    
    private func buildImage(from uiImage: UIImage) -> ModifiedContent<Image, _AspectRatioLayout> {
        Image(uiImage: uiImage)
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: resizeMethod.contentMode) as! ModifiedContent<Image, _AspectRatioLayout>
    }
    
    private func updateImage(size: CGSize) {
        updateImage(urlStr: urlStr,
                    size: size,
                    method: resizeMethod,
                    quality: quality)
    }
    
    private func updateImage(urlStr: String, size: CGSize, method: ResizeMethod, quality: Quality) {
        guard !urlStr.isEmpty else { return }
        if urlStr != self.latestURL { image = nil }
        self.latestURL = urlStr
        
        Task(priority: .medium) {
            do {
                let fetchedImage = try await imageFetcher.fetchImage(url: urlStr,
                                                                     size: size,
                                                                     method: method,
                                                                     scale: quality.scale)
                Task { @MainActor in
                    guard urlStr == self.latestURL else { return }
                    self.image = fetchedImage
                }
            } catch {
                #if DEBUG
                Logger.log("Failed to fetch image from url \(urlStr) with error: \(error)")
                #endif
            }
        }
    }
    
    public enum PlaceholderType {
        case none
        case image(UIImage)
        case color(Color)
    }
    
    public enum ContentType {
        case image(UIImage)
        case color(Color)
    }
    
    public enum Quality: Sendable {
        case low
        case medium
        case high
        
        @MainActor
        var scale: CGFloat {
            switch self {
            case .low:      return QualityScale.low
            case .medium:   return QualityScale.medium
            case .high:     return QualityScale.high
            }
        }
    }
}

@MainActor
fileprivate struct QualityScale {
    static let low: CGFloat     = 1.0
    static let medium: CGFloat  = 1.0 + ((UIScreen.main.scale - 1.0) / 2)
    static let high: CGFloat    = UIScreen.main.scale
}

fileprivate extension ResizeMethod {
    var contentMode: ContentMode {
        switch self {
        case .fit:              return .fit
        case .fill, .fillcrop:  return .fill
        }
    }
}

#if DEBUG
struct CachingRemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        let imageURL = "https://avatars.githubusercontent.com/u/9919?v=4"
        
        VStack(spacing: 0) {
            RemoteImage(urlStr: imageURL,
                        resizeMethod: .fillcrop,
                        placeholder: .color(.gray))
            .border(Color.red)
            .clipped()
            .environment(\.imageFetcher, RemoteImageFetcher(sid: "com.test1",
                                                            memoryCacheCapacity: 0,
                                                            diskCacheCapacity: 0))
            
            RemoteImage(urlStr: imageURL,
                        resizeMethod: .fill,
                        placeholder: .color(.gray))
            .environment(\.imageFetcher, RemoteImageFetcher(sid: "com.test1",
                                                            memoryCacheCapacity: 0,
                                                            diskCacheCapacity: 0))
            .border(Color.green)
            .clipped()
            
            RemoteImage(urlStr: imageURL,
                        resizeMethod: .fill,
                        placeholder: .color(.gray))
            .environment(\.imageFetcher, RemoteImageFetcher(sid: "com.test2",
                                                            memoryCacheCapacity: 10,
                                                            diskCacheCapacity: 0))
            .border(Color.blue)
            .clipped()
            
            RemoteImage(urlStr: imageURL,
                        resizeMethod: .fit,
                        placeholder: .color(.gray))
            .environment(\.imageFetcher, RemoteImageFetcher(sid: "com.test3",
                                                            memoryCacheCapacity: 0,
                                                            diskCacheCapacity: 10))
            .border(Color.orange)
            .clipped()
            
            RemoteImage(urlStr: imageURL,
                        resizeMethod: .fill,
                        placeholder: .color(.gray)) { image in
                ZStack {
                    image
                    Color.yellow.opacity(0.5)
                    Text(verbatim: "Overlaying text example")
                        .background(Color.green)
                }
            }
            .environment(\.imageFetcher, RemoteImageFetcher(sid: "com.test3",
                                                            memoryCacheCapacity: 0,
                                                            diskCacheCapacity: 00))
            .border(Color.purple)
            .clipped()
        }
        .environment(\.imageFetcher, RemoteImageFetcher(sid: "com.test1",
                                                        memoryCacheCapacity: 0,
                                                        diskCacheCapacity: 0))
    }
}
#endif
