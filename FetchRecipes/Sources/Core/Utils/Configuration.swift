//
//  Configuration.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/9/24.
//

import Foundation

struct Config {
    enum Error: Swift.Error {
        case missingKey(String)
        case invalidValue(String)
        case missingResource(String)
        case badResource(String)
    }

    private static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey:key) else {
            throw Error.missingKey(key)
        }

        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue(key)
        }
    }
}

extension Config {
    static var api: API.Type { API.self }

    enum API {
        static var baseAPIUrl: String {
            get throws {
                return try Config.value(for: "BASE_API_URL")
            }
        }
    }
}
