//
//  RecipesFeedRoute.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/9/24.
//

import Foundation

enum RecipesFeedRoute: Sendable, Hashable {
    case recipeDetails(URL)
    case recipeVideo(URL)
    case recipeYoutubeVideo(String)
}
