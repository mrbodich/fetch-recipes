//
//  RemoteImageError.swift
//  Networking
//
//  Created by Bogdan Chornobryvets on 11/8/24.
//

import Foundation

public enum RemoteImageError: Error {
    case badStatusCode(Int, url: String?)
    case badResponse
    case badURL(_ url: String)
    case noDataReceived(url: String)
}
