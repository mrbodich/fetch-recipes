//
//  AppCoordinator.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/9/24.
//

import Foundation

final class AppCoordinator: ObservableObject {
    private let screenFabric: ScreenFabric
    let recipesFeedCoordinator: RecipesFeedCoordinator
    
    init(screenFabric: ScreenFabric) {
        self.screenFabric = screenFabric
        recipesFeedCoordinator = screenFabric.recipesFeedCoordinator()
        recipesFeedCoordinator.loadRecipes()
    }
}
