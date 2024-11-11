//
//  MockData.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/9/24.
//


#if DEBUG
struct MockData {
    var recipes: [Recipe] = Self.mockRecipes()
}
#endif
