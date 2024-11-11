//
//  HTTPStatusCode.swift
//  Networking
//
//  Created by Bogdan Chornobryvets on 11/8/24.
//

public enum HTTPStatusCode {
    public static func isAcceptable(code: Int) -> Bool {
        200...299 ~= code
    }
}
