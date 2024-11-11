//
//  Untitled.swift
//  Networking
//
//  Created by Bogdan Chornobryvets on 11/8/24.
//

import Foundation
import UIKit

public protocol ImageFetcher: Sendable {
    func fetchImage(url: String) async throws -> UIImage
    func fetchImage(url: String, size: CGSize, method: ResizeMethod, scale: CGFloat) async throws -> UIImage
}
