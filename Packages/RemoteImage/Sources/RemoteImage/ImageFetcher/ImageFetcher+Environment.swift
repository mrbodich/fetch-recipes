//
//  ImageFetcher+Environment.swift
//  Networking
//
//  Created by Bogdan Chornobryvets on 11/8/24.
//

import Foundation
import SwiftUI

public struct ImageFetcherKey: EnvironmentKey {
    public static let defaultValue: ImageFetcher = RemoteImageFetcher.shared
}

public extension EnvironmentValues {
    var imageFetcher: ImageFetcher {
        get { self[ImageFetcherKey.self] }
        set { self[ImageFetcherKey.self] = newValue }
    }
}

public extension View {
    /// Injects a custom Image Fetcher into the views hierarchy
    func imageFetcher(_ imageFetcher: ImageFetcher) -> some View {
        self.environment(\.imageFetcher, imageFetcher)
    }
}
