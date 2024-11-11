//
//  RecipesListVMTests.swift
//  FetchRecipesTests
//
//  Created by Bogdan Chornobryvets on 11/8/24.
//

import Foundation
import Testing
@testable import FetchRecipes

struct RecipesListVMTests {

    @Test func recipesListFetched() async throws {
        // given
        let mockRecipe = Recipe(uuid: "7", cuisine: "Italian", name: "Pizza", photoUrlLarge: "", photoUrlSmall: "", sourceUrl: "", youtubeUrl: "")
        let recipesListVM = RecipesListVM {
            try await Task.sleep(for: .milliseconds(100))
            return [
                mockRecipe
            ]
        }
        
        // then
        #expect(recipesListVM.state.equals(.none))
        #expect(recipesListVM.isRefreshing == false)
        
        // when
        Task.detached {
            await recipesListVM.refresh()
        }
        try await Task.sleep(for: .milliseconds(10))
        
        // then
        #expect(recipesListVM.state.equals(.none))
        #expect(recipesListVM.isRefreshing == true)
        
        // when
        try await Task.sleep(for: .milliseconds(150))
        
        // then
        let optionalRecipes: [Recipe]? = switch recipesListVM.state {
        case let .loaded(recipes): recipes
        default: nil
        }
        let recipes = try #require(optionalRecipes)
        #expect(recipes.count == 1)
        let recipe = try #require(recipes.first)
        #expect(recipe.id == mockRecipe.id)
        #expect(recipe.cuisine == mockRecipe.cuisine)
        #expect(recipe.name == mockRecipe.name)
        #expect(recipesListVM.isRefreshing == false)
    }
    
    @Test func recipesListFailed() async throws {
        // given
        let recipesListVM = RecipesListVM {
            try await Task.sleep(for: .milliseconds(100))
            throw NSError(domain: "", code: 0)
        }
        
        // when
        Task.detached {
            await recipesListVM.refresh()
        }
        try await Task.sleep(for: .milliseconds(10))
        
        // then
        #expect(recipesListVM.state.equals(.none))
        #expect(recipesListVM.isRefreshing == true)
        
        // when
        try await Task.sleep(for: .milliseconds(150))
        
        // then
        #expect(recipesListVM.state.equals(.error))
        #expect(recipesListVM.isRefreshing == false)
    }
    
    @Test func recipesListEmpty() async throws {
        // given
        let recipesListVM = RecipesListVM {
            try await Task.sleep(for: .milliseconds(100))
            return []
        }
        
        // when
        Task.detached {
            await recipesListVM.refresh()
        }
        try await Task.sleep(for: .milliseconds(10))
        
        // then
        #expect(recipesListVM.state.equals(.none))
        #expect(recipesListVM.isRefreshing == true)
        
        // when
        try await Task.sleep(for: .milliseconds(150))
        
        // then
        #expect(recipesListVM.state.equals(.loaded([])))
        #expect(recipesListVM.isRefreshing == false)
    }

}

fileprivate extension RecipesState {
    func equals(_ state: RecipesState) -> Bool {
        switch (self, state) {
        case (.none, .none):    true
        case (.error, .error):  true
        case let (.loaded(recipes1), .loaded(recipes2))
            where recipes1.map(\.id) == recipes2.map(\.id):  true
        default: false
        }
    }
}
