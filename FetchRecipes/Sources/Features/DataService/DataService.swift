//
//  DataService.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/9/24.
//

protocol DataService: Sendable {
    func getRecipes() async throws -> [Recipe]
}
