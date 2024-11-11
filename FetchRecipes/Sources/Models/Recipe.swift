//
//  Recipe.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/9/24.
//

import Foundation

struct Recipe: Sendable, Decodable {
    let uuid: String
    let cuisine: String
    let name: String
    let photoUrlLarge: String?
    let photoUrlSmall: String?
    let sourceUrl: String?
    let youtubeUrl: String?
}

extension Recipe: Identifiable {
    var id: String { uuid }
}
