//
//  Data+Extensions.swift
//  Networking
//
//  Created by Bogdan Chornobryvets on 11/8/24.
//

import Foundation
import UIKit

extension Data {
    func imageDownsampled(to pointSize: CGSize, scale: CGFloat, contentMode: ResizeMethod) -> (image: UIImage, data: Data)? {
        
        // Create an CGImageSource that represent an image
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithData(self as CFData, imageSourceOptions),
              let imageProps = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary?
        else {
            return nil
        }
        
        let originalPixelWidth = imageProps[kCGImagePropertyPixelWidth] as! CGFloat?
        let originalPixelHeight = imageProps[kCGImagePropertyPixelHeight] as! CGFloat?
        let extractedOrientation = (imageProps[kCGImagePropertyOrientation] as! Int?)

        guard let originalPixelWidth, let originalPixelHeight else { return nil }
        
        let cgImageOrientation = extractedOrientation.flatMap { CGImagePropertyOrientation(rawValue: UInt32($0))! } ?? .up
        let uiImageOrientation = cgImageOrientation.uiImageOrientation
        
        let isFrameRotated = cgImageOrientation.isFrameRotated
        let targetPixelWidth: CGFloat = (isFrameRotated ? pointSize.height : pointSize.width) * scale
        let targetPixelHeight: CGFloat = (isFrameRotated ? pointSize.width : pointSize.height) * scale
        
        /// If target size equals original size, return UIImage constructed from original data
        guard targetPixelWidth != originalPixelWidth, targetPixelHeight != originalPixelHeight else {
            return UIImage(data: self, scale: scale)
                .flatMap {
                    ($0, self)
                }
        }

        let widthRatio = targetPixelWidth / originalPixelWidth
        let heightRatio = targetPixelHeight / originalPixelHeight
        
        let scaleFactor: CGFloat
        switch contentMode {
        case .fit:              scaleFactor = Swift.min(widthRatio, heightRatio)
        case .fill, .fillcrop:  scaleFactor = Swift.max(widthRatio, heightRatio)
        }
        
        // Only allow downscale, not allowing upscale
        let downscaleFactor = Swift.min(1, scaleFactor)
        // Calculate the desired downscale dimensions
        let scaledTargetWidth = originalPixelWidth * downscaleFactor
        let scaledTargetHeight = originalPixelHeight * downscaleFactor
        let maxDimensionInPixels = Swift.max(scaledTargetWidth, scaledTargetHeight)
        
        // Perform downsampling
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as [CFString : Any] as CFDictionary
        guard var downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else { return nil }
        
        if case .fillcrop = contentMode {
            let cropDownscaleFactor = Swift.max(1, scaleFactor)
            let cropPixelWidth = targetPixelWidth / cropDownscaleFactor
            let cropPixelHeight = targetPixelHeight / cropDownscaleFactor
            
            let imageOrigin: CGPoint = .init(
                x: (scaledTargetWidth - cropPixelWidth) / 2,
                y: (scaledTargetHeight - cropPixelHeight) / 2
            )
            let imageSize: CGSize = .init(width: cropPixelWidth, height: cropPixelHeight)
            let cropRect = CGRect(origin: imageOrigin, size: imageSize)
            guard let croppedImage = downsampledImage.cropping(to: cropRect) else { return nil }
            downsampledImage = croppedImage
        }
        
        // Return the downsampled image as UIImage
        let image = UIImage(cgImage: downsampledImage, scale: scale, orientation: uiImageOrientation)
        let imageData = image.imageData(ofFormat: self.imageFormat)
        return (image, imageData ?? self)
    }
}

fileprivate extension UIImage {
    func imageData(ofFormat imageFormat: ImageFormat?) -> Data? {
        switch imageFormat {
        case .jpg:
            return self.jpegData(compressionQuality: 0.6)
        case .png:
            return self.pngData()
        case .gif, .webp, .none:
            return imageDataAuto()
        }
    }
    
    func imageDataAuto() -> Data? {
        switch hasAlpha {
        case false: return self.jpegData(compressionQuality: 0.6)
        case true:  return self.pngData()
        }
    }
    
    var hasAlpha: Bool {
        guard let alphaInfo = self.cgImage?.alphaInfo else { return false }
        switch alphaInfo {
        case .none, .noneSkipLast, .noneSkipFirst:
          return false
        default:
          return true
        }
      }
}

fileprivate extension CGImagePropertyOrientation {
    var uiImageOrientation: UIImage.Orientation {
        switch self {
        case .up:           return .up
        case .upMirrored:   return .upMirrored
        case .down:         return .down
        case .downMirrored: return .downMirrored
        case .left:         return .left
        case .leftMirrored: return .leftMirrored
        case .right:        return .right
        case .rightMirrored: return .rightMirrored
        }
    }
    
    var isFrameRotated: Bool {
        switch self {
        case .up, .upMirrored, .down, .downMirrored:        return false
        case .left, .leftMirrored, .right, .rightMirrored:  return true
        }
    }
}
