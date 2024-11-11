//
//  MockURL.swift
//  Networking
//
//  Created by Bogdan Chornobryvets on 11/9/24.
//

import Foundation
import UIKit

public struct MockData {
    static let hostName = "mock-domain.com"
    static var hostUrl: String {
        "https://\(hostName)"
    }
}

public final class MockingURLProtocol: URLProtocol, @unchecked Sendable {
    
    private static let state: MockingURLProtocolState = .init()
    
    static var mockedResponse: MockedResponse {
        get { state.mockedResponse }
        set { state.mockedResponse = newValue }
    }
    static var mockedStatusCode: Int? {
        get { state.mockedStatusCode }
        set { state.mockedStatusCode = newValue }
    }
    static var currentRequest: URLRequest? {
        get { state.currentRequest }
        set { state.currentRequest = newValue }
    }
    static var delay: TimeInterval {
        get { state.delay }
        set { state.delay = newValue }
    }
    
    public override class func canInit(with request: URLRequest) -> Bool {
        currentRequest = request
        return request.url?.host == MockData.hostName
    }
    
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    public override func startLoading() {
        let data = Self.mockedResponse.data
        
        let response: URLResponse
        switch Self.mockedStatusCode {
        case .some(let statusCode):
            response = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: [:])!
        case .none:
            response = URLResponse()
        }
        
        Task {
            try await Task.sleep(nanoseconds: UInt64(Self.delay * 1e9))
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: URLCache.StoragePolicy.allowed)
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    public override func stopLoading() { }
    
    public enum MockedResponse {
        case empty
        case string(String)
        case data(Data)
        
        var data: Data {
            switch self {
            case .empty:                return Data()
            case let .string(string):   return string.data(using: String.Encoding.utf8) ?? Data()
            case let .data(data):       return data
            }
        }
    }
}

public final class MockingURLProtocolState: @unchecked Sendable {
    var mockedResponse: MockingURLProtocol.MockedResponse = .data(Data())
    var mockedStatusCode: Int? = nil
    var currentRequest: URLRequest?
    var delay: TimeInterval = 0
}

public struct UserJSON: Decodable {
    let firstname: String
    let lastname: String
}

extension UIImage {
    func resizeWithUIKit(to newSize: CGSize, scale: CGFloat? = nil) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale ?? self.scale)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        defer { UIGraphicsEndImageContext() }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
