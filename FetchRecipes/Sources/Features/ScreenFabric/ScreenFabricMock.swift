//
//  ScreenFabricMock.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/9/24.
//

#if DEBUG
extension ScreenFabricMock: ScreenFabric {
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

struct ScreenFabricMock {
    let dataService: DataService
    
    init(
        delay: Float = 0,
        mockData: MockData = .init()
    ) {
        dataService = DataServiceMock(
            delay: delay,
            mockData: mockData
        )
    }
}
#endif
