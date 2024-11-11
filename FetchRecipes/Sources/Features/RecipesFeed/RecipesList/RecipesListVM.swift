//
//  RecipesListVM.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/10/24.
//

import Foundation

final class RecipesListVM: ObservableObject {
    typealias RecipesGetter = () async throws -> [Recipe]
    
    private let getRecipes: RecipesGetter
    @Published private(set) var state: RecipesState = .none
    @Published var isRefreshing: Bool = false
    
    init(recipesGetter: @escaping RecipesGetter) {
        self.getRecipes = recipesGetter
    }
    
    @MainActor
    func refresh() async {
        isRefreshing = true
        defer { isRefreshing = false }
        
        /// Resetting state
        switch state {
        case let .loaded(recipes) where !recipes.isEmpty:
            break
        default:
            state = .none
        }
        
        do {
            state = .loaded(try await getRecipes())
        } catch {
            state = .error
            print("Error: \(error)")
        }
    }
}
