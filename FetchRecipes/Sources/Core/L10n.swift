//
//  L10n.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/10/24.
//

let Ln = MainLocalisation()

struct MainLocalisation {
    let recipes = String(localized: "recipes", comment: "Label: Recipes")
    let sort = String(localized: "sort", comment: "Label: Sort")
    let sortByName = String(localized: "sort.by_name", comment: "Label indicating sorting option by name")
    let sortByCuisineName = String(localized: "sort.by_cuisine_name", comment: "Label indicating sorting option by cuisine name")
    let reload = String(localized: "reload", comment: "Label: Reload")
    let recipesEmpty = String(localized: "recipes.empty", comment: "Label describing the empty state of the recipes list")
    let recipesError = String(localized: "recipes.error", comment: "Label: Error describing the error state of the recipes list")
    let recipesLoad = String(localized: "recipes.load", comment: "Label asking user to load recipes")
    let recipeDetails = String(localized: "recipe.details", comment: "Label: Recipe details")
    let recipeVideo = String(localized: "recipe.video", comment: "Label: Recipe video")
    let home = String(localized: "home", comment: "Label: Home")
}

extension MainLocalisation {
    func cuisineName(_ name: String) -> String {
        String(localized: "cuisine: \(name)", comment: "Template for displaying the cuisine name")
    }
}
