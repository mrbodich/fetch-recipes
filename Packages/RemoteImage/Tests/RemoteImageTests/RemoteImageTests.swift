//
//  RemoteImageTests.swift
//  Networking
//
//  Created by Bogdan Chornobryvets on 11/9/24.
//

import Foundation
import UIKit
import Testing
@testable import RemoteImage
@testable import TestMocks

@Suite(.serialized)
final class RemoteImageTests {
    private let memoryCachingID = "com.remoteimage.memorycaching.test"
    private let diskCachingID = "com.remoteimage.diskcaching.test"
    
    var memoryCachingFetcher: ImageFetcher!
    var diskCachingFetcher: ImageFetcher!
    var nonCachingFetcher: ImageFetcher!
    var imagesHostUrl: String = ""

    init() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        memoryCachingFetcher = RemoteImageFetcher(sid: memoryCachingID, memoryCacheCapacity: 50, diskCacheCapacity: 0, baseUrlSessionConfiguration: configuration)
        diskCachingFetcher = RemoteImageFetcher(sid: diskCachingID, memoryCacheCapacity: 0, diskCacheCapacity: 50, baseUrlSessionConfiguration: configuration)
        nonCachingFetcher = RemoteImageFetcher(sid: diskCachingID, memoryCacheCapacity: 0, diskCacheCapacity: 0, baseUrlSessionConfiguration: configuration)
        MockingURLProtocol.mockedStatusCode = 200
        imagesHostUrl = "\(MockData.hostUrl)/images"
    }

    deinit {
        memoryCachingFetcher = nil
        diskCachingFetcher = nil
        imagesHostUrl = ""

        MockingURLProtocol.mockedResponse = .empty
        MockingURLProtocol.mockedStatusCode = 200
        MockingURLProtocol.currentRequest = nil
    }

    @Test func remoteImageFetcherInMemoryCache() async throws {
        //given
        let url = "\(imagesHostUrl)/108380"
        let image = UIImage(systemName: "photo")!
        MockingURLProtocol.mockedResponse = .data(image.pngData()!)
        
        //when
        let image1 = try await memoryCachingFetcher.fetchImage(url: url)
        let image2 = try await memoryCachingFetcher.fetchImage(url: url)
        
        //then
        #expect(image1 === image2, "One single URL returned 2 different UIImage objects (the second one from memory cache)")
    }
    
    @Test func remoteImageFetcherOnDiskCache() async throws {
        //given
        let url = "\(imagesHostUrl)/108380"
        let image = UIImage(systemName: "photo")!
        MockingURLProtocol.mockedResponse = .data(image.pngData()!)
        
        //when
        let image1 = try await diskCachingFetcher.fetchImage(url: url)
        let image2 = try await diskCachingFetcher.fetchImage(url: url)
        
        //then
        #expect(image1 !== image2, "One URL returned 2 same UIImage objects, when must return 2 different objects (due to 0 memory limit)")
        #expect(image1.size == image2.size)
        #expect(image1.scale == image2.scale)
    }
    
    @Test func remoteImageFetcherNoCache() async throws {
        //given
        let url = "\(imagesHostUrl)/108380"
        let image = UIImage(systemName: "photo")!
        MockingURLProtocol.mockedResponse = .data(image.pngData()!)
        
        //when
        let image1 = try await nonCachingFetcher.fetchImage(url: url)
        let image2 = try await nonCachingFetcher.fetchImage(url: url)
        
        //then
        #expect(image1 !== image2, "One URL returned 2 same UIImage objects, when must return 2 different objects (due to 0 memory limit)")
    }
    
    @Test func imageCacheCapacity() async throws {
        //given
        let configuration = UIImage.SymbolConfiguration(pointSize: 24)
        let mockImage1 = UIImage(systemName: "photo", withConfiguration: configuration)!.resizeWithUIKit(to: .init(width: 30, height: 15))!
        let mockImage2 = UIImage(systemName: "eraser", withConfiguration: configuration)!.resizeWithUIKit(to: .init(width: 30, height: 15))!
        let mockImage3 = UIImage(systemName: "pencil", withConfiguration: configuration)!.resizeWithUIKit(to: .init(width: 30, height: 15))!
        let mockImage4 = UIImage(systemName: "paperplane", withConfiguration: configuration)!.resizeWithUIKit(to: .init(width: 30, height: 15))!
        
        let mockImageSize = mockImage1.diskSize //Size is same for all images due to same resize 30x15
        let cache = MemoryImageCache(memoryLimit: mockImageSize * 2 + 10) //Cache limit can hold max 2 images + 10 bytes
        
        //when
        cache.add(mockImage1, for: .init(url: .init(string: "\(imagesHostUrl)/1")!))
        cache.add(mockImage2, for: .init(url: .init(string: "\(imagesHostUrl)/2")!))
        cache.add(mockImage3, for: .init(url: .init(string: "\(imagesHostUrl)/3")!))
        cache.add(mockImage4, for: .init(url: .init(string: "\(imagesHostUrl)/4")!))
        
        //then
        #expect(cache.itemsCount == 2)
        #expect(cache.memoryUsageBytes == mockImageSize * 2)
    }
    
    @Test func imageCacheClearance() async throws {
        //given
        let mockImage1 = UIImage(systemName: "photo")!
        let mockImage2 = UIImage(systemName: "eraser")!
        let mockImage1Size = mockImage1.diskSize
        let mockImage2Size = mockImage2.diskSize
        
        let cache = MemoryImageCache(memoryLimit: mockImage1Size + mockImage2Size) //Cache limit can hold both 2 images
        
        //when
        cache.add(mockImage1, for: .init(url: .init(string: "\(imagesHostUrl)/1")!))
        cache.add(mockImage2, for: .init(url: .init(string: "\(imagesHostUrl)/2")!))
        
        //then
        #expect(cache.itemsCount == 2)
        #expect(cache.memoryUsageBytes == mockImage1Size + mockImage2Size)
        
        //when
        cache.removeAllImages()
        
        //then
        #expect(cache.itemsCount == 0)
        #expect(cache.memoryUsageBytes == 0)
    }
}
