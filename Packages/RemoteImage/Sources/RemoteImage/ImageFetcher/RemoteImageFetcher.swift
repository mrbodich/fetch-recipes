//
//  RemoteImageFetcher.swift
//  Networking
//
//  Created by Bogdan Chornobryvets on 11/8/24.
//

import Foundation
import UIKit

public actor RemoteImageFetcher {
    private var fetchingTasks: [URLRequest: Task<UIImage, Error>] = [:]
    private let urlSession: URLSession
    private let imageCache: ImageCache
    private let urlCache: URLCache
    private let imageBuilderFabric: ImageBuilderFabric
    
    public static let shared: RemoteImageFetcher = .init(
        sid: "com.remoteImage.remoteImageFetcher.shared",
        memoryCacheCapacity: 100,
        diskCacheCapacity: 150
    )
    
    public init(
        sid: String,
        memoryCacheCapacity: Int,
        diskCacheCapacity: Int,
        baseUrlSessionConfiguration: URLSessionConfiguration? = nil,
        headers: [HTTPHeader] = [],
        imageBuilderFabric: ImageBuilderFabric = OriginalImageBuilderFabric()
    ) {
        let totalMemoryCapacity = memoryCacheCapacity * 1024 * 1024 // From Megabytes to bytes
        
        let imageMemoryCapacity = totalMemoryCapacity / 4 * 3
        let dataMemoryCapacity = totalMemoryCapacity / 4 * 1
        let dataDiskCapacity = diskCacheCapacity * 1024 * 1024 // From Megabytes to bytes
        
        //Initializing Caches
        imageCache = MemoryImageCache(memoryLimit: imageMemoryCapacity)
        
        let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let diskCacheURL = cachesURL.appendingPathComponent(sid)
        urlCache = URLCache(memoryCapacity: dataMemoryCapacity,
                            diskCapacity: dataDiskCapacity,
                            directory: diskCacheURL)
        
        let urlSessionConfiguration = RemoteImageFetcher.defaultURLSessionConfiguration(basedOn: baseUrlSessionConfiguration)
        urlSessionConfiguration.urlCache = nil
        urlSessionConfiguration.httpAdditionalHeaders = headers.reduce(into: [:]) { $0[$1.name] = $1.value }
        urlSession = URLSession(configuration: urlSessionConfiguration)
        self.imageBuilderFabric = imageBuilderFabric
    }
    
    private func fetchImage(
        with request: URLRequest,
        cachingProps: String?,
        imageBuilder: ImageBuilder
    ) async throws -> UIImage {
        let cachingRequest = request
            .cacheableVersion(cachingProps)
        
        if let existingTask = fetchingTasks[cachingRequest] {
            return try await existingTask.value
        }
        
        if let cachedImage = imageCache.image(for: cachingRequest) {
            return cachedImage
        }
        
        if let (data, _) = retrieveData(using: cachingRequest, from: urlCache),
           let (image, _) = imageBuilder.buildImage(from: data) {
            imageCache.add(image, for: cachingRequest)
            return image
        }
        
        let task: Task<UIImage, Error> = Task(priority: .medium) {
            do {
                let ((originalImageData, rawResponse), wasCached) =
                switch retrieveData(using: request, from: urlCache) {
                case let .some((data, response)):
                    ((data, response), true)
                case .none:
                    (try await urlSession.data(for: request), false)
                }
                
                guard let response = rawResponse as? HTTPURLResponse else { throw RemoteImageError.badResponse }
                guard HTTPStatusCode.isAcceptable(code: response.statusCode) else {
                    throw RemoteImageError.badStatusCode(response.statusCode, url: request.url?.absoluteString)
                }
                
                guard let (image, imageData) = imageBuilder.buildImage(from: originalImageData) else { throw URLError(.cannotDecodeContentData) }
                
                imageCache.add(image, for: cachingRequest)
                /// Explicitly store the image data into the cache
                if !wasCached {
                    store(originalImageData, with: rawResponse, using: request, to: urlCache)
                }
                store(imageData, with: rawResponse, using: cachingRequest, to: urlCache)
                
                return image
            } catch {
                throw error
            }
        }
        
        fetchingTasks[cachingRequest] = task
        
        defer {
            fetchingTasks.removeValue(forKey: cachingRequest)
        }
        
        return try await task.value
    }
    
    private func store(
        _ imageData: Data,
        with urlResponse: URLResponse,
        using urlRequest: URLRequest,
        to urlCache: URLCache
    ) {
        let response = CachedURLResponse(response: urlResponse, data: imageData)
        urlCache.storeCachedResponse(response, for: urlRequest)
    }
    
    private func retrieveData(
        using urlRequest: URLRequest,
        from urlCache: URLCache
    ) -> (Data, URLResponse)? {
        guard let cachedResponse = urlCache.cachedResponse(for: urlRequest) else { return nil }
        return (cachedResponse.data, cachedResponse.response)
    }
    
    private static func defaultURLSessionConfiguration(basedOn baseConfiguration: URLSessionConfiguration?) -> URLSessionConfiguration {
        let configuration = baseConfiguration ?? URLSessionConfiguration.default
        
        configuration.httpShouldSetCookies = true
        configuration.httpShouldUsePipelining = false

        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.allowsCellularAccess = true
        configuration.timeoutIntervalForRequest = 60
        configuration.httpMaximumConnectionsPerHost = 10
        
        return configuration
    }
    
}

extension RemoteImageFetcher: ImageFetcher {
    public func fetchImage(url urlStr: String, size: CGSize, method: ResizeMethod, scale: CGFloat) async throws -> UIImage {
        guard let url = URL(string: urlStr) else { throw RemoteImageError.badURL(urlStr) }
        let request = URLRequest(url: url)
        return try await fetchImage(
            with: request,
            cachingProps: "\(size.width * scale)x\(size.height * scale)",
            imageBuilder: imageBuilderFabric.builder(for: size, method: method, scale: scale)
        )
    }
    
    public func fetchImage(url urlStr: String) async throws -> UIImage {
        guard let url = URL(string: urlStr) else { throw RemoteImageError.badURL(urlStr) }
        let request = URLRequest(url: url)
        return try await fetchImage(
            with: request,
            cachingProps: nil,
            imageBuilder: OriginalImageBuilder(scale: UIScreen.main.scale)
        )
    }
}

extension URLSession {
    @Sendable
    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request, delegate: nil)
    }
}

extension URLRequest {
    private static let cachingKey = "Caching-Spot-Size"
    
    func cacheableVersion(_ cachingValue: String?) ->  URLRequest {
        var cachingRequest = self

        if let url = cachingRequest.url,
           var components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            
            var query = components.queryItems ?? []
            query.append(.init(name: Self.cachingKey, value: cachingValue))
            components.queryItems = query
            cachingRequest.url = components.url
        }
        
        return cachingRequest
    }
}
