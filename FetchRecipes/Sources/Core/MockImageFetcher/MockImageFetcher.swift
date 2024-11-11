//
//  MockImageFetcher.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/9/24.
//

#if DEBUG
import Foundation
import UIKit
import RemoteImage
import Networking

final class MockImageFetcher: FakeImageFetcher, @unchecked Sendable {
    private let delay: Float
    
    init(delay: Float = 0) {
        self.delay = delay
    }
    
    override func originalImage(for url: String) async throws -> UIImage {
        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        guard let image = UIImage(named: url) else { throw RemoteImageError.noDataReceived(url: url) }
        return image
    }
}

extension String {
    static func resourceName(_ resource: ImageResource) -> String {
        (Mirror(reflecting: resource).children.first?.value as? String) ?? ""
    }
}

struct MockImage {
    static let foodBeef         = "food-beef"
    static let foodFish         = "food-fish"
    static let foodSaladChicken = "food-salad-chicken"
    static let foodSaladHot     = "food-salad-hot"
    static let foodSushi        = "food-sushi"
}
#endif
