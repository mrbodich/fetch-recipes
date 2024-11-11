//
//  ScreenFabricLive.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/9/24.
//

extension ScreenFabricLive: ScreenFabric {
    func appCoordinator() -> AppCoordinator {
        AppCoordinator(screenFabric: self)
    }
    
    func recipesFeedCoordinator() -> RecipesFeedCoordinator {
        RecipesFeedCoordinator(screenFabric: self)
    }
    
    func recipesListVM() -> RecipesListVM {
        RecipesListVM(recipesGetter: dataService.getRecipes)
    }
}

struct ScreenFabricLive {
    private let dataService: DataService
    
    init(
        dataService: DataService
    ) {
        self.dataService = dataService
    }
}
