//
//  RecipesFeedCoordinator.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/9/24.
//

import Foundation

final class RecipesFeedCoordinator: ObservableObject {
    var router = NavigationRouter<RecipesFeedRoute>()
    private let screenFabric: ScreenFabric
    
    let rootRecipesListVM: RecipesListVM
    
    init(screenFabric: ScreenFabric) {
        self.screenFabric = screenFabric
        rootRecipesListVM = screenFabric.recipesListVM()
    }
    
    func loadRecipes() {
        Task {
            await rootRecipesListVM.refresh()
        }
    }
    
    func showRecipeDetails(withUrl url: URL) {
        router.push(.recipeDetails(url))
    }
    
    func showRecipeVideo(withUrl url: URL) {
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let videoId = components.queryItems?.first(where: { $0.name == "v" })?.value {
            showYoutubeVideo(withId: videoId)
        } else {
            showVideoDetails(withUrl: url)
        }
    }
    
    private func showVideoDetails(withUrl url: URL) {
        router.push(.recipeVideo(url))
    }
    
    private func showYoutubeVideo(withId id: String) {
        router.push(.recipeYoutubeVideo(id))
    }
}
