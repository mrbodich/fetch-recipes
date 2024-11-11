//
//  RecipesFeedCoordinatorView.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/9/24.
//

import SwiftUI

struct RecipesFeedCoordinatorView: View {
    @ObservedObject var coordinator: RecipesFeedCoordinator
    
    var body: some View {
        RoutedNavigationStack(router: coordinator.router) {
            RecipesListView(viewModel: coordinator.rootRecipesListVM)
                .navigationTitle(Ln.recipes)
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: RecipesFeedRoute.self) { route in
                    switch route {
                    case let .recipeDetails(url):
                        NavigationView {
                            WebBrowserView(url: url) {
                                coordinator.router.pop()
                            }
                            .ignoresSafeArea(.all, edges: .top)
                            .ignoresSafeArea(.all, edges: .horizontal)
                        }
                        .ignoresSafeArea(.all, edges: .top)
                        .ignoresSafeArea(.all, edges: .horizontal)
                        .navigationBarHidden(true)
                        .navigationTitle(Ln.recipeDetails)
                    case let .recipeVideo(url):
                        NavigationView {
                            WebBrowserView(url: url) {
                                coordinator.router.pop()
                            }
                            .ignoresSafeArea(.all, edges: .top)
                            .ignoresSafeArea(.all, edges: .horizontal)
                        }
                        .ignoresSafeArea(.all, edges: .top)
                        .ignoresSafeArea(.all, edges: .horizontal)
                        .navigationBarHidden(true)
                        .navigationTitle(Ln.recipeVideo)
                    case let .recipeYoutubeVideo(id):
                        YouTubePlayerView(videoID: id)
                            .toolbarBackground(.visible, for: .navigationBar)
                            .toolbarBackground(Color.black, for: .navigationBar)
                            .toolbarBackground(.visible, for: .tabBar)
                            .toolbarBackground(Color.black, for: .tabBar)
                            .ignoresSafeArea(.container, edges: .all)
                            .background(Color.black)
                    }
                }
                .environment(\.recipeDetailsDidPress, coordinator.showRecipeDetails(withUrl:))
                .environment(\.recipeVideoDidPress, coordinator.showRecipeVideo(withUrl:))
        }
    }
}

#if DEBUG
#Preview {
    RecipesFeedCoordinatorView(
        coordinator: ScreenFabricMock(delay: 0.1)
            .recipesFeedCoordinator()
    )
    .mockImageFetcher()
}
#endif
