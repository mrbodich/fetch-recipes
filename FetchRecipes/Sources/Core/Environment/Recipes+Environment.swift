//
//  Recipes+Environment.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/10/24.
//

import SwiftUI

struct RecipeDetailsUrlDidPressKey: EnvironmentKey {
    static let defaultValue: (URL) -> () = { _ in }
}

struct RecipeVideoUrlDidPressKey: EnvironmentKey {
    static let defaultValue: (URL) -> () = { _ in }
}

extension EnvironmentValues {
    var recipeDetailsDidPress: RecipeDetailsUrlDidPressKey.Value {
        get { self[RecipeDetailsUrlDidPressKey.self] }
        set { self[RecipeDetailsUrlDidPressKey.self] = newValue }
    }
    
    var recipeVideoDidPress: RecipeVideoUrlDidPressKey.Value {
        get { self[RecipeVideoUrlDidPressKey.self] }
        set { self[RecipeVideoUrlDidPressKey.self] = newValue }
    }
}
