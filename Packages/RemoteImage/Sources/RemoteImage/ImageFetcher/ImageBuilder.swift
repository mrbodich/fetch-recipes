//
//  ImageBuilder.swift
//  Networking
//
//  Created by Bogdan Chornobryvets on 11/8/24.
//

import UIKit

public protocol ImageBuilderFabric: Sendable {
    func builder(for size: CGSize,
                 method: ResizeMethod,
                 scale: CGFloat) -> ImageBuilder
}

public protocol ImageBuilder: Sendable {
    var scale: CGFloat { get }
    func buildImage(from imageData: Data) -> (image: UIImage, data: Data)?
}

public struct ResizingImageBuilderFabric: ImageBuilderFabric {
    public init () {}
    
    public func builder(for size: CGSize, method: ResizeMethod, scale: CGFloat) -> ImageBuilder {
        ResizingImageBuilder(size: size, method: method, scale: scale)
    }
}

public struct OriginalImageBuilderFabric: ImageBuilderFabric {
    public init () {}
    
    public func builder(for size: CGSize, method: ResizeMethod, scale: CGFloat) -> ImageBuilder {
        OriginalImageBuilder(scale: scale)
    }
}

public struct ResizingImageBuilder: ImageBuilder {
    public let size: CGSize
    public let method: ResizeMethod
    public let scale: CGFloat
    
    public func buildImage(from imageData: Data) -> (image: UIImage, data: Data)? {
        imageData.imageDownsampled(to: size, scale: scale, contentMode: method)
    }
}

public struct OriginalImageBuilder: ImageBuilder {
    public let scale: CGFloat
    
    public func buildImage(from imageData: Data) -> (image: UIImage, data: Data)? {
        UIImage(data: imageData, scale: scale)
            .flatMap {
                ($0, imageData)
            }
    }
}
