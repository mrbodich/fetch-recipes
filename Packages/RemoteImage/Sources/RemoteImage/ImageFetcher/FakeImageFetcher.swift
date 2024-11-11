//
//  FakeImageFetcher.swift
//  Networking
//
//  Created by Bogdan Chornobryvets on 11/8/24.
//

import UIKit

open class FakeImageFetcher: ImageFetcher, @unchecked Sendable {
    public init() {}
    
    public final func fetchImage(url: String) async throws -> UIImage {
        try await Task(priority: .medium) {
            try await originalImage(for: url)
        }.value
    }
    
    public final func fetchImage(url: String,
                                 size: CGSize,
                                 method: ResizeMethod,
                                 scale: CGFloat) async throws -> UIImage {
        try await Task(priority: .medium) {
            let image = try await originalImage(for: url)
            guard let resizedImage = image.resized(to: size, method: method) else { throw RemoteImageError.badResponse }
            return resizedImage
        }.value
    }
    
    open func originalImage(for url: String) async throws -> UIImage {
        fatalError("This method must be overrided. No default logic provided.")
    }
    
}

fileprivate extension UIImage {
    func resized(to newSize: CGSize, method: ResizeMethod) -> UIImage? {
        let imageOrigin: CGPoint
        let imageSize: CGSize
        let artboardSize: CGSize
        
        let sizeRatio = CGSize(width: newSize.width / size.width, height: newSize.height / size.height)
        
        switch method {
        case .fillcrop:
            let ratio = max(sizeRatio.width, sizeRatio.height)
            imageSize = .init(width: size.width * ratio, height: size.height * ratio)
            artboardSize = newSize
            imageOrigin = .init(x: -(imageSize.width - artboardSize.width) / 2,
                                y: -(imageSize.height - artboardSize.height) / 2)
        case .fill:
            let ratio = max(sizeRatio.width, sizeRatio.height)
            imageSize = .init(width: size.width * ratio, height: size.height * ratio)
            imageOrigin = .zero
            artboardSize = imageSize
        case .fit:
            let ratio = min(sizeRatio.width, sizeRatio.height)
            imageSize = .init(width: size.width * ratio, height: size.height * ratio)
            imageOrigin = .zero
            artboardSize = imageSize
        }
        
        let renderer = UIGraphicsImageRenderer(size: artboardSize)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: imageOrigin, size: imageSize))
        }
    }
}
