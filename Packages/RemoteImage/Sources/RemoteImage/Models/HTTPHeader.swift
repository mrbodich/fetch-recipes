//
//  HTTPHeader.swift
//  Networking
//
//  Created by Bogdan Chornobryvets on 11/8/24.
//

public struct HTTPHeader: Hashable, Sendable {
    public let name: String
    public let value: String
    
    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}
