//
//  MemoryImageCache.swift
//  Networking
//
//  Created by Bogdan Chornobryvets on 11/8/24.
//

import Foundation
import UIKit

final class MemoryImageCache: @unchecked Sendable {
    private let queue = DispatchQueue(label: "networking.MemoryImageCache.queue")
    
    private let imageCache: NSCache<NSString, UIImage>
    private let delegate: MemoryImageCacheDelegate
    
    let memoryLimit: Int
    
    private(set) var itemsCount: Int = 0
    private(set) var memoryUsageBytes: Int = 0
    
    init(memoryLimit: Int) {
        self.memoryLimit = memoryLimit
        imageCache = NSCache<NSString, UIImage>()
        imageCache.totalCostLimit = memoryLimit > 0 ? memoryLimit : 1
        delegate = .init()
        delegate.willEvictObject = { [weak self] obj in
            guard let self, let image = obj as? UIImage else { return }
            queue.sync {
                self.itemsCount -= 1
                self.memoryUsageBytes -= image.diskSize
            }
        }
        imageCache.delegate = delegate
    }
}

extension MemoryImageCache: ImageCache {

    public func add(_ image: UIImage, for key: URLRequest) {
        let size = image.diskSize
        defer {
            queue.sync {
                itemsCount += 1
                memoryUsageBytes += size
            }
        }
        imageCache.setObject(
            image,
            forKey: keyString(for: key),
            cost: size
        )
    }
    
    public func removeImage(for key: URLRequest) {
        imageCache.removeObject(forKey: keyString(for: key))
    }
    
    public func image(for key: URLRequest) -> UIImage? {
        return imageCache.object(forKey: keyString(for: key))
    }
    
    public func removeAllImages() {
        imageCache.removeAllObjects()
        queue.sync {
            itemsCount = 0
            memoryUsageBytes = 0
        }
    }
    
    private func keyString(for key: URLRequest) -> NSString {
        key.keyHash as NSString
    }
}

fileprivate final class MemoryImageCacheDelegate: NSObject, NSCacheDelegate {
    var willEvictObject: ((_ obj: Any) -> ())? = nil
    
    public func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        willEvictObject?(obj)
    }
}

extension UIImage {
    var diskSize: Int {
        let size = CGSize(width: self.size.width * self.scale, height: self.size.height * self.scale)
        let bytesPerPixel: CGFloat = 4.0
        let bytesPerRow = size.width * bytesPerPixel
        let totalBytes = Int(bytesPerRow) * Int(size.height)

        return totalBytes
    }
}

extension URLRequest {
    var keyHash: String {
        url?.absoluteString ?? ""
    }
}
