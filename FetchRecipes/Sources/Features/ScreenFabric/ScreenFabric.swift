//
//  ScreenFabric.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/9/24.
//

protocol ScreenFabric {
    func appCoordinator() -> AppCoordinator
    func recipesFeedCoordinator() -> RecipesFeedCoordinator
    func recipesListVM() -> RecipesListVM
}
