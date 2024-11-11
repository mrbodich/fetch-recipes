//
//  RecipesState.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/10/24.
//

enum RecipesState: Sendable {
    case loaded([Recipe])
    case error
    case none
}
