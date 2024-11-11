//
//  ImageCache.swift
//  Networking
//
//  Created by Bogdan Chornobryvets on 11/8/24.
//

import Foundation
import UIKit

//MARK: - Interface

/// Type which can cache images, retrieve tham and delete
public protocol ImageCache: Sendable {
    func image(for request: URLRequest) -> UIImage?
    func add(_ image: UIImage, for request: URLRequest)
    func removeImage(for request: URLRequest)
    func removeAllImages()
}
