//
//  DataServiceLive.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/9/24.
//

import Foundation
import Networking

final class DataServiceLive: @unchecked Sendable {
    let network: NetworkingClient
    
    init(baseAPIUrl: String) {
        network = .init(baseURL: baseAPIUrl)
        network.sessionConfiguration = .default
        network.sessionConfiguration.urlCache = nil
        network.jsonDecoderFactory = {
            Self.jsonDecoder
        }
    }
    
    static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}

extension DataServiceLive: DataService {
    func getRecipes() async throws -> [Recipe] {
        let recipesDto: RecipesDTO = try await network.get("/recipes.json")
        return recipesDto.recipes
    }
}
