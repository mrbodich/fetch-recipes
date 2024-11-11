//
//  AppCoordinatorView.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/9/24.
//

import SwiftUI

struct AppCoordinatorView: View {
    @ObservedObject var coordinator: AppCoordinator
    
    var body: some View {
        TabView {
            RecipesFeedCoordinatorView(
                coordinator: coordinator.recipesFeedCoordinator
            )
            .tabItem {
                Label(Ln.home, systemImage: "house.fill")
            }
        }
    }
}

#if DEBUG
#Preview {
    AppCoordinatorView(
        coordinator: ScreenFabricMock(delay: 0.3)
            .appCoordinator()
    )
    .mockImageFetcher()
}
#endif
